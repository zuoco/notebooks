---
title: "第6节 - multiset与multimap"
description: 
date: 2021-09-06
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
    - C++
---

与set/map类似，但是允许重复键。   
```cpp
#include <iostream>
#include <set>

int main()
{
    std::multiset<int> s{3, 6, 3};
    for (auto i : s) 
    {
        std::cout << i << std::endl;
    }
}
```
代码输出：
```
3  
3  
6
```

# 1. 元素访问    
## 1.1. find()
返回首个查找到的元素。   
```cpp
int main()
{
    std::multiset<int> s{2, 3, 2};
    auto ptr = s.find(2);  // ptr指向第一个“2”
    ++ptr;                 // ptr指向第二个“2”
}
```

## 1.2. count()
返回一个“键”对应的“值”的个数。    


## 1.3. lower_bound()、 upper_bound()、 equal_range()
返回查找到区间。      
```cpp
int main()
{
    std::multiset<int> s{2, 3, 2};
    auto b = s.lower_bound(2);
    auto e = s.upper_bound(2);
    fir (auto ptr = b; ptr != e; ++ptr) 
    {
        std::cout << *ptr std::endl;
    }
}
```
或者：  
```cpp
int main()
{
    std::multiset<int> s{2, 3, 2};
    auto p = s.equal_range(2);
    fir (auto ptr = p.first; ptr != p.second; ++ptr) 
    {
        std::cout << *ptr std::endl;
    }
}
```
