//
//  main.cpp
//  C&C++
//
//  Created by 王伟虎 on 2018/1/23.
//  Copyright © 2018年 wwh. All rights reserved.
//

#include <iostream>
#include "Circle.hpp"
#include "Reference.hpp"
#include "Name.hpp"
#include "Area.hpp"
#include "Triangle.hpp"
#include "Square.hpp"

/**************Day5**************/
//多重继承接口不会带来二义性和复杂性等问题
class InterfaceA {
public:
    virtual void print() = 0;
    virtual int add(int a, int b) = 0;
};

class InterfaceB {
public:
    virtual void print() = 0;
    virtual int add(int a, int b) = 0;
    virtual int minus(int a, int b) = 0;
};

class Parent {
public:
    int a;
};

class Child : public Parent, public InterfaceA, public InterfaceB {
public:
    void print() {
        cout<<"Child::print"<<endl;
    }
    
    int add(int a, int b) {
        return a + b;
    }
    
    int minus(int a, int b) {
        return a - b;
    }
};

void InterfaceTest() {
    Child c;
    c.print();
    
    cout<<c.add(3, 5)<<endl;
    cout<<c.minus(4, 6)<<endl;
    
    InterfaceA* i1 = &c;
    InterfaceB* i2 = &c;
    
    cout<<i1->add(7, 8)<<endl;
    cout<<i2->add(7, 8)<<endl;
    
    cout << "Hello, World!\n";
}


/**************Day4**************/
//class Parent {
//public:
//    static int num;//声明静态变量
//public:
//    virtual void print(){
//
//    }
//private:
//};

//int Parent::num = 10;
//
//class Child: public Parent {
//public:
//    int c;
//    int d;
//    int e;
//};

void VirtualTest() {
//    cout << "静态变量：" << Parent::num << endl;
    
    // 字节对齐
    // vptr指针 8字节
    cout << "Parent大小：" << sizeof(Parent) << endl;
    cout << "Child大小：" << sizeof(Child) << endl;
    
    // 步长问题
    Child child0;
    Child child1;
    Child child2;
    Child child3;
    Child child[] = {child0, child1, child2, child3};
    Parent *parent = child;
    Child *childPtr = child;
    for (int i = 0; i < 4; i++) {
        childPtr  ++; printf("childPtr地址：%p \n", childPtr  ++);
        parent    ++; printf("parent地址：%p \n", parent  ++);
    }
}

/**************Day3**************/
void PlayObjc1(Area *base) {
    cout << "面积：" << base->calculateArea() << endl;
}

void CalculateAreaTest(void) {
    Triangle *t = new Triangle(12.6, 3.4);
    Square *s = new Square(12.0, 3.0);
    Circle *c = new Circle(12);
    PlayObjc1((Area *)t);
    PlayObjc1((Area *)s);
    PlayObjc1((Area *)c);
}

/**************Day2**************/
void ReferenceTest(void) {
    Teacher t1;
    t1.name = 20;
    cout << "Teacher的名字：" << t1.name << endl;
    cout << "Teacher的名字：" << t1.aliasName << endl;
}
// 以下两个函数重载了
void SwapTwoNumber(int &a, int &b) {
    int c = 0;
    c = a;
    a = b;
    b = c;
}

void SwapTwoNumber(int *a, int *b) {
    int c = 0;
    c = *a;
    *a = *b;
    *b = c;
}

void ReferenceTest2(void) {
    int a = 30;
    int b = 20;
    SwapTwoNumber(&a, &b); //间接
    // SwapTwoNumber(a, b); //引用
    cout << "a：" << a << endl;
    cout << "b：" << b << endl;
}

/**************Day1**************/
void CircleTest1(void) {
    double r = 0.0f;
    Circle circleOne(10);//对象分配在栈上
    cout << "请输入半径：";//标准输出函数，相当于C语言中的 printf("请输入半径：\n");
    cin >> r;//标准输入函数，相当于C语言中的 scanf(&(circleOne.c_r));
    circleOne.setR(r);
    cout << "圆的面积：" << circleOne.getS() << endl;
    cout << "Hello, World!\n";
}

void CircleTest2(void) {
    Circle circleOne(10);//调用有参构造函数
    Circle circleTwo = circleOne;//调用构造函数
    
    cout << "圆的面积：" << circleTwo.getS() << endl;
    cout << "Hello, World!\n";
}

void CircleTest3(void) {
    Circle circleOne(10);//调用有参构造函数
    Circle circleTwo(2);
    circleTwo = circleOne;// 不调用赋值构造函数，operation=()，操作符重载
    cout << "圆的面积：" << circleTwo.getS() << endl;
    cout << "Hello, World!\n";
}

/*
 结合CircleTest1、CircleTest2、CircleTest3总结构造函数调用规则:
 1.当类中没有定义任何一个构造函数时，c++编译器会提供默认无参构造函数和默认拷贝构造函数
 2.当类中定义了拷贝构造函数时，c++编译器不会提供无参数构造函数
 3.当类中定义了任意的非拷贝构造函数（即：当类中提供了有参构造函数或无参构造函数），c++编译器不会提供默认无参构造函数
 4.默认拷贝构造函数成员变量简单赋值
 总结：只要你写了构造函数，那么你必须用
 */

/*
 深拷贝、浅拷贝问题的引出
 ➢对象的数据资源是由指针指向的堆时，默认复制构造函数仅作指针值复制
 ➢默认复制构造函数可以完成对象的数据成员值简单的复制
 */

void playObj() {
    Name obj1("obj1.....");//一般的带参构造函数
    Name obj2 = obj1; //obj2创建并初始化，调用赋值拷贝函数
    Name obj3("obj3...");//一般的带参构造函数
    
    //重载=号操作符
    //在不重载=号操作符的时候，c++编译器提供的=号浅拷贝，只是简单的指针值拷贝
    obj2 = obj3; //=号操作
}

int main(int argc, const char * argv[]) {
    // insert code here...

    return 0;
}


