---
title: "第二节 - DeskFlow工程源码整体认识"
description: 
date: 2025-05-06T20:36:33+08:00
comments: true
draft: false
categories:
  - 代码设计
---

# 1. 项目构建系统
![](Deskflow项目构建系统.svg)

# 2. 项目目录结构
```
deskflow-1.21.2/
├── cmake/
├── CMakeLists.txt
├── cspell.json
├── deploy/
├── doc/
├── src/
├── LICENSE
├── LICENSES/
├── README.md
├── REUSE.toml
├── SECURITY.md
├── sonar-project.properties
├── vcpkg-configuration.json
└── vcpkg.json
```
下面大概介绍一下主要文件的用途：
## 2.1. vcpkg.json和vcpkg-configuration.json
vcpkg是一个C++包管理工具，vcpkg-configuration.json 和 vcpkg.json 协同工作。vcpkg.json 列出了项目所需的依赖包，而 vcpkg-configuration.json 则指定了从哪些地方获取这些包。当执行 vcpkg install 命令时，vcpkg 会先依据 vcpkg-configuration.json 配置的注册表，再按照 vcpkg.json 列出的依赖，去下载、编译并集成所需的包到项目中。

## 2.2. sonar-project.properties
代码质量管理相关的文件。

## 2.3. SECURITY.md
声明安全策略和漏洞管理流程。

## 2.4. RESEUE.toml
统一管理Deskflow项目的版权归属和许可证声明，确保所有文件符合开源合规要求。

## 2.5. LICENSE
统一管理Deskflow项目的版权归属和许可证声明，确保所有文件符合开源合规要求。

## 2.6. cspell.json
拼写检查配置文件，用于定义 Deskflow 项目中允许的特定术语、技术词汇和专有名词，确保拼写检查工具（如 VS Code 的 Code Spell Checker）在扫描代码时 忽略合法词汇，同时标记拼写错误。
## 2.7. 目录LICENSES
包含四种开源许可证文件，定义了项目各组件的合法使用、修改和分发规则。

## 2.8. 目录src
包含源代码文件，包括主程序、工具类、配置文件等。

## 2.9. 目录deploy
部署脚本,定义了在不同平台上的部署方法.

## 2.10. cmake
cmake模块,定义了cmake的配置文件,负责构建过程中的依赖检查.

## 2.11. doc
文档,包括用户指南、开发指南等.

# 3. 子目录src
```
src/
├── apps/
├── CMakeLists.txt
├── lib/
└── test/
```
面对一个软件,我们可以将代码分为两部分: `架构层代码`、`业务层代码`。    
`apps`: 业务层代码，包含了具体的业务逻辑和功能实现。
`lib`: 架构层代码，包含了框架、工具类、配置文件等。     
`test`: 测试代码，包含了单元测试、集成测试等。


## 3.2. apps
```
apps/
├── CMakeLists.txt
├── deskflow-client/
├── deskflow-core/
├── deskflow-daemon/
├── deskflow-gui/
├── deskflow-server/
└── res
```
apps目录下就是业务层的代码了，通过第一节，我们知道，DeskFlow这个软件是一个“服务器－客户端”的模式，DeskFlow编译成功后有３个可执行文件: deskflow、deskflow-server、deskflow-client。       
`deskflow-server`:  
就是服务端代码，也就运行在实际插入物理键盘鼠标的电脑上;     
`deskflow-client`:    
就是客户端代码，和服务端相对;       
`deskflow-core`:    
deskflow就是deskflow-core程序，既是客户端也是服务端，运行是根据传入的命令行参数来判断是运行为服务端还是运行为客户端。       
`deskflow-gui`:    
GUI代码，基于Qt。

## 3.1. lib
DeskFlow的底层逻辑，比如跨平台抽象层。
