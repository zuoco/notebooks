---
title: "08 跨平台抽象层之 —— 时间"
description: 
date: 2024-09-16
image: 
math: 
license: 
hidden: false
comments: true
draft: flase
categories:
    - "跨平台抽象层-C++"
---

- [1. **抽象类**](#1-抽象类)
- [2. **实现类**](#2-实现类)


# 1. **抽象类**
跨平台高精度时间获取接口，提供统一、高精度的时间基准，用于性能分析、超时控制等场景。  
```cpp
class IArchTime : public IInterface
{
public:
    virtual double time() = 0;
};
```

# 2. **实现类**
**Windows**    
```cpp
class ArchTimeWindows : public IArchTime
{
public:
    ArchTimeWindows();
    ~ArchTimeWindows() override;

    double time() override;
};
```

**Unix**   
```cpp
#define ARCH_TIME ArchTimeUnix

class ArchTimeUnix : public IArchTime
{
public:
    ArchTimeUnix() = default;
    ~ArchTimeUnix() override = default;

    double time() override;
};
```
