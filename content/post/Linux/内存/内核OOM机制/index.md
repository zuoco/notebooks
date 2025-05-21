---
title: "内核OOM机制"
description: 
date: 2025-05-21T20:53:24+08:00
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
  - Linux内核
  - Linux内存管理
---

# 1. 什么是OOM
在内存不足时，内存管理系统会回收内核中可以释放的内存，当实在没有内存可用的时候，就会进入OOM（Out of Memory）状态，内存管理系统会执行OOM Killer，依据一定的规则杀死一些进程来释放内存，对于个人PC来说，这都不是个事儿，但对于服务器，有可能就会将重要的业务进程给干死了，所以有的服务器会将sysctl的vm.panic_on_omc参数设为1，当发生OOM时强制关闭系统，如果设置为0(默认)，在OOM时就会运行OOM Killer。   

# OOM Killer机制
杀死进程的依据......


