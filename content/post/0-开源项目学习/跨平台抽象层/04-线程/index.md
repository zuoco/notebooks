---
title: "04 跨平台抽象层之 —— 线程模块"
description: 
date: 2024-09-27
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
    - "跨平台抽象层-C++"
---


- [1. 抽象类型 IArchMultithread](#1-抽象类型-iarchmultithread)
- [2. 实现类](#2-实现类)

# 1. 抽象类型 IArchMultithread
IArchMultithread 是一个跨平台多线程抽象接口，继承自 IInterface，定义了线程、互斥锁和条件变量等核心操作。   
![](multi-thread.svg)   

```cpp
class IArchMultithread : public IInterface
{
public:
    // 线程任务函数的类型
    using ThreadFunc = void *(*)(void *);
    // 线程 ID
    using ThreadID = unsigned int;

    // 信号类型
    enum ESignal {
        kINTERRUPT,  // Ctrl+C
        kTERMINATE,  // Ctrl+Break
        kHANGUP,     // SIGHUP
        kUSER,       // SIGUSR2
        kNUM_SIGNALS
    };
    // 信号处理函数的类型
    using SignalFunc = void (*)(ESignal, void *userData);

    // 条件变量
    virtual ArchCond newCondVar() = 0;           // 创建条件变量
    virtual void closeCondVar(ArchCond) = 0;     // 销毁条件变量
    virtual void signalCondVar(ArchCond) = 0;    // 唤醒单个等待线程
    virtual void broadcastCondVar(ArchCond) = 0; // 唤醒单个等待线程
    virtual bool waitCondVar(ArchCond, ArchMutex, double timeout) = 0; // 带超时的条件等待 (取消点)

    // 互斥锁
    virtual ArchMutex newMutex() = 0;         // 创建互斥锁
    virtual void closeMutex(ArchMutex) = 0;   // 销毁互斥锁
    virtual void lockMutex(ArchMutex) = 0;    // 加锁
    virtual void unlockMutex(ArchMutex) = 0;  // 解锁

    // 线程对象操作
    virtual ArchThread newThread(ThreadFunc func, void *userData) = 0;  // 创建新线程
    virtual ArchThread newCurrentThread() = 0;                          // 返回一个表示当前（即调用）线程的对象的引用
    virtual ArchThread copyThread(ArchThread thread) = 0;               // 复制线程对象
    virtual void closeThread(ArchThread) = 0;                           // 释放线程引用
    virtual void cancelThread(ArchThread thread) = 0;                   // 请求线程取消
    virtual void setPriorityOfThread(ArchThread, int n) = 0;            // 设置线程优先级
    virtual void testCancelThread() = 0;                                // 显式取消点，应该是用于测试的
    virtual bool wait(ArchThread thread, double timeout) = 0;           // 等待线程结束 (取消点)
    virtual bool isSameThread(ArchThread, ArchThread) = 0;              // 线程对象比较
    virtual bool isExitedThread(ArchThread thread) = 0;                 // 检查线程是否退出
    virtual void *getResultOfThread(ArchThread thread) = 0;             // 获取线程退出码 (取消点)
    virtual ThreadID getIDOfThread(ArchThread thread) = 0;              // 获取线程ID（日志用）

    // 信号处理
    virtual void setSignalHandler(ESignal, SignalFunc func, void *userData) = 0;  // 设置信号处理函数
    virtual void raiseSignal(ESignal signal) = 0;                                 // 触发信号处理
};
```

# 2. 实现类
**Windows:**    
```cpp
#define ARCH_MULTITHREAD ArchMultithreadWindows

class ArchMultithreadWindows : public IArchMultithread
{
    // override 纯虚函数，就是封装Win的系统调用。
};
```

**Unix**   
```cpp
#define ARCH_MULTITHREAD ArchMultithreadPosix

class ArchMultithreadPosix : public IArchMultithread
{
        // override 纯虚函数，就是封装Posix标准线程接口。
};
```
