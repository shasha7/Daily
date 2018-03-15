/*
 * Copyright (c) 2008-2011 Apple Inc. All rights reserved.
 *
 * @APPLE_APACHE_LICENSE_HEADER_START@
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * @APPLE_APACHE_LICENSE_HEADER_END@
 */

/*
 * IMPORTANT: This header file describes INTERNAL interfaces to libdispatch
 * which are subject to change in future releases of Mac OS X. Any applications
 * relying on these interfaces WILL break.
 */

#ifndef __DISPATCH_QUEUE_INTERNAL__
#define __DISPATCH_QUEUE_INTERNAL__

#ifndef __DISPATCH_INDIRECT__
#error "Please #include <dispatch/dispatch.h> instead of this file directly."
#include <dispatch/base.h> // for HeaderDoc
#endif

// If dc_vtable is less than 127, then the object is a continuation.
// Otherwise, the object has a private layout and memory management rules. The
// first two words must align with normal objects.
// 如果dc_vtable < 127 才表示这个object是一个continuation；否则表示是一个私有的布局，这个私有的布局表示它可能是一个队列或者其他的结构，这种私有的布局的结构要求前面2个字，也就是前32位必须与普通object是对齐的；
// 以后在队列和任务的调度过程中，会发现这个do_vtable用来判定调度的对象是任务和队列；
#define DISPATCH_CONTINUATION_HEADER(x) \
	const void *do_vtable; \
	struct x *volatile do_next; \
	dispatch_function_t dc_func; \
	void *dc_ctxt

#define DISPATCH_OBJ_ASYNC_BIT		0x1
#define DISPATCH_OBJ_BARRIER_BIT	0x2
#define DISPATCH_OBJ_GROUP_BIT		0x4
#define DISPATCH_OBJ_SYNC_SLOW_BIT	0x8

// vtables are pointers far away from the low page in memory
#define DISPATCH_OBJ_IS_VTABLE(x) ((unsigned long)(x)->do_vtable > 127ul)

/*
#define DISPATCH_CONTINUATION_HEADER(x) \
const void *do_vtable; \
struct x *volatile do_next; \
dispatch_function_t dc_func; \
void *dc_ctxt
*/

struct dispatch_continuation_s {
	DISPATCH_CONTINUATION_HEADER(dispatch_continuation_s);
	dispatch_group_t dc_group;
	void *dc_data[3];
};

typedef struct dispatch_continuation_s *dispatch_continuation_t;

struct dispatch_queue_attr_vtable_s {
	DISPATCH_VTABLE_HEADER(dispatch_queue_attr_s);
};

struct dispatch_queue_attr_s {
	DISPATCH_STRUCT_HEADER(dispatch_queue_attr_s, dispatch_queue_attr_vtable_s);
};

struct dispatch_queue_vtable_s {
	DISPATCH_VTABLE_HEADER(dispatch_queue_s);
};

#define DISPATCH_QUEUE_MIN_LABEL_SIZE 64

#ifdef __LP64__
#define DISPATCH_QUEUE_CACHELINE_PAD 32
#else
#define DISPATCH_QUEUE_CACHELINE_PAD 8
#endif

#define DISPATCH_QUEUE_HEADER \
	uint32_t volatile dq_running; \
	uint32_t dq_width; \
	struct dispatch_object_s *volatile dq_items_tail; \
	struct dispatch_object_s *volatile dq_items_head; \
	unsigned long dq_serialnum; \
	dispatch_queue_t dq_specific_q;

//struct dispatch_queue_s {
//	DISPATCH_STRUCT_HEADER(dispatch_queue_s, dispatch_queue_vtable_s);
//	DISPATCH_QUEUE_HEADER;
//	char dq_label[DISPATCH_QUEUE_MIN_LABEL_SIZE]; // must be last
//	char _dq_pad[DISPATCH_QUEUE_CACHELINE_PAD]; // for static queues only
//};

struct dispatch_queue_s {
	const struct dispatch_queue_vtable_s *do_vtable;
	struct dispatch_queue_s *volatile do_next;
	unsigned int do_ref_cnt;
	unsigned int do_xref_cnt;
	unsigned int do_suspend_cnt;//通常用于指示延时处理的任务，当计数大于等于2表示为延时任务；
	struct dispatch_queue_s *do_targetq;//目标队列，通常如果不是全局队列、主队列，如mgr_queue，需要压入到glablalQueue、主队列中来处理，因此需要指明target_queue，所有新建的的队列会把默认优先级的全局并发队列当做其目标队列，把一个串行队列设置为一个并发队列的目标队列并没有实际的应用的意义
	void *do_ctxt;//上下文，关于线程池相关的，用来存储线程池相关数据，比如用于线程挂起和唤醒的信号量、线程池大小等；
	void *do_finalizer;
	uint32_t volatile dq_running;
	uint32_t dq_width;//判定可以并行运行的任务数
	struct dispatch_object_s *volatile dq_items_tail;
	struct dispatch_object_s *volatile dq_items_head;
	unsigned long dq_serialnum;
	dispatch_queue_t dq_specific_q;
	char dq_label[64]; // must be last
	char _dq_pad[32]; // for static queues only
};

extern struct dispatch_queue_s _dispatch_mgr_q;

void _dispatch_queue_dispose(dispatch_queue_t dq);
void _dispatch_queue_invoke(dispatch_queue_t dq);
void _dispatch_queue_push_list_slow(dispatch_queue_t dq,
		struct dispatch_object_s *obj);

DISPATCH_ALWAYS_INLINE
static inline void
_dispatch_queue_push_list(dispatch_queue_t dq, dispatch_object_t _head, dispatch_object_t _tail)
{
	/*
	 进入到_dispatch_queue_push_list，_head/_tail都是dc；
	 1.将tail->do_next设置为NULL；
	 2.然后将prev = fastpath(dispatch_atomic_xchg(&dq->dq_items_tail, tail));这条语句干了这么两件事：
	 	(a). 将dc插入到dq->dq_items_tail上；也就是tail和dq->dq_items_tail互换；
	 	(b). 返回dq->dq_items_tail的值；
	 3.若发现prev != NULL，表示dq中存在任务，prev->do_next = head；表示将Head插入到prev的后面??,然后返回；
	 4.否则，进入到_dispatch_queue_push_list_slow(dq, head)；
	 */
	struct dispatch_object_s *prev, *head = _head._do, *tail = _tail._do;
	//#1
	tail->do_next = NULL;
	//#2
	// prev = fastpath(dispatch_atomic_xchg2o(dq, dq_items_tail, tail));
	dispatch_object_s *tmp = dq->dq_items_tail;
	dq->dq_items_tail = tail;
	tail = tmp;
	prev = dq->dq_items_tail;
	//#3
	if (prev) {
		prev->do_next = head;
	} else {
		//#4
		_dispatch_queue_push_list_slow(dq, head);
	}
}

#define _dispatch_queue_push(x, y) _dispatch_queue_push_list((x), (y), (y))

#if DISPATCH_DEBUG
void dispatch_debug_queue(dispatch_queue_t dq, const char* str);
#else
static inline void dispatch_debug_queue(dispatch_queue_t dq DISPATCH_UNUSED,
		const char* str DISPATCH_UNUSED) {}
#endif

size_t dispatch_queue_debug(dispatch_queue_t dq, char* buf, size_t bufsiz);
size_t _dispatch_queue_debug_attr(dispatch_queue_t dq, char* buf,
		size_t bufsiz);

DISPATCH_ALWAYS_INLINE
static inline dispatch_queue_t
_dispatch_queue_get_current(void)
{
	return _dispatch_thread_getspecific(dispatch_queue_key);
}

#define DISPATCH_QUEUE_PRIORITY_COUNT 4
#define DISPATCH_ROOT_QUEUE_COUNT (DISPATCH_QUEUE_PRIORITY_COUNT * 2)

// overcommit priority index values need bit 1 set
enum {
	DISPATCH_ROOT_QUEUE_IDX_LOW_PRIORITY = 0,
	DISPATCH_ROOT_QUEUE_IDX_LOW_OVERCOMMIT_PRIORITY,
	DISPATCH_ROOT_QUEUE_IDX_DEFAULT_PRIORITY,
	DISPATCH_ROOT_QUEUE_IDX_DEFAULT_OVERCOMMIT_PRIORITY,
	DISPATCH_ROOT_QUEUE_IDX_HIGH_PRIORITY,
	DISPATCH_ROOT_QUEUE_IDX_HIGH_OVERCOMMIT_PRIORITY,
	DISPATCH_ROOT_QUEUE_IDX_BACKGROUND_PRIORITY,
	DISPATCH_ROOT_QUEUE_IDX_BACKGROUND_OVERCOMMIT_PRIORITY,
};

extern const struct dispatch_queue_attr_vtable_s dispatch_queue_attr_vtable;
extern const struct dispatch_queue_vtable_s _dispatch_queue_vtable;
extern unsigned long _dispatch_queue_serial_numbers;
extern struct dispatch_queue_s _dispatch_root_queues[];

DISPATCH_ALWAYS_INLINE DISPATCH_CONST
static inline dispatch_queue_t
_dispatch_get_root_queue(long priority, bool overcommit)
{
	if (overcommit) {
		switch (priority) {
			case DISPATCH_QUEUE_PRIORITY_LOW:
				return &_dispatch_root_queues[DISPATCH_ROOT_QUEUE_IDX_LOW_OVERCOMMIT_PRIORITY];
			case DISPATCH_QUEUE_PRIORITY_DEFAULT:
				return &_dispatch_root_queues[DISPATCH_ROOT_QUEUE_IDX_DEFAULT_OVERCOMMIT_PRIORITY];
			case DISPATCH_QUEUE_PRIORITY_HIGH:
				return &_dispatch_root_queues[DISPATCH_ROOT_QUEUE_IDX_HIGH_OVERCOMMIT_PRIORITY];
			case DISPATCH_QUEUE_PRIORITY_BACKGROUND:
				return &_dispatch_root_queues[DISPATCH_ROOT_QUEUE_IDX_BACKGROUND_OVERCOMMIT_PRIORITY];
		}
	}
	switch (priority) {
		case DISPATCH_QUEUE_PRIORITY_LOW:
			return &_dispatch_root_queues[DISPATCH_ROOT_QUEUE_IDX_LOW_PRIORITY];
		case DISPATCH_QUEUE_PRIORITY_DEFAULT:
			return &_dispatch_root_queues[DISPATCH_ROOT_QUEUE_IDX_DEFAULT_PRIORITY];
		case DISPATCH_QUEUE_PRIORITY_HIGH:
			return &_dispatch_root_queues[DISPATCH_ROOT_QUEUE_IDX_HIGH_PRIORITY];
		case DISPATCH_QUEUE_PRIORITY_BACKGROUND:
			return &_dispatch_root_queues[DISPATCH_ROOT_QUEUE_IDX_BACKGROUND_PRIORITY];
		default:
			return NULL;
	}
}

// Note to later developers: ensure that any initialization changes are
// made for statically allocated queues (i.e. _dispatch_main_q).
static inline void
_dispatch_queue_init(dispatch_queue_t dq)
{
	dq->do_vtable = &_dispatch_queue_vtable;
	dq->do_next = DISPATCH_OBJECT_LISTLESS;
	dq->do_ref_cnt = 1;
	dq->do_xref_cnt = 1;
	// Default target queue is overcommit!
	// 这里也印证了我们自己创建的队列都会赋值一个默认优先级的全局队列用作目标队列，且这个目标队列可用于并行执行的线程数目是超过当前设备的核数的。
	/*
	 do_targetq:
	 {
	 .do_vtable = &_dispatch_queue_root_vtable,
	 .do_ref_cnt = DISPATCH_OBJECT_GLOBAL_REFCNT,
	 .do_xref_cnt = DISPATCH_OBJECT_GLOBAL_REFCNT,
	 .do_suspend_cnt = DISPATCH_OBJECT_SUSPEND_LOCK,
	 .do_ctxt = &_dispatch_root_queue_contexts[DISPATCH_ROOT_QUEUE_IDX_DEFAULT_OVERCOMMIT_PRIORITY],
	 .dq_label = "com.apple.root.default-overcommit-priority",
	 .dq_running = 2,
	 .dq_width = UINT32_MAX,
	 .dq_serialnum = 7,
	 }
	 */
	dq->do_targetq = _dispatch_get_root_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, true);
	dq->dq_running = 0;
	dq->dq_width = 1;
	dq->dq_serialnum = dispatch_atomic_inc(&_dispatch_queue_serial_numbers) - 1;
}

#endif
