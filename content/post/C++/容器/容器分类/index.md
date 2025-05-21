---
title: "什么是容器、容器分类"
description: 
date: 2025-05-04
image: 【哲风壁纸】冬季艺术-可爱雪景.png
math: 
license: 
comments: true
draft: false
categories:
    - C++20
    - C++容器
---


# 1. 什么是容器
**类模板**，用于存储和管理数据，支持对象的添加、删除、索引、遍历等功能。

# 2. 容器分类
**序列容器**：容器成员按严格的线性顺序排列，例如：array、vector、list、forward_list、deque、basic_string。     
**关联容器**：就是“键值对”。    
**适配器**：对原有容器进行包装、扩展，得到一个新容器。      
**生成器**：构造元素序列。      

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