---
title: "FreeCAD（05） — Python模块初始化"
description: 
date: 2025-08-11
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
  - FreeCAD
---


|||
|------|------|
|src/Main/MainCmd.cpp| CLI版本的入口程序|
|src/Main/MainGui.cpp| GUI版本的入口程序|
|src/Main/MainPy.cpp | 实现Python绑定的初始化函数PyMOD_INIT_FUNC(FreeCAD)，负责在Python环境中加载FreeCAD核心功能 |


MainPy.cpp中定义了如下函数： 
```cpp
PyMOD_INIT_FUNC(FreeCAD)
{
    // ......
    // 这个函数就FreeCAD Python绑定的模块初始化函数定义，责建立C++与Python的交互环境。  
    // ......
}
```
这个宏（PyMOD_INIT_FUNC）展开就是：  
```cpp
#define PyMOD_INIT_FUNC(name) PyMODINIT_FUNC PyInit_##name(void)
```
这个`PyMODINIT_FUNC`其实是 Python C/C++ 扩展模块中的一个宏，用于定义模块的初始化函数（即模块被导入时由 Python 解释器调用的入口函数）。它的作用是确保初始化函数的签名和链接方式符合 Python 解释器的要求，并适配不同平台和编译器的特性。在 Python 3 中，PyMODINIT_FUNC 隐式将函数返回类型声明为 `PyObject*`。宏替换后就是：
```cpp
PyObject* PyInit_FreeCAD(void)
{
    // ......

    return module; // PyObject*
}
```

在Python中导入FreeCAD模块：  
```py
import FreeCAD
print(FreeCAD.__file__)  # 输出模块路径，验证初始化结果
```

