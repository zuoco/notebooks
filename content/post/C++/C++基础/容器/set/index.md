---
title: "关联容器之Set"
description: 
date: 2025-05-26T21:55:17+08:00
hidden: false
comments: true
draft: false
categories:
    - C++20
    - C++容器
---

# 1. set
由于set底层是红黑树，因此set中的元素必须支持比较大小，对于自定义类型需要重载“<”，或者自定义一个比较函数并在创建set对象时指定。
```cpp
template<
    class Key,
    class Compare = std::less<Key>,
    class Allocator = std::allocator<Key>
> class set;
```
从模板类型的声明看，Compare是元素比较函数，Allocator是分配器，这两个都有默认参数，所以我们可以如下创建set对象：   
```cpp
# include <iostream>
# include <set>

inr main()
{
    /**
     * 初始化时，元素顺序不重要
     * 元素必须支持比较大小
     * 如果有重复，只保留一个
     */
    std::set<int> s{66, 99, 88};
    for (auto ptr = s.begin(); ptr != s.end(); ++ptr)
    {
        std::cout << *ptr << std::endl;
    }
}
```
代码输出:  
```
66
99
88
```
由于set底层使用是红黑树，并且代码输出结果为升序，因此set遍历方式为`中序遍历`。   


# 2. 插入元素
## 2.1. insert




## 2.2. emplace

## 2.3. emplace_hint

# 3. 删除元素
## 3.1. erase

# 4. 访问元素
## 4.1. find

## 4.2. contains

# 5. 修改元素
## 5.1. extract


# 6. 迭代器
set迭代器所指向的对象是const的，不能通过迭代器修改元素。