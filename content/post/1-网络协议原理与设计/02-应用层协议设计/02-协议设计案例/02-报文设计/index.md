---
title: "网络协议设计 — 3 — 报文设计"
description: 
date: 2024-11-10
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
    - 网络协议设计
---

- [1. 报文结构](#1-报文结构)
  - [1.1. 报文头部](#11-报文头部)
  - [1.2. 类型头部](#12-类型头部)
  - [1.3. 状态](#13-状态)



# 1. 报文结构
![](报文结构.svg)

------

## 1.1. 报文头部
&emsp;&emsp;所有的报文都以特定的头部开始，例如：  
```c
struct header {
    uint32_t type;     // 报文类型，决定了类型头部的结构。
    uint32_t length;   // 类型头部长度 + 数据长度。
    uint64_t id;       // 报文编号，用于通信双方标识报文。
}
```
&emsp;&emsp;不一定完全就是上面这些字段，根据实际需求设计。

------

## 1.2. 类型头部
&emsp;&emsp;类型头部的样式就会多一点了，解析器就是通过类型头部识别报文的类型，以此将数据部分交给对应的处理程序。一般使用一个枚举声明所有的报文类型：   
```c
enum {
    /* 控制报文 */
    XXX_HELLO；
    // 控制类型2
    // ......

    /* 数据报文 */
    // 数据类型1
    // 数据类型2
    // ......
};
```
   
&emsp;&emsp;声明了报文类型后，就要声明每个类型的类型头部结构体了，但是具体有那些类型，就是要结合业务了，这里只作一个演示。不过一般要有一个`Hello`报文，用于在建立连接时沟通双方的版本信息等等。尤其是协议已经更新了多个版本时，要确保通信双方的版本能够兼容。   
&emsp;&emsp;下面就以Hello报文为例：  
```c
#define ATTR_PACKED __attribute__ ((__packed__))

struct hello_header {
    char     version[64];         // 版本信息等等。
    uint32_t capabilities[0];     // 变长数组，每一个数组成员就是一个bitmask，表示协议当前版本支持的功能特性。
} ATTR_PACKED；
```
&emsp;&emsp;对于Hello报文，它没有数据部分，所以拿到整个报文后，除了报文头部和类型头部的versoin字段，剩下的都是capabilities字段。  
&emsp;&emsp;对于一些特定业务可能需要connect、disconnect等操作，例如连接远程的控制设备，所以要定基于实际业务义声明对应的类型头部：      
```c
struct connect_header {
        // ... ...
} ATTR_PACKED;

struct disconnect_header {
        // ... ...
} ATTR_PACKED;
```

&emsp;&emsp;可以粗浅的理解为： `Hello` -> `connect` -> `控制报文/数据报文` -> `disconnect`。   

------

## 1.3. 状态
所有的响应报文都要包含`状态`字段，所以也要协议声明的重要部分：   
```c
enum {
    xxx_success,
    xxx_inval,
    xxx_timeout,
    // ......
    // 根据实际的业务场景，定义状态，以反映业务请求的执行状态。
    // ......
};
```

