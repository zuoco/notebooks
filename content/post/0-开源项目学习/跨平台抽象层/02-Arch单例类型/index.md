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


- [1. **Arch类的定义**](#1-arch类的定义)
- [2. **Arch类的实现**](#2-arch类的实现)
- [3. **跨平台实现**](#3-跨平台实现)
- [4. **使用**](#4-使用)




# 1. **Arch类的定义**

**Arch.h**  
```cpp
// 提供一个宏，用于单例的全局访问
#define ARCH (Arch::getInstance())  


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
   * 构造与析构函数，按理说应该是private，可能因为这部分代码仅仅只是本项目使用，而本项目的开发人员应该是熟悉项目的代码设计细节的，所以不太关注细节。
   */
  Arch();
  ~Arch() override = default;

  /*
   * 应该禁用拷贝构造、移动构成、复制操作符等等。
   */
  void init() override; // 创建单例后调用

  static Arch *getInstance(); 

private:
  /*
   *  静态私有实例，由该类自行实例化，并向系统提供这个实例。
   *  也可以使用 unique_ptr，std::once_flag
   */ 
  static Arch *s_instance; 
};
```  
单例模式好像是有什么饿汉模式，懒汉模式，但是该项目实现的单例两种都不是，一般饿汉模式下，静态成员变量（instance）是在程序加载时（全局静态对象初始化阶段）初始化的，懒汉模式是在第一次getInstance()时初始化的，但是该项目的单例是在创建单例类型的实例时初始化。虽然有些问题，但也符合该项目的需求，这个项目设计该单例主要为了给业务层提供无关平台的系统调用接口，整个程序共享该单例，在进入main后马上就创建并初始化单例对象。  

# 2. **Arch类的实现**
**Arch.cpp**  
```cpp
#include "arch/Arch.h"

#if SYSAPI_WIN32
#include "arch/win32/ArchMiscWindows.h"
#endif

Arch *Arch::s_instance = nullptr;

/*
 * 虽然构造函数在定义中没有私有，但是这里使用了assert(s_instance == nullptr); 也能保证只有一个实例存在。
 */
Arch::Arch()
{
  assert(s_instance == nullptr);
  s_instance = this;
}


/* 初始化Arch中的模块，这里只初始化了网络模块 */
void Arch::init()
{
  ARCH_NETWORK::init();
#if SYSAPI_WIN32
  ArchMiscWindows::init();
#endif
}

/* 访问单例 */
Arch *Arch::getInstance()
{
  assert(s_instance != nullptr);
  return s_instance;
}
```

# 3. **跨平台实现**
上面的Arch类继承了多个基类（如ARCH_DAEMON、ARCH_LOG等），这些基类分别提供了不同的功能模块（如守护进程、日志记录、多线程支持等）。每一个宏就是一个模块类型，定义在特定头文件中。在编译时，根据平台的不同来包含不同的头文件，并进行宏替换：   
**Arch.h**  
```cpp
#if SYSAPI_WIN32   // Win平台实现代码

#include "arch/win32/ArchDaemonWindows.h"
#include "arch/win32/ArchLogWindows.h"
#include "arch/win32/ArchMultithreadWindows.h"
#include "arch/win32/ArchNetworkWinsock.h"
#include "arch/win32/ArchSleepWindows.h"
#include "arch/win32/ArchTimeWindows.h"

#elif SYSAPI_UNIX  // Unix平台实现

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

以ARCH_NetWork为例， 如果是Windows平台，条件编译后，ArchNetworkWinsock.h头文件被包含到：  
```cpp
// 此时Arch类继承ARCH_NETWORK，就是继承了Win平台的实现
#define ARCH_NETWORK ArchNetworkWinsock
```   
对于Unix系统，条件编译后，ArchNetWorkBSD.h头文件被包含：  
```cpp
// 此时Arch类继承ARCH_NETWORK，就是继承了Unix平台的实现
#define ARCH_NETWORK ArchNetworkBSD
```
对于每一个功能模块，后续会以单独的章节介绍。   

# 4. **使用**
这个单例封装了系统调用，在程序启动时就要创建，以便于程序使用。  
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
