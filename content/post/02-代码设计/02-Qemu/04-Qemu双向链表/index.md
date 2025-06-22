---
title: "Qemu双向链表"
description: 
date: 2024-10-27
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
  - 数据结构
---

- [1. 双向链表定义](#1-双向链表定义)
- [2. 链表操作](#2-链表操作)
  - [2.1. 链表初始化](#21-链表初始化)
  - [2.2. 插入操作](#22-插入操作)
    - [2.2.1. 链表头部插入新节点](#221-链表头部插入新节点)
    - [2.2.2. 指定位置插入元素](#222-指定位置插入元素)
  - [2.3. 交换两个双链表的全部内容](#23-交换两个双链表的全部内容)
- [3. 使用示例](#3-使用示例)
  - [3.1. 节点结构](#31-节点结构)
  - [3.2. 链表头结构](#32-链表头结构)


# 1. 双向链表定义
   
```c
/* qemu-8.2.2/include/qemu/queue.h */


/*
 * 链表头： 包含一个指向首元节点的指针
 */
#define QLIST_HEAD(name, type)                                          \
struct name {                                                           \
        struct type *lh_first;  /* first element */                     \
}


/*
 * 链表初始化。
 * 首元节点指针初始化为NULL。
 */
#define QLIST_HEAD_INITIALIZER(head)                                    \
        { NULL }


/*
 * 链表节点的连接域。
 * 节点类型的结构体中包含此结构体，用于连接链表。
 * 每个节点通过这个这个字段来连接前后的节点。
 */
#define QLIST_ENTRY(type)                                               \
struct {                                                                \
        struct type *le_next;   /* 指向下一个节点 */                      \
        struct type **le_prev;  /* 前一个节点的指针的地址 */  \
}
```

看如下代码：  
```c
// block.c
static QLIST_HEAD(, BlockDriver) bdrv_drivers =
    QLIST_HEAD_INITIALIZER(bdrv_drivers);
```
上面是一个块设备驱动相关的链表，使用QLIST_HEAD宏函数创建，宏替换后如下：  
```c
static struct { 
        struct BlockDriver *lh_first;
} bdrv_drivers = { NULL };
```

# 2. 链表操作
qemu-8.2.2/include/qemu/queue.h 

## 2.1. 链表初始化
```c
#define QLIST_INIT(head) do {                                           \
        (head)->lh_first = NULL;                                        \
} while (/*CONSTCOND*/0)
```
原子化操作，使用do { ... } while(0)结构确保宏作为单个语句执行。  


## 2.2. 插入操作
### 2.2.1. 链表头部插入新节点
```c
#define QLIST_INSERT_HEAD(head, elm, field) do {                        \
        if (((elm)->field.le_next = (head)->lh_first) != NULL)          \
                (head)->lh_first->field.le_prev = &(elm)->field.le_next;\
        (head)->lh_first = (elm);                                       \
        (elm)->field.le_prev = &(head)->lh_first;                       \
} while (/*CONSTCOND*/0)
```
**解释：**  
- field： 就是使用宏`QLIST_ENTRY(type)`创建的链表节点连接结构，是节点中的连接域字段，该字段内部包含prev和next。   

**代码逐行解释：**   




### 2.2.2. 指定位置插入元素





## 2.3. 交换两个双链表的全部内容


# 3. 使用示例


## 3.1. 节点结构
```c
// thread-pool.h
typedef struct ThreadPoolElement ThreadPoolElement;

// thread-pool.c
struct ThreadPoolElement {
    BlockAIOCB common;
    ThreadPool *pool;
    ThreadPoolFunc *func;
    void *arg;

    enum ThreadState state;
    int ret;

    QTAILQ_ENTRY(ThreadPoolElement) reqs;

    /* 
     * 节点的连接区域，每个节点通过该域连接前后相邻节点。
     */
    QLIST_ENTRY(ThreadPoolElement) all;
};
```

## 3.2. 链表头结构

```c
BlockAIOCB *thread_pool_submit_aio(ThreadPoolFunc *func, void *arg,
                                   BlockCompletionFunc *cb, void *opaque)
{
    ThreadPoolElement *req;
    // ......
    // 省略一堆代码

    /*
     * 链表头部保存在pool实例中。 
     */
    ThreadPool *pool = aio_get_thread_pool(ctx);
    // .....
    QLIST_INSERT_HEAD(&pool->head, req, all);
    // ......
}
```
下面我们来看这个`ThreadPool *pool`是如何保存头部的：  
```c
// thread-pool.h
typedef struct ThreadPool ThreadPool;

// thread-pool.c
struct ThreadPool {
    AioContext *ctx;
    QEMUBH *completion_bh;
    QemuMutex lock;
    QemuCond worker_stopped;
    QemuCond request_cond;
    QEMUBH *new_thread_bh;

    /*
     * 使用QLIST_HEAD宏创建一个链表，链表节点中所保存的元素类型为ThreadPoolElement。
     */
    QLIST_HEAD(, ThreadPoolElement) head;

    QTAILQ_HEAD(, ThreadPoolElement) request_list;
    int cur_threads;
    int idle_threads;
    int new_threads;
    int pending_threads; 
    int min_threads;
    int max_threads;
};
```
