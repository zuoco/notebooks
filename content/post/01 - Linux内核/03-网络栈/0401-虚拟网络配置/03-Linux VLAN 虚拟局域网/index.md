---
title: "第3节 - Linux VLAN 虚拟局域网"
description: 
date: 2025-06-07T18:55:53+08:00
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
 - Linux内核
---

# Linux VLAN
将网络划分为多个逻辑网络，使得不同的VLAN可以在同一物理网段上实现隔离通信，是一种基于`网络层`的虚拟局域网技术，是通过内核的网络子系统实现的，当一个VLAN数据包进入系统时，内核会根据数据包中的VLAN标记信息，将数据包转发到相应的VLAN接口或者物理接口上。linux中有两种方法实现VLAN：`内核模块`、`VLAN交换机`，内核模块方式更加灵活，需要更多配置工作，VLAN更易于配置和管理，但是会带来硬件成本。
## linux中VLAN的实现方式
`内核模块方式`  
在内核中加载VLAN模块来实现，


`VLAN交换机`
通过软件模拟交换机。
