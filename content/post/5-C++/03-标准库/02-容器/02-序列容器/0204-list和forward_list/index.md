---
title: "序列容器之 list 和 forward_list"
description: 
date: 2023-04-18
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
    - "C++"
    - "C++ STL"
---



# 1. std::list
[std::list](https://en.cppreference.com/w/cpp/container/list.html)，底层是双向链表形式的。  
```cpp
// Defined in header <list>
template<
    class T,
    class Allocator = std::allocator<T>
> class list;
```

# 2. 迭代器
支持双向迭代器。   


# 3. 创建std::list容器对象
```cpp
std::list<int> values;

std::list<int> values(10); // 创建一个有 10 个元素的 list 容器，元素值都为 0

std::list<int> values(10, 5); // 创建一个有 10 个元素的 list 容器，元素值都为 5

std::list<int> values{1, 2, 3, 4, 5};


// 使用他容器或数组中数据创建 list 容器
int a[] = { 1,2,3,4,5 };
std::list<int> values(a, a+5);

std::array<int, 5>arr{ 11,12,13,14,15 };
std::list<int>values(arr.begin()+2, arr.end());
```


# 4. 成员函数
## 4.1. 访问
front()、back()、迭代器。  


## 4.2. 插入
push_front()、push_back()、emplace_front()、emplace_back()、emplace()、insert()、splice()   

```cpp
// 将另一个链表（other）中的元素 移动到当前链表的指定位置（pos）之前
void splice( const_iterator pos, list& other );
void splice( const_iterator pos, list&& other );

void splice( const_iterator pos, list& other, const_iterator it );
void splice( const_iterator pos, list&& other, const_iterator it );

void splice( const_iterator pos, list& other, const_iterator first, const_iterator last );
void splice( const_iterator pos, list&& other, const_iterator first, const_iterator last );
```

##  4.3. 删除
pop_front()： 	删除位于 list 容器头部的一个元素。
pop_back()： 	删除位于 list 容器尾部的一个元素。
erase()：	该成员函数既可以删除 list 容器中指定位置处的元素，也可以删除容器中某个区域内的多个元素。
clear()：	删除 list 容器存储的所有元素。
remove(val)： 	删除容器中所有等于 val 的元素。
unique():	删除容器中相邻的重复元素，只保留一份。
remove_if(): 	删除容器中满足条件的元素。  


# forward_list
单链表。   
