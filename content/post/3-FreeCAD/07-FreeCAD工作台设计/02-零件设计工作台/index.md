---
title: "FreeCAD（07）— 零件设计工作台-PartDesign"
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


我们先看一下Part-Design模块目录下都有什么：  
```bash
./src/Mod/PartDesign
├── CMakeLists.txt
├── App/             # C++实现核心建模逻辑（特征类如FeatureExtrude、FeatureRevolution）
├── fcgear/          # 
├── fcsprocket/
├── Gui/             # Qt实现图形界面（任务面板TaskXXXParameters、视图提供者ViewProviderXXX）
├── Resources/
├── Scripts/         # Python脚本接口
├── __init__.py      # 执行 PyMOD_INIT_FUNC(PartDesignGui)
├── Init.py          # 第一个初始化脚本
├── InitGui.py       # 第二个初始化脚本，PartDesignWorkbench类型的定义
├── PartDesignTests/    # 单元测试
├── WizardShaft/
├── partdesign.dox
├── PartDesignGlobal.h
├── PartDesign_Model.xml
├── InvoluteGearFeature.py

├── SprocketFeature.py
├── SprocketFeature.ui
├── TestPartDesignApp.py
├── TestPartDesignGui.py
└── InvoluteGearFeature.ui
```

零件设计工作台类型 —— `PartDesignWorkbench`设计：  
```py
class PartDesignWorkbench(Workbench):
    def __init__(self):  # 初始化工作台元数据
        self.Icon = "图标路径"        # 图标资源位置
        self.MenuText = "Part Design" # 菜单显示名称
        self.ToolTip = "工作台描述"    # 悬停提示信息

    def Initialize(self):  # 模块初始化逻辑
        try:
            import traceback
            from PartDesign.WizardShaft import WizardShaft  # 轴类向导模块
        except ImportError:
            print("错误处理：模块无法加载")  # 异常捕获

        # 核心模块加载
        import PartDesignGui
        import PartDesign

        # 可选功能模块加载
        try:
            from PartDesign import InvoluteGearFeature  # 渐开线齿轮特征
            from PartDesign import SprocketFeature      # 链轮特征
        except ImportError:
            print("可选模块缺失处理")

    def GetClassName(self):  # 返回C++绑定类名
        return "PartDesignGui::Workbench"
```


```py
Gui.addWorkbench(PartDesignWorkbench()) # 注册到FreeCAD GUI系统
```

