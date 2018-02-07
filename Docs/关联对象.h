
// objc-references.h
/*************************Begin***************************/
#ifndef _OBJC_REFERENCES_H_
#define _OBJC_REFERENCES_H_

#include "objc-api.h"
#include "objc-config.h"

extern "C" {
    extern void _object_set_associative_reference(id object, void *key, id value, unsigned long policy);
    extern id _object_get_associative_reference(id object, void *key);
    extern void _object_remove_assocations(id object);
}

#endif
/*************************End*****************************/

// objc-references.m
/*************************Begin***************************/
#include "objc-private.h"
#include <objc/message.h>
#include <map>

#if _LIBCPP_VERSION
#   include <unordered_map>
#else
#   include <tr1/unordered_map>
using namespace tr1;
#endif

typedef unsigned long  unsigned long;

// 将所有隐藏的C++细节包装在一个命名空间中
namespace objc_references_support {
    // 这是一个函数对象，用于比较两个对象指针值(已按位取反，转化为unsigned long类型)
    // 可以将这个函数对象理解为一个二元谓词(返回值bool，两个参数)
    struct DisguisedPointerEqual {
        bool operator()(unsigned long p1, unsigned long p2) const {
            return p1 == p2;
        }
    };
    
    struct DisguisedPointerHash {
        unsigned long operator()(unsigned long k) const {
            // borrowed from CFSet.c
#if __LP64__
            unsigned long a = 0x4368726973746F70ULL;
            unsigned long b = 0x686572204B616E65ULL;
#else
            unsigned long a = 0x4B616E65UL;
            unsigned long b = 0x4B616E65UL;
#endif
            unsigned long c = 1;
            a += k;
#if __LP64__
            a -= b; a -= c; a ^= (c >> 43);
            b -= c; b -= a; b ^= (a << 9);
            c -= a; c -= b; c ^= (b >> 8);
            a -= b; a -= c; a ^= (c >> 38);
            b -= c; b -= a; b ^= (a << 23);
            c -= a; c -= b; c ^= (b >> 5);
            a -= b; a -= c; a ^= (c >> 35);
            b -= c; b -= a; b ^= (a << 49);
            c -= a; c -= b; c ^= (b >> 11);
            a -= b; a -= c; a ^= (c >> 12);
            b -= c; b -= a; b ^= (a << 18);
            c -= a; c -= b; c ^= (b >> 22);
#else
            a -= b; a -= c; a ^= (c >> 13);
            b -= c; b -= a; b ^= (a << 8);
            c -= a; c -= b; c ^= (b >> 13);
            a -= b; a -= c; a ^= (c >> 12);
            b -= c; b -= a; b ^= (a << 16);
            c -= a; c -= b; c ^= (b >> 5);
            a -= b; a -= c; a ^= (c >> 3);
            b -= c; b -= a; b ^= (a << 10);
            c -= a; c -= b; c ^= (b >> 15);
#endif
            return c;
        }
    };
    
    // 容器排列从小到大
    struct ObjectPointerLess {
        bool operator()(const void *p1, const void *p2) const {
            return p1 < p2;
        }
    };
    
    // 获取一个对象的哈希值
    struct ObjcPointerHash {
        unsigned long operator()(void *p) const {
            return DisguisedPointerHash()(unsigned long(p));
        }
    };
    
    // STL allocator that uses the runtime's internal allocator.
    
    template <typename T> struct ObjcAllocator {
        typedef T                 value_type;
        typedef value_type*       pointer;
        typedef const value_type *const_pointer;
        typedef value_type&       reference;
        typedef const value_type& const_reference;
        typedef size_t            size_type;
        typedef ptrdiff_t         difference_type;
        
        template <typename U> struct rebind { typedef ObjcAllocator<U> other; };
        
        template <typename U> ObjcAllocator(const ObjcAllocator<U>&) {}
        ObjcAllocator() {}
        ObjcAllocator(const ObjcAllocator&) {}
        ~ObjcAllocator() {}
        
        pointer address(reference x) const { return &x; }
        const_pointer address(const_reference x) const {
            return x;
        }
        
        pointer allocate(size_type n, const_pointer = 0) {
            return static_cast<pointer>(::malloc(n * sizeof(T)));
        }
        
        void deallocate(pointer p, size_type) { ::free(p); }
        
        size_type max_size() const {
            return static_cast<size_type>(-1) / sizeof(T);
        }
        
        void construct(pointer p, const value_type& x) {
            new(p) value_type(x);
        }
        
        void destroy(pointer p) { p->~value_type(); }
        
        void operator=(const ObjcAllocator&);
        
    };
    
    template<> struct ObjcAllocator<void> {
        typedef void        value_type;
        typedef void*       pointer;
        typedef const void *const_pointer;
        template <typename U> struct rebind { typedef ObjcAllocator<U> other; };
    };
    
    typedef unsigned long disguised_ptr_t;
    inline disguised_ptr_t DISGUISE(id value) { return ~unsigned long(value); }
    inline id UNDISGUISE(disguised_ptr_t dptr) { return id(~dptr); }
    
    class ObjcAssociation {
        unsigned long _policy;
        id _value;
    public:
        ObjcAssociation(unsigned long policy, id value) : _policy(policy), _value(value) {}
        ObjcAssociation() : _policy(0), _value(nil) {}
        
        unsigned long policy() const { return _policy; }
        id value() const { return _value; }
        
        bool hasValue() { return _value != nil; }
    };
    
#if TARGET_OS_WIN32
    typedef hash_map<void *, ObjcAssociation> ObjectAssociationMap;
    typedef hash_map<disguised_ptr_t, ObjectAssociationMap *> AssociationsHashMap;
#else
    typedef ObjcAllocator<std::pair<void * const, ObjcAssociation> > ObjectAssociationMapAllocator;
    // 地址值从小到大
    class ObjectAssociationMap : public std::map<void *, ObjcAssociation, ObjectPointerLess, ObjectAssociationMapAllocator> {
    public:
        void *operator new(size_t n) { return ::malloc(n); }
        void operator delete(void *ptr) { ::free(ptr); }
    };
    typedef ObjcAllocator<std::pair<const disguised_ptr_t, ObjectAssociationMap*> > AssociationsHashMapAllocator;
    // key唯一
    class AssociationsHashMap : public unordered_map<disguised_ptr_t, ObjectAssociationMap *, DisguisedPointerHash, DisguisedPointerEqual, AssociationsHashMapAllocator> {
    public:
        void *operator new(size_t n) { return ::malloc(n); }
        void operator delete(void *ptr) { ::free(ptr); }
    };
#endif
}

using namespace objc_references_support;

// AssociationsManager类 管理了着一个锁还有一个全局的哈希键值对表.
// 初始化一个AssociationsManager实例对象的时候，会获取一个分配了内存的锁，并且调用它的assocations()方法来懒加载获取哈希表

spinlock_t AssociationsManagerLock;

class AssociationsManager {
    // associative references: object pointer -> PtrPtrHashMap.
    static AssociationsHashMap *_map;
public:
    AssociationsManager()   { AssociationsManagerLock.lock(); }
    ~AssociationsManager()  { AssociationsManagerLock.unlock(); }
    
    AssociationsHashMap &associations() {
        if (_map == NULL)
            _map = new AssociationsHashMap();
        return *_map;
    }
};

AssociationsHashMap *AssociationsManager::_map = NULL;

enum {
    OBJC_ASSOCIATION_SETTER_ASSIGN      = 0,
    OBJC_ASSOCIATION_SETTER_RETAIN      = 1,
    OBJC_ASSOCIATION_SETTER_COPY        = 3,
    OBJC_ASSOCIATION_GETTER_READ        = (0 << 8),
    OBJC_ASSOCIATION_GETTER_RETAIN      = (1 << 8),
    OBJC_ASSOCIATION_GETTER_AUTORELEASE = (2 << 8)
};

// 根据一个给定的对象以及一个键值来获取它所绑定过的关联对象
id _object_get_associative_reference(id object, void *key) {
    id value = nil;//关联对象
    unsigned long policy = OBJC_ASSOCIATION_ASSIGN;//缓存策略
    {//安全释放
        AssociationsManager manager;//初始化AssociationsManager管理类
        /*
         这里用到了C++中引用的知识点，对这一块不太了解的同学可以自行查阅
         int a = 10;
         int &b = a;
         b变量只是a的别名，两者访问的是同一块内存空间
         
         为了更好的理解这里我们拆分一下
         AssociationsHashMap &associations(manager.associations());
         manager.associations();manager的associations()方法返回的是引用,是一个全局哈希键值对表的引用,我们一个临时变量去接这个返回值
         */
        AssociationsHashMap tmp = manager.associations();
        AssociationsHashMap &associations(tmp);//AssociationsHashMap引用初始化方法

        /*
         http://blog.csdn.net/coder__cs/article/details/79186677
         阐述了计算机能够识别的二进制串是一种补码，我们理解的原码、反码只是我们自己定义的，计算机并不能识别。
         二进制按位取反 x的按位取反结果为-(x+1)
         */
        unsigned long disguised_object = DISGUISE(object);
        
        /*
         ObjectAssociationMap stl中map的子类、保存的是键值对
         绑定关联对象时用到的key作为键，ObjcAssociation(policy,new_value)作为值,这样一对键值对存储在ObjectAssociationMap中
         AssociationsHashMap stl中unordered_map的子类，这里是全局的
         以对象指针16进制按位取反获得的补码作为键，以上述一对键值对作为值，存储在AssociationsHashMap中
         */
        /*
         unordered_map容器中的迭代器，在AssociationsHashMap中查找给定对象所有绑定对象的键值对
         查找到之后返回容器中所在的位置，用迭代器指向所在的位置。
         i->first;  //key
         i->second; // value
         */
        AssociationsHashMap::iterator i = associations.find(disguised_object);
        if (i != associations.end()) {
            ObjectAssociationMap *refs = i->second;
            ObjectAssociationMap::iterator j = refs->find(key);
            if (j != refs->end()) {
                ObjcAssociation &entry = j->second;
                value = entry.value();
                policy = entry.policy();
                if (policy & OBJC_ASSOCIATION_GETTER_RETAIN) ((id(*)(id, SEL))objc_msgSend)(value, SEL_retain);
            }
        }
    }
    // 根据缓存策略来对关联对象进行内存管理
    if (value && (policy & OBJC_ASSOCIATION_GETTER_AUTORELEASE)) {
        ((id(*)(id, SEL))objc_msgSend)(value, SEL_autorelease);
    }
    return value;
}

static id acquireValue(id value, unsigned long policy) {
    switch (policy & 0xFF) {
        case OBJC_ASSOCIATION_SETTER_RETAIN:
            return ((id(*)(id, SEL))objc_msgSend)(value, SEL_retain);
        case OBJC_ASSOCIATION_SETTER_COPY:
            return ((id(*)(id, SEL))objc_msgSend)(value, SEL_copy);
    }
    return value;
}

static void releaseValue(id value, unsigned long policy) {
    if (policy & OBJC_ASSOCIATION_SETTER_RETAIN) {
        ((id(*)(id, SEL))objc_msgSend)(value, SEL_release);
    }
}

struct ReleaseValue {
    void operator() (ObjcAssociation &association) {
        releaseValue(association.value(), association.policy());
    }
};

// 给某个object绑定关联对象
void _object_set_associative_reference(id object, void *key, id value, unsigned long policy) {
    // retain the new value (if any) outside the lock.
    ObjcAssociation old_association(0, nil);
    // value对象时简单的技术加一还是copy
    id new_value = value ? acquireValue(value, policy) : nil;
    {
        AssociationsManager manager;
        AssociationsHashMap &associations(manager.associations());
        disguised_ptr_t disguised_object = DISGUISE(object);
        if (new_value) {
            // break any existing association.
            AssociationsHashMap::iterator i = associations.find(disguised_object);
            if (i != associations.end()) {
                // secondary table exists
                /*
                 i->first; key   disguised_object
                 i->second;value ObjectAssociationMap
                 */
                ObjectAssociationMap *refs = i->second;
                
                ObjectAssociationMap::iterator j = refs->find(key);
                if (j != refs->end()) {
                    /*
                     i->first; key   就是绑定关联对象时用到的key作为键值
                     i->second;value 就是ObjcAssociation(policy, new_value)
                     */
                    old_association = j->second;
                    j->second = ObjcAssociation(policy, new_value);
                } else {
                    (*refs)[key] = ObjcAssociation(policy, new_value);
                }
            } else {
                // create the new association (first time).
                ObjectAssociationMap *refs = new ObjectAssociationMap;
                associations[disguised_object] = refs;
                (*refs)[key] = ObjcAssociation(policy, new_value);
                
                // 设置当前对象已经绑定了关联对象
                object->setHasAssociatedObjects();
            }
        } else {
            // setting the association to nil breaks the association.
            AssociationsHashMap::iterator i = associations.find(disguised_object);
            if (i !=  associations.end()) {
                ObjectAssociationMap *refs = i->second;
                ObjectAssociationMap::iterator j = refs->find(key);
                if (j != refs->end()) {
                    old_association = j->second;
                    refs->erase(j);
                }
            }
        }
    }
    // release the old value (outside of the lock).
    if (old_association.hasValue()) ReleaseValue()(old_association);
}

// 删除object对象绑定的关联对象
void _object_remove_assocations(id object) {
    vector< ObjcAssociation,ObjcAllocator<ObjcAssociation> > elements;
    
    // 搭建舞台，生命周期完整
    {
        // AssociationsManager无参构造函数以及析构函数分别实现了加锁、解锁操作，避免了资源竞争
        // AssociationsManager内部有一个共享的AssociationsHashMap
        AssociationsManager manager;
        
        // AssociationsHashMap集成unordered_map 无序map
        // unordered_map(const unordered_map& __u);
        // manager.associations()返回值AssociationsHashMap引用
        AssociationsHashMap tmp = manager.associations();
        AssociationsHashMap &associations(tmp);
        
        if (associations.size() == 0) return;
        
        /*
         inline
         disguised_ptr_t DISGUISE(id value) {
         return ~unsigned long(value);
         }
         
         unsigned long DISGUISE(id value) {
         return ~(unsigned long)(value);
         }
         */
        disguised_ptr_t disguised_object = DISGUISE(object);
        
        // 迭代器
        AssociationsHashMap::iterator i = associations.find(disguised_object);
        if (i != associations.end()) {
            // copy all of the associations that need to be removed.
            ObjectAssociationMap *refs = i->second;
            for (ObjectAssociationMap::iterator j = refs->begin(), end = refs->end(); j != end; ++j) {
                elements.push_back(j->second);
            }
            // remove the secondary table.
            delete refs;
            associations.erase(i);
        }
    }
    
    // the calls to releaseValue() happen outside of the lock.
    /*
     struct ReleaseValue {
        void operator() (ObjcAssociation &association) {
            releaseValue(association.value(), association.policy());
        }
     }
     */
    // 遍历对象，对容器中的所有关联对象进行内存释放
    for_each(elements.begin(), elements.end(), ReleaseValue());
}

/*************************End*****************************/
