---
title: "第1节 - ip命令"
description: 
date: 2025-06-07T23:43:14+08:00
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
   - "Linux内核"
---

# ip命令

`1. 查看网卡状态`   
```bash
ip a
```
命令输出：   
![](ip-a.bmp)  

`2. 启用网卡`    
```bash
sudo ip link set dev wlan0 up  # 将 "wlan0" 替换为实际的无线接口名称
```