---
title: "内存分析常用工具、内存相关内核日志"
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
  - 内存
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
## 1.2. free命令
```
zcli@fedora:~$ free -h
               total        used        free      shared  buff/cache   available
Mem:            30Gi       5.4Gi        21Gi        79Mi       4.4Gi        25Gi
Swap:          8.0Gi          0B       8.0Gi
```

```
zcli@fedora:~$ free -m
               total        used        free      shared  buff/cache   available
Mem:           31400        5554       21799          86        4564       25845
Swap:           8191           0        8191
```

# 2. 内核的OOM机制
OOM（Out of Memory）机制是为了应对系统内存耗尽的情况而设计的一种保护机制。当系统内存资源紧张到无法为新的内存分配请求提供足够的空间时，OOM Killer会被触发，依据一定的规则杀掉一些进程来释放内存。  
1. `查询OOM事件： `   
```bash
$ dmesg | grep -i "out of memory"
```
2. `oom_score分数： `(后面会文章单独分析oom killer机制)
```bash
zcli@fedora:/proc/11991$ ls -al | grep oom
-rw-r--r--.   1 root root 0  5月20日 22:34 oom_adj         # 新的内核中已经弃用。
-r--r--r--.   1 root root 0  5月20日 22:34 oom_score       # 只读文件，保存了当前进程的oom_score分数。
-rw-r--r--.   1 root root 0  5月20日 22:34 oom_score_adj   # 用户自定义的oom_score_adj值，用于干预oom_score分数的计算。
```
# 3. 检查内存碎片化：
相关信息位于文件中：
```bash
/proc/buddyinfo
/proc/meminfo
```
## 3.1. buddyinfo文件
看一下文件内容：
```
zcli@fedora:~$ cat /proc/buddyinfo
Node 0, zone      DMA      0      0      0      0      0      0      0      0      1      1      2 
Node 0, zone    DMA32      8     11      6      7      7      7     10      8      7      9    573 
Node 0, zone   Normal   1958    592    249    207    133     32     98     87     36     11   4422 
```
每一行的格式为：  
```bash
Node <node_id>, zone <zone_name> <order0> <order1> ... <order10>
```
Node 0：表示单个 NUMA 节点（无 NUMA 架构时仅一个节点）。     
zone <zone_name>：内存区域类型，常见类型包括：     
  - DMA：直接内存访问（DMA）区域，用于 32 位设备的内存访问（地址范围有限）。    
  - DMA32：扩展的 32 位 DMA 区域（地址范围比 DMA 更广）。    
  - Normal：普通内存区域，用于大多数内存分配。     
<orderN>：表示阶（order）为 N 的空闲内存块数量(N从0开始)。每个阶的内存块大小为 2^N * PAGE_SIZE（通常 PAGE_SIZE = 4KB）    

对于32位的系统: 
```bash 
  DMA
  Normal
  HighMem  # 高内存区，在32位系统上用于扩展可寻址内存范围，对于64位系统，这个区域可能不存在。
```

`碎片化判断`: `低阶空闲块越多，高阶阶空闲块越少`代表内存碎片化越严重。

## /proc/vmstat文件
部分字段：  
```bash
nr_free_pages 718778　　　   #　当前系统中空闲（未分配）的物理页面总数。每个页面的大小通常是 4KB，但这也取决于具体的系统架构。

pgalloc_dma 0
pgalloc_normal 10593690     # 从普通内存区（Normal zone）成功分配的物理页面总数
pgalloc_high   72600886

pgsteal_dma 0
pgsteal_normal 26597        # 回收的页面数量
pgsteal_high 0              # 为 0，说明没有从 HighMem 回收页面

compact_stall 1  # 表示由内存整理操作,而暂停分配器（allocator stalls）的次数。
                 # 当内核需要分配一个较大的连续内存块但无法立即找到足够的连续页面时，它会触发内存整理操作来尝试重组内存，使得更多的连续内存块可用。
                 # 如果这个过程花费的时间超过了内核设定的阈值，就会记录一次 compact_stall。
compact_fail 0     # 表示内存整理失败的次数。即使进行了内存整理，有时也可能无法找到足够大的连续内存块来满足分配请求。
compact_success 0  # 表示内存整理成功的次数。即通过内存整理操作成功创建了足够大的连续内存块，从而满足了分配请求。
                   # 既没有失败，也没有成功，可能是没有开启内存整理功能。

allocstall_dma 0     # 表示有几次因内存分配失败而进入 stall 状态的情况。
allocstall_dma32 0
allocstall_normal 0
allocstall_movable 0
allocstall_device 0
```

## /proc/meminfo
```bash　
MemTotal:        4005176 kB　　　　 # 总的物理内存
MemFree:         2875924 kB　　　   # 剩余内存
Buffers:           40576 kB　　　　 　
Cached:           500332 kB
SwapCached:            0 kB
# 6. 32位系统
HighTotal:       3143004 kB　　 # 加上LowTotal等于MemTotal, 在64位系统中，这一部分主要是为了兼容性保留的概念，在实际应用中意义不大。
HighFree:        2140940 kB    # 加上LowFree等于MemFree
LowTotal:         862172 kB    # 标识低端内存区域的总容量为 862,172 KB（约 842 MB）。低端内存可以直接映射到内核地址空间，在32位系统中尤为重要。
LowFree:          734984 kB
```

高低内存划分: 
由于32位系统的地址空间限制，通常会将内存划分为“低端内存”（Low Memory）和“高端内存”（High Memory）。这种划分主要是因为32位系统能够直接映射到内核空间的物理内存有限（通常是前1GB或前896MB，具体取决于内核配置）。 在你的32位系统中，总共有约 4GB 的物理内存，其中大约 2.87 GB 是空闲的（MemFree）。系统中有约 3.14 GB 被视为高端内存，剩下的约 862 MB 为低端内存。大部分的空闲内存位于高端内存区域（HighFree 为约 2.14 GB），但也有相当一部分（约 735 MB）是在更易于访问的低端内存区域（LowFree）。缓存和缓冲区占用了约 540 MB 的内存（Buffers 加上 Cached），这有助于加快文件和块设备的访问速度。   


## /proc/sys/vm/min_free_kbytes
文件中的值定义了在系统中应始终保持空闲的最小内存量（以KB为单位）。这个参数对于防止内存完全耗尽，确保系统即使在高负载下也能平稳运行至关重要。当可用内存降至 min_free_kbytes 设置的阈值之下时，Linux 内核的内存回收机制会主动尝试释放内存，例如通过回收缓存或交换出不活跃的页面到磁盘。




# 4. 内存压缩（整理）
如果内存碎片化严重，可以通过调整内存压缩（整理）的方式来解决，。
```
root@fedora:~# ls -al /proc/sys/vm/compact_memory
--w-------. 1 root root 0  5月20日 22:44 /proc/sys/vm/compact_memory # 写入1或0
```
0： 禁止内存整理功能（默认值）。
1： 启用内存压缩，并触发一次内存整理操作。

`可以手动触发内存整理操作(临时措施)：  `   
```bash
echo 1 > /proc/sys/vm/compact_memory
```
或者:   
```bash
sudo susctl vm.compact_memory=1
```
`永久措施:  `   
将下面内容写入/etc/sysctl.conf文件中：   
```bash
vm.compact_memory=1
```
然后执行：
```bash
sudo sysctl -p
```

`但是要注意`:     
1. 内存压缩是一个同步、阻塞式的操作，会增加CPU和IO开销，不建议在生产环境频繁使用。    
2. 内存压缩需要启用内核**CONFIG_COMPACTION**选项，可以通过以下命令查看该功能是否启用：  
```bash
grep CONFIG_COMPACTION /boot/config-$(uname -r) # 输出CONFIG_COMPACTION=y表示启用了该功能。
```







# 5. 太晚了，明天再整理


内核文件：　/proc/sys/vm/oom_kill_allocating_task，　写入1表示优先杀死导致内存不足的任务，而不是选择评分最高的任务。　　　



##

使用 sar 或 vmstat 工具监控系统的内存使用变化：
vmstat 1 10　　　　＃　研究一下命令的输出
sar -r 1 10　　　　＃　研究一下命令的输出

## 5.3. 
Slab 分配器：　研究slabtop命令使用。





