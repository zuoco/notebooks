---
title: "第4节 - 关联容器之Set"
description: 
date: 2025-05-26T21:55:17+08:00
hidden: false
comments: true
draft: false
categories:
    现代C++
---

- [1. 初步认识](#1-初步认识)
- [2. 自定义比较函数](#2-自定义比较函数)
- [3. 迭代器](#3-迭代器)
- [4. 插入元素](#4-插入元素)
  - [4.1. insert与emplace](#41-insert与emplace)
  - [4.2. emplace\_hint](#42-emplace_hint)
- [5. 删除元素](#5-删除元素)
  - [5.1. erase](#51-erase)
- [6. 访问元素](#6-访问元素)
  - [6.1. contains](#61-contains)
  - [6.2. find](#62-find)
- [7. 修改元素](#7-修改元素)
  - [7.1. extract](#71-extract)


# 1. 初步认识
由于set底层是红黑树，因此set中的元素必须支持比较大小，对于自定义类型需要重载“<”，或者自定义一个比较函数并在创建set对象时指定。

```cpp
template<
    class Key,
    class Compare = std::less<Key>,
    class Allocator = std::allocator<Key>
> class set;
```
从类木板的声明来看，Compare是用于元素比较的函数，Allocator是分配器，这两个都有默认的参数，所以我们可以如下创建set对象：   
```cpp
# include <iostream>
# include <set>

int main()
{
    /**
     * 初始化时，元素顺序不重要，set会进行排序；
     * 元素必须支持比较大小，set会去除重复元素；
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

# 2. 自定义比较函数
```cpp
class Str
{
    int x;
}

bool MyCompare(const Str &a, const Str &b)
{
    return a.x < b.x;  //a<b时返回true
}

int main()
{
    std::set<Str, decltype(&MyCompare)> s{Str{Str{66}, Str{99}}, Compare};
}
```

# 3. 迭代器
set迭代器所指向的对象是const的，因此不能通过迭代器修改元素。

# 4. 插入元素
## 4.1. insert与emplace
```cpp
int main()
{
    std::set<Str, decltype(&MyCompare)> s{Str{Str{66}, Str{99}}, Compare};
    s.insert(Str{88}});
    s.emplace(77);
}
```
根据参数来看，insert是先构造一个Str对象,然后拷贝或者移动到s中，而emplace，直接在s中构造一个Str对象。

## 4.2. emplace_hint
```cpp
template< class... Args >
iterator emplace_hint( const_iterator hint, Args&&... args );
```
通过hint参数，告诉系统，新元素大约要插入到那里，参数"Args&&... args"用来构造新元素，这样能够减少比较次数，但是要求hint准确，如果hint不准确，可能导致效率更低。

# 5. 删除元素
## 5.1. erase
```cpp
size_type erase( const Key& key );                             // (constexpr since C++26)
iterator erase( const_iterator pos );                          // (since C++11)  (constexpr since C++26)
iterator erase( const_iterator first, const_iterator last );   // (since C++11)  (constexpr since C++26)
```
# 6. 访问元素
## 6.1. contains
```cpp
bool contains( const Key& key ) const;    // (since C++20)  (constexpr since C++26)

template< class K >
bool contains( const K& x ) const;        // (since C++20)   (constexpr since C++26)
```
如果包含就返回true，否则返回false。

## 6.2. find
```cpp
iterator find( const Key& key );                // (constexpr since C++26)
const_iterator find( const Key& key ) const;    // (constexpr since C++26)

template< class K >
iterator find( const K& x );                    // (since C++14)  (constexpr since C++26)

template< class K >
const_iterator find( const K& x ) const;       //  (since C++14)   (constexpr since C++26)
```
如果找到元素就返回该元素的迭代器，否则返回end()。


# 7. 修改元素
由于set迭代器是const的，因此不能通过迭代器修改元素。
## 7.1. extract
```cpp
node_type extract( const_iterator pos );    // (since C++17)    (constexpr since C++26)

node_type extract( const Key& k );          // (since C++17)    (constexpr since C++26)

template< class K >
node_type extract( K&& x );                 // (since C++23)    (constexpr since C++26)
```
使用方法：  
```cpp
#include <algorithm>
#include <iostream>
#include <string_view>
#include <set>
 
void print(std::string_view comment, const auto& data)
{
    std::cout << comment;
    for (auto datum : data)
        std::cout << ' ' << datum;
 
    std::cout << '\n';
}
 
int main()
{
    std::set<int> cont{1, 2, 3};
 
    print("Start:", cont);
 
    // Extract node handle and change key
    auto nh = cont.extract(1);
    nh.value() = 4;
 
    print("After extract and before insert:", cont);
 
    // Insert node handle back
    cont.insert(std::move(nh));
 
    print("End:", cont);
}
```
程序输出：   
```
Start: 1 2 3
After extract and before insert: 2 3
End: 2 3 4
```
显然，extract类似于先erase再insert，但是extract利用了已经创建好的对象，省去了创建对象的开销。
