/*
 * Copyright (c) 2010-2011 Apple Inc. All rights reserved.
 *
 * @APPLE_LICENSE_HEADER_START@
 * 
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this
 * file.
 * 
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 * 
 * @APPLE_LICENSE_HEADER_END@
 */

#ifndef _OBJC_WEAK_H_
#define _OBJC_WEAK_H_

#include <objc/objc.h>
#include "objc-config.h"

__BEGIN_DECLS

/*
key是__weak修饰符修饰的变量所引用对象的内存地址，value是__weak修饰符修饰的变量的数组。
弱引用表是由单个自旋锁管理的散列表(数组)。分配一块内存，通常是一个对象，但在GC之下分配，可能会将其地址存储在标记为__weak的存储位置通过使用编译器生成的写入屏障或手动编码的用途注册弱原语。与注册相关联可以是回调
当分配的内存块之一被回收的情况下阻塞。该表被散列在分配内存的地址上。 当__weak标记记忆改变了它的参考，我们依靠我们仍然可以的事实见其以前的参考。所以，在由弱引用的项索引的哈希表中，是一个列表该地址当前正在存储的所有位置。对于ARC，我们也跟踪是否有任意的对象通过在调用之前将其简单地放置在表格中来解除分配dealloc，并通过objc_clear_deallocating在内存之前删除它开垦。
The weak table is a hash table governed by a single spin lock.
An allocated blob of memory, most often an object, but under GC any such 
allocation, may have its address stored in a __weak marked storage location 
through use of compiler generated write-barriers or hand coded uses of the 
register weak primitive. Associated with the registration can be a callback 
block for the case when one of the allocated chunks of memory is reclaimed. 
The table is hashed on the address of the allocated memory.  When __weak 
marked memory changes its reference, we count on the fact that we can still 
see its previous reference.

So, in the hash table, indexed by the weakly referenced item, is a list of 
all locations where this address is currently being stored.
 
For ARC, we also keep track of whether an arbitrary object is being 
deallocated by briefly placing it in the table just prior to invoking 
dealloc, and removing it via objc_clear_deallocating just prior to memory 
reclamation.

*/

// The address of a __weak variable.
// These pointers are stored disguised so memory analysis tools
// don't see lots of interior pointers from the weak table into objects.
// 这些指针是伪装存储的，所以内存分析工具看不到很多从弱表到对象的内部指针
// 模板类
/*
 template<typename T>
 class A {
 public:
    A(T t) {
        this->t = t;
    }
 
    T &getT() {
        return t;
    }
 public:
    T t;
 };
 
 void main() {
    // 模板了中如果使用了构造函数,则遵守以前的类的构造函数的调用规则
    A<int> a(100);
    int a = a.getT();
    printf("a = %d", a);
    system("pause");
    return;
 }
 */
// template<typename T> === objc_object * 相当于T
typedef DisguisedPtr<objc_object *> weak_referrer_t;

#if __LP64__
#define PTR_MINUS_2 62
#else
#define PTR_MINUS_2 30
#endif

/**
 内部结构存储在弱引用表中。 它维护并存储指向对象的弱引用的散列集
 如果out_of_line_ness！= REFERRERS_OUT_OF_LINE，那么这个集合是一个小的内联数组。
 * The internal structure stored in the weak references table. 
 * It maintains and stores
 * a hash set of weak references pointing to an object.
 * If out_of_line_ness != REFERRERS_OUT_OF_LINE then the set
 * is instead a small inline array.
 */
#define WEAK_INLINE_COUNT 4

/*
 out_of_line_ness字段与inline_referrers[1]的低两位重叠。
 inline_referrers[1]是一个指针对齐地址的DisguisedPtr。
 指针对齐DisguisedPtr的低两位总是0b00（伪装无或0x80..00）或0b11（任何其他地址）。
 因此，out_of_line_ness == 0b10用于标记out-of-line(非线性)状态。
 */
// out_of_line_ness field overlaps with the low two bits of inline_referrers[1].
// inline_referrers[1] is a DisguisedPtr of a pointer-aligned address.
// The low two bits of a pointer-aligned DisguisedPtr will always be 0b00
// (disguised nil or 0x80..00) or 0b11 (any other address).
// Therefore out_of_line_ness == 0b10 is used to mark the out-of-line state.
#define REFERRERS_OUT_OF_LINE 2

struct weak_entry_t {
    DisguisedPtr<objc_object> referent;
    union {
        struct {
            // typedef DisguisedPtr<objc_object *> weak_referrer_t;
            weak_referrer_t *referrers;
            uintptr_t        out_of_line_ness : 2;
            uintptr_t        num_refs : PTR_MINUS_2;
            uintptr_t        mask;
            uintptr_t        max_hash_displacement;
        };
        struct {
            // out_of_line_ness field is low bits of inline_referrers[1]
            weak_referrer_t  inline_referrers[WEAK_INLINE_COUNT];
        };
    };

    bool out_of_line() {
        return (out_of_line_ness == REFERRERS_OUT_OF_LINE);
    }

    weak_entry_t& operator=(const weak_entry_t& other) {
        memcpy(this, &other, sizeof(other));
        return *this;
    }

    // weak_entry_t 构造函数
    weak_entry_t(objc_object *newReferent, objc_object **newReferrer)
        : referent(newReferent)
    {
        inline_referrers[0] = newReferrer;
        for (int i = 1; i < WEAK_INLINE_COUNT; i++) {
            inline_referrers[i] = nil;
        }
    }
};

/**
 * The global weak references table. Stores object ids as keys,
 * and weak_entry_t structs as their values.
 */
struct weak_table_t {
    weak_entry_t *weak_entries;
    size_t    num_entries;
    uintptr_t mask;
    uintptr_t max_hash_displacement;
};

/// Adds an (object, weak pointer) pair to the weak table.
id weak_register_no_lock(weak_table_t *weak_table, id referent, 
                         id *referrer, bool crashIfDeallocating);

/// Removes an (object, weak pointer) pair from the weak table.
void weak_unregister_no_lock(weak_table_t *weak_table, id referent, id *referrer);

#if DEBUG
/// Returns true if an object is weakly referenced somewhere.
bool weak_is_registered_no_lock(weak_table_t *weak_table, id referent);
#endif

/// Called on object destruction. Sets all remaining weak pointers to nil.
void weak_clear_no_lock(weak_table_t *weak_table, id referent);

__END_DECLS

#endif /* _OBJC_WEAK_H_ */
