//
//  main.m
//  debug_objc
//
//  Created by Holy_Han on 19/09/2017.
//
//

#import <Foundation/Foundation.h>
#import "Dog.h"
/*
 struct objc_class {
    Class isa                                                OBJC_ISA_AVAILABILITY;
 #if !__OBJC2__
    Class super_class                                        OBJC2_UNAVAILABLE;
    const char *name                                         OBJC2_UNAVAILABLE;
    long version                                             OBJC2_UNAVAILABLE;
    long info                                                OBJC2_UNAVAILABLE;
    long instance_size                                       OBJC2_UNAVAILABLE;
    struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;
    struct objc_method_list **methodLists                    OBJC2_UNAVAILABLE;
    struct objc_cache *cache                                 OBJC2_UNAVAILABLE;
    struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
 #endif
 } OBJC2_UNAVAILABLE;
 这里如果动态修改*methodLists的值来添加成员方法，这也是Category实现的原理，同样解释了Category不能添加属性的原因
 https://tech.meituan.com/?l=320&pos=0
 https://tech.meituan.com/DiveIntoCategory.html
 所有的OC类和对象，在runtime层都是用struct表示的，category也不例外，在runtime层，category用结构体category_t（在objc-runtime-new.h中可以找到此定义），它包含了
 1)、类的名字（name）
 2)、类（cls）
 3)、category中所有给类添加的实例方法的列表（instanceMethods）
 4)、category中所有添加的类方法的列表（classMethods）
 5)、category实现的所有协议的列表（protocols）
 6)、category中添加的所有属性（instanceProperties）
 typedef struct category_t {
    const char *name;
    classref_t cls;
    struct method_list_t *instanceMethods;
    struct method_list_t *classMethods;
    struct protocol_list_t *protocols;
    struct property_list_t *instanceProperties;
 } category_t;
 从category的定义也可以看出category的可为（可以添加实例方法，类方法，甚至可以实现协议，添加属性）和不可为（无法添加实例变量）。
 1)、把category的实例方法、协议以及属性添加到类上
 2)、把category的类方法和协议添加到类的metaclass上
 */
// 全局变量 在该文件内谁都可以改 所以应该通过内存地址去查值
int age = 3;

int main(int argc, const char * argv[]) {

    @autoreleasepool {
        // insert code here...
        Dog *dog = [[Dog alloc] init];
        NSLog(@"dog=%@",dog);
//        __weak id ptr = stu;
//        __weak id ptr2 = ptr;
        /*
         内部调用这个方法
         newObj = stu
         *location = ptr
         location = &ptr
         id objc_initWeak(id *location, id newObj) {
            // 检查newObj的有效性
            if (!newObj) {
                *location = nil;
                return nil;
            }
            // 这里传递了三个bool数值
            // 使用template进行常量参数传递是为了优化性能
            return storeWeak<DontHaveOld, DoHaveNew, DoCrashIfDeallocating>
                (location, (objc_object*)newObj);
        }
         */
        
        /*
         char *name = "wangweihu";
         //        int age = 20;
         struct {
         char *name;
         int age;
         }stu = {name, age};
         
         NSLog(@"%s", stu.name);
         debug_objc`main:
         0x100000ef0 <+0>:   pushq  %rbp
         0x100000ef1 <+1>:   movq   %rsp, %rbp
         0x100000ef4 <+4>:   subq   $0x40, %rsp
         0x100000ef8 <+8>:   movl   $0x0, -0x4(%rbp)
         0x100000eff <+15>:  movl   %edi, -0x8(%rbp)
         0x100000f02 <+18>:  movq   %rsi, -0x10(%rbp)
         
         0x100000f06 <+22>:  callq  0x100000f64           ; symbol stub for: objc_autoreleasePoolPush
         
         leaq就是目标地址传送指令： 将一个近地址指针写入到指定的寄存器
         0x100000f0b <+27>:  leaq   0x116(%rip), %rsi     ; rsi = @"%s"
         0x100000f12 <+34>:  leaq   0x85(%rip), %rcx      ; rcx = "wangweihu"
         // 0x100000f35 <+53>:  movl   0x1fd(%rip), %edi     ; c
         0x100000f19 <+41>:  movq   %rcx, -0x18(%rbp)     ; rbp-0x18 = "wangweihu" name
         0x100000f1d <+45>:  movl   $0x14, -0x1c(%rbp)    ; rbp-0x1c = 20   age
         0x100000f24 <+52>:  movq   -0x18(%rbp), %rcx     ; rcx = wangweihu
         0x100000f28 <+56>:  movq   %rcx, -0x30(%rbp)     ; rbp-30 = rcx
         0x100000f2c <+60>:  movl   -0x1c(%rbp), %edi     ; edi = 20
         0x100000f2f <+63>:  movl   %edi, -0x28(%rbp)     ; rbp-28= 20
         ->  0x100000f32 <+66>:  movq   -0x30(%rbp), %rcx ; rcx = name
         0x100000f36 <+70>:  movq   %rsi, %rdi            ; di = @"%s"
         0x100000f39 <+73>:  movq   %rcx, %rsi            ; rsi = name
         0x100000f3c <+76>:  movq   %rax, -0x38(%rbp)     ; rbp-38 = rax
         0x100000f40 <+80>:  movb   $0x0, %al             ; al = 0000
         
         0x100000f42 <+82>:  callq  0x100000f58           ; symbol stub for: NSLog
         0x100000f47 <+87>:  movq   -0x38(%rbp), %rdi     ; rdi = rax
         
         0x100000f4b <+91>:  callq  0x100000f5e           ; symbol stub for: objc_autoreleasePoolPop
         0x100000f50 <+96>:  xorl   %eax, %eax
         0x100000f52 <+98>:  addq   $0x40, %rsp
         0x100000f56 <+102>: popq   %rbp
         0x100000f57 <+103>: retq
         */
    }
    return 0;
}
