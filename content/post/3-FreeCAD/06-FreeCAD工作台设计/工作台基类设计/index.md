---
title: "FreeCAD（06）— 工作台基类设计"
description: 
date: 2025-08-12
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
  - FreeCAD
---


- [1. 工作台基础类型](#1-工作台基础类型)
- [2. 工作台类型](#2-工作台类型)
- [3. 零件工作台类型](#3-零件工作台类型)
- [4. 工作台管理类](#4-工作台管理类)


Workbench是FreeCAD模块提供的工作台实现，工作台就是一组功能的集合，例如“零件建模工作台”、“CAM工作台”、“装配体工作台”。它定义了哪些GUI元素（如工具栏、菜单）会被添加到主窗口中，以及哪些会被移除或隐藏。当一个workbench对象首次被激活时，它所代表的模块会被加载到RAM中。    


# 1. 工作台基础类型
```cpp
namespace Gui {

// GUI元素体系，支持4类界面元素，实际上还有一个命令栏（CommandBars）
class MenuItem;        // 菜单栏
class ToolBarItem;     // 工具栏
class DockWindowItems; // 停靠窗口

class WorkbenchManager;

class GuiExport Workbench : public Base::BaseClass
{
    // ...


    // 核心生命周期管理
    /**
     * Activates the workbench and adds/removes GUI elements.
     */
    bool activate();
    /** Run some actions when the workbench gets activated. */
    virtual void activated();
    /** Run some actions when the workbench gets deactivated. */
    virtual void deactivated();

    // Python绑定支持
    PyObject* getPyObject() override;

    // ...


protected:
    // 设置各种小窗口
    /** Returns a MenuItem tree structure of menus for this workbench. */
    virtual MenuItem* setupMenuBar() const=0;                                        // 设置菜单栏
    /** Returns a ToolBarItem tree structure of toolbars for this workbench. */      
    virtual ToolBarItem* setupToolBars() const=0;                                    // 设置工具栏
    /** Returns a ToolBarItem tree structure of command bars for this workbench. */
    virtual ToolBarItem* setupCommandBars() const=0;                                 // 设置命令栏
    /** Returns a DockWindowItems structure of dock windows this workbench. */
    virtual DockWindowItems* setupDockWindows() const=0;                             // 设置停靠窗口

    // ... 
};

}
```
管理不同模块的GUI元素展示与激活逻辑。以下是关键分析：

# 2. 工作台类型
FreeCAD提供了几种不同类型的workbench基类，最终的工作台继承自这些基类：
|基类型|  功能  |派生类型|
|------------|------------|------------|
|StdWorkbench| 标准工作台类，定义了标准的菜单、工具栏等元素 | NoneWorkbench 精简版的工作台|
|BlankWorkbench| 完全空白的工作台 | |
|PythonBaseWorkbench| 支持Python操作的工作台 | PythonBlankWorkbench <br> PythonWorkbench |
|其他|...|...|


以StdWorkbench为例，看看都重写了什么：  
```cpp
class GuiExport StdWorkbench : public Workbench
{
    TYPESYSTEM_HEADER_WITH_OVERRIDE();

public:
    StdWorkbench();
    ~StdWorkbench() override;

public:
    // 上下文菜单，可能是右键菜单
    /** Defines the standard context menu. */
    void setupContextMenu(const char* recipient, MenuItem*) const override;
    void createMainWindowPopupMenu(MenuItem*) const override;

protected:
    // 设置工作台的各个组件
    /** Defines the standard menus. */
    MenuItem* setupMenuBar() const override;
    /** Defines the standard toolbars. */
    ToolBarItem* setupToolBars() const override;
    /** Defines the standard command bars. */
    ToolBarItem* setupCommandBars() const override;
    /** Returns a DockWindowItems structure of dock windows this workbench. */
    DockWindowItems* setupDockWindows() const override;


    friend class PythonWorkbench;
};
```

# 3. 零件工作台类型

```py

```


# 4. 工作台管理类







