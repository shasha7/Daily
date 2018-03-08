/*
 * Copyright (c) 2008-2011 Apple Inc. All rights reserved.
 *
 * @APPLE_APACHE_LICENSE_HEADER_START@
 *
 */

#include "internal.h"

// semaphores are too fundamental to use the dispatch_assume*() macros
#if USE_MACH_SEM
#define DISPATCH_SEMAPHORE_VERIFY_KR(x) do { \
		if (slowpath(x)) { \
			DISPATCH_CRASH("flawed group/semaphore logic"); \
		} \
	} while (0)
#elif USE_POSIX_SEM
#define DISPATCH_SEMAPHORE_VERIFY_RET(x) do { \
		if (slowpath((x) == -1)) { \
			DISPATCH_CRASH("flawed group/semaphore logic"); \
		} \
	} while (0)
#endif

DISPATCH_WEAK // rdar://problem/8503746
long _dispatch_semaphore_signal_slow(dispatch_semaphore_t dsema);

static void _dispatch_semaphore_dispose(dispatch_semaphore_t dsema);
static size_t _dispatch_semaphore_debug(dispatch_semaphore_t dsema, char *buf,
		size_t bufsiz);
static long _dispatch_group_wake(dispatch_semaphore_t dsema);

#pragma mark -
#pragma mark dispatch_semaphore_t

struct dispatch_semaphore_vtable_s {
	DISPATCH_VTABLE_HEADER(dispatch_semaphore_s);
};

const struct dispatch_semaphore_vtable_s _dispatch_semaphore_vtable = {
	.do_type = DISPATCH_SEMAPHORE_TYPE,
	.do_kind = "semaphore",
	.do_dispose = _dispatch_semaphore_dispose,
	.do_debug = _dispatch_semaphore_debug,
};

dispatch_semaphore_t dispatch_semaphore_create(long value)
{
	dispatch_semaphore_t dsema;

	// 如果内部值为负数，则该值的绝对值等于等待线程的数量。因此，用负值初始化信号量是虚假的
	if (value < 0) {
		return NULL;
	}

	dsema = calloc(1, sizeof(struct dispatch_semaphore_s));

	/*
	 const struct dispatch_semaphore_vtable_s _dispatch_semaphore_vtable = {
		 .do_type = DISPATCH_SEMAPHORE_TYPE,
		 .do_kind = "semaphore",
		 .do_dispose = _dispatch_semaphore_dispose,
		 .do_debug = _dispatch_semaphore_debug,
	 };
	 
	 DISPATCH_QUEUE_PRIORITY_DEFAULT优先级的全局队列：
	 {
		 .do_vtable = &_dispatch_queue_root_vtable,
		 .do_ref_cnt = DISPATCH_OBJECT_GLOBAL_REFCNT,
		 .do_xref_cnt = DISPATCH_OBJECT_GLOBAL_REFCNT,
		 .do_suspend_cnt = DISPATCH_OBJECT_SUSPEND_LOCK,
		 .do_vtable = &_dispatch_semaphore_vtable,
		 .do_ref_cnt = DISPATCH_OBJECT_GLOBAL_REFCNT,
		 .do_xref_cnt = DISPATCH_OBJECT_GLOBAL_REFCNT,
		 .dgq_thread_pool_size = MAX_THREAD_COUNT,
		 .dq_label = "com.apple.root.default-overcommit-priority",
		 .dq_running = 2,
		 .dq_width = UINT32_MAX,
		 .dq_serialnum = 7,
	 }
	 */
	if (fastpath(dsema)) {
		dsema->do_vtable = &_dispatch_semaphore_vtable;
		dsema->do_next = DISPATCH_OBJECT_LISTLESS;
		dsema->do_ref_cnt = 1;
		dsema->do_xref_cnt = 1;
		dsema->do_targetq = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
		dsema->dsema_value = value;
		dsema->dsema_orig = value;
#if USE_POSIX_SEM
		int ret = sem_init(&dsema->dsema_sem, 0, 0);
		DISPATCH_SEMAPHORE_VERIFY_RET(ret);
#endif
	}

	return dsema;
}

#if USE_MACH_SEM
static void _dispatch_semaphore_create_port(semaphore_t *s4) {
	kern_return_t kr;
	semaphore_t tmp;

	if (*s4) {
		return;
	}

	// lazily allocate the semaphore port

	// Someday:
	// 1) Switch to a doubly-linked FIFO in user-space.
	// 2) User-space timers for the timeout.
	// 3) Use the per-thread semaphore port.

	while ((kr = semaphore_create(mach_task_self(), &tmp, SYNC_POLICY_FIFO, 0))) {
		DISPATCH_VERIFY_MIG(kr);
		sleep(1);
	}

	if (!dispatch_atomic_cmpxchg(s4, 0, tmp)) {
		kr = semaphore_destroy(mach_task_self(), tmp);
		DISPATCH_SEMAPHORE_VERIFY_KR(kr);
	}

	_dispatch_safe_fork = false;
}
#endif

static void _dispatch_semaphore_dispose(dispatch_semaphore_t dsema)
{
	// 当前可用资源数目小于原始值，表示有线程正在执行任务，不可被dispose
	if (dsema->dsema_value < dsema->dsema_orig) {
		printf("BUG IN CLIENT OF LIBDISPATCH: Semaphore/group object deallocated while in use");
	}

#if USE_MACH_SEM
	kern_return_t kr;
	// 销毁dsema_port
	if (dsema->dsema_port) {
		kr = semaphore_destroy(mach_task_self(), dsema->dsema_port);
		DISPATCH_SEMAPHORE_VERIFY_KR(kr);
	}
	// 有线程正在等待，销毁dsema_waiter_port
	if (dsema->dsema_waiter_port) {
		kr = semaphore_destroy(mach_task_self(), dsema->dsema_waiter_port);
		DISPATCH_SEMAPHORE_VERIFY_KR(kr);
	}
#elif USE_POSIX_SEM
	int ret = sem_destroy(&dsema->dsema_sem);
	DISPATCH_SEMAPHORE_VERIFY_RET(ret);
#endif

	_dispatch_dispose(dsema);
}

static size_t _dispatch_semaphore_debug(dispatch_semaphore_t dsema, char *buf, size_t bufsiz)
{
	size_t offset = 0;
	offset += snprintf(&buf[offset], bufsiz - offset, "%s[%p] = { ",
			dx_kind(dsema), dsema);
	offset += _dispatch_object_debug_attr(dsema, &buf[offset], bufsiz - offset);
#if USE_MACH_SEM
	offset += snprintf(&buf[offset], bufsiz - offset, "port = 0x%u, ",
			dsema->dsema_port);
#endif
	offset += snprintf(&buf[offset], bufsiz - offset,
			"value = %ld, orig = %ld }", dsema->dsema_value, dsema->dsema_orig);
	return offset;
}

DISPATCH_NOINLINE
long _dispatch_semaphore_signal_slow(dispatch_semaphore_t dsema)
{
	_dispatch_retain(dsema);
	// 仅仅是将dsema->dsema_sent_ksignals值加1
	(void)dispatch_atomic_inc2o(dsema, dsema_sent_ksignals);
	// 创建semaphore_t
	_dispatch_semaphore_create_port(&dsema->dsema_port);
	// 核心:利用系统的信号量库实现发送信号量的功能，表示现在可用的资源数目+1，这里是可创建的用于并行线程数目+1
	kern_return_t kr = semaphore_signal(dsema->dsema_port);
	// 如果kr返回不为真，打印错误
	do {
		if (kr) {
			printf("BUG IN CLIENT OF LIBDISPATCH: flawed group/semaphore logic");
		}
	} while (0);
	_dispatch_release(dsema);
	return 1;
}

long dispatch_semaphore_signal(dispatch_semaphore_t dsema) {
	// dispatch_atomic_release_barrier();
	// __sync_add_and_fetch((p), (v))
	// dispatch_atomic_inc2o(dsema, dsema_value)
	long value = dsema->dsema_value + 1;
	if (value > 0) {
		return 0;
	}
	
	if (slowpath(value == LONG_MIN)) {// 输出错误日志
		printf("BUG IN CLIENT OF LIBDISPATCH: Unbalanced call to dispatch_semaphore_signal()");
	}
	
	return _dispatch_semaphore_signal_slow(dsema);
}

DISPATCH_NOINLINE
static long
_dispatch_semaphore_wait_slow(dispatch_semaphore_t dsema, dispatch_time_t timeout)
{
	long orig;
again:
	// Mach信号似乎有时会虚假地醒来,因此，我们保持一个Mach信号量被发信号的次数的平行计数6880961
	// 判断dsema->dsema_sent_ksignals与orig是否相等，如果相等就返回YES，并将orig - 1的值赋给dsema->dsema_sent_ksignals
	while ((orig = dsema->dsema_sent_ksignals)) {
		if ((long)(dsema->dsema_sent_ksignals) == orig) {
			dsema->dsema_sent_ksignals = orig - 1;
			return 0;
		}
	}
#if USE_MACH_SEM
	mach_timespec_t _timeout;
	kern_return_t kr;

	_dispatch_semaphore_create_port(&dsema->dsema_port);

	// From xnu/osfmk/kern/sync_sema.c:
	// wait_semaphore->count = -1; /* we don't keep an actual count */
	//
	// The code above does not match the documentation, and that fact is
	// not surprising. The documented semantics are clumsy to use in any
	// practical way. The above hack effectively tricks the rest of the
	// Mach semaphore logic to behave like the libdispatch algorithm.

	switch (timeout) {
		default:
			do {
				uint64_t nsec = _dispatch_timeout(timeout);
				_timeout.tv_sec = (typeof(_timeout.tv_sec))(nsec / NSEC_PER_SEC);
				_timeout.tv_nsec = (typeof(_timeout.tv_nsec))(nsec % NSEC_PER_SEC);
				kr = slowpath(semaphore_timedwait(dsema->dsema_port, _timeout));
			} while (kr == KERN_ABORTED);

			if (kr != KERN_OPERATION_TIMED_OUT) {
				DISPATCH_SEMAPHORE_VERIFY_KR(kr);
				break;
			}
			// Fall through and try to undo what the fast path did to
			// dsema->dsema_value
		case DISPATCH_TIME_NOW:
			while ((orig = dsema->dsema_value) < 0) {
				if (dispatch_atomic_cmpxchg2o(dsema, dsema_value, orig, orig + 1)) {
					return KERN_OPERATION_TIMED_OUT;
				}
			}
			// Another thread called semaphore_signal().
			// Fall through and drain the wakeup.
		case DISPATCH_TIME_FOREVER:
			do {
				kr = semaphore_wait(dsema->dsema_port);
			} while (kr == KERN_ABORTED);
			DISPATCH_SEMAPHORE_VERIFY_KR(kr);
			break;
	}
#elif USE_POSIX_SEM
	struct timespec _timeout;
	int ret;

	switch (timeout) {
		default:
			do {
				uint64_t nsec = _dispatch_timeout(timeout);
				_timeout.tv_sec = (typeof(_timeout.tv_sec))(nsec / NSEC_PER_SEC);
				_timeout.tv_nsec = (typeof(_timeout.tv_nsec))(nsec % NSEC_PER_SEC);
				ret = slowpath(sem_timedwait(&dsema->dsema_sem, &_timeout));
			} while (ret == -1 && errno == EINTR);

			if (ret == -1 && errno != ETIMEDOUT) {
				DISPATCH_SEMAPHORE_VERIFY_RET(ret);
				break;
			}
			// Fall through and try to undo what the fast path did to
			// dsema->dsema_value
		case DISPATCH_TIME_NOW:
			while ((orig = dsema->dsema_value) < 0) {
				if (dispatch_atomic_cmpxchg2o(dsema, dsema_value, orig, orig + 1)) {
					errno = ETIMEDOUT;
					return -1;
				}
			}
			// Another thread called semaphore_signal().
			// Fall through and drain the wakeup.
		case DISPATCH_TIME_FOREVER:
			do {
				ret = sem_wait(&dsema->dsema_sem);
			} while (ret != 0);
			DISPATCH_SEMAPHORE_VERIFY_RET(ret);
			break;
	}
#endif
	goto again;
}

long dispatch_semaphore_wait(dispatch_semaphore_t dsema, dispatch_time_t timeout)
{
	// 调用GCC内置的函数__sync_sub_and_fetch，实现减法的原子性操作。
	// __sync_sub_and_fetch(p, v)
	// long value = dsema->dsema_value - 1;
	long value = dispatch_atomic_dec2o(dsema, dsema_value);
	
	// value大于等于0 就立刻返回
	if (fastpath(value >= 0)) {
		return 0;
	}
	// value < 0 进入等待状态
	return _dispatch_semaphore_wait_slow(dsema, timeout);
}

#pragma mark -
#pragma mark dispatch_group_t

dispatch_group_t dispatch_group_create(void)
{
	return (dispatch_group_t)dispatch_semaphore_create(LONG_MAX);
}

void dispatch_group_enter(dispatch_group_t dg) {
	dispatch_semaphore_t dsema = (dispatch_semaphore_t)dg;
	(void)dispatch_semaphore_wait(dsema, DISPATCH_TIME_FOREVER);
}

static long _dispatch_group_wake(dispatch_semaphore_t dsema)
{
	// 循环调用signal函数,唤醒当初等待group的信号量
	struct dispatch_sema_notify_s *next, *head, *tail = NULL;
	long rval;

	head = dispatch_atomic_xchg2o(dsema, dsema_notify_head, NULL);
	if (head) {
		// snapshot before anything is notified/woken <rdar://problem/8554546>
		tail = dispatch_atomic_xchg2o(dsema, dsema_notify_tail, NULL);
	}
	rval = dispatch_atomic_xchg2o(dsema, dsema_group_waiters, 0);
	if (rval) {
		// wake group waiters
#if USE_MACH_SEM
		_dispatch_semaphore_create_port(&dsema->dsema_waiter_port);
		do {
			kern_return_t kr = semaphore_signal(dsema->dsema_waiter_port);
			DISPATCH_SEMAPHORE_VERIFY_KR(kr);
		} while (--rval);
#elif USE_POSIX_SEM
		do {
			int ret = sem_post(&dsema->dsema_sem);
			DISPATCH_SEMAPHORE_VERIFY_RET(ret);
		} while (--rval);
#endif
	}
	
	// 获取链表遍历,依次调用dispatch_async_f异步执行在notify函数中注册的回调
	if (head) {
		// async group notify blocks
		do {
			dispatch_async_f(head->dsn_queue, head->dsn_ctxt, head->dsn_func);
			_dispatch_release(head->dsn_queue);
			next = head->dsn_next;
			if (!next && head != tail) {
				while (!(next = head->dsn_next)) {
					_dispatch_hardware_pause();
				}
			}
			free(head);
		} while ((head = next));
		_dispatch_release(dsema);
	}
	return 0;
}

void dispatch_group_leave(dispatch_group_t dg)
{
	dispatch_semaphore_t dsema = (dispatch_semaphore_t)dg;

	// 原子加函数
	long value = dispatch_atomic_inc2o(dsema, dsema_value);
	if (slowpath(value == LONG_MIN)) {
		DISPATCH_CLIENT_CRASH("Unbalanced call to dispatch_group_leave()");
	}
	if (slowpath(value == dsema->dsema_orig)) {
		(void)_dispatch_group_wake(dsema);
	}
}

DISPATCH_NOINLINE
static long _dispatch_group_wait_slow(dispatch_semaphore_t dsema, dispatch_time_t timeout)
{
	long orig;

again:
	// check before we cause another signal to be sent by incrementing
	// dsema->dsema_group_waiters
	if (dsema->dsema_value == dsema->dsema_orig) {
		return _dispatch_group_wake(dsema);
	}
	// Mach semaphores appear to sometimes spuriously wake up. Therefore,
	// we keep a parallel count of the number of times a Mach semaphore is
	// signaled (6880961).
	(void)dispatch_atomic_inc2o(dsema, dsema_group_waiters);
	// check the values again in case we need to wake any threads
	if (dsema->dsema_value == dsema->dsema_orig) {
		return _dispatch_group_wake(dsema);
	}

#if USE_MACH_SEM
	mach_timespec_t _timeout;
	kern_return_t kr;

	_dispatch_semaphore_create_port(&dsema->dsema_waiter_port);

	// From xnu/osfmk/kern/sync_sema.c:
	// wait_semaphore->count = -1; /* we don't keep an actual count */
	//
	// The code above does not match the documentation, and that fact is
	// not surprising. The documented semantics are clumsy to use in any
	// practical way. The above hack effectively tricks the rest of the
	// Mach semaphore logic to behave like the libdispatch algorithm.

	switch (timeout) {
	default:
		do {
			uint64_t nsec = _dispatch_timeout(timeout);
			_timeout.tv_sec = (typeof(_timeout.tv_sec))(nsec / NSEC_PER_SEC);
			_timeout.tv_nsec = (typeof(_timeout.tv_nsec))(nsec % NSEC_PER_SEC);
			kr = slowpath(semaphore_timedwait(dsema->dsema_waiter_port,
					_timeout));
		} while (kr == KERN_ABORTED);

		if (kr != KERN_OPERATION_TIMED_OUT) {
			DISPATCH_SEMAPHORE_VERIFY_KR(kr);
			break;
		}
		// Fall through and try to undo the earlier change to
		// dsema->dsema_group_waiters
	case DISPATCH_TIME_NOW:
		while ((orig = dsema->dsema_group_waiters)) {
			if (dispatch_atomic_cmpxchg2o(dsema, dsema_group_waiters, orig,
					orig - 1)) {
				return KERN_OPERATION_TIMED_OUT;
			}
		}
		// Another thread called semaphore_signal().
		// Fall through and drain the wakeup.
	case DISPATCH_TIME_FOREVER:
		do {
			kr = semaphore_wait(dsema->dsema_waiter_port);
		} while (kr == KERN_ABORTED);
		DISPATCH_SEMAPHORE_VERIFY_KR(kr);
		break;
	}
#elif USE_POSIX_SEM
	struct timespec _timeout;
	int ret;

	switch (timeout) {
	default:
		do {
			uint64_t nsec = _dispatch_timeout(timeout);
			_timeout.tv_sec = (typeof(_timeout.tv_sec))(nsec / NSEC_PER_SEC);
			_timeout.tv_nsec = (typeof(_timeout.tv_nsec))(nsec % NSEC_PER_SEC);
			ret = slowpath(sem_timedwait(&dsema->dsema_sem, &_timeout));
		} while (ret == -1 && errno == EINTR);

		if (!(ret == -1 && errno == ETIMEDOUT)) {
			DISPATCH_SEMAPHORE_VERIFY_RET(ret);
			break;
		}
		// Fall through and try to undo the earlier change to
		// dsema->dsema_group_waiters
	case DISPATCH_TIME_NOW:
		while ((orig = dsema->dsema_group_waiters)) {
			if (dispatch_atomic_cmpxchg2o(dsema, dsema_group_waiters, orig,
					orig - 1)) {
				errno = ETIMEDOUT;
				return -1;
			}
		}
		// Another thread called semaphore_signal().
		// Fall through and drain the wakeup.
	case DISPATCH_TIME_FOREVER:
		do {
			ret = sem_wait(&dsema->dsema_sem);
		} while (ret == -1 && errno == EINTR);
		DISPATCH_SEMAPHORE_VERIFY_RET(ret);
		break;
	}
#endif

	goto again;
}

long dispatch_group_wait(dispatch_group_t dg, dispatch_time_t timeout)
{
	dispatch_semaphore_t dsema = (dispatch_semaphore_t)dg;

	if (dsema->dsema_value == dsema->dsema_orig) {
		return 0;
	}
	if (timeout == 0) {
#if USE_MACH_SEM
		return KERN_OPERATION_TIMED_OUT;
#elif USE_POSIX_SEM
		errno = ETIMEDOUT;
		return (-1);
#endif
	}
	return _dispatch_group_wait_slow(dsema, timeout);
}

void dispatch_group_notify_f(dispatch_group_t dg, dispatch_queue_t dq, void *ctxt,
		void (*func)(void *))
{
	// 在链表的尾部接上新的节点，notify方法并没有做过多的处理，只是是用链表把所有回调通知保存起来，等待调用
	dispatch_semaphore_t dsema = (dispatch_semaphore_t)dg;
	struct dispatch_sema_notify_s *dsn, *prev;

	// FIXME -- this should be updated to use the continuation cache
	while (!(dsn = calloc(1, sizeof(*dsn)))) {
		sleep(1);
	}

	dsn->dsn_queue = dq;
	dsn->dsn_ctxt = ctxt;
	dsn->dsn_func = func;
	_dispatch_retain(dq);

	prev = dispatch_atomic_xchg2o(dsema, dsema_notify_tail, dsn);
	if (fastpath(prev)) {
		prev->dsn_next = dsn;
	} else {
		_dispatch_retain(dg);
		(void)dispatch_atomic_xchg2o(dsema, dsema_notify_head, dsn);
		if (dsema->dsema_value == dsema->dsema_orig) {
			_dispatch_group_wake(dsema);
		}
	}
}

#ifdef __BLOCKS__
void dispatch_group_notify(dispatch_group_t dg, dispatch_queue_t dq,
		dispatch_block_t db)
{
	dispatch_group_notify_f(dg, dq, _dispatch_Block_copy(db),
			_dispatch_call_block_and_release);
}
#endif

#pragma mark -
#pragma mark _dispatch_thread_semaphore_t

DISPATCH_NOINLINE
static _dispatch_thread_semaphore_t
_dispatch_thread_semaphore_create(void)
{
#if USE_MACH_SEM
	semaphore_t s4;
	kern_return_t kr;
	while (slowpath(kr = semaphore_create(mach_task_self(), &s4, SYNC_POLICY_FIFO, 0))) {
		DISPATCH_VERIFY_MIG(kr);
		sleep(1);
	}
	return s4;
#elif USE_POSIX_SEM
	sem_t s4;
	int ret = sem_init(&s4, 0, 0);
	DISPATCH_SEMAPHORE_VERIFY_RET(ret);
	return s4;
#endif
}

DISPATCH_NOINLINE
void _dispatch_thread_semaphore_dispose(_dispatch_thread_semaphore_t sema)
{
#if USE_MACH_SEM
	semaphore_t s4 = (semaphore_t)sema;
	kern_return_t kr = semaphore_destroy(mach_task_self(), s4);
	DISPATCH_SEMAPHORE_VERIFY_KR(kr);
#elif USE_POSIX_SEM
	sem_t s4 = (sem_t)sema;
	int ret = sem_destroy(&s4);
	DISPATCH_SEMAPHORE_VERIFY_RET(ret);
#endif
}

void _dispatch_thread_semaphore_signal(_dispatch_thread_semaphore_t sema)
{
#if USE_MACH_SEM
	semaphore_t s4 = (semaphore_t)sema;
	kern_return_t kr = semaphore_signal(s4);
	DISPATCH_SEMAPHORE_VERIFY_KR(kr);
#elif USE_POSIX_SEM
	sem_t s4 = (sem_t)sema;
	int ret = sem_post(&s4);
	DISPATCH_SEMAPHORE_VERIFY_RET(ret);
#endif
}

void _dispatch_thread_semaphore_wait(_dispatch_thread_semaphore_t sema)
{
#if USE_MACH_SEM
	semaphore_t s4 = (semaphore_t)sema;
	kern_return_t kr;
	do {
		kr = semaphore_wait(s4);
	} while (slowpath(kr == KERN_ABORTED));
	DISPATCH_SEMAPHORE_VERIFY_KR(kr);
#elif USE_POSIX_SEM
	sem_t s4 = (sem_t)sema;
	int ret;
	do {
		ret = sem_wait(&s4);
	} while (slowpath(ret != 0));
	DISPATCH_SEMAPHORE_VERIFY_RET(ret);
#endif
}

// _dispatch_get_thread_semaphore内部使用的是“有即取用，无即创建”策略来获取信号量
_dispatch_thread_semaphore_t _dispatch_get_thread_semaphore(void)
{
	// 利用了tsl技术，从线程的私有存储空间中以dispatch_sema4_key为键值，进行取值
	_dispatch_thread_semaphore_t sema = (_dispatch_thread_semaphore_t)_dispatch_thread_getspecific(dispatch_sema4_key);
	if (!sema) {// 不存在，建一个新值
		return _dispatch_thread_semaphore_create();
	}
	// 保存新值到线程的私有存储区域，以dispatch_sema4_key为键值进行存储
	_dispatch_thread_setspecific(dispatch_sema4_key, NULL);
	return sema;
}

// _dispatch_put_thread_semaphore内部使用的是“销毁旧的，存储新的”策略来缓存信号量
void _dispatch_put_thread_semaphore(_dispatch_thread_semaphore_t sema)
{
	_dispatch_thread_semaphore_t old_sema = (_dispatch_thread_semaphore_t)
			_dispatch_thread_getspecific(dispatch_sema4_key);
	_dispatch_thread_setspecific(dispatch_sema4_key, (void*)sema);
	if (old_sema) {
		return _dispatch_thread_semaphore_dispose(old_sema);
	}
}
