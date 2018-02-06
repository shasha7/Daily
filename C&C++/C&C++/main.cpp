//
//  main.cpp
//  C&C++
//
//  Created by 王伟虎 on 2018/2/5.
//  Copyright © 2018年 wwh. All rights reserved.
//

#include <iostream>
#include <iterator>

#include <string>
#include <vector>
#include <stack>
#include <deque>
#include <queue>
#include <list>
#include <set>
#include <map>
#include <unordered_map>

#include <algorithm>
#include <numeric>
#include <functional>

using namespace std;

class Student {
public:
    Student(char *name, int ID) {
        this->s_name = name;
        this->s_ID = ID;
    }
public:
    char *s_name;
    int s_ID;
};

bool Compare(const Student &stu1, const Student &stu2) {
    if (stu1.s_ID > stu2.s_ID) {
        return true;
    }
    return false;
}

/*
 deque的使用场景：比如排队购票系统，对排队者的存储可以采用deque，支持头端的快速移除，尾端的快速添加。如果采用vector，则头端移除时，会移动大量的数据，速度慢。
 vector与deque的比较：
 一：vector.at()比deque.at()效率高，比如vector.at(0)是固定的，deque的开始位置却是不固定的。
 二：如果有大量释放操作的话，vector花的时间更少，这跟二者的内部实现有关。
 三：deque支持头部的快速插入与快速移除，这是deque的优点。
 list的使用场景：比如公交车乘客的存储，随时可能有乘客下车，支持频繁的不确实位置元素的移除插入。
 set的使用场景：比如对手机游戏的个人得分记录的存储，存储要求从高分到低分的顺序排列。
 map的使用场景：比如按ID号存储十万个用户，想要快速通过ID查找对应的用户。二叉树的查找效率，这时就体现出来了。如果是vector容器，最坏的情况下可能要遍历完整个容器才能找到该用户。
 */

void main07() {
    //map的具体实现采用红黑树变体的平衡二叉树的数据结构

}

void main06() {
    //set<int> setIntA;//自动排序、按照从小到大排序
    set<int, less<int>> setIntA; //按照从小到大排序
//    set<int, greater<int>> setIntA;//按照从大到小排序
    
    setIntA.insert(3);
    setIntA.insert(1);
    setIntA.insert(7);
    setIntA.insert(5);
    setIntA.insert(9);
    
    if (!setIntA.empty()) {
        cout << "set大小：" << setIntA.size() << endl;
    }
    
    // 迭代器遍历
    for (set<int>::iterator it = setIntA.begin(); it != setIntA.end(); it++) {
        cout << *it << " ";
    }
    cout << endl;
    
    // 删除元素
    set<int>::iterator itb = setIntA.begin();
    set<int>::iterator ite = setIntA.begin();
    ite++;
    ite++;
    setIntA.erase(itb, ite);
    
    // 迭代器遍历
    for (set<int>::iterator it = setIntA.begin(); it != setIntA.end(); it++) {
        cout << *it << " ";
    }
    cout << endl;
    
    setIntA.erase(9);
    
    // 迭代器遍历
    for (set<int>::iterator it = setIntA.begin(); it != setIntA.end(); it++) {
        cout << *it << " ";
    }
    cout << endl;
}

void main05() {
    queue<int> q1;
    q1.push(20);
    q1.push(23);
    q1.push(21);
    q1.push(29);
    
    cout << q1.front() << endl;
}

void main04() {
    // 栈 先进后出
    stack<int> s1;
    
    s1.push(1);
    s1.push(2);
    s1.push(3);
    s1.push(4);
    s1.push(5);
    cout << "栈大小：" << s1.size() << endl;
    
    while (!s1.empty()) {
        cout << s1.top() << " ";
        s1.pop();
    }
    cout << endl;
}

void main03() {
    // 双端数组
    deque<int> d1;
    cout << "双端数组大小：" << d1.size() <<endl;
    
    d1.push_front(9);
    d1.push_back(10);
    d1.push_back(11);
    
    d1.push_front(-1);
    d1.push_front(-3);
    
    cout << "双端数组大小：" << d1.size() <<endl;
    
    for (deque<int>::iterator it = d1.begin(); it != d1.end(); it++) {
        cout << *it << " ";
    }
    cout << endl;
    
    d1.pop_back();
    d1.pop_back();
    
    d1.pop_front();
    d1.pop_front();
    
    cout << "双端数组大小：" << d1.size() <<endl;
    
    for (deque<int>::iterator it = d1.begin(); it != d1.end(); it++) {
        cout << *it << " ";
    }
    cout << endl;
    
}


unsigned long DISGUISE(Student *value) {
    return ~(unsigned long)(value);
}

void main02() {
    /*
    vector<int> v1;
    v1.push_back(1);
    v1.push_back(3);
    v1.push_back(5);
    v1.push_back(7);
    
    for (vector<int>::iterator it = v1.begin(); it != v1.end(); it++) {
        cout << *it << " ";
    }
    cout << endl;
    
    vector<int> v2(10);
    
    for (int i = 0;i < v2.size();i++) {
        v2[i] = i + 1;
    }
    
    for (vector<int>::iterator it = v2.begin(); it != v2.end(); it++) {
        cout << *it << " ";
    }
    cout << endl;
    
    v2.pop_back();
    v2.pop_back();
    v2.pop_back();
    v2.pop_back();
    
    for (vector<int>::iterator it = v2.begin(); it != v2.end(); it++) {
        cout << *it << " ";
    }
    cout << endl;
    
    cout << v2.front() << endl;
    cout << v2.back() << endl;
    
    cout << "=======" << endl;
    vector<int> v3(10);
    
    for (int i = 0;i < v3.size();i++) {
        v3[i] = i + 1;
    }
    vector<int>::iterator it = v3.begin();
    
    v3.erase(it, it + 2);
    
    for (vector<int>::iterator it = v3.begin(); it != v3.end(); it++) {
        cout << *it << " ";
    }
    cout << endl;
    
    cout << "=======" << endl;
    */
    
    /*
    vector<int> vecIntA;
    vecIntA.push_back(1);
    vecIntA.push_back(3);
    vecIntA.push_back(5);
    vecIntA.push_back(7);
    vecIntA.push_back(9);
    
    vector<int> vecIntB;
    vecIntB.push_back(2);
    vecIntB.push_back(4);
    vecIntB.push_back(6);
    vecIntB.push_back(8);
    
    vector<int> vecIntC(9);
    
    // 算法 合并 vecIntA、vecIntB到vecIntC
    merge(vecIntA.begin(), vecIntA.end(), vecIntB.begin(), vecIntB.end(), vecIntC.begin());
    for (vector<int>::iterator it = vecIntC.begin(); it != vecIntC.end(); it++) {
        cout << *it << " ";
    }
    cout << endl;
     */
    
    /*
    Student t1((char *)"dongshi", 100501101);
    Student t2((char *)"liyingya", 100501102);
    Student t3((char *)"zhangluming", 100501103);
    Student t4((char *)"wangweihu", 100501104);
    
    vector<Student> vecIntA;
    
    vecIntA.push_back(t3);
    vecIntA.push_back(t1);
    vecIntA.push_back(t4);
    vecIntA.push_back(t2);
    
    sort(vecIntA.begin(), vecIntA.end(), Compare);
    
    for (vector<Student>::iterator it = vecIntA.begin(); it != vecIntA.end(); it++) {
        Student tmp = *it;
        cout << tmp.s_name << endl;
    }
    cout << endl;
     */
    
    Student t1((char *)"dongshi", 100501101);
    Student &stu(t1);
    stu.s_name = (char *)"dongshi1";
    cout << stu.s_name << endl;
}

void main01() {
    // char *===>string
    string s1 = "wangweihu";
    cout << s1 << endl;
    
    //string ===>char *
    string s2("wushanshan");
    cout << s2.c_str() << endl;
    
    // 迭代器遍历
    string s3 = s1 + s2;
    for (string::iterator it = s3.begin(); it != s3.end(); it++) {
        cout << *it;
    }
    cout << endl;
}

void main00() {
    // Create an unordered_map of three strings (that map to strings)
    unordered_map<string, string> u = {
        {"RED","#FF0000"},
        {"GREEN","#00FF00"},
        {"BLUE","#0000FF"}
    };
    
    // Add two new entries to the unordered_map
    u["BLACK"] = "#000000";
    u["WHITE"] = "#FFFFFF";
    
    // Output values by key
    cout << "The HEX of color RED is:[" << u["RED"] << "]\n";
    cout << "The HEX of color BLACK is:[" << u["BLACK"] << "]\n";
    
    // Iterate and print keys and values of unordered_map
    for(unordered_map<string, string>::iterator it = u.begin(); it != u.end(); it++) {
        cout << "Key:[" << it->first << "] Value:[" << it->second << "]\n";
    }
    /*
     这是什么鬼????
     for( const auto& n : u ) {
        std::cout << "Key:[" << n.first << "] Value:[" << n.second << "]\n";
     }
     */
}

int main(int argc, const char * argv[]) {
    // insert code here...
    //main07();
    //main06();
    //main05();
    //main04();
    //main03();
    //main02();
    //main01();
    //main00();
    return 0;
}
