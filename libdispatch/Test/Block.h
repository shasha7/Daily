/*
How do blocks work in ARC?

Blocks “just work” when you pass blocks up the stack in ARC mode, such as in a return. You don’t have to call Block Copy any more.

The one thing to be aware of is that NSString * __block myString is retained in ARC mode, not a possibly dangling pointer. To get the previous behavior, use __block NSString * __unsafe_unretained myString or (better still) use __block NSString * __weak myString.
 ARC时代，block只有两种 全局、堆上
 栈上的block将不复存在，编译器自动将执行copy操作，将栈上的block移动到堆上
*/

#ifndef _BLOCK_H_
#define _BLOCK_H_

#if !defined(BLOCK_EXPORT)
#   if defined(__cplusplus)
#       define BLOCK_EXPORT extern "C"
#   else
#       define BLOCK_EXPORT extern
#   endif
#endif

#if defined(__cplusplus)
extern "C" {
#endif
	
	/* Create a heap based copy of a Block or simply add a reference to an existing one.
	 * This must be paired with Block_release to recover memory, even when running
	 * under Objective-C Garbage Collection.
	 */
	BLOCK_EXPORT void *_Block_copy(const void *aBlock);
	
	/* Lose the reference, and if heap based and last reference, recover the memory. */
	BLOCK_EXPORT void _Block_release(const void *aBlock);
	
#if defined(__cplusplus)
}
#endif

/* Type correct macros. */

#define Block_copy(...) ((__typeof(__VA_ARGS__))_Block_copy((const void *)(__VA_ARGS__)))
#define Block_release(...) _Block_release((const void *)(__VA_ARGS__))


#endif
