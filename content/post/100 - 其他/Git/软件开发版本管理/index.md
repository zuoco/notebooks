---
title: "软件开发版本管理"
description: 
date: 2025-05-25T17:04:00+08:00
hidden: false
comments: true
draft: false
categories:
  - Git
---


# 分支管理
`master分支`:   
用于生产环境的部署，不允许直接push分支，由release分支或者hotfix分支合并。    
`hotfix分支`:  
针对线上紧急问题进行修复的分支，以master分支为基线创建的，修复完成后合并到dev分支、master分支。    
`release分支`:   
预发布分支，UAT测试阶段使用，一般由test分支或hitfix分支合并。    
`dev分支`:   
开发分支，最新版本迭代代码，包括bug修复后的代码。    
`feature分支`:   
基于dev分支在本地创建，每个开发人员的本地分支，针对各自的功能进行开发，开发完成合并到dev分支，并删除该fearure分支，feature是每个开发人员的本地分支，不可推送到远程，只能在本地合并到dev分支，然后推送dev分支。   
