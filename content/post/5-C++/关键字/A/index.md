---
title: "C++20关键字"
description: 
date: 2025-05-21T20:43:36+08:00
image: 
math: 
license: 
hidden: false
comments: true
draft: true
categories:
  C++
---

1. [1. explicit](#1-explicit)
2. [2. noexcept](#2-noexcept)
3. [3. constexpr](#3-constexpr)
4. [4. consteval](#4-consteval)
5. [5. final](#5-final)
6. [6.](#6)
7. [7. pragma once](#7-pragma-once)
8. [8. 内存对齐](#8-内存对齐)
  1. [8.1. aligans](#81-aligans)






# 1. explicit
explicit 关键字用于修饰类的构造函数，表明该构造函数是显式的，不能用于隐式类型转换，也就是说用户给的参数类型必须与构造函数的参数类型一致，否则会编译错误。   

# 2. noexcept
声明函数不会抛出异常。  

# 3. constexpr
编译期常量，在编译器初始化。   

# 4. consteval
这个函数每次调用都返回一个编译期常量。

# 5. final
在类声明后添加 final，表示该类不可作为基类：
```cpp
class Base final {  // 此类不能被继承
    // ...
};

// 尝试继承将导致编译错误
class Derived : public Base {  // ❌ 错误：Base 是 final 的
    // ...
};
```

# 6. 
```cpp

```

# 7. pragma once
```cpp
// 用于传统头文件
 #pragma once // 告诉编译器，此文件只包含一次，防止重复包含
```


concepts、[[nodiscard]]

# 8. 内存对齐
## 8.1. aligans
alignas 是 C++11 引入的标准方法，用于显式指定变量或类型的对齐方式。通过调整结构体成员的顺序，可以减少填充字节（padding），从而优化内存布局。虽然这与标准无关，但仍是实际开发中常用的方法。
```cpp
// 指定结构体对齐
struct alignas(32) Data {  // 32 字节对齐
    int x;
    double y;
    char z;
};

// 指定变量对齐
alignas(64) char buffer[1024];  // 64 字节对齐

// 检查对齐
static_assert(alignof(Data) == 32);  // 编译期验证
```
C++17中又引入了std::aligned_union，std::aligned_alloc等等来支持分配对齐内存。C++20 引入了 `[[nodiscard]]` 特性，可以用于标记返回对齐内存的函数，防止开发者忽略对齐检查，也可以使用编译器特性，但是不同的编译器使用方法不同。