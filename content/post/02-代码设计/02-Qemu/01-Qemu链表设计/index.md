---
title: "Qemu链表设计"
description: 
date: 2025-06-16T23:08:01+08:00
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
  - 代码设计
---


# 1. Qemu链表链表设计
QTAILQ 是 QEMU 实现的一种 尾队列（Tail Queue） 数据结构，代码位于include/qemu/queue.h  
## 1.1. 第一部分: 节点定义  
```c
// include/qemu/queue.h
typedef struct QTailQLink {
    void *tql_next;
    struct QTailQLink *tql_prev;
} QTailQLink;
```
这段代码定义了一个通用的双向链表节点结构，通过 tql_next 和 tql_prev 可以向前或向后遍历链表。   

## 1.2. 第二部分: 链表定义 
### 1.2.1. 链表头结构设计
```c
#define QTAILQ_HEAD(name, type)                                         \
union name {                                                            \
        struct type *tqh_first;       /* first element */               \
        QTailQLink tqh_circ;          /* link for circular backwards list */ \
}
```
- tqh_circ 是指向链表尾部的指针，用于实现 O(1) 时间复杂度的尾插操作。   


```c
#define QTAILQ_HEAD_INITIALIZER(head)                                   \
        { .tqh_circ = { NULL, &(head).tqh_circ } }
```


```c
#define QTAILQ_ENTRY(type)                                              \
union {                                                                 \
        struct type *tqe_next;        /* next element */                \
        QTailQLink tqe_circ;          /* link for circular backwards list */ \
}
```

在链表节点中同时支持普通链表和循环链表操作。   

# 2. 链表使用
```c
// util/module.c
typedef struct ModuleEntry
{
    void (*init)(void);     // 类型注册函数，就是type_init(<class_name>_register_types);中的<class_name>_register_types
    QTAILQ_ENTRY(ModuleEntry) node;
    module_init_type type;  // 所属模块类型，类型系统就是MODULE_INIT_QOM
} ModuleEntry;
```

重点需要理解的就是`QTAILQ_ENTRY(ModuleEntry) node;`，将宏函数展开就是:   
```c
union {
        struct type *tqe_next;
        QTailQLink tqe_circ;
} node;
```