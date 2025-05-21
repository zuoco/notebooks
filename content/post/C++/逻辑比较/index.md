---
title: "三路比较运算符"
description: "C++20三路比较运算符: operator<=>"
date: 2025-05-04
image: AAA.jpg
math: 
license: 
comments: true
draft: false
categories:
    - C++20
---

# 1. operator<=>
<=>目的在于简化自定义类型的比较逻辑，只要实现了<=>和==，编译器就会自动生成其他比较运算逻辑。   
返回值类型为三种比较类别类型：  
```cpp 
std::strong_ordering 
std::weak_ordering  
std::partial_ordering   
```  
下面介绍这三种比较类型：

## 1.1. std::strong_ordering
当两个对象之间存在完全可比较的强序关系时使用，也就是说两个对象之间可以明确的判断出谁大谁小。      
**返回值**：       
```cpp
std::strong_ordering::less      // 左操作数小于右操作数   
std::strong_ordering::equal     // 左操作数等于右操作数
std::strong_ordering::greater   // 左操作数大于右操作数
```
## 1.2. std::weak_ordering
当两个对象之间存在弱序关系时，这意味着两者之间可以比较大小，但是有时不会完全相等，比如说大小写，但是std::weak_ordering依然视为相等，所以在需要忽略大小写时，以及其他将“非完全相等”视为“相等”时，使用std::weak_ordering。     
**返回值**：
```cpp
std::weak_ordering::less         // 左操作数小于右操作数   
std::weak_ordering::equivalent   // 左操作数等于右操作数
std::weak_ordering::greater      // 左操作数大于右操作数
```
## 1.3. std::partial_ordering 
如果两个对象在某些情况下无法进行对比，例如:      
```cpp
double x = 1.0/0.0;  //InF
double y = 1.0/0.0;  //NaN
```
a和b的值无法进行比较，所以返回std::partial_ordering::unordered。          
**返回值**：    
```cpp
std::partial_ordering::less         // 左操作数小于右操作数   
std::partial_ordering::equivalent   // 左操作数等于右操作数
std::partial_ordering::greater      // 左操作数大于右操作数
std::partial_ordering::unordered    // 左操作数和右操作数不相等
```

# 2. 类型转换
std::strong_ordering可以隐式转换为std::weak_ordering，  
std::weak_ordering可以隐式转换为std::partial_ordering。

# 实现
对于简单类型，使用**=default**，让编译器自动生成比较逻辑，对于复杂类型需要手动实现比较逻辑。






