---
title: "Python的C/C++绑定"
description: 
date: 2025-08-10
image: 
math: 
license: 
hidden: false
comments: true
draft: true
categories:
    - Python
---



# Python C API接口
![](cpython.svg)   
Python C API 是 Python 官方提供的 C 语言接口，允许 C/C++ 程序与 Python 解释器交互，CPython就是这套接口的实现。     
这套接口有两种用法：     
1. **在C/C++代码中调用Python代码**：在 C 代码里启动 Python 虚拟机、执行 Python 脚本、调用 Python 函数、使用 Python 对象，从而直接复用现成的 Python 生态。     
2. **在Python代码中调用使用C/C++编写扩展模块**：把性能关键或系统级代码写成 C/C++ 函数，编译成共享库（.so / .pyd），在 Python 里像普通模块一样 import。    



# 