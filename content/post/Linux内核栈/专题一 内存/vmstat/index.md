---
title: "vmstat"
description: 
date: 2025-05-21T22:01:50+08:00
math: 
license: 
hidden: false
comments: true
draft: false
categories:
  - Linux内核
  - Linux内存管理
---


# 安装vmstat
```bash
sudo dnf install sysstat  # Fedora
```
# 启用sysstat服务
```bash
sudo systemctl start sysstat
sudo systemctl enable sysstat
```
# 查看内存信息
```bash
sar -r 1 10
```
```bash
zcli@fedora:~/myBlog/notebooks$ sar -r 1 2
Linux 6.14.6-200.fc41.x86_64 (fedora) 	2025年05月21日 	_x86_64_	(16 CPU)

22时27分50秒 kbmemfree   kbavail kbmemused  %memused kbbuffers  kbcached  kbcommit   %commit  kbactive   kbinact   kbdirty
22时27分51秒  21377908  26044624   5275184     16.41      5844   5071508  24039676     59.29   6736456   2538556       800
22时27分52秒  21379140  26045856   5273952     16.40      5844   5071508  24039692     59.29   6736584   2538556       808
平均时间:  21378524  26045240   5274568     16.40      5844   5071508  24039684     59.29   6736520   2538556       804
```
字段含义：  
`kbmemfree（空闲物理内存）`   
系统当前未被使用的物理内存，直接可分配。   
`kbavail（可用内存）`   
包含空闲内存和可回收的缓存/缓冲（如文件缓存），反映实际可分配给进程的内存。   
`kbmemused（已用内存）`   
内核和进程已占用的物理内存（不包含缓存/缓冲）。  
`%memused（内存使用率）`     
物理内存使用率较低，系统内存压力小。  
`kbbuffers（缓冲区内存）`     
内核缓冲区用于临时存储磁盘块数据（如文件系统元数据）。  
`kbcached（缓存内存）`    
文件缓存，加速文件访问，可被快速回收供进程使用。   
`kbcommit（提交内存总量）`   
当前系统所有进程申请的内存总和（包括物理内存和交换空间）。   
`%commit（提交内存占比）`    
提交内存占总物理内存+交换空间的59%，无内存耗尽风险。   
`kbactive（活跃内存）`   
近期被频繁访问的内存页（如进程代码、数据）。   
`kbinact（非活跃内存）`   
长时间未使用的内存页，可被回收（如缓存旧文件）。   
`kbdirty（脏页）`   
需写回磁盘的修改过的内存页，数值低说明I/O压力小。   


# 提交内存


# 脏页


