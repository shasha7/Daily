
// 主队列的vtable结构
const struct dispatch_queue_vtable_s _dispatch_queue_vtable = {
    .do_type = DISPATCH_QUEUE_TYPE,
    .do_kind = "queue",
    .do_dispose = _dispatch_queue_dispose,
    .do_invoke = NULL,
    .do_probe = (void *)dummy_function_r0,
    .do_debug = dispatch_queue_debug,
};

// 主队列的目标队列的vtable结构
static const struct dispatch_queue_vtable_s _dispatch_queue_root_vtable = {
    .do_type = DISPATCH_QUEUE_GLOBAL_TYPE,
    .do_kind = "global-queue",
    .do_debug = dispatch_queue_debug,
    .do_probe = _dispatch_queue_wakeup_global,
};

// 主队列的目标队列:
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

struct dispatch_queue_s _dispatch_main_q = {
    .do_vtable = &_dispatch_queue_vtable,
    .do_targetq = &_dispatch_root_queues[DISPATCH_ROOT_QUEUE_IDX_DEFAULT_OVERCOMMIT_PRIORITY],
    .do_ref_cnt = DISPATCH_OBJECT_GLOBAL_REFCNT,
    .do_xref_cnt = DISPATCH_OBJECT_GLOBAL_REFCNT,
    .do_suspend_cnt = DISPATCH_OBJECT_SUSPEND_LOCK,
    .dq_label = "com.apple.main-thread",
    .dq_running = 1,
    .dq_width = 1,
    .dq_serialnum = 1,
};


