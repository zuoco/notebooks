---
title: "虚函数与多态"
description: 
date: 2023-03-26
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
    - "C++"
---

1. [1. 虚函数与纯虚函数](#1-虚函数与纯虚函数)
    1. [1.1. 虚函数](#11-虚函数)
    2. [1.2. 纯虚函数](#12-纯虚函数)
2. [2. 构造与析构](#2-构造与析构)
    1. [2.1. 构造](#21-构造)
    2. [2.2. 析构](#22-析构)
3. [3. 虚函数表](#3-虚函数表)
    1. [3.1. 什么是虚函数表](#31-什么是虚函数表)
    2. [3.2. 虚函数表结构](#32-虚函数表结构)
4. [4. 多态](#4-多态)


# 1. 虚函数与纯虚函数
- `抽象类`：包含至少一个纯虚函数的类，这种类无法实例化，用于定义接口规范，然后让派生类实现。     
- `强制实现`：派生类必须实现所有纯虚函数，否则仍为`抽象类`。  
 
## 1.1. 虚函数
基类中声明为 virtual 的成员函数，允许派生类重写（override）该函数，从而实现运行时多态性。  
```cpp/*虚基类*/
class A
{
protected:
int m_x;
};
/*虚继承*/
class B: virtual public A
{
protected:
int m_y;
};
class Base {
public:
    virtual void func() { std::cout << "Base::func" << std::endl; }
};

class Derived : public Base {
public:
    void func() override { std::cout << "Derived::func" << std::endl; }
};
```
`动态绑定`特性，通过基类指针或引用调用虚函数时，会根据对象的实际类型动态决定调用哪个实现。

## 1.2. 纯虚函数
声明为 virtual void func() = 0; 的虚函数，基类不会给出具体实现。      
```cpp
class AbstractBase {
public:
    virtual void pureFunc() = 0;  // 纯虚函数
};

class Concrete : public AbstractBase {
public:
    void pureFunc() override { std::cout << "Concrete::pureFunc" << std::endl; }
};
```

# 2. 构造与析构

## 2.1. 构造
构造函数和普通类型的构造函数的规则一样。   

## 2.2. 析构
和一般基类的析构函数相比，抽象类的析构函数可以是纯虚函数。    
```cpp
class AbstractBase {
public:
    virtual ~AbstractBase() = default;
}
```


# 3. 虚函数表
## 3.1. 什么是虚函数表

&emsp;&emsp;如果一个类包含了虚函数，那么在创建该类的对象时就会额外地增加一个数组（`虚函数表vtable`），数组中的每一个元素都是虚函数的入口地址。不过虚函数表和对象是分开存储的，为了将对象和数组关联起来，`编译器在对象内存的开始位置安插一个指针（虚函数表指针vfptr）`，指向vtable的起始位置。   
&emsp;&emsp;基类的虚函数在vtable中的索引（下标）是固定的，不会随着继承层次的增加而改变，派生类新增（不是覆盖的那个）的虚函数放在vtable的最后。如果派生类有同名的虚函数覆盖了基类的虚函数，那么将使用派生类的虚函数替换基类的虚函数，位置不变。这样具有遮蔽关系的虚函数在vtable中只会出现一次。在单继承情况下，当通过对象指针p调用虚函数时，编译器内部会发生类似下面的转换：
<div style="width: 80%; margin: 0 auto; background-color:#f5f9ff; padding:1em; border-radius:10px; box-shadow: 0 2px 6px rgba(0,0,0,0.1);">
<code style="color:#333; font-family:monospace; font-size:1.2em; white-space: pre;">
<mark style="background-color:#ffeb3b; padding:0.2em 0.4em; border-radius:4px;">*(p+vbi)</mark>               //虚函数表的地址
<mark style="background-color:#8bc34a; padding:0.2em 0.4em; border-radius:4px;">*(*(p+vbi)+vfi)</mark>        //该虚函数的在表中的地址
<mark style="background-color:#2196f3; padding:0.2em 0.4em; border-radius:4px;">(*(*(p+vbi)+vfi))(p);</mark>   //函数调用，p是参数
</code>
</div>


- `vbi`是`vfptr`(虚函数表指针)在对象中的偏移，`p+vbi`是`vfptr`的地址，虚函数表指针始终位于对象的起始位置，所以`vbi = 0`;
- `*(p+vbi)`是`vfptr`的值，而`vfptr`是指向`vtable`的指针，所以`*(p+vbi)`也就是vtable的地址;
- `vfi`是虚函数在`vtable`中的索引，所以`(*(p+vbi)+vfi)`也就是虚函数的地址;
- 知道了虚函数的地址，`(*(*(p+vbi)+vfi))(p)`也就是对虚函数的调用了，这里的p就是传递的实参，它会赋值给this指针。


&emsp;&emsp;可以看到，转换后的表达式是固定的，只要调用同一个虚函数，不管是哪个类的对象来调用，都会使用这个表达式，最终指向的是虚函数表中的同一个位置。   


## 3.2. 虚函数表结构
- 基类的虚函数在 vtable 中的索引（下标）是固定的，不会随着继承层次的增加而改变。  
- 派生类新增的虚函数放在基类虚函数的后面。   
- 如果派生重写了基类的虚函数，那么将使用派生类重写的虚函数替换基类的虚函数，这样vtable只有重写后的虚函数。     

# 4. 多态
&emsp;&emsp;多态可以分为编译时多态(重载)和运行时多态（虚函数），通过寄了指针/引用来访问派生类对象，虚函数的调用成本高于普通成员函数，所以多态是会带来性能损失。

**`类的向上转型`**   
- 向上转型（Upcasting）是指，从派生类类型转换为基类类型。
- 在C++中，向上转型可以是隐式的，也可以是显式的，使用显式类型转换主要是为了代码的清晰性和可读性（ static_cast()、dynamic_cast() ）。  
- 向上转型后通过基类的对象、指针、引用只能访问从基类继承过去的成员（包括成员变量和成员函数），不能访问派生类新增的成员。  


**向上转型的三种情况：**     

1. **将派生类对象赋值给基类对象**   
&emsp;&emsp;对象的内存只包含了成员变量，所以对象之间的赋值是成员变量的赋值。将派生类对象赋值给基类对象时，会舍弃派生类新增的成员     

2. **将派生类指针赋值给基类指针**（通过基类指针访问派生类成员）。   
&emsp;&emsp;成员函数和成员变量的访问方式不同，`编译器通过指针的类型来访问成员函数`。基类指针可以指向派生类对象，但是指针的类型不会变，指向派生类对象后，指针还是基类类型，所以此时当问的是基类的成员函数。  
&emsp;&emsp;`编译器通过指针的指向来访问成员变量`，一个基类指针指向派生类对象，这会导致 this 发生了变化，此时的this指向了派生类对象，所以访问的就是派生了的成员变量。这就引发了一个荒诞的现象： 访问的变量是派生类的，使用的函数却是基类的，要解决这个问题，需要用到`虚函数`————《虚函数》。   

3. **将派生类引用赋值给基类引用**   
类似于**将派生类指针赋值给基类指针**。  
