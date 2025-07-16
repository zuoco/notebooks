---
title: "07 跨平台抽象层之 —— 休眠"
description: 
date: 2024-09-17
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
    - "跨平台抽象层-C++"
---

- [1. 抽象类型](#1-抽象类型)
- [2. 实现类型](#2-实现类型)
    - [2.1. Windows](#21-windows)
    - [2.2. Unix](#22-unix)


# 1. 抽象类型
跨平台线程休眠接口，核心目标是提供精确的、可移植的线程阻塞控制。  
```cpp
class IArchSleep : public IInterface
{
public:
    // 使调用线程进入休眠状态指定时长
    virtual void sleep(double timeout) = 0;
};
```

# 2. 实现类型
## 2.1. Windows  
```cpp
#define ARCH_SLEEP ArchSleepWindows

class ArchSleepWindows : public IArchSleep
{
public:
  ArchSleepWindows() = default;
  ~ArchSleepWindows() override = default;

  void sleep(double timeout) override;
};
```
Win平台休眠逻辑： 
```cpp
void ArchSleepWindows::sleep(double timeout)
{
  ARCH->testCancelThread();
  if (timeout < 0.0) {    // 若超时时间<0则立即返回。
    return;
  }

  // 检测线程取消事件，保证休眠中的线程可以及时响应其他线程发出的取消请求（如用户主动终止操作），正常终止线程。
  ArchMultithreadWindows *mt = ArchMultithreadWindows::getInstance();  // 获取Windows多线程实例
  if (mt != nullptr) {
    HANDLE cancelEvent = mt->getCancelEventForCurrentThread();         // 尝试获取线程取消事件
    WaitForSingleObject(cancelEvent, (DWORD)(1000.0 * timeout));
    if (timeout == 0.0) {
      Sleep(0);
    }
  } else {
    Sleep((DWORD)(1000.0 * timeout));   // 没有取消事件，通过Sleep实现基础休眠
  }
  ARCH->testCancelThread();
}
```

## 2.2. Unix   
```cpp
#define ARCH_SLEEP ArchSleepUnix

class ArchSleepUnix : public IArchSleep
{
public:
  ArchSleepUnix() = default;
  ~ArchSleepUnix() override = default;

  void sleep(double timeout) override;
};

```
Unix平台休眠逻辑：  
```cpp
void ArchSleepUnix::sleep(double timeout)
{
  ARCH->testCancelThread(); 
  if (timeout < 0.0) {
    return;
  }

#if HAVE_NANOSLEEP
    // 优先使用nanosleep系统调用实现高精度休眠。
    struct timespec t;
    t.tv_sec = (long)timeout;
    t.tv_nsec = (long)(1.0e+9 * (timeout - (double)t.tv_sec));

    while (nanosleep(&t, &t) < 0)
        ARCH->testCancelThread();
#else
    // 当nanosleep不可用时，使用 “select+时间计算” 模拟休眠。
    double startTime = ARCH->time();
    double timeLeft = timeout;
    while (timeLeft > 0.0) {
        struct timeval timeout2;
        timeout2.tv_sec = static_cast<int>(timeLeft);
        timeout2.tv_usec = static_cast<int>(1.0e+6 * (timeLeft - timeout2.tv_sec));
        select(
            (SELECT_TYPE_ARG1)0, SELECT_TYPE_ARG234 nullptr, SELECT_TYPE_ARG234 nullptr, SELECT_TYPE_ARG234 nullptr,
            SELECT_TYPE_ARG5 & timeout2
        );
        ARCH->testCancelThread();
        timeLeft = timeout - (ARCH->time() - startTime);
    }
#endif
}
```

