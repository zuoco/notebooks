---
title: "自定义类型"
description: 
date: 2023-03-11
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
    - "C++"
---



1. [1. 实例的初始化](#1-实例的初始化)
    1. [1.1. 基本类型](#11-基本类型)
    2. [1.2. 自定义类](#12-自定义类)
2. [2. 类成员](#2-类成员)
    1. [2.1. 访问权限](#21-访问权限)
    2. [2.2. mutable](#22-mutable)
    3. [2.3. 静态成员变量](#23-静态成员变量)
    4. [2.4. 友元](#24-友元)
    5. [2.5. this指针](#25-this指针)
    6. [2.6. 静态成员函数](#26-静态成员函数)
    7. [2.7. 构造函数](#27-构造函数)
    8. [2.8. 析构函数](#28-析构函数)



# 1. 实例的初始化
## 1.1. 基本类型
对于基本类型，都可以使用零初始化。  
```cpp
int x {};   //零初始化： 初始化为0

int y {10};  //
```

## 1.2. 自定义类
```cpp
class MyClass {
public:
    MyClass() { /* 默认构造函数 */ }
    MyClass(int x, int y) : x_(x), y_(y) {}

private:
    int x_, y_;
};

int main() {
    MyClass obj; // 默认初始化
    MyClass p(3, 4); // 直接初始化
}
```

# 2. 类成员   
## 2.1. 访问权限  
指定成员被访问的方式。   
**private**&emsp;&emsp;: &emsp;默认权限，仅限类的内部访问。   
**protected**&emsp;: &emsp;仅限类的内部访问，和private的区别在于继承时。        
**public**&emsp;: &emsp;类的外部，通过类的实例访问。  

## 2.2. mutable    
对于一个const对象，它的mutable成员变量依然可写。  

## 2.3. 静态成员变量   
所有实例共享，也遵循类的访问控制规则（public/private/protected），在单例模式中用的较多。
```cpp
// MyClass.h
class MyClass {
public:
    /* 
     * C++17 的 inline static 特性，允许在类内部定义并初始化静态成员变量
     * inline 允许在头文件中定义静态成员变量，并确保即使多个翻译单元包含该头文件，链接器也能正确处理，不会导致多重定义错误。
     */
    inline static int count = 0; 
};
```

```cpp
class MyClass {
public:
    /* 
     * C++20的constexpr特性, 编译时使用字面量初始化。  
     * 不可修改，默认内联。  
     */
    static constexpr int MaxValue = 100; 
};
```

## 2.4. 友元
class中的成员默认是private的，但是有个别时候，需要访问private成员，此时就需要使用`友元`，但是友元会破坏封装，一般不用，等用到了再去研究。  
```cpp
class B;

class A {
    friend B;
    static int a;
    float b;
};

class B {
    void func() {
        // 作为A的友元，可以访问A的私有成员
        std::cout << A::a << std::endl;
    }
};
```

## 2.5. this指针
在类的内部，成员函数可以使用`this`指针访问当前对象，this的类型是`MyClass* const`，所以this本身是不能修改的。如果不允许成员函数修改当前对象的值就要在函数声明的形参列表后面使用`const`。
```cpp
class MyClass {

    void func() {
        // this的类型为： MyClass* const
    }

    void func() const {
        // this的类型为：  const MyClass* const
    }
};
```
上面两个函数还是重载关系，因为

## 2.6. 静态成员函数
所有实例共享，也遵循类的访问控制规则（public/private/protected），但是没有this指针，无法访问非静态成员。需要显式传递对象。

## 2.7. 构造函数
《构造函数》
## 2.8. 析构函数
《析构函数》


