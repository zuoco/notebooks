---
title: "迭代器"
description: 
date: 2023-07-12
image: 
math: 
license: 
hidden: false
comments: true
draft: true
categories:
  - C++
---

- [1. 迭代器分类](#1-迭代器分类)
- [2. 常规迭代器](#2-常规迭代器)
  - [2.1. 输入迭代器 InputIt](#21-输入迭代器-inputit)
  - [2.2. 输出迭代器 OutputIt](#22-输出迭代器-outputit)
  - [2.3. 前向迭代器 ForwardIt](#23-前向迭代器-forwardit)
  - [2.4. 双向迭代器 BidirIt](#24-双向迭代器-bidirit)
  - [2.5. 随机访问迭代器 RandomIt](#25-随机访问迭代器-randomit)
- [3. 特殊迭代器](#3-特殊迭代器)
  - [3.1. 插入迭代器](#31-插入迭代器)
    - [3.1.1. back\_insert\_iterator类模板](#311-back_insert_iterator类模板)
    - [3.1.2. insert\_iterator](#312-insert_iterator)



# 1. 迭代器分类
- **输入迭代器**&emsp;：&emsp;可读，可递增，典型应用为find算法。   
- **输出迭代器**&emsp;：&emsp;可写，可递增，典型用应用为copy算法。   
- **前向迭代器**&emsp;：&emsp;可读，可写，可递增，典型应用为算法如replace。     
- **双向迭代器**&emsp;：&emsp;可读，可写，可递增，可递减，典型应用为reverse算法。      
- **随机访问迭代器**&emsp;：&emsp;可读，可写，可递增一个整数(随机跳跃)，下标访问，迭代器距离，典型应用为sort算法。    

&emsp;&emsp;泛型算法可以根据迭代器类型的不同引入相应的优化。   
&emsp;&emsp;不管是哪一个类型，根源上，都是从同一个抽象基类型派生出来的。

# 2. 常规迭代器
## 2.1. 输入迭代器 InputIt
以std::find为例：   
```cpp
template< class InputIt, class T >
InputIt find( InputIt first, InputIt last, const T& value );
```
实现逻辑如下：  
```cpp
template<class InputIt, class T = typename std::iterator_traits<InputIt>::value_type>
constexpr InputIt find(InputIt first, InputIt last, const T& value)
{
    for (; first != last; ++first)
        if (*first == value)  // 只是访问，不改变
            return first;
 
    return last;
}
```

## 2.2. 输出迭代器 OutputIt
以std::copy为例：   
```cpp
template< class InputIt, class OutputIt >
OutputIt copy( InputIt first, InputIt last,
               OutputIt d_first );
```
实现逻辑如下：
```cpp
template<class InputIt, class OutputIt>
OutputIt copy(InputIt first, InputIt last, OutputIt d_first)
{   
    for (; first != last; (void)++first, (void)++d_first)
        *d_first = *first;  // 可以改变迭代器指向的对象的值
 
    return d_first;
}
```

## 2.3. 前向迭代器 ForwardIt   
```cpp
template< class ForwardIt, class T >
void replace( ForwardIt first, ForwardIt last,
              const T& old_value, const T& new_value );
```
实现案例如下： 
```cpp
template<class ForwardIt,
         class T = typename std::iterator_traits<ForwardIt>::value_type>
void replace(ForwardIt first, ForwardIt last, const T& old_value, const T& new_value)
{
    // 前向迭代器支持 “++” 操作
    for (; first != last; ++first)
        if (*first == old_value)
            *first = new_value;
}
```

## 2.4. 双向迭代器 BidirIt
```cpp
template< class BidirIt >
void reverse( BidirIt first, BidirIt last );
```
实现案例如下：  
```cpp
template<class BidirIt>
constexpr // since C++20
void reverse(BidirIt first, BidirIt last)
{
    // 翻转[frist, last)区间的元素。
    // 双向迭代器支持 “++”和“--”操作。     
    using iter_cat = typename std::iterator_traits<BidirIt>::iterator_category;

    // 进行条件编译
    if constexpr (std::is_base_of_v<std::random_access_iterator_tag, iter_cat>) // 判断iter_cat是否继承自std::random_access_iterator_tag
    {
        if (first == last)
            return;
 
        for (--last; first < last; (void)++first, --last)
            std::iter_swap(first, last);
    }
    else
        while (first != last && first != --last)
            std::iter_swap(first++, last);
}
```
&emsp;&emsp;上面代码涉及到std::random_access_iterator_tag类型，这里简单提一下，是 C++ 中用于标识随机访问迭代器的结构体，如果iter_cat是否继承自std::random_access_iterator_tag返回true,那么iter_cat就属于随机访问迭代器类型，随机访问迭代器支持“<”、“>”操作，算法根据迭代器类型不同来优化实现。   



## 2.5. 随机访问迭代器 RandomIt
&emsp;&emsp;随机访问迭代器支持的特性最多，可读，可写，可递增一个整数(随机跳跃)，下标访问，迭代器距离，支持<, <=, >, >=，但是不支持==。  
```cpp
template< class RandomIt >
void sort( RandomIt first, RandomIt last );
```
排序算法实现路线较多，不同的实现路线要求不同的访问元素的方式，所以就选用了随机访问迭代器。  





# 3. 特殊迭代器
- **插入迭代器** &emsp;：&emsp; insert_iterator、back_insert_iterator、front_insert_iterator。
- **流迭代器**  &emsp;：&emsp; istream_iterator、ostream_iterator。
- **反向迭代器**  &emsp;：&emsp; reverse_iterator。 
- **移动迭代器**  &emsp;：&emsp; move_iterator。     

## 3.1. 插入迭代器
insert_iterator、back_insert_iterator、front_insert_iterator是标准库提供的3个类模板。

### 3.1.1. back_insert_iterator类模板
```cpp
template< class Container >
class back_insert_iterator;
```
&emsp;&emsp;构成函数：  
```cpp
constexpr explicit back_insert_iterator( Container& c );   // (since C++20)
```
&emsp;&emsp;使用容器来初始化back_insert_iterator迭代器，所以这个迭代器对象与一个容器关联，使用该迭代器的“=”运算符可以将元素插入到容器的尾部。使用示例：   
```cpp
#include <iostream>
#include <iterator>
#include <deque>

int main()
{
    std::deque<int> q;  
    std::back_insert_iterator<std::deque<int>> it(q);

    for(int i = 0; i < 10; i++)
        it = i;  // 将元素插入到容器的尾部, q.push_back(i);

    for (auto& elem : q) std::cout << elem << ' ';
    std::cout << '\n';
}
```
&emsp;&emsp;一个容器要想使用insert_iterator迭代器， 就必须支持push_back()方法。   

### 3.1.2. insert_iterator
```cpp
template< class Container >
class insert_iterator;
```


