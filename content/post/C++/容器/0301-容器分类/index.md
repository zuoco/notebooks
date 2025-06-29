---
title: "第1节 - 什么是容器、容器分类"
description: 
date: 2021-09-04
comments: true
draft: false
categories:
    C++
---

# 1. 什么是容器
就是一些标准库中设计好数据结构，使用**类模板**实现，用于存储和管理数据，支持对象的添加、删除、索引、遍历等功能。

# 2. 容器分类
## 2.1. 序列容器
容器成员按严格的线性顺序排列，例如：array、vector、list、forward_list、deque、basic_string。     
## 2.2. 关联容器
就是“键值对”：    
set/map/multiset/multimap底层使用红黑树实现。   
unordered_set/unordered_map/unordered_multiset/unordered_multimap底层使用哈希表实现。
## 2.3. 适配器
对原有容器进行包装、扩展，得到一个新容器。      
## 2.4. 生成器
构造元素序列。      

# 3. 容器迭代器
指定容器中的一段区间，用于遍历容器中的元素。     
**常用迭代器**：
```
begin()：
end()：
```
```
rbegin()：
rend()：  # 指向第一个元素的前一个位置
```
```
cbegin()：
```
```
crbegin()：
crend()：
```
迭代器分为5类，支持的操作集合不同。

不是所有的容器都支持迭代器，支持迭代器的容器称为**range**。