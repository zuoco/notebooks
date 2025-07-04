---
title: "散点图"
description: 
date: 2025-07-03
image: 
math: 
license: 
hidden: false
comments: true
draft: true
---


1. 创建画布；
2. 添加三维坐标系；
3. 散点图对象;
4. plot。


![](fig1.svg)

```python
import numpy as np
import matplotlib.pyplot as plt

plt.rcParams['font.sans-serif'] = ['WenQuanYi Micro Hei', 'SimHei', 'Microsoft YaHei']  # 常用中文字体
plt.rcParams['axes.unicode_minus'] = False  # 禁用Unicode减号显示，防止负号显示为方块或乱码


np.random.seed(42) # 设置随机种子以确保结果可重现，通过固定种子值，每次运行程序时都能获得相同的随机结果，便于实验复现和调试。

# 1. 画布
fig = plt.figure(figsize=(10, 8))
# 2. 添加一个三维坐标系
ax = fig.add_subplot(111, projection='3d') # 111表示创建一个1行1列的子图，并选择第1个子图



# 3. 准备散点图对象

n_points = 200                 # 生成200个随机数据。
x = np.random.randn(n_points)  # X坐标
y = np.random.randn(n_points)  # Y坐标
z = np.random.randn(n_points)  # Z坐标


colors = np.sqrt(x**2 + y**2 + z**2)  # 数据的颜色，距离原点越远颜色越深


sizes = 50 * np.abs(z) + 10  # 数据点的大小，离原点越远的点越大


scatter = ax.scatter(  # 散点图对象
    x, y, z, 
    c=colors,          # 颜色映射
    s=sizes,           # 点的大小
    alpha=0.7,         # 透明度
    cmap='viridis',    # 颜色方案
    edgecolor='k',     # 边缘颜色
    depthshade=True    # 深度阴影效果
)

cbar = fig.colorbar(scatter, ax=ax, pad=0.1)  # 添加颜色条，在坐标轴ax上添加颜色条，pad参数控制颜色条与图表间距
cbar.set_label('距离原点的欧氏距离', fontsize=12)

ax.set_xlabel('X 轴', fontsize=12, labelpad=10)
ax.set_ylabel('Y 轴', fontsize=12, labelpad=10)
ax.set_zlabel('Z 轴', fontsize=12, labelpad=10)

ax.set_title('3D 散点图示例', fontsize=16, pad=20)

ax.grid(True)


ax.view_init(elev=25, azim=45)  # 设置视角, 仰角25度，方位角45度

size_legend = [10, 30, 60]      # 图例内容
labels = ['小点', '中等点', '大点']
handles = []
for size, label in zip(size_legend, labels):
    handles.append(ax.scatter([], [], [], s=size, c='gray', edgecolor='k', alpha=0.7, label=label))

ax.legend(handles=handles, loc='upper right', title='点的大小') # 添加图例到图表中

# 4. Plot
plt.tight_layout()
plt.show()
```