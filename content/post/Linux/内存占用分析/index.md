---
title: "内存占用分析"
description: 
date: 2025-05-20T00:18:27+08:00
image: AAA.jpg
math: 
license: 
hidden: false
comments: true
draft: false
categories:
  - Linux内核
  - 内存占用分析
---

# 1. 动态分析
就是我们面对着正在运行的Linux系统，然后通过一些命令，查看正在运行的进程占用内存的情况。
## 1.1. ps命令查看内存使用量大的进程   
```bash
ps -eo pid,comm,%mem --sort -%mem | head -n 10
```
参数解释：
``` 
-e：显示所有进程。
-o：显示制定的列，pid(进程ID),comm(进程名),%mem(进程使用的内存百分比)
--sort -%mem：按照内存使用百分比降序排序。
head -n 10：显示前10行。
```

# 2. 内核的OOM机制
OOM（Out of Memory）机制是为了应对系统内存耗尽的情况而设计的一种保护机制。当系统内存资源紧张到无法为新的内存分配请求提供足够的空间时，OOM Killer会被触发，依据一定的规则杀掉一些进程来释放内存。   
```bash
zcli@fedora:/proc/79800$ ls | grep oom
oom_adj          
oom_score
oom_score_adj
```

# 太晚了，明天再整理



oom_score_adj: 这是一个可以调整的参数，范围从-1000到1000，允许用户或管理员通过修改特定进程的oom_score_adj值来影响其oom_score。例如，将某个重要服务的oom_score_adj设置为-1000可以确保它不会被OOM Killer选中。
oom_adj: 
oom_score: 这是一个只读的参数，表示当前进程的oom_score。这个值是OOM Killer根据进程的内存使用情况计算得到的，它越小，表示越有可能被OOM Killer选中。






内核文件：　/proc/sys/vm/oom_kill_allocating_task，　写入1表示优先杀死导致内存不足的任务，而不是选择评分最高的任务。　　　


oom_score: 
/proc/<pid>/oom_adj 或 /proc/<pid>/oom_score_adj


检查内存碎片花：
cat /proc/buddyinfo


内存压缩功能：　
echo 1 > /proc/sys/vm/compact_memory


使用 sar 或 vmstat 工具监控系统的内存使用变化：
vmstat 1 10　　　　＃　研究一下命令的输出
sar -r 1 10　　　　＃　研究一下命令的输出


Slab 分配器：　研究slabtop命令使用。




/proc/buddyinfo认识：　
/proc/buddyinfo 文件展示了系统内存分配的情况，具体来说是每个内存区域（zones）内不同大小的内存块（以2的幂次方大小为单位）的可用数量。这对于理解系统的内存碎片状况非常有用。
在 Linux 系统中，"物理内存"被划分为不同的节点（Node），每个节点又进一步划分为多个区域（Zone）。常见的区域有：
    DMA：直接内存访问区，通常用于旧硬件，地址范围较低。
    Normal：普通内存区，大多数现代硬件使用的内存。
    HighMem：高内存区，在32位系统上用于扩展可寻址内存范围，对于64位系统，这个区域可能不存在。
　


/proc/vmstat文件中：
nr_free_pages 718778　　　＃　当前系统中空闲（未分配）的物理页面总数。每个页面的大小通常是 4KB，但这也取决于具体的系统架构。
pgalloc_dma 0
pgalloc_normal 10593690  # 从普通内存区（Normal zone）成功分配的物理页面总数
pgalloc_high   72600886

pgsteal_dma 0
pgsteal_normal 26597  # 回收的页面数量s
pgsteal_high 0        # 为 0，说明无法从 HighMem 回收页面


虽然内存压缩（整理）没有失败，但仍然存在内存分配延迟。
compact_stall 1   # 表示由于内存整理操作而暂停分配器（allocator stalls）的次数。当内核需要分配一个较大的连续内存块但无法立即找到足够的连续页面时，它会触发内存整理操作来尝试重组内存，使得更多的连续内存块可用。如果这个过程花费的时间超过了内核设定的阈值，就会记录一次 compact_stall。
compact_fail 0   # 表示内存整理失败的次数。即使进行了内存整理，有时也可能无法找到足够大的连续内存块来满足分配请求。
compact_success 0  # 表示内存整理成功的次数。即通过内存整理操作成功创建了足够大的连续内存块，从而满足了分配请求。


allocstall=10 　　＃　　表示有10次因内存分配失败而进入 stall 状态的情况。



／proc／meminfo文件：　　
MemTotal:        4005176 kB　　　　＃　总的物理内存
MemFree:         2875924 kB　　　　＃　剩余内存
Buffers:           40576 kB　　　　＃　
Cached:           500332 kB
SwapCached:            0 kB
# 3. 32位系统
HighTotal:       3143004 kB　　＃ 加上LowTotal等于MemTotal, 在64位系统中，这一部分主要是为了兼容性保留的概念，在实际应用中意义不大。
HighFree:        2140940 kB    # 加上LowFree等于MemFree
LowTotal:         862172 kB    # 标识低端内存区域的总容量为 862,172 KB（约 842 MB）。低端内存可以直接映射到内核地址空间，在32位系统中尤为重要。
LowFree:          734984 kB

高低内存划分: 
由于32位系统的地址空间限制，通常会将内存划分为“低端内存”（Low Memory）和“高端内存”（High Memory）。   
这种划分主要是因为32位系统能够直接映射到内核空间的物理内存有限（通常是前1GB或前896MB，具体取决于内核配置）。  
在你的32位系统中，总共有约 4GB 的物理内存，其中大约 2.87 GB 是空闲的（MemFree）。
系统中有约 3.14 GB 被视为高端内存，剩下的约 862 MB 为低端内存。
大部分的空闲内存位于高端内存区域（HighFree 为约 2.14 GB），但也有相当一部分（约 735 MB）是在更易于访问的低端内存区域（LowFree）。
缓存和缓冲区占用了约 540 MB 的内存（Buffers 加上 Cached），这有助于加快文件和块设备的访问速度。


/proc/sys/vm/min_free_kbytes:
文件中的值定义了在系统中应始终保持空闲的最小内存量（以KB为单位）。这个参数对于防止内存完全耗尽，确保系统即使在高负载下也能平稳运行至关重要。当可用内存降至 min_free_kbytes 设置的阈值之下时，Linux 内核的内存回收机制会主动尝试释放内存，例如通过回收缓存或交换出不活跃的页面到磁盘。


强制进行内存压缩以合并碎片：
echo 1 > /proc/sys/vm/compact_memory



