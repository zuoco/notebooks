---
title: "Ollama基础操作"
description: "Ollama基础操作" 
date: 2025-03-17
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
  - AI
---

# Ollama基础命令


```bash
# 但是ollama默认下载的可能是量化版本，且国内访问会很慢，可以从modelscope下载  
ollama run <模型名>:<版本号>  # 运行模型（含下载）。
ollama run <模型名称>:<版本号>  modelscope.cn/Qwen/<模型名称>:<版本号> # 国内下载
```


```bash
ollama run <模型名> --verbose   # 显示推理过程的耗时情况
```


```bash
ollama list  # 列出所有模型 
```


```bash
ollama show <模型名称>   # 显示模型参数信息
```


```bash
ollama rm <模型名称>     # 删除模型
```



```bash
ollama ps   # 显示正在运行的模型
```



```bash
ollama stop <模型名称>   # 停止运行中的模型
```


#   