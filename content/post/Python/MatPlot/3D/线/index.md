---
title: "线段"
description: 
date: 2023-07-03
image: 
math: 
license: 
hidden: false
comments: true
draft: true
---


1. 创建画布
2. 线段坐标
3. 绘制线段


```python
import numpy as np
import matplotlib.pyplot as plt

fig = plt.figure(figsize=(10, 8))
ax = fig.add_subplot(111, projection='3d')

# 给定坐标点
points = np.array([
    [1, 1, 1],  # 点A
    [2, 2, 2],  # 点B
    [3, 3, 3]   # 点C
])

# 绘制直线段
ax.plot(
    points[:, 0],  # 所有点的X坐标
    points[:, 1],  # 所有点的Y坐标
    points[:, 2],  # 所有点的Z坐标
    color='blue',          # 线段颜色
    linewidth=3,           # 线段粗细
    alpha=0.9,             # 透明度
    marker='o',            # 端点标记
    markersize=10,         # 标记大小
    markeredgecolor='k',   # 标记边缘颜色
    markerfacecolor='red', # 标记填充颜色
    label='直线段 ABC'      # 图例标签
)

ax.set_xlabel('X 轴', fontsize=12, labelpad=10)
ax.set_ylabel('Y 轴', fontsize=12, labelpad=10)
ax.set_zlabel('Z 轴', fontsize=12, labelpad=10)

ax.set_title('三维空间中的直线段', fontsize=16, pad=20)

ax.grid(True)

# 添加图例
ax.legend(loc='best')

# 设置等比例缩放（使坐标轴比例一致）
ax.set_box_aspect([1, 1, 1])  # 使X,Y,Z轴比例相同

ax.view_init(elev=30, azim=45)  # 仰角30度，方位角45度

# 显示图形
plt.tight_layout()
plt.show()
```