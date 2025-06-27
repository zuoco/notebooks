---
title: "Linux直接渲染管理-DRM"
description: 
date: 2024-12-13
image: 
math: 
license: 
hidden: false
comments: true
draft: false
---

- [1. DRM](#1-drm)
- [2. DRM核心概念](#2-drm核心概念)
  - [2.1. 内存管理和显存](#21-内存管理和显存)
  - [2.2. 命令队列和GPU任务调度](#22-命令队列和gpu任务调度)
  - [2.3. 同步机制](#23-同步机制)
  - [2.4. DRM和用户控件交互](#24-drm和用户控件交互)



# 1. DRM
&emsp;&emsp;在Linux系统上，图形栈包括从应用层序、窗口系统（XWindows、Wayland）、DRM到最终的硬件多个层次，每一层都有其特定职能。其中DRM内核子系统负责管理图形硬件资源，提供用户空间程序与GPU之间的接口
。






&emsp;&emsp;DRM(Direct Rendering Manager)是Linux内核中的图形设备管理模块，用于管理图形设备，如显卡、显示器、鼠标、键盘等。DRM模块提供了一种机制，使得应用程序可以安全地访问和控制图形设备，而不需要直接访问设备寄存器。


# 2. DRM核心概念


## 2.1. 内存管理和显存


## 2.2. 命令队列和GPU任务调度


## 2.3. 同步机制


## 2.4. DRM和用户控件交互

