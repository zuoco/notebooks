---
title: "C++包管理器之vcpkg"
description: 
date: 2025-05-31T21:58:34+08:00
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
    现代C++
---

# 1. vcpkg
Vcpkg 由 Microsoft 和 C++ 社区维护，可在 Windows、macOS 和 Linux 上运行，使用 C++ 和 CMake 脚本编写。

## 1.1. 安装    
1. 我这里就安装到~/.APP/目录下：   
```bash
cd /opt   
#
git clone https://github.com/microsoft/vcpkg.git   
#   
cd vcpkg
#     
./bootstrap-vcpkg.sh
```
2. 设置软连接：     
```bash
sudo ln -s /home/zcli/.APP/vcpkg/vcpkg /usr/local/bin/vcpkg
```
## 1.2. 使用
### 1.2.1. 使用依赖清单安装依赖
1. 在项目根目录下：   
```bash
vcpkg new --application
```
2. 生成两个文件：   
```bash
vcpkg-configuration.json
vcpkg.json    # 依赖清单
```
vcpkg-configuration.json文件如下：  
```bash
{
  "default-registry": {
    "kind": "git",
    "baseline": "89dc8be6dbcf18482a5a1bf86a2f4615c939b0fb",
    "repository": "https://github.com/microsoft/vcpkg"
  },
  "registries": [
    {
      "kind": "artifact",
      "location": "https://github.com/microsoft/vcpkg-ce-catalog/archive/refs/heads/main.zip",
      "name": "microsoft"
    }
  ]
}
```
vcpkg.json文件如下：  
```bash
{}
```
3. 添加依赖
```bash
vcpkg add port opencv
```
添加结果如下：  
```bash
{
  "dependencies": [
    "opencv"
  ]
}
```
也可以指定具体的版本。

4. 在准备好清单文件后：   
```bash
vcpkg install  # 自动读取当前目录的 vcpkg.json 文件
```
下载的二进制文件位于当前目录下的：vcpkg_installed目录。

### 1.2.2. 手动安装每个依赖

1. 安装软件包
```bash
vcpkg install zlib # 安装zlib
```

2. 卸载软件包
```bash
vcpkg remove zlib
```
3. 查找可用包
```bash
vcpkg remove zlib
```

## 1.3. CMake构建
```bash
cmake -B build -S . \ 
  -DCMAKE_TOOLCHAIN_FILE=/home/zcli/.APP/vcpkg/scripts/buildsystems/vcpkg.cmake \ 
  -DVCPKG_TARGET_TRIPLET=x64-linux \ 
  -DCMAKE_BUILD_TYPE=Release \ 
  -DCMAKE_INSTALL_PREFIX=/usr/local
```