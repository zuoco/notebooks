---
title: "Ollama基础操作"
description: "Ollama基础操作" 
date: 2025-05-21T20:39:47+08:00
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
  - AI
---

```bash
ollama run <模型名称>   # 运行模型（含下载）
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
