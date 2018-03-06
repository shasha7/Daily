/*
 * Copyright (c) 2008-2014 Apple Inc. All rights reserved.
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

#ifndef __DISPATCH_QUEUE__
#define __DISPATCH_QUEUE__

#ifndef __DISPATCH_INDIRECT__
#error "Please #include <dispatch/dispatch.h> instead of this file directly."
#include <dispatch/base.h> // for HeaderDoc
#endif

#if __has_include(<sys/qos.h>)
#include <sys/qos.h>
#endif

DISPATCH_ASSUME_NONNULL_BEGIN

/*!
 * @header
 *
 * Dispatch是通过简单但功能强大的API来表达并发性的抽象模型
 * 在核心，dispatch提供了可以提交块的串行FIFO队列。提交给这些分派队列的块在由系统完全管理的线程池上调用。无法保证块将在哪个线程上被调用; 但是，一次只能调用一个提交给FIFO调度队列的数据块
 * 当多个队列有要处理的块时，系统可以自由分配额外的线程来同时调用这些块。当队列变空时，这些线程会自动释放。
 *
 * Dispatch is an abstract model for expressing concurrency via simple but
 * powerful API.
 *
 * At the core, dispatch provides serial FIFO queues to which blocks may be
 * submitted. Blocks submitted to these dispatch queues are invoked on a pool
 * of threads fully managed by the system. No guarantee is made regarding
 * which thread a block will be invoked on; however, it is guaranteed that only
 * one block submitted to the FIFO dispatch queue will be invoked at a time.
 *
 * When multiple queues have blocks to be processed, the system is free to
 * allocate additional threads to invoke the blocks concurrently. When the
 * queues become empty, these threads are automatically released.
 */

/*!
 * @typedef dispatch_queue_t
 *
 * @abstract
 * 分派队列以FIFO顺序调用以串行方式提交给它们的块。一个队列一次只能调用一个块，但是独立的队列可能会相互之间同时调用它们的块
 * 分派队列是可以提交块的轻量级对象。系统管理线程池，处理分派队列并调用提交给它们的块。
 * 从概念上讲，分派队列可以有它自己的执行线程，并且队列之间的交互是非常异步的
 * 调度队列通过调用dispatch_retain（）和dispatch_release（）进行引用计数。 提交给队列的待处理块在队列完成之前还会持续引用队列。 一旦所有对队列的引用都被释放，队列将被系统解除分配。
 *
 * Dispatch queues invoke blocks submitted to them serially in FIFO order. A
 * queue will only invoke one block at a time, but independent queues may each
 * invoke their blocks concurrently with respect to each other.
 *
 * @discussion
 * Dispatch queues are lightweight objects to which blocks may be submitted.
 * The system manages a pool of threads which process dispatch queues and
 * invoke blocks submitted to them.
 *
 * Conceptually a dispatch queue may have its own thread of execution, and
 * interaction between queues is highly asynchronous.
 *
 * Dispatch queues are reference counted via calls to dispatch_retain() and
 * dispatch_release(). Pending blocks submitted to a queue also hold a
 * reference to the queue until they have finished. Once all references to a
 * queue have been released, the queue will be deallocated by the system.
 */
DISPATCH_DECL(dispatch_queue); // 相当于===>

typedef struct dispatch_queue_s : public dispatch_object_s {
	
} *dispatch_queue_t

__BEGIN_DECLS

/*!
 * @function dispatch_async
 *
 * @abstract
 * 提交一个在调度队列上异步执行的块。
 
 * dispatch_async()函数是将块提交给调度队列的基本机制。
 * 调用dispatch_async()总是在块被提交后立即返回，并且永远不会等待块被调用。
 * 目标队列确定是否将相对于提交给同一队列的其他块而连续或同时调用该块。串行队列相对于彼此同时处理。
 * @param queue
 * 提交块到目标分派队列。
 * 系统将在目标队列上保存一个参考，直到块完成。
 * 在这个参数中传递NULL的结果是未定义的。
 * @param block
 * 要提交给目标调度队列的块。
 * 这个函数代表调用者执行Block_copy（）和Block_release（）。
 * 在这个参数中传递NULL的结果是未定义的。
 * Submits a block for asynchronous execution on a dispatch queue.
 *
 * @discussion
 * The dispatch_async() function is the fundamental mechanism for submitting
 * blocks to a dispatch queue.
 *
 * Calls to dispatch_async() always return immediately after the block has
 * been submitted, and never wait for the block to be invoked.
 *
 * The target queue determines whether the block will be invoked serially or
 * concurrently with respect to other blocks submitted to that same queue.
 * Serial queues are processed concurrently with respect to each other.
 *
 * @param queue
 * The target dispatch queue to which the block is submitted.
 * The system will hold a reference on the target queue until the block
 * has finished.
 * The result of passing NULL in this parameter is undefined.
 *
 * @param block
 * The block to submit to the target dispatch queue. This function performs
 * Block_copy() and Block_release() on behalf of callers.
 * The result of passing NULL in this parameter is undefined.
 */
#ifdef __BLOCKS__

API_AVAILABLE(macos(10.6), ios(4.0))
DISPATCH_EXPORT DISPATCH_NONNULL_ALL DISPATCH_NOTHROW
// typedef void (^dispatch_block_t)(void);
void dispatch_async(dispatch_queue_t queue, dispatch_block_t block);

#endif

/*!
 * @function dispatch_async_f
 *
 * @abstract
 * Submits a function for asynchronous execution on a dispatch queue.
 *
 * @discussion
 * See dispatch_async() for details.
 *
 * @param queue
 * The target dispatch queue to which the function is submitted.
 * The system will hold a reference on the target queue until the function
 * has returned.
 * The result of passing NULL in this parameter is undefined.
 *
 * @param context
 * The application-defined context parameter to pass to the function.
 *
 * @param work
 * The application-defined function to invoke on the target queue. The first
 * parameter passed to this function is the context provided to
 * dispatch_async_f().
 * The result of passing NULL in this parameter is undefined.
 */
API_AVAILABLE(macos(10.6), ios(4.0))
DISPATCH_EXPORT DISPATCH_NONNULL1 DISPATCH_NONNULL3 DISPATCH_NOTHROW
void dispatch_async_f(dispatch_queue_t queue, void *_Nullable context, dispatch_function_t work);

/*!
 * @function dispatch_sync
 *
 * @abstract
 * 提交一个任务在调度队列上同步执行
 * Submits a block for synchronous execution on a dispatch queue.
 *
 * @discussion
 * 将一个任务提交到dispatch_async()调度队列，dispatch_sync()将不会返回，直到块完成
 * Submits a block to a dispatch queue like dispatch_async(), however
 * dispatch_sync() will not return until the block has finished.
 * 在当前队列调用dispatch_sync()将导致死锁。dispatch_sync()的使用也受制于可能因使用互斥体而导致的相同多方死锁问题。使用dispatch_async()为首选
 * Calls to dispatch_sync() targeting the current queue will result
 * in dead-lock. Use of dispatch_sync() is also subject to the same
 * multi-party dead-lock problems that may result from the use of a mutex.
 * Use of dispatch_async() is preferred.
 *
 * 与dispatch_async()不同，由于对此函数的调用是同步的，所以目标队列并不会引用，dispatch_sync()“借用”调用者的引用
 * Unlike dispatch_async(), no retain is performed on the target queue. Because
 * calls to this function are synchronous, the dispatch_sync() "borrows" the
 * reference of the caller.
 *
 * As an optimization, dispatch_sync() invokes the block on the current
 * thread when possible.
 *
 * @param queue
 * The target dispatch queue to which the block is submitted.
 * The result of passing NULL in this parameter is undefined.
 *
 * @param block
 * The block to be invoked on the target dispatch queue.
 * The result of passing NULL in this parameter is undefined.
 */
#ifdef __BLOCKS__
API_AVAILABLE(macos(10.6), ios(4.0))
DISPATCH_EXPORT DISPATCH_NONNULL_ALL DISPATCH_NOTHROW
void
dispatch_sync(dispatch_queue_t queue, DISPATCH_NOESCAPE dispatch_block_t block);
#endif

/*!
 * @function dispatch_sync_f
 *
 * @abstract
 * Submits a function for synchronous execution on a dispatch queue.
 *
 * @discussion
 * See dispatch_sync() for details.
 *
 * @param queue
 * The target dispatch queue to which the function is submitted.
 * The result of passing NULL in this parameter is undefined.
 *
 * @param context
 * The application-defined context parameter to pass to the function.
 *
 * @param work
 * The application-defined function to invoke on the target queue. The first
 * parameter passed to this function is the context provided to
 * dispatch_sync_f().
 * The result of passing NULL in this parameter is undefined.
 */
API_AVAILABLE(macos(10.6), ios(4.0))
DISPATCH_EXPORT DISPATCH_NONNULL1 DISPATCH_NONNULL3 DISPATCH_NOTHROW
void
dispatch_sync_f(dispatch_queue_t queue,
	void *_Nullable context,
	dispatch_function_t work);


#if !defined(__APPLE__) || TARGET_OS_WATCH || TARGET_OS_TV || \
		(defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && \
		__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0) || \
		(defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && \
		__MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_9)
#define DISPATCH_APPLY_AUTO_AVAILABLE 1
#else
#define DISPATCH_APPLY_AUTO_AVAILABLE 0
#endif

/*!
 * @constant DISPATCH_APPLY_AUTO
 *
 * @abstract
 * Constant to pass to dispatch_apply() or dispatch_apply_f() to request that
 * the system automatically use worker threads that match the configuration of
 * the current thread as closely as possible.
 *
 * @discussion
 * When submitting a block for parallel invocation, passing this constant as the
 * queue argument will automatically use the global concurrent queue that
 * matches the Quality of Service of the caller most closely.
 *
 * No assumptions should be made about which global concurrent queue will
 * actually be used.
 *
 * Using this constant deploys backward to macOS 10.9, iOS 7.0 and any tvOS or
 * watchOS version.
 */
#if DISPATCH_APPLY_AUTO_AVAILABLE
#define DISPATCH_APPLY_AUTO ((dispatch_queue_t _Nonnull)0)
#endif

/*!
 * @function dispatch_apply
 *
 * @abstract
 * 将一个块提交给分派队列 并行调用。
 * Submits a block to a dispatch queue for parallel invocation.
 *
 * @discussion
 * Submits a block to a dispatch queue for parallel invocation. This function
 * waits for the task block to complete before returning. If the specified queue
 * is concurrent, the block may be invoked concurrently, and it must therefore
 * be reentrant safe.
 *
 * Each invocation of the block will be passed the current index of iteration.
 *
 * @param iterations
 * The number of iterations to perform.
 *
 * @param queue
 * The dispatch queue to which the block is submitted.
 * The preferred value to pass is DISPATCH_APPLY_AUTO to automatically use
 * a queue appropriate for the calling thread.
 *
 * @param block
 * The block to be invoked the specified number of iterations.
 * The result of passing NULL in this parameter is undefined.
 */
#ifdef __BLOCKS__
API_AVAILABLE(macos(10.6), ios(4.0))
DISPATCH_EXPORT DISPATCH_NONNULL3 DISPATCH_NOTHROW
void
dispatch_apply(size_t iterations, dispatch_queue_t queue,
		DISPATCH_NOESCAPE void (^block)(size_t));
#endif

/*!
 * @function dispatch_apply_f
 *
 * @abstract
 * Submits a function to a dispatch queue for parallel invocation.
 *
 * @discussion
 * See dispatch_apply() for details.
 *
 * @param iterations
 * The number of iterations to perform.
 *
 * @param queue
 * The dispatch queue to which the function is submitted.
 * The preferred value to pass is DISPATCH_APPLY_AUTO to automatically use
 * a queue appropriate for the calling thread.
 *
 * @param context
 * The application-defined context parameter to pass to the function.
 *
 * @param work
 * The application-defined function to invoke on the specified queue. The first
 * parameter passed to this function is the context provided to
 * dispatch_apply_f(). The second parameter passed to this function is the
 * current index of iteration.
 * The result of passing NULL in this parameter is undefined.
 */
API_AVAILABLE(macos(10.6), ios(4.0))
DISPATCH_EXPORT DISPATCH_NONNULL4 DISPATCH_NOTHROW
void
dispatch_apply_f(size_t iterations, dispatch_queue_t queue,
	void *_Nullable context,
	void (*work)(void *_Nullable, size_t));

/*!
 * @function dispatch_get_current_queue
 *
 * @abstract
 * Returns the queue on which the currently executing block is running.
 *
 * @discussion
 * Returns the queue on which the currently executing block is running.
 *
 * When dispatch_get_current_queue() is called outside of the context of a
 * submitted block, it will return the default concurrent queue.
 *
 * Recommended for debugging and logging purposes only:
 * The code must not make any assumptions about the queue returned, unless it
 * is one of the global queues or a queue the code has itself created.
 * The code must not assume that synchronous execution onto a queue is safe
 * from deadlock if that queue is not the one returned by
 * dispatch_get_current_queue().
 *
 * When dispatch_get_current_queue() is called on the main thread, it may
 * or may not return the same value as dispatch_get_main_queue(). Comparing
 * the two is not a valid way to test whether code is executing on the
 * main thread (see dispatch_assert_queue() and dispatch_assert_queue_not()).
 *
 * This function is deprecated and will be removed in a future release.
 *
 * @result
 * Returns the current queue.
 */
API_DEPRECATED("unsupported interface", macos(10.6,10.9), ios(4.0,6.0))
DISPATCH_EXPORT DISPATCH_PURE DISPATCH_WARN_RESULT DISPATCH_NOTHROW
dispatch_queue_t
dispatch_get_current_queue(void);

API_AVAILABLE(macos(10.6), ios(4.0))
DISPATCH_EXPORT struct dispatch_queue_s _dispatch_main_q;

/*!
 * @function dispatch_get_main_queue
 *
 * @abstract
 * 返回绑定到主线程的默认队列。
 * Returns the default queue that is bound to the main thread.
 *
 * @discussion
 * In order to invoke blocks submitted to the main queue, the application must
 * call dispatch_main(), NSApplicationMain(), or use a CFRunLoop on the main
 * thread.
 *
 * @result
 * Returns the main queue. This queue is created automatically on behalf of
 * the main thread before main() is called.
 */
DISPATCH_INLINE DISPATCH_ALWAYS_INLINE DISPATCH_CONST DISPATCH_NOTHROW
dispatch_queue_t
dispatch_get_main_queue(void)
{
	return (__bridge dispatch_queue_t)&(_dispatch_main_q);
}

/*!
 * @typedef dispatch_queue_priority_t
 * Type of dispatch_queue_priority
 *
 * @constant DISPATCH_QUEUE_PRIORITY_HIGH
 * Items dispatched to the queue will run at high priority,
 * i.e. the queue will be scheduled for execution before
 * any default priority or low priority queue.
 *
 * @constant DISPATCH_QUEUE_PRIORITY_DEFAULT
 * Items dispatched to the queue will run at the default
 * priority, i.e. the queue will be scheduled for execution
 * after all high priority queues have been scheduled, but
 * before any low priority queues have been scheduled.
 *
 * @constant DISPATCH_QUEUE_PRIORITY_LOW
 * Items dispatched to the queue will run at low priority,
 * i.e. the queue will be scheduled for execution after all
 * default priority and high priority queues have been
 * scheduled.
 *
 * @constant DISPATCH_QUEUE_PRIORITY_BACKGROUND
 * Items dispatched to the queue will run at background priority, i.e. the queue
 * will be scheduled for execution after all higher priority queues have been
 * scheduled and the system will run items on this queue on a thread with
 * background status as per setpriority(2) (i.e. disk I/O is throttled and the
 * thread's scheduling priority is set to lowest value).
 */
#define DISPATCH_QUEUE_PRIORITY_HIGH 2
#define DISPATCH_QUEUE_PRIORITY_DEFAULT 0
#define DISPATCH_QUEUE_PRIORITY_LOW (-2)
#define DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN

typedef long dispatch_queue_priority_t;

/*!
 * @typedef dispatch_qos_class_t
 * Alias for qos_class_t type.
 */
#if __has_include(<sys/qos.h>)
typedef qos_class_t dispatch_qos_class_t;
#else
typedef unsigned int dispatch_qos_class_t;
#endif

/*!
 * @function dispatch_get_global_queue
 *
 * @abstract
 * 返回一个给定优先级、众所周知的全局并发队列
 * Returns a well-known global concurrent queue of a given quality of service
 * class.
 *
 * @discussion
 * The well-known global concurrent queues may not be modified. Calls to
 * dispatch_suspend(), dispatch_resume(), dispatch_set_context(), etc., will
 * have no effect when used with queues returned by this function.
 *
 * @param identifier
 * A quality of service class defined in qos_class_t or a priority defined in
 * dispatch_queue_priority_t.
 *
 * It is recommended to use quality of service class values to identify the
 * well-known global concurrent queues:
 *  - QOS_CLASS_USER_INTERACTIVE
 *  - QOS_CLASS_USER_INITIATED
 *  - QOS_CLASS_DEFAULT
 *  - QOS_CLASS_UTILITY
 *  - QOS_CLASS_BACKGROUND
 *
 * The global concurrent queues may still be identified by their priority,
 * which map to the following QOS classes:
 *  - DISPATCH_QUEUE_PRIORITY_HIGH:         QOS_CLASS_USER_INITIATED
 *  - DISPATCH_QUEUE_PRIORITY_DEFAULT:      QOS_CLASS_DEFAULT
 *  - DISPATCH_QUEUE_PRIORITY_LOW:          QOS_CLASS_UTILITY
 *  - DISPATCH_QUEUE_PRIORITY_BACKGROUND:   QOS_CLASS_BACKGROUND
 *
 * @param flags
 * 这个参数是预留以后使用的，传递除0之外的任何值都可能导致返回值为NULL
 * Reserved for future use. Passing any value other than zero may result in
 * a NULL return value.
 *
 * @result
 * 如果请求的全局队列不存在，则返回所请求的全局队列或NULL。
 * Returns the requested global queue or NULL if the requested global queue
 * does not exist.
 */
API_AVAILABLE(macos(10.6), ios(4.0))
DISPATCH_EXPORT DISPATCH_CONST DISPATCH_WARN_RESULT DISPATCH_NOTHROW
dispatch_queue_t
dispatch_get_global_queue(long identifier, unsigned long flags);

/*!
 * @typedef dispatch_queue_attr_t
 *
 * @abstract
 * Attribute for dispatch queues.
 */
DISPATCH_DECL(dispatch_queue_attr);

/*!
 * @const DISPATCH_QUEUE_SERIAL
 *
 * @discussion A dispatch queue that invokes blocks serially in FIFO order.
 */
#define DISPATCH_QUEUE_SERIAL NULL

/*!
 * @const DISPATCH_QUEUE_SERIAL_INACTIVE
 *
 * @discussion
 * A dispatch queue that invokes blocks serially in FIFO order, and that is
 * created initially inactive. See dispatch_queue_attr_make_initially_inactive().
 */
#define DISPATCH_QUEUE_SERIAL_INACTIVE \
		dispatch_queue_attr_make_initially_inactive(DISPATCH_QUEUE_SERIAL)

/*!
 * @const DISPATCH_QUEUE_CONCURRENT
 *
 * @discussion A dispatch queue that may invoke blocks concurrently and supports
 * barrier blocks submitted with the dispatch barrier API.
 */
#define DISPATCH_QUEUE_CONCURRENT \
		DISPATCH_GLOBAL_OBJECT(dispatch_queue_attr_t, \
		_dispatch_queue_attr_concurrent)

API_AVAILABLE(macos(10.7), ios(4.3))
DISPATCH_EXPORT
struct dispatch_queue_attr_s _dispatch_queue_attr_concurrent;

/*!
 * @const DISPATCH_QUEUE_CONCURRENT_INACTIVE
 *
 * @discussion
 * A dispatch queue that may invoke blocks concurrently and supports barrier
 * blocks submitted with the dispatch barrier API, and that is created initially
 * inactive. See dispatch_queue_attr_make_initially_inactive().
 */
#define DISPATCH_QUEUE_CONCURRENT_INACTIVE \
		dispatch_queue_attr_make_initially_inactive(DISPATCH_QUEUE_CONCURRENT)

/*!
 * @function dispatch_queue_attr_make_initially_inactive
 *
 * @abstract
 * Returns an attribute value which may be provided to dispatch_queue_create()
 * or dispatch_queue_create_with_target(), in order to make the created queue
 * initially inactive.
 *
 * @discussion
 * Dispatch queues may be created in an inactive state. Queues in this state
 * have to be activated before any blocks associated with them will be invoked.
 *
 * A queue in inactive state cannot be deallocated, dispatch_activate() must be
 * called before the last reference to a queue created with this attribute is
 * released.
 *
 * The target queue of a queue in inactive state can be changed using
 * dispatch_set_target_queue(). Change of target queue is no longer permitted
 * once an initially inactive queue has been activated.
 *
 * @param attr
 * A queue attribute value to be combined with the initially inactive attribute.
 *
 * @return
 * Returns an attribute value which may be provided to dispatch_queue_create()
 * and dispatch_queue_create_with_target().
 * The new value combines the attributes specified by the 'attr' parameter with
 * the initially inactive attribute.
 */
API_AVAILABLE(macos(10.12), ios(10.0), tvos(10.0), watchos(3.0))
DISPATCH_EXPORT DISPATCH_WARN_RESULT DISPATCH_PURE DISPATCH_NOTHROW
dispatch_queue_attr_t
dispatch_queue_attr_make_initially_inactive(
		dispatch_queue_attr_t _Nullable attr);

/*!
 * @const DISPATCH_QUEUE_SERIAL_WITH_AUTORELEASE_POOL
 *
 * @discussion
 * A dispatch queue created with this attribute invokes blocks serially in FIFO
 * order, and surrounds execution of any block submitted asynchronously to it
 * with the equivalent of a individual Objective-C <code>@autoreleasepool</code>
 * scope.
 *
 * See dispatch_queue_attr_make_with_autorelease_frequency().
 */
#define DISPATCH_QUEUE_SERIAL_WITH_AUTORELEASE_POOL \
		dispatch_queue_attr_make_with_autorelease_frequency(\
				DISPATCH_QUEUE_SERIAL, DISPATCH_AUTORELEASE_FREQUENCY_WORK_ITEM)

/*!
 * @const DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL
 *
 * @discussion
 * A dispatch queue created with this attribute may invokes blocks concurrently
 * and supports barrier blocks submitted with the dispatch barrier API. It also
 * surrounds execution of any block submitted asynchronously to it with the
 * equivalent of a individual Objective-C <code>@autoreleasepool</code>
 *
 * See dispatch_queue_attr_make_with_autorelease_frequency().
 */
#define DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL \
		dispatch_queue_attr_make_with_autorelease_frequency(\
				DISPATCH_QUEUE_CONCURRENT, DISPATCH_AUTORELEASE_FREQUENCY_WORK_ITEM)

/*!
 * @typedef dispatch_autorelease_frequency_t
 * Values to pass to the dispatch_queue_attr_make_with_autorelease_frequency()
 * function.
 *
 * @const DISPATCH_AUTORELEASE_FREQUENCY_INHERIT
 * Dispatch queues with this autorelease frequency inherit the behavior from
 * their target queue. This is the default behavior for manually created queues.
 *
 * @const DISPATCH_AUTORELEASE_FREQUENCY_WORK_ITEM
 * Dispatch queues with this autorelease frequency push and pop an autorelease
 * pool around the execution of every block that was submitted to it
 * asynchronously.
 * @see dispatch_queue_attr_make_with_autorelease_frequency().
 *
 * @const DISPATCH_AUTORELEASE_FREQUENCY_NEVER
 * Dispatch queues with this autorelease frequency never set up an individual
 * autorelease pool around the execution of a block that is submitted to it
 * asynchronously. This is the behavior of the global concurrent queues.
 */
DISPATCH_ENUM(dispatch_autorelease_frequency, unsigned long,
	DISPATCH_AUTORELEASE_FREQUENCY_INHERIT DISPATCH_ENUM_API_AVAILABLE(macos(10.12), ios(10.0), tvos(10.0), watchos(3.0)) = 0,
	DISPATCH_AUTORELEASE_FREQUENCY_WORK_ITEM DISPATCH_ENUM_API_AVAILABLE(macos(10.12), ios(10.0), tvos(10.0), watchos(3.0)) = 1,
	DISPATCH_AUTORELEASE_FREQUENCY_NEVER DISPATCH_ENUM_API_AVAILABLE(macos(10.12), ios(10.0), tvos(10.0), watchos(3.0)) = 2,
);

/*!
 * @function dispatch_queue_attr_make_with_autorelease_frequency
 *
 * @abstract
 * Returns a dispatch queue attribute value with the autorelease frequency
 * set to the specified value.
 *
 * @discussion
 * When a queue uses the per-workitem autorelease frequency (either directly
 * or inherithed from its target queue), any block submitted asynchronously to
 * this queue (via dispatch_async(), dispatch_barrier_async(),
 * dispatch_group_notify(), etc...) is executed as if surrounded by a individual
 * Objective-C <code>@autoreleasepool</code> scope.
 *
 * Autorelease frequency has no effect on blocks that are submitted
 * synchronously to a queue (via dispatch_sync(), dispatch_barrier_sync()).
 *
 * The global concurrent queues have the DISPATCH_AUTORELEASE_FREQUENCY_NEVER
 * behavior. Manually created dispatch queues use
 * DISPATCH_AUTORELEASE_FREQUENCY_INHERIT by default.
 *
 * Queues created with this attribute cannot change target queues after having
 * been activated. See dispatch_set_target_queue() and dispatch_activate().
 *
 * @param attr
 * A queue attribute value to be combined with the specified autorelease
 * frequency or NULL.
 *
 * @param frequency
 * The requested autorelease frequency.
 *
 * @return
 * Returns an attribute value which may be provided to dispatch_queue_create()
 * or NULL if an invalid autorelease frequency was requested.
 * This new value combines the attributes specified by the 'attr' parameter and
 * the chosen autorelease frequency.
 */
API_AVAILABLE(macos(10.12), ios(10.0), tvos(10.0), watchos(3.0))
DISPATCH_EXPORT DISPATCH_WARN_RESULT DISPATCH_PURE DISPATCH_NOTHROW
dispatch_queue_attr_t
dispatch_queue_attr_make_with_autorelease_frequency(
		dispatch_queue_attr_t _Nullable attr,
		dispatch_autorelease_frequency_t frequency);

/*!
 * @function dispatch_queue_attr_make_with_qos_class
 *
 * @abstract
 * Returns an attribute value which may be provided to dispatch_queue_create()
 * or dispatch_queue_create_with_target(), in order to assign a QOS class and
 * relative priority to the queue.
 *
 * @discussion
 * When specified in this manner, the QOS class and relative priority take
 * precedence over those inherited from the dispatch queue's target queue (if
 * any) as long that does not result in a lower QOS class and relative priority.
 *
 * The global queue priorities map to the following QOS classes:
 *  - DISPATCH_QUEUE_PRIORITY_HIGH:         QOS_CLASS_USER_INITIATED
 *  - DISPATCH_QUEUE_PRIORITY_DEFAULT:      QOS_CLASS_DEFAULT
 *  - DISPATCH_QUEUE_PRIORITY_LOW:          QOS_CLASS_UTILITY
 *  - DISPATCH_QUEUE_PRIORITY_BACKGROUND:   QOS_CLASS_BACKGROUND
 *
 * Example:
 * <code>
 *	dispatch_queue_t queue;
 *	dispatch_queue_attr_t attr;
 *	attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL,
 *			QOS_CLASS_UTILITY, 0);
 *	queue = dispatch_queue_create("com.example.myqueue", attr);
 * </code>
 *
 * @param attr
 * A queue attribute value to be combined with the QOS class, or NULL.
 *
 * @param qos_class
 * A QOS class value:
 *  - QOS_CLASS_USER_INTERACTIVE
 *  - QOS_CLASS_USER_INITIATED
 *  - QOS_CLASS_DEFAULT
 *  - QOS_CLASS_UTILITY
 *  - QOS_CLASS_BACKGROUND
 * Passing any other value results in NULL being returned.
 *
 * @param relative_priority
 * A relative priority within the QOS class. This value is a negative
 * offset from the maximum supported scheduler priority for the given class.
 * Passing a value greater than zero or less than QOS_MIN_RELATIVE_PRIORITY
 * results in NULL being returned.
 *
 * @return
 * Returns an attribute value which may be provided to dispatch_queue_create()
 * and dispatch_queue_create_with_target(), or NULL if an invalid QOS class was
 * requested.
 * The new value combines the attributes specified by the 'attr' parameter and
 * the new QOS class and relative priority.
 */
API_AVAILABLE(macos(10.10), ios(8.0))
DISPATCH_EXPORT DISPATCH_WARN_RESULT DISPATCH_PURE DISPATCH_NOTHROW
dispatch_queue_attr_t
dispatch_queue_attr_make_with_qos_class(dispatch_queue_attr_t _Nullable attr,
		dispatch_qos_class_t qos_class, int relative_priority);

/*!
 * @const DISPATCH_TARGET_QUEUE_DEFAULT
 * @discussion Constant to pass to the dispatch_queue_create_with_target(),
 * dispatch_set_target_queue() and dispatch_source_create() functions to
 * indicate that the default target queue for the object type in question
 * should be used.
 */
#define DISPATCH_TARGET_QUEUE_DEFAULT NULL

/*!
 * @function dispatch_queue_create_with_target
 *
 * @abstract
 * Creates a new dispatch queue with a specified target queue.
 *
 * @discussion
 * Dispatch queues created with the DISPATCH_QUEUE_SERIAL or a NULL attribute
 * invoke blocks serially in FIFO order.
 *
 * Dispatch queues created with the DISPATCH_QUEUE_CONCURRENT attribute may
 * invoke blocks concurrently (similarly to the global concurrent queues, but
 * potentially with more overhead), and support barrier blocks submitted with
 * the dispatch barrier API, which e.g. enables the implementation of efficient
 * reader-writer schemes.
 *
 * When a dispatch queue is no longer needed, it should be released with
 * dispatch_release(). Note that any pending blocks submitted to a queue will
 * hold a reference to that queue. Therefore a queue will not be deallocated
 * until all pending blocks have finished.
 *
 * When using a dispatch queue attribute @a attr specifying a QoS class (derived
 * from the result of dispatch_queue_attr_make_with_qos_class()), passing the
 * result of dispatch_get_global_queue() in @a target will ignore the QoS class
 * of that global queue and will use the global queue with the QoS class
 * specified by attr instead.
 *
 * Queues created with dispatch_queue_create_with_target() cannot have their
 * target queue changed, unless created inactive (See
 * dispatch_queue_attr_make_initially_inactive()), in which case the target
 * queue can be changed until the newly created queue is activated with
 * dispatch_activate().
 *
 * @param label
 * A string label to attach to the queue.
 * This parameter is optional and may be NULL.
 *
 * @param attr
 * A predefined attribute such as DISPATCH_QUEUE_SERIAL,
 * DISPATCH_QUEUE_CONCURRENT, or the result of a call to
 * a dispatch_queue_attr_make_with_* function.
 *
 * @param target
 * The target queue for the newly created queue. The target queue is retained.
 * If this parameter is DISPATCH_TARGET_QUEUE_DEFAULT, sets the queue's target
 * queue to the default target queue for the given queue type.
 *
 * @result
 * The newly created dispatch queue.
 */
API_AVAILABLE(macos(10.12), ios(10.0), tvos(10.0), watchos(3.0))
DISPATCH_EXPORT DISPATCH_MALLOC DISPATCH_RETURNS_RETAINED DISPATCH_WARN_RESULT
DISPATCH_NOTHROW
dispatch_queue_t
dispatch_queue_create_with_target(const char *_Nullable label,
	dispatch_queue_attr_t _Nullable attr, dispatch_queue_t _Nullable target)
	DISPATCH_ALIAS_V2(dispatch_queue_create_with_target);

/*!
 * @function dispatch_queue_create
 *
 * @abstract
 * Creates a new dispatch queue to which blocks may be submitted.
 *
 * @discussion
 * Dispatch queues created with the DISPATCH_QUEUE_SERIAL or a NULL attribute
 * invoke blocks serially in FIFO order.
 *
 * Dispatch queues created with the DISPATCH_QUEUE_CONCURRENT attribute may
 * invoke blocks concurrently (similarly to the global concurrent queues, but
 * potentially with more overhead), and support barrier blocks submitted with
 * the dispatch barrier API, which e.g. enables the implementation of efficient
 * reader-writer schemes.
 *
 * When a dispatch queue is no longer needed, it should be released with
 * dispatch_release(). Note that any pending blocks submitted to a queue will
 * hold a reference to that queue. Therefore a queue will not be deallocated
 * until all pending blocks have finished.
 *
 * Passing the result of the dispatch_queue_attr_make_with_qos_class() function
 * to the attr parameter of this function allows a quality of service class and
 * relative priority to be specified for the newly created queue.
 * The quality of service class so specified takes precedence over the quality
 * of service class of the newly created dispatch queue's target queue (if any)
 * as long that does not result in a lower QOS class and relative priority.
 *
 * When no quality of service class is specified, the target queue of a newly
 * created dispatch queue is the default priority global concurrent queue.
 *
 * @param label
 * A string label to attach to the queue.
 * This parameter is optional and may be NULL.
 *
 * @param attr
 * A predefined attribute such as DISPATCH_QUEUE_SERIAL,
 * DISPATCH_QUEUE_CONCURRENT, or the result of a call to
 * a dispatch_queue_attr_make_with_* function.
 *
 * @result
 * The newly created dispatch queue.
 */
API_AVAILABLE(macos(10.6), ios(4.0))
DISPATCH_EXPORT DISPATCH_MALLOC DISPATCH_RETURNS_RETAINED DISPATCH_WARN_RESULT
DISPATCH_NOTHROW
dispatch_queue_t
dispatch_queue_create(const char *_Nullable label,
		dispatch_queue_attr_t _Nullable attr);

/*!
 * @const DISPATCH_CURRENT_QUEUE_LABEL
 * @discussion Constant to pass to the dispatch_queue_get_label() function to
 * retrieve the label of the current queue.
 */
#define DISPATCH_CURRENT_QUEUE_LABEL NULL

/*!
 * @function dispatch_queue_get_label
 *
 * @abstract
 * Returns the label of the given queue, as specified when the queue was
 * created, or the empty string if a NULL label was specified.
 *
 * Passing DISPATCH_CURRENT_QUEUE_LABEL will return the label of the current
 * queue.
 *
 * @param queue
 * The queue to query, or DISPATCH_CURRENT_QUEUE_LABEL.
 *
 * @result
 * The label of the queue.
 */
API_AVAILABLE(macos(10.6), ios(4.0))
DISPATCH_EXPORT DISPATCH_PURE DISPATCH_WARN_RESULT DISPATCH_NOTHROW
const char *
dispatch_queue_get_label(dispatch_queue_t _Nullable queue);

/*!
 * @function dispatch_queue_get_qos_class
 *
 * @abstract
 * Returns the QOS class and relative priority of the given queue.
 *
 * @discussion
 * If the given queue was created with an attribute value returned from
 * dispatch_queue_attr_make_with_qos_class(), this function returns the QOS
 * class and relative priority specified at that time; for any other attribute
 * value it returns a QOS class of QOS_CLASS_UNSPECIFIED and a relative
 * priority of 0.
 *
 * If the given queue is one of the global queues, this function returns its
 * assigned QOS class value as documented under dispatch_get_global_queue() and
 * a relative priority of 0; in the case of the main queue it returns the QOS
 * value provided by qos_class_main() and a relative priority of 0.
 *
 * @param queue
 * The queue to query.
 *
 * @param relative_priority_ptr
 * A pointer to an int variable to be filled with the relative priority offset
 * within the QOS class, or NULL.
 *
 * @return
 * A QOS class value:
 *	- QOS_CLASS_USER_INTERACTIVE
 *	- QOS_CLASS_USER_INITIATED
 *	- QOS_CLASS_DEFAULT
 *	- QOS_CLASS_UTILITY
 *	- QOS_CLASS_BACKGROUND
 *	- QOS_CLASS_UNSPECIFIED
 */
API_AVAILABLE(macos(10.10), ios(8.0))
DISPATCH_EXPORT DISPATCH_WARN_RESULT DISPATCH_NONNULL1 DISPATCH_NOTHROW
dispatch_qos_class_t
dispatch_queue_get_qos_class(dispatch_queue_t queue,
		int *_Nullable relative_priority_ptr);

/*!
 * @function dispatch_set_target_queue
 *
 * @abstract
 * Sets the target queue for the given object.
 *
 * @discussion
 * An object's target queue is responsible for processing the object.
 *
 * When no quality of service class and relative priority is specified for a
 * dispatch queue at the time of creation, a dispatch queue's quality of service
 * class is inherited from its target queue. The dispatch_get_global_queue()
 * function may be used to obtain a target queue of a specific quality of
 * service class, however the use of dispatch_queue_attr_make_with_qos_class()
 * is recommended instead.
 *
 * Blocks submitted to a serial queue whose target queue is another serial
 * queue will not be invoked concurrently with blocks submitted to the target
 * queue or to any other queue with that same target queue.
 *
 * The result of introducing a cycle into the hierarchy of target queues is
 * undefined.
 *
 * A dispatch source's target queue specifies where its event handler and
 * cancellation handler blocks will be submitted.
 *
 * A dispatch I/O channel's target queue specifies where where its I/O
 * operations are executed. If the channel's target queue's priority is set to
 * DISPATCH_QUEUE_PRIORITY_BACKGROUND, then the I/O operations performed by
 * dispatch_io_read() or dispatch_io_write() on that queue will be
 * throttled when there is I/O contention.
 *
 * For all other dispatch object types, the only function of the target queue
 * is to determine where an object's finalizer function is invoked.
 *
 * In general, changing the target queue of an object is an asynchronous
 * operation that doesn't take effect immediately, and doesn't affect blocks
 * already associated with the specified object.
 *
 * However, if an object is inactive at the time dispatch_set_target_queue() is
 * called, then the target queue change takes effect immediately, and will
 * affect blocks already associated with the specified object. After an
 * initially inactive object has been activated, calling
 * dispatch_set_target_queue() results in an assertion and the process being
 * terminated.
 *
 * If a dispatch queue is active and targeted by other dispatch objects,
 * changing its target queue results in undefined behavior.
 *
 * @param object
 * The object to modify.
 * The result of passing NULL in this parameter is undefined.
 *
 * @param queue
 * The new target queue for the object. The queue is retained, and the
 * previous target queue, if any, is released.
 * If queue is DISPATCH_TARGET_QUEUE_DEFAULT, set the object's target queue
 * to the default target queue for the given object type.
 */
API_AVAILABLE(macos(10.6), ios(4.0))
DISPATCH_EXPORT DISPATCH_NOTHROW
void
dispatch_set_target_queue(dispatch_object_t object,
		dispatch_queue_t _Nullable queue);

/*!
 * @function dispatch_main
 *
 * @abstract
 * Execute blocks submitted to the main queue.
 *
 * @discussion
 * This function "parks" the main thread and waits for blocks to be submitted
 * to the main queue. This function never returns.
 *
 * Applications that call NSApplicationMain() or CFRunLoopRun() on the
 * main thread do not need to call dispatch_main().
 */
API_AVAILABLE(macos(10.6), ios(4.0))
DISPATCH_EXPORT DISPATCH_NOTHROW DISPATCH_NORETURN
void
dispatch_main(void);

/*!
 * @function dispatch_after
 *
 * @abstract
 * Schedule a block for execution on a given queue at a specified time.
 *
 * @discussion
 * Passing DISPATCH_TIME_NOW as the "when" parameter is supported, but not as
 * optimal as calling dispatch_async() instead. Passing DISPATCH_TIME_FOREVER
 * is undefined.
 *
 * @param when
 * A temporal milestone returned by dispatch_time() or dispatch_walltime().
 *
 * @param queue
 * A queue to which the given block will be submitted at the specified time.
 * The result of passing NULL in this parameter is undefined.
 *
 * @param block
 * The block of code to execute.
 * The result of passing NULL in this parameter is undefined.
 */
#ifdef __BLOCKS__
API_AVAILABLE(macos(10.6), ios(4.0))
DISPATCH_EXPORT DISPATCH_NONNULL2 DISPATCH_NONNULL3 DISPATCH_NOTHROW
void
dispatch_after(dispatch_time_t when,
	dispatch_queue_t queue,
	dispatch_block_t block);
#endif

/*!
 * @function dispatch_after_f
 *
 * @abstract
 * Schedule a function for execution on a given queue at a specified time.
 *
 * @discussion
 * See dispatch_after() for details.
 *
 * @param when
 * A temporal milestone returned by dispatch_time() or dispatch_walltime().
 *
 * @param queue
 * A queue to which the given function will be submitted at the specified time.
 * The result of passing NULL in this parameter is undefined.
 *
 * @param context
 * The application-defined context parameter to pass to the function.
 *
 * @param work
 * The application-defined function to invoke on the target queue. The first
 * parameter passed to this function is the context provided to
 * dispatch_after_f().
 * The result of passing NULL in this parameter is undefined.
 */
API_AVAILABLE(macos(10.6), ios(4.0))
DISPATCH_EXPORT DISPATCH_NONNULL2 DISPATCH_NONNULL4 DISPATCH_NOTHROW
void
dispatch_after_f(dispatch_time_t when,
	dispatch_queue_t queue,
	void *_Nullable context,
	dispatch_function_t work);

/*!
 * @functiongroup Dispatch Barrier API
 * The dispatch barrier API is a mechanism for submitting barrier blocks to a
 * dispatch queue, analogous to the dispatch_async()/dispatch_sync() API.
 * It enables the implementation of efficient reader/writer schemes.
 * Barrier blocks only behave specially when submitted to queues created with
 * the DISPATCH_QUEUE_CONCURRENT attribute; on such a queue, a barrier block
 * will not run until all blocks submitted to the queue earlier have completed,
 * and any blocks submitted to the queue after a barrier block will not run
 * until the barrier block has completed.
 * When submitted to a a global queue or to a queue not created with the
 * DISPATCH_QUEUE_CONCURRENT attribute, barrier blocks behave identically to
 * blocks submitted with the dispatch_async()/dispatch_sync() API.
 */

/*!
 * @function dispatch_barrier_async
 *
 * @abstract
 * Submits a barrier block for asynchronous execution on a dispatch queue.
 *
 * @discussion
 * Submits a block to a dispatch queue like dispatch_async(), but marks that
 * block as a barrier (relevant only on DISPATCH_QUEUE_CONCURRENT queues).
 *
 * See dispatch_async() for details.
 *
 * @param queue
 * The target dispatch queue to which the block is submitted.
 * The system will hold a reference on the target queue until the block
 * has finished.
 * The result of passing NULL in this parameter is undefined.
 *
 * @param block
 * The block to submit to the target dispatch queue. This function performs
 * Block_copy() and Block_release() on behalf of callers.
 * The result of passing NULL in this parameter is undefined.
 */
#ifdef __BLOCKS__
API_AVAILABLE(macos(10.7), ios(4.3))
DISPATCH_EXPORT DISPATCH_NONNULL_ALL DISPATCH_NOTHROW
void
dispatch_barrier_async(dispatch_queue_t queue, dispatch_block_t block);
#endif

/*!
 * @function dispatch_barrier_async_f
 *
 * @abstract
 * Submits a barrier function for asynchronous execution on a dispatch queue.
 *
 * @discussion
 * Submits a function to a dispatch queue like dispatch_async_f(), but marks
 * that function as a barrier (relevant only on DISPATCH_QUEUE_CONCURRENT
 * queues).
 *
 * See dispatch_async_f() for details.
 *
 * @param queue
 * The target dispatch queue to which the function is submitted.
 * The system will hold a reference on the target queue until the function
 * has returned.
 * The result of passing NULL in this parameter is undefined.
 *
 * @param context
 * The application-defined context parameter to pass to the function.
 *
 * @param work
 * The application-defined function to invoke on the target queue. The first
 * parameter passed to this function is the context provided to
 * dispatch_barrier_async_f().
 * The result of passing NULL in this parameter is undefined.
 */
API_AVAILABLE(macos(10.7), ios(4.3))
DISPATCH_EXPORT DISPATCH_NONNULL1 DISPATCH_NONNULL3 DISPATCH_NOTHROW
void
dispatch_barrier_async_f(dispatch_queue_t queue,
	void *_Nullable context,
	dispatch_function_t work);

/*!
 * @function dispatch_barrier_sync
 *
 * @abstract
 * Submits a barrier block for synchronous execution on a dispatch queue.
 *
 * @discussion
 * Submits a block to a dispatch queue like dispatch_sync(), but marks that
 * block as a barrier (relevant only on DISPATCH_QUEUE_CONCURRENT queues).
 *
 * See dispatch_sync() for details.
 *
 * @param queue
 * The target dispatch queue to which the block is submitted.
 * The result of passing NULL in this parameter is undefined.
 *
 * @param block
 * The block to be invoked on the target dispatch queue.
 * The result of passing NULL in this parameter is undefined.
 */
#ifdef __BLOCKS__
API_AVAILABLE(macos(10.7), ios(4.3))
DISPATCH_EXPORT DISPATCH_NONNULL_ALL DISPATCH_NOTHROW
void
dispatch_barrier_sync(dispatch_queue_t queue,
		DISPATCH_NOESCAPE dispatch_block_t block);
#endif

/*!
 * @function dispatch_barrier_sync_f
 *
 * @abstract
 * 往同步执行调度队列中提交一个回调函数。
 * Submits a barrier function for synchronous execution on a dispatch queue.
 *
 * @discussion
 * Submits a function to a dispatch queue like dispatch_sync_f(), but marks that
 * fuction as a barrier (relevant only on DISPATCH_QUEUE_CONCURRENT queues).
 *
 * See dispatch_sync_f() for details.
 *
 * @param queue
 * The target dispatch queue to which the function is submitted.
 * The result of passing NULL in this parameter is undefined.
 *
 * @param context
 * The application-defined context parameter to pass to the function.
 *
 * @param work
 * The application-defined function to invoke on the target queue. The first
 * parameter passed to this function is the context provided to
 * dispatch_barrier_sync_f().
 * The result of passing NULL in this parameter is undefined.
 */
API_AVAILABLE(macos(10.7), ios(4.3))
DISPATCH_EXPORT DISPATCH_NONNULL1 DISPATCH_NONNULL3 DISPATCH_NOTHROW
void
dispatch_barrier_sync_f(dispatch_queue_t queue,
	void *_Nullable context,
	dispatch_function_t work);

/*!
 * @functiongroup Dispatch queue-specific contexts
 * This API allows different subsystems to associate context to a shared queue
 * without risk of collision and to retrieve that context from blocks executing
 * on that queue or any of its child queues in the target queue hierarchy.
 */

/*!
 * @function dispatch_queue_set_specific
 *
 * @abstract
 * Associates a subsystem-specific context with a dispatch queue, for a key
 * unique to the subsystem.
 *
 * @discussion
 * The specified destructor will be invoked with the context on the default
 * priority global concurrent queue when a new context is set for the same key,
 * or after all references to the queue have been released.
 *
 * @param queue
 * The dispatch queue to modify.
 * The result of passing NULL in this parameter is undefined.
 *
 * @param key
 * The key to set the context for, typically a pointer to a static variable
 * specific to the subsystem. Keys are only compared as pointers and never
 * dereferenced. Passing a string constant directly is not recommended.
 * The NULL key is reserved and attempts to set a context for it are ignored.
 *
 * @param context
 * The new subsystem-specific context for the object. This may be NULL.
 *
 * @param destructor
 * The destructor function pointer. This may be NULL and is ignored if context
 * is NULL.
 */
API_AVAILABLE(macos(10.7), ios(5.0))
DISPATCH_EXPORT DISPATCH_NONNULL1 DISPATCH_NOTHROW
void
dispatch_queue_set_specific(dispatch_queue_t queue, const void *key,
	void *_Nullable context, dispatch_function_t _Nullable destructor);

/*!
 * @function dispatch_queue_get_specific
 *
 * @abstract
 * 以子系统特有的密钥为键，返回与分派队列相关联的特定的上下文
 * Returns the subsystem-specific context associated with a dispatch queue, for
 * a key unique to the subsystem.
 *
 * @discussion
 * Returns the context for the specified key if it has been set on the specified
 * queue.
 *
 * @param queue
 * The dispatch queue to query.
 * The result of passing NULL in this parameter is undefined.
 *
 * @param key
 * The key to get the context for, typically a pointer to a static variable
 * specific to the subsystem. Keys are only compared as pointers and never
 * dereferenced. Passing a string constant directly is not recommended.
 *
 * @result
 * The context for the specified key or NULL if no context was found.
 */
API_AVAILABLE(macos(10.7), ios(5.0))
DISPATCH_EXPORT DISPATCH_NONNULL1 DISPATCH_PURE DISPATCH_WARN_RESULT
DISPATCH_NOTHROW
void *_Nullable
dispatch_queue_get_specific(dispatch_queue_t queue, const void *key);

/*!
 * @function dispatch_get_specific
 *
 * @abstract
 * 以子系统特有的密钥为键，返回当前子系统特定上下文
 * Returns the current subsystem-specific context for a key unique to the
 * subsystem.
 *
 * @discussion
 * When called from a block executing on a queue, returns the context for the
 * specified key if it has been set on the queue, otherwise returns the result
 * of dispatch_get_specific() executed on the queue's target queue or NULL
 * if the current queue is a global concurrent queue.
 *
 * @param key
 * 获取上下文的键，通常是当前线程一个指向一个静态变量的实例
 * 键仅作为指针进行比较，并且从不解引用。不推荐直接传递字符串常量。
 * The key to get the context for, typically a pointer to a static variable
 * specific to the subsystem. Keys are only compared as pointers and never
 * dereferenced. Passing a string constant directly is not recommended.
 *
 * @result
 * The context for the specified key or NULL if no context was found.
 */
API_AVAILABLE(macos(10.7), ios(5.0))
DISPATCH_EXPORT DISPATCH_PURE DISPATCH_WARN_RESULT DISPATCH_NOTHROW
void *_Nullable
dispatch_get_specific(const void *key);

/*!
 * @functiongroup Dispatch assertion API
 *
 * This API asserts at runtime that code is executing in (or out of) the context
 * of a given queue. It can be used to check that a block accessing a resource
 * does so from the proper queue protecting the resource. It also can be used
 * to verify that a block that could cause a deadlock if run on a given queue
 * never executes on that queue.
 */

/*!
 * @function dispatch_assert_queue
 *
 * @abstract
 * 验证当前块是否正在给定的分派队列上执行
 * Verifies that the current block is executing on a given dispatch queue.
 *
 * @discussion
 * Some code expects to be run on a specific dispatch queue. This function
 * verifies that that expectation is true.
 *
 * If the currently executing block was submitted to the specified queue or to
 * any queue targeting it (see dispatch_set_target_queue()), this function
 * returns.
 *
 * If the currently executing block was submitted with a synchronous API
 * (dispatch_sync(), dispatch_barrier_sync(), ...), the context of the
 * submitting block is also evaluated (recursively).
 * If a synchronously submitting block is found that was itself submitted to
 * the specified queue or to any queue targeting it, this function returns.
 *
 * Otherwise this function asserts: it logs an explanation to the system log and
 * terminates the application.
 *
 * Passing the result of dispatch_get_main_queue() to this function verifies
 * that the current block was submitted to the main queue, or to a queue
 * targeting it, or is running on the main thread (in any context).
 *
 * When dispatch_assert_queue() is called outside of the context of a
 * submitted block (for example from the context of a thread created manually
 * with pthread_create()) then this function will also assert and terminate
 * the application.
 *
 * The variant dispatch_assert_queue_debug() is compiled out when the
 * preprocessor macro NDEBUG is defined. (See also assert(3)).
 *
 * @param queue
 * The dispatch queue that the current block is expected to run on.
 * The result of passing NULL in this parameter is undefined.
 */
API_AVAILABLE(macos(10.12), ios(10.0), tvos(10.0), watchos(3.0))
DISPATCH_EXPORT DISPATCH_NONNULL1
void
dispatch_assert_queue(dispatch_queue_t queue)
	DISPATCH_ALIAS_V2(dispatch_assert_queue);

/*!
 * @function dispatch_assert_queue_barrier
 *
 * @abstract
 * 验证当前块是否正在给定的分派队列上执行，并且该块在该队列中充当屏障。
 * Verifies that the current block is executing on a given dispatch queue,
 * and that the block acts as a barrier on that queue.
 *
 * @discussion
 * This behaves exactly like dispatch_assert_queue(), with the additional check
 * that the current block acts as a barrier on the specified queue, which is
 * always true if the specified queue is serial (see DISPATCH_BLOCK_BARRIER or
 * dispatch_barrier_async() for details).
 *
 * The variant dispatch_assert_queue_barrier_debug() is compiled out when the
 * preprocessor macro NDEBUG is defined. (See also assert()).
 *
 * @param queue
 * The dispatch queue that the current block is expected to run as a barrier on.
 * The result of passing NULL in this parameter is undefined.
 */
API_AVAILABLE(macos(10.12), ios(10.0), tvos(10.0), watchos(3.0))
DISPATCH_EXPORT DISPATCH_NONNULL1
void
dispatch_assert_queue_barrier(dispatch_queue_t queue);

/*!
 * @function dispatch_assert_queue_not
 *
 * @abstract
 * Verifies that the current block is not executing on a given dispatch queue.
 *
 * @discussion
 * This function is the equivalent of dispatch_queue_assert() with the test for
 * equality inverted. That means that it will terminate the application when
 * dispatch_queue_assert() would return, and vice-versa. See discussion there.
 *
 * The variant dispatch_assert_queue_not_debug() is compiled out when the
 * preprocessor macro NDEBUG is defined. (See also assert(3)).
 *
 * @param queue
 * The dispatch queue that the current block is expected not to run on.
 * The result of passing NULL in this parameter is undefined.
 */
API_AVAILABLE(macos(10.12), ios(10.0), tvos(10.0), watchos(3.0))
DISPATCH_EXPORT DISPATCH_NONNULL1
void
dispatch_assert_queue_not(dispatch_queue_t queue)
	DISPATCH_ALIAS_V2(dispatch_assert_queue_not);

#ifdef NDEBUG
#define dispatch_assert_queue_debug(q) ((void)(0 && (q)))
#define dispatch_assert_queue_barrier_debug(q) ((void)(0 && (q)))
#define dispatch_assert_queue_not_debug(q) ((void)(0 && (q)))
#else
#define dispatch_assert_queue_debug(q) dispatch_assert_queue(q)
#define dispatch_assert_queue_barrier_debug(q) dispatch_assert_queue_barrier(q)
#define dispatch_assert_queue_not_debug(q) dispatch_assert_queue_not(q)
#endif

__END_DECLS

DISPATCH_ASSUME_NONNULL_END

#endif
