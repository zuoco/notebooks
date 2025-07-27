---
title: "03 跨平台抽象层之 —— 网络模块"
description: 
date: 2024-09-28
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
    - "跨平台抽象层-C++"
---


- [1. 抽象基类](#1-抽象基类)
- [2. 平台实现](#2-平台实现)


# 1. **抽象基类**
需要对系统网络接口有一点了解，实际就是封装了常用的网络接口而已。  
```cpp
class IArchNetwork : public IInterface
{
public:

    // 地址族，需要在创建Socket时指定
    enum EAddressFamily
    {
        kUNKNOWN,
        kINET,     // IPV4
        kINET6,    // IPV6
    };

    // 协议类型
    enum ESocketType
    {
        kDGRAM,   // UDP
        kSTREAM   // TCP
    };


    // 异步I/O —— poll事件
    enum
    {
        kPOLLIN = 1,         // Socket 接收缓存区有数据可读。
        kPOLLOUT = 2,        // Socket 发送缓存区为空，可以发送数据。
        kPOLLERR = 4,        // 错误状态
        kPOLLNVAL = 8        // 无效socket
    };

    // 异步I/O ——　用于套接字事件轮询，监控多个套接字的状态变化。
    class PollEntry
    {
        public:
        ArchSocket m_socket;       // 要监听的套接字
        unsigned short m_events;   // 要监听的事件
        unsigned short m_revents;  // 实际监听到的事件
    };


    // 下面都是socket操作
    virtual ArchSocket newSocket(EAddressFamily, ESocketType) = 0; // 创建socket
    virtual ArchSocket copySocket(ArchSocket s) = 0;               
    virtual void closeSocket(ArchSocket s) = 0;                    // 关闭sokcet
    virtual void closeSocketForRead(ArchSocket s) = 0;             // 关闭读通道
    virtual void closeSocketForWrite(ArchSocket s) = 0;            // 关闭写通道

    // 连接网络
    virtual void bindSocket(ArchSocket s, ArchNetAddress addr) = 0;           // 绑定地址，服务端
    virtual void listenOnSocket(ArchSocket s) = 0;                            // 监听客户端连接，服务端
    virtual ArchSocket acceptSocket(ArchSocket s, ArchNetAddress *addr) = 0;  // 接收客户端连接，服务端
    virtual bool connectSocket(ArchSocket s, ArchNetAddress addr) = 0;        // 向服务端发起连接，客户端

    // 异步I/O
    virtual int pollSocket(PollEntry[], int num, double timeout) = 0;         // 使用poll轮训socket
    virtual void unblockPollSocket(ArchThread thread) = 0;                    // 解除轮询阻塞 

    virtual size_t readSocket(ArchSocket s, void *buf, size_t len) = 0;        // 读socket
    virtual size_t writeSocket(ArchSocket s, const void *buf, size_t len) = 0; // 写socket

    virtual void throwErrorOnSocket(ArchSocket s) = 0;
    virtual bool setNoDelayOnSocket(ArchSocket, bool noDelay) = 0;             // 启用/禁用Nagle算法
    virtual bool setReuseAddrOnSocket(ArchSocket, bool reuse) = 0;             // 地址重用选项

    virtual std::string getHostName() = 0;
    virtual ArchNetAddress newAnyAddr(EAddressFamily) = 0;                     // 创建通配地址
    virtual ArchNetAddress copyAddr(ArchNetAddress) = 0;                  
    virtual std::vector<ArchNetAddress> nameToAddr(const std::string &) = 0;   // 域名解析
    virtual void closeAddr(ArchNetAddress) = 0;                                
    virtual std::string addrToName(ArchNetAddress) = 0;
    virtual std::string addrToString(ArchNetAddress) = 0;
    virtual EAddressFamily getAddrFamily(ArchNetAddress) = 0;
    virtual void setAddrPort(ArchNetAddress, int port) = 0;            // 设置端口
    virtual int getAddrPort(ArchNetAddress) = 0;
    virtual bool isEqualAddr(ArchNetAddress, ArchNetAddress) = 0;      // 地址比较
    virtual bool isAnyAddr(ArchNetAddress addr) = 0;

    virtual void init() = 0;
};
```

# 2. **平台实现**
提供了Unix和Windows平台上的实现，就是将平台的系统调用封装了一下，具体就是系统调用的知识点，和跨平台主题无关就不细讲了。  
**Windows** 
```cpp
#define ARCH_NETWORK ArchNetworkWinsock

class ArchNetworkWinsock : public IArchNetwork
{
    // override 父类的纯虚函数
};
```

**Unix**
```cpp
#define ARCH_NETWORK ArchNetworkBSD

class ArchNetworkBSD : public IArchNetwork
{
    // override 父类的纯虚函数
};
```