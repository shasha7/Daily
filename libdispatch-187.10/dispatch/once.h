/*
 * Copyright (c) 2008-2010 Apple Inc. All rights reserved.
 *
 * @APPLE_APACHE_LICENSE_HEADER_START@
 */

#ifndef __DISPATCH_ONCE__
#define __DISPATCH_ONCE__

#ifndef __DISPATCH_INDIRECT__
#error "Please #include <dispatch/dispatch.h> instead of this file directly."
#include <dispatch/base.h> // for HeaderDoc
#endif

__BEGIN_DECLS

/*!
 * @typedef dispatch_once_t
 *
 * @abstract
 * predicate需要先初始化为0，static和global变量创建出来即有默认值0
 * A predicate for use with dispatch_once(). It must be initialized to zero.
 * Note: static and global variables default to zero.
 */
typedef long dispatch_once_t;

/*!
 * @function dispatch_once
 *
 * @abstract
 * 看这个函数所在的头文件，发现目前它的实现其实是一个宏，进行了内联的初始化测试，这意味着通常情况下，你不用付出函数调用的负载代价，并且会有更少的同步控制负载
 * Execute a block once and only once.
 *
 * @param predicate
 * A pointer to a dispatch_once_t that is used to test whether the block has
 * completed or not.
 *
 * @param block
 * The block to execute once.
 *
 * @discussion
 * Always call dispatch_once() before using or testing any variables that are
 * initialized by the block.
 */
#ifdef __BLOCKS__
__OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_4_0)
DISPATCH_EXPORT DISPATCH_NONNULL_ALL DISPATCH_NOTHROW
void
dispatch_once(dispatch_once_t *predicate, dispatch_block_t block);

DISPATCH_INLINE DISPATCH_ALWAYS_INLINE DISPATCH_NONNULL_ALL DISPATCH_NOTHROW
void
_dispatch_once(dispatch_once_t *predicate, dispatch_block_t block)
{
	if (DISPATCH_EXPECT(*predicate, ~0l) != ~0l) {
		dispatch_once(predicate, block);
	}
}
#undef dispatch_once
#define dispatch_once _dispatch_once
#endif

__OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_4_0)
DISPATCH_EXPORT DISPATCH_NONNULL1 DISPATCH_NONNULL3 DISPATCH_NOTHROW
void
dispatch_once_f(dispatch_once_t *predicate, void *context,
		dispatch_function_t function);

DISPATCH_INLINE DISPATCH_ALWAYS_INLINE DISPATCH_NONNULL1 DISPATCH_NONNULL3
DISPATCH_NOTHROW
void
_dispatch_once_f(dispatch_once_t *predicate, void *context,
		dispatch_function_t function)
{
	// __builtin_expect((x), (v))
	if (DISPATCH_EXPECT(*predicate, ~0l) != ~0l) {
		dispatch_once_f(predicate, context, function);
	}
}
#undef dispatch_once_f

// 这里需要认真查看
#define dispatch_once_f _dispatch_once_f

__END_DECLS

#endif
