---
title: "Git"
description: "Git使用技巧"
date: 2025-05-07T21:48:29+08:00
image: git.jpg
math: 
license: 
hidden: false
comments: true
draft: false
categories:
  - Git
---

# 基本概念
**仓库（Repository）**：一个Git仓库是一个包含所有版本控制文件和历史记录的目录。    
- 本地仓库（Local Repository）：在你的本地计算机上的仓库。   
- 远程仓库（Remote Repository）：托管在服务器上的仓库，通常是GitHub、GitLab等。   

**工作区（Workspace）**: 你在本地计算机上的项目目录，包含了所有的文件和目录。     
**暂存区（Stage）**: 用于暂存即将提交的文件，添加到暂存区的文件会被git跟踪。     
**主分支**：新建一个仓库会分配一个默认主分支，早期为“master”，现在为“main”。         
**head**: 指向当前工作的分支的最新提交，每次提交都会更新head，保持head指向最新的提交。        

# Git的配置
全局配置：  
```bash
git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"
仓库配置：   
```bash
# 在仓库目录下执行以下命令：
git config --local user.name "Your Name"
git config --local user.email "your_email@example.com"
```
保存在当前仓库下.git/config文件中，仓库配置会覆盖全局配置。

查看配置：      
```bash
git config --list  
```
# 创建本地仓库
```bash
git init
```
# 查看仓库状态
```bash
git status
```
# 添加文件到暂存区
```bash
git add <file>
git add .   # 添加所有文件
```
# 提交到本地仓库
```bash
git commit -m "提交信息"
```
git会为每一个提交创建一条版本历史记录，包含：        
1. commit id: 40位字符串，表示一个唯一的提交ID，用于标识提交，在命令中使用前6位即可。    
2. commit message: 提交信息，用于描述本次提交的内容。    
3. 快照： 完整版本文件，以对象树的形式存储在.git/objects目录下。

commit还有其他用法：
```bash
# 使用一次新的提交，替代上一次提交，会修改commit id
git commit --amend -m "修改提交信息"
```
```bash
# 提交指定文件
git commit filename
```
# 提交日至
```bash
git log
```
会列出所有提交的信息，包括commit id、commit message、作者、提交时间等。   

# 查询文件变更
```bash
git diff
```
可以查看工作区和暂存区之间的差异，删除的行会以删除符号（---）标记，新增的行会以新增符号（+++）标记。   
Changes to be committed: 已经git add的文件，但是还没有git commit的文件。      
Changes not staged for commit: 还没有git add的文件。    
Unmodified files: 没有被git跟踪的文件。    

# 远程仓库
关联远程仓库：
情况1：已创建本地仓库
```bash
git remote add origin <repository_url>
git push -u origin main   # 第一次推送时，需要加上-u指定远程仓库，表示将当前分支与远程仓库关联起来。
```
情况2：未创建本地仓库   
```bash
# 先创建仓库
git init
# 关联远程仓库
git remote add origin <repository_url>
# 提交到本地仓库
git add .
git commit -m "xxxxxx"
# 推送本地仓库到远程仓库
git push -u origin main
```

