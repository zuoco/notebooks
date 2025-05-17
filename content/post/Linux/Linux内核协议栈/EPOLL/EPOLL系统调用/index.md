---
title: "EPOLL系统调用"
description: 
date: 2025-05-12T20:16:48+08:00
image: 【哲风壁纸】夜景-夜空-月亮.png
math: 
license: 
hidden: false
comments: true
draft: false
categories:
  - Linux
  - EPOLL
---

# 1. EPOLL介绍
EPOLL是Linux特有的I/O复用函数，它把用户关心的“文件描述符”放在内核里面一个`事件表`中，也就是说EPOLL需要一个“文件描述符”来标识内核中的这个事件表。另外EPOLL有两种工作模式：`水平触发`(Level Triggered，LT)和`边缘触发`(Edge Triggered，ET)，LT模式是EPOLL默认的工作模式，EPOLL和异步，非阻塞结合使用。  

# 2. EPOLL使用
## 2.1. 创建EPOLL对象
```c
#include <sys/epoll.h>
int epoll_create(int size); // size参数没有意义。
```
返回一个文件描述符，代表内核事件表。

## 2.2. 操作内核事件表
```c
#include <sys/epoll.h>
int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event); //成功返回0，失败返回-1，并设置errno。  
```
epfd：内核事件表文件描述符。  
op：操作类型。   
fd：要操作的文件描述符。   
event：指向 epoll_event 结构体的指针，用于指定要添加、修改或删除的事件。  

其中，op(操作类型)有三种：  
- EPOLL_CTL_ADD：往内核事件表中添加事件。
- EPOLL_CTL_MOD：修改事件。
- EPOLL_CTL_DEL：删除事件。

其中，event(关心的事件)的类型是`struct epoll_event`，结构体定义如下：
```c
struct epoll_event {
    __uint32_t events; // 事件
    epoll_data_t data; // 事件携带的用户数据
}
```
**events** 是一个位图，有EPOLLIN、EPOLLOUT、EPOLLET、EPOLLONESHOT。   
**data** 是`epoll_data_t`类型，它是一个联合体，定义如下：  
```c
typedef union epoll_data {
    void *ptr;
    int fd;
    uint32_t u32;
    uint64_t u64;
} epoll_data_t;
```
由于这是一个联合体，所以这四个成员，我们只能使用其中的一个。

## 2.3. 等待事件
```c
#include <sys/epoll.h>
int epoll_wait(int epfd, struct epoll_event *events, int maxevents, int timeout);
```
epoll_wait在一段超时时间内，等待一组文件描述符上的事件，返回就绪的文件描述符的数量。  
- timeout: 参数指定等待的时间，单位是毫秒。如果timeout为-1，则表示无限等待。  
- maxevents: 参数指定最多等待的事件数，必须大于0。  

epoll_wait检测到事件，就会将所有的就绪事件从内核事件表拷贝到events数组中，并返回就绪事件的数量，也就是说event中的事件都是就绪的。   

# 3. ET和LT模式对比
对于Socket读事件，只要Socket上的数据没有读完，就会一直触发EPOLL事件，而对于ET模式，Socket上每来一次数据就会触发一次`EPOLLIN`事件，如果上一次触发后，未将 socket 上的数据读完，也不会再触发，除非再新来一次数据。对于 socket 写事件，如果 socket 的 TCP 窗口一直不饱和，会一直触发 EPOLLOUT 事件；而对于边缘模式，只会触发一次，除非 TCP 窗口由不饱和变成饱和再一次变成不饱和，才会再次触发 `EPOLLOUT`事件。根据以上分析来看，如果采用ET模式就必须在收到事件后一次性将数据读取完，但如果采用默认模式，就可以根据业务每次收取固定的字节数，多次收取，显然相对于默认的LT模式，ET模式能够减少同一个事件被触发的次数，效率比LT模式高。        
## 3.1. 问题
多线程场景下，我们使用ET模式监听一个Socket上的读事件，当数据到达时触发EPOLLIN事件，我们在一个独立线程(或进程)中读取该Socket上的数据，但是我们还没有读取完，该Socket又有新数据到达，此时另一个线程(或进程)被唤醒来读取该Socket上的数据，那么就有两个线程(进程)同时操作同一个Socket，这样好吗，这样不好，但是如何解决呢？此时就该EPOLLONESHOT出场了。

# 4. EPOLLONESHOT事件
显然，`一次性事件`，就是触发以后，需要手动重新注册，给文件描述符注册EPOLLONESHOT事件，就可以保证同一时间只有一个人在使用。  
```c
// 重新注册EPOLLONESHOT事件
void reset_oneshot(int epollfd, int fd)
{
    epoll_event event;
    event.data.fd = fd;
    event.events = EPOLLIN | EPOLLET | EPOLLONESHOT;
    epoll_ctl(epollfd, EPOLL_CTL_MOD, fd, &event);
}
```

`注意：`
listening socket是不能使用EPOLLONESHOT的，否则后续的客户段连接请求就不会再触发listening socket的EPOLLIN事件了。


# 5. 其他小代码
`1. 将文件描述符设置为非阻塞`  
```c
int setnonblocking(int fd)
{
    int old_option = fcntl(fd, F_GETFL);
    int new_option = old_option | O_NONBLOCK;
    fcntl(fd, F_SETFL, new_option);
    return old_option;
}
```

`2. 事件注册`  
```c
void addfd(int epollfd, int fd, bool enable_et)
{
    epoll_event event;
    event.data.fd = fd;
    event.events = EPOLLIN;
    if(enable_et)
    {
        event.events |= EPOLLET;  //启用ET模式
    }
    epoll_ctl(epollfd, EPOLL_CTL_ADD, fd, &event);
    setnonblocking(fd);
}
```

`3. 判断数据是否读取完了`  
```c
// 非阻塞模式
if ((errno == EAGAIN) || (errno == EWOULDBLOCK))
{
    // 数据读取完了
}
```