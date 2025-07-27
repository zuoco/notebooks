---
title: "06 跨平台抽象层之 —— 日志"
description: 
date: 2024-09-21
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
    - "跨平台抽象层-C++"
---


- [1. **抽象类型**](#1-抽象类型)
- [2. **实现**](#2-实现)


# 1. **抽象类型**
```cpp
class IArchLog : public IInterface
{
public:

    // 初始化日志系统
    virtual void openLog(const char *name) = 0;
    
    // 释放日志资源
    virtual void closeLog() = 0;
    
    // 可视化日志展示，实现GUI，CLI逻辑
    virtual void showLog(bool showIfEmpty) = 0;

    // 日志记录主入口
    virtual void writeLog(ELevel, const char *) = 0;

};
```

# 2. **实现**
**Windows**   
```cpp
#define ARCH_LOG ArchLogWindows

class ArchLogWindows : public IArchLog
{

};
```

**Unix**   
```cpp
#define ARCH_LOG ArchLogUnix

class ArchLogUnix : public IArchLog
{

};
```