//
//  Create.m
//  libdispatch
//
//  Created by 王伟虎 on 2018/3/6.
//

#import "Create.h"

#define DISPATCH_QUEUE_SERIAL NULL

#define DISPATCH_QUEUE_CONCURRENT ==> ((__bridge dispatch_queue_attr_t)&(object)) = { \
	.do_vtable = (&OS_dispatch_queue_attr_class), \
	._objc_isa = (&OS_dispatch_queue_attr_class), \
	.do_ref_cnt = DISPATCH_OBJECT_GLOBAL_REFCNT, \
	.do_xref_cnt = DISPATCH_OBJECT_GLOBAL_REFCNT\
	.dqa_qos_and_relpri = (_dispatch_priority_make(QOS_CLASS_UNSPECIFIED, 0) & \
	DISPATCH_PRIORITY_REQUESTED_MASK), \
	.dqa_overcommit = _dispatch_queue_attr_overcommit_unspecified, \
	.dqa_autorelease_frequency = DISPATCH_AUTORELEASE_FREQUENCY_INHERIT, \
	.dqa_concurrent = (1), \
	.dqa_inactive = (false), \
}

@implementation Create

/*
 * 创建dispatch_queue_t队列
 * dispatch_queue_attr_t队列属性结构体，预定义的属性，例如DISPATCH_QUEUE_SERIAL，DISPATCH_QUEUE_CONCURRENT或调用dispatch_queue_attr_make_with_*函数的结果。
 * 通过dispatch_queue_create()函数来创建一个用于提交任务队列的时候，第二个参数传DISPATCH_QUEUE_SERIAL或NULL的时候都会创建一个串行队列，
 */
dispatch_queue_t
dispatch_queue_create(const char *label, dispatch_queue_attr_t attr) {
	return _dispatch_queue_create_with_target(label, attr, DISPATCH_TARGET_QUEUE_DEFAULT, true);
}

static dispatch_queue_t
_dispatch_queue_create_with_target(const char *label, dispatch_queue_attr_t dqa, dispatch_queue_t tq, bool legacy) {
	if (!dqa) {// 传的是串行队列的话 无论是NULL或者DISPATCH_QUEUE_SERIAL代表的都是NULL
		dqa = (dispatch_queue_attr_t)&_dispatch_queue_attrs
				[DISPATCH_QOS_UNSPECIFIED]
				[0]
				[DQA_INDEX_UNSPECIFIED_OVERCOMMIT]
				[DISPATCH_AUTORELEASE_FREQUENCY_INHERIT]
				[DQA_INDEX_SERIAL]
				[DQA_INDEX_ACTIVE];
		}
	
	// 当传入其他队列类型的时候走这个分支
	// 但是DISPATCH_QUEUE_CONCURRENT跳过这个分支
	} else if (dqa->do_vtable != DISPATCH_VTABLE(queue_attr)) {
		DISPATCH_CLIENT_CRASH(dqa->do_vtable, "非法队列属性");
	}
	
	//
	// Step 1: Normalize arguments (qos, overcommit, tq)
	//

	// 优先级
	// 串行队列_dispatch_priority_qos(NULL)
	// 并行队列_dispatch_priority_qos((_dispatch_priority_make(QOS_CLASS_UNSPECIFIED, 0) & DISPATCH_PRIORITY_REQUESTED_MASK))
	dispatch_qos_t qos = _dispatch_priority_qos(dqa->dqa_qos_and_relpri);


#if !HAVE_PTHREAD_WORKQUEUE_QOS
	if (qos == DISPATCH_QOS_USER_INTERACTIVE) {
		qos = DISPATCH_QOS_USER_INITIATED;
	}
	if (qos == DISPATCH_QOS_MAINTENANCE) {
		qos = DISPATCH_QOS_BACKGROUND;
	}
#endif // !HAVE_PTHREAD_WORKQUEUE_QOS

	// 允许创建的子线程个数是否可以超过CPU内核数
	_dispatch_queue_attr_overcommit_t overcommit = dqa->dqa_overcommit;

	// 串行队列
	if (overcommit != _dispatch_queue_attr_overcommit_unspecified && tq) {
		if (tq->do_targetq) {
			DISPATCH_CLIENT_CRASH(tq, "Cannot specify both overcommit and "
								  "a non-global target queue");
		}
	}

	// 并行
	if (tq && !tq->do_targetq &&
		tq->do_ref_cnt == DISPATCH_OBJECT_GLOBAL_REFCNT) {
		// Handle discrepancies between attr and target queue, attributes win
		if (overcommit == _dispatch_queue_attr_overcommit_unspecified) {
			if (tq->dq_priority & DISPATCH_PRIORITY_FLAG_OVERCOMMIT) {
				overcommit = _dispatch_queue_attr_overcommit_enabled;
			} else {
				overcommit = _dispatch_queue_attr_overcommit_disabled;
			}
		}
		if (qos == DISPATCH_QOS_UNSPECIFIED) {
			dispatch_qos_t tq_qos = _dispatch_priority_qos(tq->dq_priority);
			tq = _dispatch_get_root_queue(tq_qos,
										  overcommit == _dispatch_queue_attr_overcommit_enabled);
		} else {
			tq = NULL;
		}
	} else if (tq && !tq->do_targetq) {
		// target is a pthread or runloop root queue, setting QoS or overcommit
		// is disallowed
		if (overcommit != _dispatch_queue_attr_overcommit_unspecified) {
			DISPATCH_CLIENT_CRASH(tq, "Cannot specify an overcommit attribute "
								  "and use this kind of target queue");
		}
		if (qos != DISPATCH_QOS_UNSPECIFIED) {
			DISPATCH_CLIENT_CRASH(tq, "Cannot specify a QoS attribute "
								  "and use this kind of target queue");
		}
	} else {
		if (overcommit == _dispatch_queue_attr_overcommit_unspecified) {
			// Serial queues default to overcommit!
			overcommit = dqa->dqa_concurrent ?
			_dispatch_queue_attr_overcommit_disabled :
			_dispatch_queue_attr_overcommit_enabled;
		}
	}
	if (!tq) {
		tq = _dispatch_get_root_queue(
									  qos == DISPATCH_QOS_UNSPECIFIED ? DISPATCH_QOS_DEFAULT : qos,
									  overcommit == _dispatch_queue_attr_overcommit_enabled);
		if (slowpath(!tq)) {
			DISPATCH_CLIENT_CRASH(qos, "Invalid queue attribute");
		}
	}
	
	//
	// Step 2: Initialize the queue
	//
	
	if (legacy) {
		// if any of these attributes is specified, use non legacy classes
		if (dqa->dqa_inactive || dqa->dqa_autorelease_frequency) {
			legacy = false;
		}
	}
	
	const void *vtable;
	dispatch_queue_flags_t dqf = 0;
	if (legacy) {
		vtable = DISPATCH_VTABLE(queue);
	} else if (dqa->dqa_concurrent) {
		vtable = DISPATCH_VTABLE(queue_concurrent);
	} else {
		vtable = DISPATCH_VTABLE(queue_serial);
	}
	switch (dqa->dqa_autorelease_frequency) {
		case DISPATCH_AUTORELEASE_FREQUENCY_NEVER:
			dqf |= DQF_AUTORELEASE_NEVER;
			break;
		case DISPATCH_AUTORELEASE_FREQUENCY_WORK_ITEM:
			dqf |= DQF_AUTORELEASE_ALWAYS;
			break;
	}
	if (legacy) {
		dqf |= DQF_LEGACY;
	}
	if (label) {
		const char *tmp = _dispatch_strdup_if_mutable(label);
		if (tmp != label) {
			dqf |= DQF_LABEL_NEEDS_FREE;
			label = tmp;
		}
	}
	
	dispatch_queue_t dq = _dispatch_object_alloc(vtable,
												 sizeof(struct dispatch_queue_s) - DISPATCH_QUEUE_CACHELINE_PAD);
	_dispatch_queue_init(dq, dqf, dqa->dqa_concurrent ?
						 DISPATCH_QUEUE_WIDTH_MAX : 1, DISPATCH_QUEUE_ROLE_INNER |
						 (dqa->dqa_inactive ? DISPATCH_QUEUE_INACTIVE : 0));
	
	dq->dq_label = label;
#if HAVE_PTHREAD_WORKQUEUE_QOS
	dq->dq_priority = dqa->dqa_qos_and_relpri;
	if (overcommit == _dispatch_queue_attr_overcommit_enabled) {
		dq->dq_priority |= DISPATCH_PRIORITY_FLAG_OVERCOMMIT;
	}
#endif
	_dispatch_retain(tq);
	if (qos == QOS_CLASS_UNSPECIFIED) {
		// legacy way of inherithing the QoS from the target
		_dispatch_queue_priority_inherit_from_target(dq, tq);
	}
	if (!dqa->dqa_inactive) {
		_dispatch_queue_inherit_wlh_from_target(dq, tq);
	}
	dq->do_targetq = tq;
	_dispatch_object_debug(dq, "%s", __func__);
	return dq;
}

void *
_dispatch_object_alloc(const void *vtable, size_t size)
{
#if OS_OBJECT_HAVE_OBJC1
	const struct dispatch_object_vtable_s *_vtable = vtable;
	dispatch_object_t dou;
	dou._os_obj = _os_object_alloc_realized(_vtable->_os_obj_objc_isa, size);
	dou._do->do_vtable = vtable;
	return dou._do;
#else
	return _os_object_alloc_realized(vtable, size);
#endif
}

static inline void
_dispatch_queue_init(dispatch_queue_t dq, dispatch_queue_flags_t dqf,
					 uint16_t width, uint64_t initial_state_bits) {
	uint64_t dq_state = DISPATCH_QUEUE_STATE_INIT_VALUE(width);
	
	dispatch_assert((initial_state_bits & ~(DISPATCH_QUEUE_ROLE_MASK |
											DISPATCH_QUEUE_INACTIVE)) == 0);
	
	if (initial_state_bits & DISPATCH_QUEUE_INACTIVE) {
		dq_state |= DISPATCH_QUEUE_INACTIVE + DISPATCH_QUEUE_NEEDS_ACTIVATION;
		dq->do_ref_cnt += 2; // rdar://8181908 see _dispatch_queue_resume
	}
	
	dq_state |= (initial_state_bits & DISPATCH_QUEUE_ROLE_MASK);
	dq->do_next = (struct dispatch_queue_s *)DISPATCH_OBJECT_LISTLESS;
	dqf |= DQF_WIDTH(width);
	os_atomic_store2o(dq, dq_atomic_flags, dqf, relaxed);
	dq->dq_state = dq_state;
	dq->dq_serialnum =
	os_atomic_inc_orig(&_dispatch_queue_serial_numbers, relaxed);
}

static inline void
_dispatch_sync_function_invoke_inline(dispatch_queue_t dq, void *ctxt, dispatch_function_t func) {
	dispatch_thread_frame_s dtf;
	// _dispatch_thread_frame_push(&dtf, dq);
	{
		void **)&dtf->dtf_queue[0] = _dispatch_thread_getspecific(dispatch_queue_key);
		void **)&dtf->dtf_queue[1] = _dispatch_thread_getspecific(dispatch_frame_key);
		_dispatch_thread_setspecific(dispatch_queue_key, dq);
		_dispatch_thread_setspecific(dispatch_frame_key, dtf);
	}
	// _dispatch_client_callout(ctxt, func);
	{
		@try {
			return f(ctxt);
		}
		@catch (...) {
			objc_terminate();
		}
	}
	// _dispatch_perfmon_workitem_inc();
	{
		unsigned long cnt;
		cnt = (unsigned long)_dispatch_thread_getspecific(dispatch_bcounter_key);
		_dispatch_thread_setspecific(dispatch_bcounter_key, (void *)++cnt);
	}
	// _dispatch_thread_frame_pop(&dtf);
	{
		_dispatch_thread_setspecific(dispatch_queue_key, (void **)&dtf->dtf_queue)[0]);
		_dispatch_thread_setspecific(dispatch_frame_key, (void **)&dtf->dtf_queue)[1]);
	}
}

static void
_dispatch_queue_barrier_sync_invoke_and_complete(dispatch_queue_t dq,void *ctxt, dispatch_function_t func)
{
	//
	_dispatch_sync_function_invoke_inline(dq, ctxt, func);
	
	
	
	if (unlikely(dq->dq_items_tail || dq->dq_width > 1)) {
		return _dispatch_queue_barrier_complete(dq, 0, 0);
	}
	
	// Presence of any of these bits requires more work that only
	// _dispatch_queue_barrier_complete() handles properly
	//
	// Note: testing for RECEIVED_OVERRIDE or RECEIVED_SYNC_WAIT without
	// checking the role is sloppy, but is a super fast check, and neither of
	// these bits should be set if the lock was never contended/discovered.
	const uint64_t fail_unlock_mask = DISPATCH_QUEUE_SUSPEND_BITS_MASK |
	DISPATCH_QUEUE_ENQUEUED | DISPATCH_QUEUE_DIRTY |
	DISPATCH_QUEUE_RECEIVED_OVERRIDE | DISPATCH_QUEUE_SYNC_TRANSFER |
	DISPATCH_QUEUE_RECEIVED_SYNC_WAIT;
	uint64_t old_state, new_state;
	
	// similar to _dispatch_queue_drain_try_unlock
	os_atomic_rmw_loop2o(dq, dq_state, old_state, new_state, release, {
		new_state  = old_state - DISPATCH_QUEUE_SERIAL_DRAIN_OWNED;
		new_state &= ~DISPATCH_QUEUE_DRAIN_UNLOCK_MASK;
		new_state &= ~DISPATCH_QUEUE_MAX_QOS_MASK;
		if (unlikely(old_state & fail_unlock_mask)) {
			os_atomic_rmw_loop_give_up({
				return _dispatch_queue_barrier_complete(dq, 0, 0);
			});
		}
	});
	if (_dq_state_is_base_wlh(old_state)) {
		_dispatch_event_loop_assert_not_owned((dispatch_wlh_t)dq);
	}
}

@end
