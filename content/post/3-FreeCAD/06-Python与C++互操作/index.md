---
title: "FreeCAD（06）— Python与C++互操作"
description: 
date: 2025-08-10
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
  - FreeCAD
---




# PyObjectBase 类型
FreeCAD的Python绑定系统基于`PyObjectBase`基类，这是所有需要导出到Python命名空间的C++类的基础类。该类提供了Python对象的标准接口，包括属性访问、方法调用和生命周期管理。FreeCAD 中几乎所有关键类都需要在 Python 中可见，以便用于宏录制（macro recording）和自动化（automation）目的。   
Python绑定系统的基础代码位于PyObjectBase.h文件中，这篇文章就主要讲解该文件中的内容。          

```cpp
class BaseExport PyObjectBase : public PyObject //NOLINT
{
      Py_Header  // 注入 Python 类型元信息

      // ... 其他成员 ...
};
```
PyObject实际上是struct _object，可以理解为所有Python对象的根类型。         
Py_Header宏：   
```cpp
#define Py_Header                                           \
public:                                                     \
    static PyTypeObject   Type;                             \
    static PyMethodDef    Methods[];                        \
    virtual PyTypeObject *GetType(void) {return &Type;}
```
通过宏展开注入 Type 类型对象和 Methods 方法表使 PyObjectBase 子类在 Python 中表现为完整类型。
- `Type` 是 Python 类型对象，使 C++ 类能在 Python 中表现为完整类型。  
- `Methods` 是 Python 方法表，通过 PyMethodDef 数组声明所有可导出方法。   


为了简化从PyObjectBase类继承并定义导出到 Python 的新方法，FreeCAD还提供了一些便捷的宏（macro）：   
- `PYFUNCDEF_D` 定义一个新的导出方法。  
- `PYFUNCIMP_D` 定义这个新导出方法的具体实现。在实现的时候，可以使用 Py_Return、Py_Error、Py_Try 和 Py_Assert 等宏。  
- `PYMETHODEDEF` 宏用于在 Python 方法表中创建对应的条目。    







