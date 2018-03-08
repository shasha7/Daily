/*
 * Copyright (c) 2008-2011 Apple Inc. All rights reserved.
 *
 * @APPLE_APACHE_LICENSE_HEADER_START@
 *
 */

#ifndef __DISPATCH_SEMAPHORE__
#define __DISPATCH_SEMAPHORE__

#ifndef __DISPATCH_INDIRECT__
#error "Please #include <dispatch/dispatch.h> instead of this file directly."
#include <dispatch/base.h> // for HeaderDoc
#endif

/*!
 * @typedef dispatch_semaphore_t
 *
 * @abstract
 * A counting semaphore.
 */
DISPATCH_DECL(dispatch_semaphore);

__BEGIN_DECLS

/*
 您可以使用调度信号来调节允许同时访问有限资源的任务数量。
 例如，每个应用程序都有一定数量的文件描述符可供使用。
 如果您有一个处理大量文件的任务，那么您不想同时打开太多的文件而耗尽文件描述符。
 相反，您可以使用信号量来限制文件处理代码在任何时候都使用的文件描述符的数量
 
 Dispatch semaphore和传统信号量工作原理类似。但是在资源可用的情况下，使用GCD semaphore将会消耗较少的时间，因为在这种情况下GCD不会调用内核，只有在资源不可用的时候才会调用内核，并且系统需要停在你的线程里，直到信号发出可用信号
 */

/*!
 * @function dispatch_semaphore_create
 *
 * @abstract
 * 用初始值创建新的计数信号量。
 *
 * @discussion
 * 当两个线程需要协调特定事件的完成时，将值传递给零值非常有用。
 * 传递大于零的值对于管理池大小等于该值的有限资源池非常有用
 *
 * @param value
 * 信号量的初始值.传递一个小于零的值将导致返回NULL
 *
 * @result
 * 创建成功返回创建的信号量，创建失败返回NULL.
 */
__OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_4_0)
DISPATCH_EXPORT DISPATCH_MALLOC DISPATCH_WARN_RESULT DISPATCH_NOTHROW
dispatch_semaphore_t
dispatch_semaphore_create(long value);

/*!
 * @function dispatch_semaphore_wait
 *
 * @abstract
 * 等待（递减）信号量。
 *
 * @discussion
 * 信号量减一，如果结果值小于零，则此函数在返回之前以FIFO顺序等待。
 *
 * @param dsema
 * 信号量
 *
 * @param timeout
 * 何时超时（请参阅dispatch_time）。 为了方便起见，有DISPATCH_TIME_NOW = 0和DISPATCH_TIME_FOREVER = ~0ull两个常量。
 *
 * @result
 * 成功时返回零，如果发生超时则返回非零值
 */
__OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_4_0)
DISPATCH_EXPORT DISPATCH_NONNULL_ALL DISPATCH_NOTHROW
long
dispatch_semaphore_wait(dispatch_semaphore_t dsema, dispatch_time_t timeout);

/*!
 * @function dispatch_semaphore_signal
 *
 * @abstract
 * 信号（增加）一个信号量
 *
 * @discussion
 * 信号量加1。如果前一个值小于零，则此函数在返回之前唤醒等待的线程
 *
 * @param dsema
 * 在这个参数中传递NULL的结果是未定义的.
 *
 * @result
 * 如果线程被唤醒，该函数返回非零值。否则，返回零.
 */
__OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_4_0)
DISPATCH_EXPORT DISPATCH_NONNULL_ALL DISPATCH_NOTHROW
long
dispatch_semaphore_signal(dispatch_semaphore_t dsema);

__END_DECLS

#endif /* __DISPATCH_SEMAPHORE__ */
