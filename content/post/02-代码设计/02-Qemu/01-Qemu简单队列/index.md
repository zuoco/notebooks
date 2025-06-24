---
title: "Qemu简单队列 Simple Queue"
description: 
date: 2024-11-03
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
  - Qemu
  - 数据结构
---

- [1. 队列定义](#1-队列定义)
  - [1.1. 使用案例](#11-使用案例)
- [2. 队列操做](#2-队列操做)
  - [2.1. 队列初始化](#21-队列初始化)
  - [2.2. 插入节点](#22-插入节点)
    - [2.2.1. 插入到头部](#221-插入到头部)
    - [2.2.2. 插入到尾部](#222-插入到尾部)
    - [2.2.3. 插入到中间](#223-插入到中间)
- [3. 移除节点](#3-移除节点)
  - [3.1. 移除头部节点](#31-移除头部节点)
  - [3.2. 移除指定节点](#32-移除指定节点)
  - [3.3. 遍历](#33-遍历)
    - [3.3.1. 遍历队列](#331-遍历队列)
    - [3.3.2. 遍历队列（安全）](#332-遍历队列安全)
    - [3.3.3. 遍历宏使用方法](#333-遍历宏使用方法)
- [4. 完整代码](#4-完整代码)



# 1. 队列定义
```c
// 队列头
#define QSIMPLEQ_HEAD(name, type)                                       \
struct name {                                                           \
    struct type *sqh_first;    /* first element */                      \
    struct type **sqh_last;    /* addr of last next element */          \
}

// 初始化一个队列
#define QSIMPLEQ_HEAD_INITIALIZER(head)                                 \
    { NULL, &(head).sqh_first }

// 节点中的连接域，指向下一个节点
#define QSIMPLEQ_ENTRY(type)                                            \
struct {                                                                \
    struct type *sqe_next;    /* next element */                        \
}
```

## 1.1. 使用案例
&emsp;&emsp;下面的函数来源于qemu-8.2.2/qemu-img.c，该文件中实现了QEMU磁盘映像工具qemu-img的核心源代码，其中img_bitmap()函数用于磁盘持久化位图操作。QSIMPLEQ队列的基本操作在该函数中都有使用。  
```c
// 节点类型
typedef struct ImgBitmapAction {
    enum ImgBitmapAct act;
    const char *src; /* only used for merge */
    QSIMPLEQ_ENTRY(ImgBitmapAction) next;
} ImgBitmapAction;


static int img_bitmap(int argc, char **argv)
{
    // ......
    // 省略一堆代码
    // ......
    QSIMPLEQ_HEAD(, ImgBitmapAction) actions;  // 队列头
    ImgBitmapAction *act, *act_next;
    const char *op;
    int inactivate_ret;

    QSIMPLEQ_INIT(&actions);  //初始化队列

    for (;;) {

        // ......

        switch (c) {

        // ......

        case OPTION_ADD:
            act = g_new0(ImgBitmapAction, 1);
            act->act = BITMAP_ADD;
            QSIMPLEQ_INSERT_TAIL(&actions, act, next);  // 添加节点
            add = true;
            break;
  
        // ......

        }
    }

    // 判断队列是否为空
    if (QSIMPLEQ_EMPTY(&actions)) {
        error_report("Need at least one of --add, --remove, --clear, "
                     "--enable, --disable, or --merge");
        goto out;
    }
    
    // ......

    QSIMPLEQ_FOREACH_SAFE(act, &actions, next, act_next) {   // 遍历队列
        switch (act->act) {
        // ......
        }

        if (err) {
            // ......
        }
        g_free(act);
    }

    // ......

 out:
    // ......
    // ......
    return ret;
}
```

# 2. 队列操做
## 2.1. 队列初始化
```c
#define QSIMPLEQ_INIT(head) do {                                        \
    (head)->sqh_first = NULL;                                           \
    (head)->sqh_last = &(head)->sqh_first;                              \
} while (/*CONSTCOND*/0)
```
![](空队列.svg)  

## 2.2. 插入节点

### 2.2.1. 插入到头部
```c
#define QSIMPLEQ_INSERT_HEAD(head, elm, field) do {                     \
    if (((elm)->field.sqe_next = (head)->sqh_first) == NULL)            \
        (head)->sqh_last = &(elm)->field.sqe_next;                      \
    (head)->sqh_first = (elm);                                          \
} while (/*CONSTCOND*/0)
```
- elm: 待插入的节点。
- field: 节点的连接域。
- head: 队列的头。    

**1. 空队列插入节点**     
![](空队列插入节点.svg)   

**2. 非空队列插入节点**     
![](非空队列插入节点.svg)  


### 2.2.2. 插入到尾部
```c
#define QSIMPLEQ_INSERT_TAIL(head, elm, field) do {                     \
    (elm)->field.sqe_next = NULL;                                       \
    *(head)->sqh_last = (elm);                                          \
    (head)->sqh_last = &(elm)->field.sqe_next;                          \
} while (/*CONSTCOND*/0)
```
![](插入到尾部.svg)

### 2.2.3. 插入到中间
```c
#define QSIMPLEQ_INSERT_AFTER(head, listelm, elm, field) do {           \
    if (((elm)->field.sqe_next = (listelm)->field.sqe_next) == NULL)    \
        (head)->sqh_last = &(elm)->field.sqe_next;                      \
    (listelm)->field.sqe_next = (elm);                                  \
} while (/*CONSTCOND*/0)
```
- elm: 等待插入的节点。   
- listelm: 插入该节点后。      
- 中间插入的节点分为两种情况：
1. listelm是尾节点，和QSIMPLEQ_INSERT_TAIL差不多。         
1. listelm不是尾节点，插入过程如下：   
![](插入到中间.svg)   



# 3. 移除节点

## 3.1. 移除头部节点  
```c
#define QSIMPLEQ_REMOVE_HEAD(head, field) do {                          \
    typeof((head)->sqh_first) elm = (head)->sqh_first;                  \
    if (((head)->sqh_first = elm->field.sqe_next) == NULL)              \
        (head)->sqh_last = &(head)->sqh_first;                          \
    elm->field.sqe_next = NULL;                                         \
} while (/*CONSTCOND*/0)
```    

1. 队列中的有两个及以上节点：     
![](移除头部节点01.svg)       

2. 队列中只有一个节点：      
![](移除头部节点02.svg)   



## 3.2. 移除指定节点    
```c
#define QSIMPLEQ_REMOVE(head, elm, type, field) do {                    \
    if ((head)->sqh_first == (elm)) {                                   \
        QSIMPLEQ_REMOVE_HEAD((head), field);                            \
    } else {                                                            \
        struct type *curelm = (head)->sqh_first;                        \
        while (curelm->field.sqe_next != (elm))                         \
            curelm = curelm->field.sqe_next;                            \
        if ((curelm->field.sqe_next =                                   \
            curelm->field.sqe_next->field.sqe_next) == NULL)            \
                (head)->sqh_last = &(curelm)->field.sqe_next;           \
        (elm)->field.sqe_next = NULL;                                   \
    }                                                                   \
} while (/*CONSTCOND*/0)
```
- elm: 要删除的节点。
1. 如果elm是第一个节点，则使用QSIMPLEQ_REMOVE_HEAD进行删除。   

2. 如果elm是中间节点：        
![](移除指定节点01.svg)   

3. 如果elm是最后一个节点：   
![](移除指定节点02.svg)  


## 3.3. 遍历

### 3.3.1. 遍历队列
不删除节点时使用。   
```c
#define QSIMPLEQ_FOREACH(var, head, field)                              \
    for ((var) = ((head)->sqh_first);                                   \
        (var);                                                          \
        (var) = ((var)->field.sqe_next))
```

### 3.3.2. 遍历队列（安全）
遍历队列时可以安全删除节点。   
```c
#define QSIMPLEQ_FOREACH_SAFE(var, head, field, next)                   \
    for ((var) = ((head)->sqh_first);                                   \
        (var) && ((next = ((var)->field.sqe_next)), 1);                 \
        (var) = (next))
```

### 3.3.3. 遍历宏使用方法






















# 4. 完整代码
```c
/*
 * Simple queue definitions.
 */
#define QSIMPLEQ_HEAD(name, type)                                       \
struct name {                                                           \
    struct type *sqh_first;    /* first element */                      \
    struct type **sqh_last;    /* addr of last next element */          \
}

#define QSIMPLEQ_HEAD_INITIALIZER(head)                                 \
    { NULL, &(head).sqh_first }

#define QSIMPLEQ_ENTRY(type)                                            \
struct {                                                                \
    struct type *sqe_next;    /* next element */                        \
}

/*
 * Simple queue functions.
 */
#define QSIMPLEQ_INIT(head) do {                                        \
    (head)->sqh_first = NULL;                                           \
    (head)->sqh_last = &(head)->sqh_first;                              \
} while (/*CONSTCOND*/0)

#define QSIMPLEQ_INSERT_HEAD(head, elm, field) do {                     \
    if (((elm)->field.sqe_next = (head)->sqh_first) == NULL)            \
        (head)->sqh_last = &(elm)->field.sqe_next;                      \
    (head)->sqh_first = (elm);                                          \
} while (/*CONSTCOND*/0)

#define QSIMPLEQ_INSERT_TAIL(head, elm, field) do {                     \
    (elm)->field.sqe_next = NULL;                                       \
    *(head)->sqh_last = (elm);                                          \
    (head)->sqh_last = &(elm)->field.sqe_next;                          \
} while (/*CONSTCOND*/0)

#define QSIMPLEQ_INSERT_AFTER(head, listelm, elm, field) do {           \
    if (((elm)->field.sqe_next = (listelm)->field.sqe_next) == NULL)    \
        (head)->sqh_last = &(elm)->field.sqe_next;                      \
    (listelm)->field.sqe_next = (elm);                                  \
} while (/*CONSTCOND*/0)

#define QSIMPLEQ_REMOVE_HEAD(head, field) do {                          \
    typeof((head)->sqh_first) elm = (head)->sqh_first;                  \
    if (((head)->sqh_first = elm->field.sqe_next) == NULL)              \
        (head)->sqh_last = &(head)->sqh_first;                          \
    elm->field.sqe_next = NULL;                                         \
} while (/*CONSTCOND*/0)

#define QSIMPLEQ_SPLIT_AFTER(head, elm, field, removed) do {            \
    QSIMPLEQ_INIT(removed);                                             \
    if (((removed)->sqh_first = (head)->sqh_first) != NULL) {           \
        if (((head)->sqh_first = (elm)->field.sqe_next) == NULL) {      \
            (head)->sqh_last = &(head)->sqh_first;                      \
        }                                                               \
        (removed)->sqh_last = &(elm)->field.sqe_next;                   \
        (elm)->field.sqe_next = NULL;                                   \
    }                                                                   \
} while (/*CONSTCOND*/0)

#define QSIMPLEQ_REMOVE(head, elm, type, field) do {                    \
    if ((head)->sqh_first == (elm)) {                                   \
        QSIMPLEQ_REMOVE_HEAD((head), field);                            \
    } else {                                                            \
        struct type *curelm = (head)->sqh_first;                        \
        while (curelm->field.sqe_next != (elm))                         \
            curelm = curelm->field.sqe_next;                            \
        if ((curelm->field.sqe_next =                                   \
            curelm->field.sqe_next->field.sqe_next) == NULL)            \
                (head)->sqh_last = &(curelm)->field.sqe_next;           \
        (elm)->field.sqe_next = NULL;                                   \
    }                                                                   \
} while (/*CONSTCOND*/0)

#define QSIMPLEQ_FOREACH(var, head, field)                              \
    for ((var) = ((head)->sqh_first);                                   \
        (var);                                                          \
        (var) = ((var)->field.sqe_next))

#define QSIMPLEQ_FOREACH_SAFE(var, head, field, next)                   \
    for ((var) = ((head)->sqh_first);                                   \
        (var) && ((next = ((var)->field.sqe_next)), 1);                 \
        (var) = (next))

#define QSIMPLEQ_CONCAT(head1, head2) do {                              \
    if (!QSIMPLEQ_EMPTY((head2))) {                                     \
        *(head1)->sqh_last = (head2)->sqh_first;                        \
        (head1)->sqh_last = (head2)->sqh_last;                          \
        QSIMPLEQ_INIT((head2));                                         \
    }                                                                   \
} while (/*CONSTCOND*/0)

#define QSIMPLEQ_PREPEND(head1, head2) do {                             \
    if (!QSIMPLEQ_EMPTY((head2))) {                                     \
        *(head2)->sqh_last = (head1)->sqh_first;                        \
        (head1)->sqh_first = (head2)->sqh_first;                          \
        QSIMPLEQ_INIT((head2));                                         \
    }                                                                   \
} while (/*CONSTCOND*/0)

#define QSIMPLEQ_LAST(head, type, field)                                \
    (QSIMPLEQ_EMPTY((head)) ?                                           \
        NULL :                                                          \
            ((struct type *)(void *)                                    \
        ((char *)((head)->sqh_last) - offsetof(struct type, field))))

/*
 * Simple queue access methods.
 */
#define QSIMPLEQ_EMPTY_ATOMIC(head) \
    (qatomic_read(&((head)->sqh_first)) == NULL)
#define QSIMPLEQ_EMPTY(head)        ((head)->sqh_first == NULL)
#define QSIMPLEQ_FIRST(head)        ((head)->sqh_first)
#define QSIMPLEQ_NEXT(elm, field)   ((elm)->field.sqe_next)
```
