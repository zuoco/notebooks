---
title: "02 跨平台抽象层之 —— Arch单例类型"
description: 
date: 2024-09-29
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
    - "跨平台抽象层-C++"
---


- [1. 代码实现](#1-代码实现)
    - [1.1. Arch类的定义](#11-arch类的定义)
    - [1.2. Arch类的实现](#12-arch类的实现)
    - [1.3. 跨平台](#13-跨平台)
- [2. 使用](#2-使用)



## 1. 代码实现
### 1.1. Arch类的定义
**Arch.h**  
```cpp
#define ARCH (Arch::getInstance())  // 访问单例

class Arch : public ARCH_DAEMON,
             public ARCH_LOG,
             public ARCH_MULTITHREAD,
             public ARCH_NETWORK,
             public ARCH_SLEEP,
             public ArchString,
             public ARCH_TIME
{
public:
  /*
   * 构造与析构函数，按理说应该是私有的，可能是这部分代码仅仅只是本项目使用，而本项目的开发人员是熟悉代码设计细节的。
   */
  Arch();
  ~Arch() override = default;

  /*
   * 应该禁用拷贝构造、移动构成、复制操作符。
   */

  void init() override;

  static Arch *getInstance();  // 单例的全局访问接口

private:
  /*
   *  静态私有实例，由该类自行实例化，并向系统提供这个实例。
   *  可以使用 unique_ptr，std::once_flag替换
   */ 
  static Arch *s_instance; 
};
```  
单例模式好像是有什么饿汉模式，懒汉模式，但是该项目实现的单例两种都不是，一般饿汉模式下，静态成员变量（instance）是在程序启动时（全局静态对象初始化阶段）初始化的，懒汉模式是在第一次getInstance()时初始化的，但是该项目的单例是在创建单例类型的实例时初始化。虽然有些问题，但也符合该项目的需求，这个项目设计该单例主要为了给业务层提供无关平台的系统调用接口，整个程序共享该单例，只要在程序启动时创建并初始化单例对象即可。  

### 1.2. Arch类的实现
**Arch.cpp**  
```cpp
#include "arch/Arch.h"

#if SYSAPI_WIN32
#include "arch/win32/ArchMiscWindows.h"
#endif

Arch *Arch::s_instance = nullptr;

// 初始化 Arch 实例，并设置单例指针
Arch::Arch()
{
  assert(s_instance == nullptr);  // 仅允许程序启动时创建。
  s_instance = this;
}


// 初始化Arch中的模块，这里只初始化了网络模块
void Arch::init()
{
  ARCH_NETWORK::init();
#if SYSAPI_WIN32
  ArchMiscWindows::init();
#endif
}

// 访问单例
Arch *Arch::getInstance()
{
  assert(s_instance != nullptr);
  return s_instance;
}
```

### 1.3. 跨平台实现
上面的Arch类继承了多个基类（如ARCH_DAEMON、ARCH_LOG等），这些基类分别提供了不同的功能模块（如守护进程、日志记录、多线程支持等）。每一个宏就是一个模块类型，定义在特定头文件中。在编译时，根据平台的不同来包含不同的头文件，并进行宏替换：   
**Arch.h**  
```cpp
#if SYSAPI_WIN32

#include "arch/win32/ArchDaemonWindows.h"
#include "arch/win32/ArchLogWindows.h"
#include "arch/win32/ArchMultithreadWindows.h"
#include "arch/win32/ArchNetworkWinsock.h"
#include "arch/win32/ArchSleepWindows.h"
#include "arch/win32/ArchTimeWindows.h"

#elif SYSAPI_UNIX

#include "arch/unix/ArchDaemonUnix.h"
#include "arch/unix/ArchLogUnix.h"
#include "arch/unix/ArchNetworkBSD.h"
#include "arch/unix/ArchSleepUnix.h"
#include "arch/unix/ArchTimeUnix.h"

#if HAVE_PTHREAD
#include "arch/unix/ArchMultithreadPosix.h"
#endif

#endif
```
以ARCH_NetWork为例， Windows平台下：  
```cpp
// ArchNetworkWinsock.h
#define ARCH_NETWORK ArchNetworkWinsock
```   
Unix系统：  
```cpp
// ArchNetWorkBSD.h
#define ARCH_NETWORK ArchNetworkBSD
```
对于每一个功能模块，后续会以单独的章节介绍。   


## 2. 使用
```cpp
int main(int argc, char **argv)
{
    // ...
    Arch arch;  
    arch.init(); 
    // ...
}
```
在程序中，使用`ARCH`宏访问取单例对象。
