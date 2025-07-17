---
title: "02 —— FreeCAD代码目录结构"
description: 
date: 2025-07-17
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
  - FreeCAD
---


# 代码目录结构
```bash
.
└── freecad
    ├── src               # 源码
    ├── tools
    ├── tests
    ├── cMake               
    ├── conda
    ├── contrib
    ├── data              # 示例
    ├── LICENSE
    ├── package
    ├── pixi.lock
    ├── pixi.toml
    ├── PRIVACY_POLICY.md
    ├── README.md
    ├── requirements.txt
    ├── rpkg.macros
    ├── SECURITY.md
    ├── CODE_OF_CONDUCT.md
    ├── CMakePresets.json
    └── CMakeLists.txt
```
源码目录：  
```bash
├── src
│   ├── 3rdParty             # 三方库，K维树、网格等等。
│   ├── App                  # 非界面代码，Document、Property、DocumentObject，支持Python。
│   ├── Base                 # 底层基础类型。
│   ├── Build                # 编译时的版本信息
│   ├── CXX                  # 对于PyCXX的修改,便于Python脚本调用C++代码。
│   ├── Doc                  # 生成手册文档
│   ├── Gui                  # 界面
│   ├── MacAppBundle         # Mac安装包配置文件
│   ├── Main                 # 程序入口，包括CLI和GUI两个入口程序
│   ├── Mod                  # 模块，CAM、工程图、有限元等等模块
│   ├── Tools
│   ├── XDGData              # Linux桌面相关文件
│   ├── zipios++             # 压缩文件读写
│   ├── CMakeLists.txt
│   ├── boost_geometry.hpp   
│   ├── boost_signals2.hpp   
│   ├── config.h.cmake
│   ├── boost_graph_adjacency_list.hpp 
│   ├── boost_graph_reverse_graph.hpp
│   ├── Ext
│   ├── FCConfig.h
│   ├── FCGlobal.h
│   ├── boost_python.hpp
│   ├── __init__.py
│   ├── LibraryVersions.h.cmake
│   ├── QtCore.h.cmake
│   ├── QtOpenGL.h.cmake
│   ├── SMESH_Version.h.cmake
│   └── boost_regex.hpp
```
源码中的模块目录：   
```bash
src/Mod/
├── Part            # 创建基础的3D元素，圆柱、立方体等等
├── OpenSCAD        # 建模
├── PartDesign      # 零件设计 
├── CAM             # 工艺，数控
├── Draft           # 2D草图 
├── Drawing         # 工程图 
├── Sketcher        # 
├── Assembly        # 装配图 
├── Fem             # 有限元
├── Material        # 材料属性
├── Mesh            # 网格化
├── MeshPart
├── Points             # 点云
├── ReverseEngineering # 从点云创建实体
├── Robot              # 机器人
├── __init__.py
├── Inspection
├── Help
├── Measure
├── Idf
├── Import
├── mod.dox
├── CMakeLists.txt
├── AddonManager
├── BIM
├── Plot             
├── Sandbox
├── Show
├── Cloud
├── Spreadsheet
├── Start
├── Surface
├── TechDraw
├── TemplatePyMod
├── Test
├── Tux
└── Web
```


