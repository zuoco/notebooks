---
title: "FreeCAD（05） — Python模块初始化"
description: 
date: 2025-08-09
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
|src/Main/MainPy.cpp | Python模块（FreeCAD）的初始化函数，负责在Python环境中加载FreeCAD核心功能 |
|src/Main/FreeCADGuiPy.cpp| Python模块（FreeCADGui）的初始化函数，负责在Python环境中加载FreeCADGui核心功能 |


- [1. 模块初始化](#1-模块初始化)
- [2. Python模块初始化流程](#2-python模块初始化流程)
- [3. FreeCADGui模块](#3-freecadgui模块)



# 1. 模块初始化
FreeCAD定义了宏——PyMOD_INIT_FUNC来辅助实现Python模块的初始化函数，我们以FreeCAD模块为例，MainPy.cpp中定义了如下函数： 
```cpp
PyMOD_INIT_FUNC(FreeCAD)
{
    // ......
    // 这个函数负责Python模块的初始化，建立C++与Python的交互环境。  
    // ......
}
```

这个宏（PyMOD_INIT_FUNC）展开就是：  
```cpp
#define PyMOD_INIT_FUNC(name) PyMODINIT_FUNC PyInit_##name(void)
```
这个`PyMODINIT_FUNC`其实是 Python C/C++ 扩展模块中的一个宏，在 Python 3 中，PyMODINIT_FUNC 就是 `PyObject*`。宏替换后就是：
```cpp
PyObject* PyInit_FreeCAD(void)
{
    // ......

    return module; // 返回一个 PyObject* 类型的对象
}
```

在Python中导入FreeCAD模块：  
```py
import FreeCAD
print(FreeCAD.__file__)  # 输出模块路径，验证初始化结果
```
所以，我们复制 “`PyMOD_INIT_FUNC(`” 到FreeCAD工程源码中搜索，就能看到都有那些模块。   



# 2. Python模块初始化流程
当 Python 执行 import module_name 时，解释器会查找名为 PyInit_module_name 的函数，过 PyInit_ 函数，可以将 C/C++ 的函数、类或变量暴露给 Python 使用。   
**PyInit_ 的调用流程：**    
- Python 导入模块：当执行 import example 时，Python 解释器会动态加载 .so（Linux/macOS）或 .pyd（Windows）文件。  
- 查找 PyInit_ 函数：解释器查找 PyInit_example 函数（模块名决定）。  
- 调用 PyInit_ 函数：该函数初始化模块对象并返回。  
- 绑定功能：模块对象中定义的方法和属性被注册到 Python 环境中。  


# 3. FreeCADGui模块
 
Python模块的注册函数中
```cpp
PyMOD_INIT_FUNC(FreeCADGui)
{
    try {
        Base::Interpreter().loadModule("FreeCAD");           // 加载FreeCAD模块， Base::Interpreter()返回 Python 解释器单例
        App::Application::Config()["AppIcon"] = "freecad";
        App::Application::Config()["SplashScreen"] = "freecadsplash";
        App::Application::Config()["CopyrightInfo"] = "\xc2\xa9 Juergen Riegel, Werner Mayer, Yorik van Havre and others 2001-2024\n";
        App::Application::Config()["LicenseInfo"] = "FreeCAD is free and open-source software licensed under the terms of LGPL2+ license.\n";
        App::Application::Config()["CreditsInfo"] = "FreeCAD wouldn't be possible without FreeCAD community.\n";

        // it's possible that the GUI is already initialized when the Gui version of the executable
        // is started in command mode
        if (Base::Type::fromName("Gui::BaseView").isBad()) {
            Gui::Application::initApplication();
        }
        static struct PyModuleDef FreeCADGuiModuleDef = {PyModuleDef_HEAD_INIT,   // 这个参数是固定的。  
                                                         "FreeCADGui",            // 模块名称
                                                         "FreeCAD GUI module\n",  // 模块的描述
                                                         -1,                      // 模块实例的大小（-1 表示动态分配）
                                                         FreeCADGui_methods,      // 模块导出的方法表
                                                         nullptr,
                                                         nullptr,
                                                         nullptr,
                                                         nullptr};
        PyObject* module = PyModule_Create(&FreeCADGuiModuleDef);   //  创建模块对象
        return module;
    }
    catch (const Base::Exception& e) {
        PyErr_Format(PyExc_ImportError, "%s\n", e.what());
    }
    catch (...) {
        PyErr_SetString(PyExc_ImportError, "Unknown runtime error occurred");
    }
    return nullptr;
}
```

**struct PyModuleDef FreeCADGuiModuleDef**是定义 Python 模块的核心结构体。它描述了模块的基本信息、方法、资源管理等。 
```c
struct PyModuleDef {
    PyModuleDef_Base m_base;          // 这个参数是固定的,就是PyModuleDef_HEAD_INIT
    const char* m_name;               // 模块名称
    const char* m_doc;                // 模块文档字符串
    Py_ssize_t m_size;                // 模块实例的大小（-1 表示动态分配）
    PyMethodDef *m_methods;           // 模块导出的方法表
    PyModuleDef_Slot *m_slots;        // 模块的插槽（slots）
    traverseproc m_traverse;          // 遍历函数（垃圾回收）
    inquiry m_clear;                  // 清理函数（垃圾回收）
    freefunc m_free;                  // 释放函数
};
```
这里面需要注意的是`m_methods`，PyMethodDef结构的原型是：  
```c
struct PyMethodDef 
{
    const char  *ml_name;   // 定义该方法在 Python 中的名称（即用户调用时使用的函数名）。
    PyCFunction ml_meth;    // 指向实现该方法的 C 函数指针。
    int         ml_flags;   // 标志位组合，描述该方法的参数规则和行为。
    const char  *ml_doc;    // 方法的描述
};
```
在Python文件中调用时使用的是ml_name。FreeCADGui的模块方法列表如下（m_methods参数），包含5个核心GUI操作方法：  
```cpp
struct PyMethodDef FreeCADGui_methods[] = {
    // 创建并显示主窗口
    {"showMainWindow",
     FreeCADGui_showMainWindow,
     METH_VARARGS,
     "showMainWindow() -- Show the main window\n"
     "If no main window does exist one gets created"},
    
    // 启动GUI事件循环
    {"exec_loop",
     FreeCADGui_exec_loop,
     METH_VARARGS,
     "exec_loop() -- Starts the event loop\n"
     "Note: this will block the call until the event loop has terminated"},
    
    // 设置非GUI模式
    {"setupWithoutGUI",
     FreeCADGui_setupWithoutGUI,
     METH_VARARGS,
     "setupWithoutGUI() -- Uses this module without starting\n"
     "an event loop or showing up any GUI\n"},
    
    {"embedToWindow",
     FreeCADGui_embedToWindow,
     METH_VARARGS,
     "embedToWindow() -- Embeds the main window into another window\n"},
    {nullptr, nullptr, 0, nullptr} /* sentinel */
};
```














