---
title: "二维的点、线、面"
description: 
date: 2023-02-17
image: 
math: 
license: 
hidden: false
comments: true
draft: true
categories:
    - "MatPlot"
---


- [1. “点”类型](#1-点类型)
- [2. 描点](#2-描点)
- [3. 散点图](#3-散点图)
- [4. 直线、折线](#4-直线折线)
- [5. 面](#5-面)
  - [5.1. fill](#51-fill)
  - [5.2. polygon](#52-polygon)


# 1. “点”类型 
&emsp;&emsp;Matplotlib 本身不提供 Point 类型，但你可以通过列表、数组或其他数据结构灵活表示点的坐标。  
- 列表（List）：例如 x = [1, 2, 3], y = [4, 5, 6]。  
- NumPy 数组（Array）：例如 x = np.array([1, 2, 3]), y = np.array([4, 5, 6])。  
- 其他可迭代对象：只要能被转换为一维数据即可（如生成器、Pandas Series 等）。  

# 2. 描点
```python
import matplotlib.pyplot as plt

x = [2]
y = [3]

# marker, 点的样式。
# markersize, 点的直径。
plt.plot(x, y, marker='o', markersize=10, color='green', label='Custom Marker')  # markersize 是点的直径（不是面积）


plt.legend()
plt.title('Green Point with plot()')
plt.show()
```

# 3. 散点图
```python
import matplotlib.pyplot as plt

x = [2， 3， 4]
y = [3， 4， 5]


# x, 所有点的x坐标
# y, 所有点的y坐标
# s, 描述点的大小。
# color, 描述点的颜色。
# marker, 描述点样式。
# label, 描述点的标签。
plt.scatter(x, y, s=100, color='green', marker='o', label='Custom Marker')  # 'o' 表示圆形标记

plt.title('Green Point')

plt.xlabel('X-axis')
plt.ylabel('Y-axis')

# 显示图例
plt.legend()

plt.show()
```


# 4. 直线、折线
```python
import matplotlib.pyplot as plt

# 实线
x1 = [2, 3, 4, 5]
y1 = [3, 5, 5, 3]

# 虚线
x2 = [2, 3, 4, 5]
y2 = [4, 6, 6, 4]


# x1, y1 = [0, 5], [0, 5]  # 实线
# x2, y2 = [0, 5], [5, 0]  # 虚线

# 绘制第一条直线（实线）
plt.plot(x1, y1, color='red', linestyle='-', linewidth=2, label='Solid Line')

# 绘制第二条直线（虚线）
plt.plot(x2, y2, color='green', linestyle='--', linewidth=2, label='Dashed Line')


# 设置坐标轴范围
plt.xlim(0, 10)
plt.ylim(0, 10)

plt.legend()
plt.grid(True)
plt.show()
```

# 5. 面

## 5.1. fill
```python
import matplotlib

# 设置matplotlib的backend
matplotlib.use('tkAgg')

import matplotlib.pyplot as plt

# 三角形顶点坐标
x = [0, 1, 2]
y = [0, 2, 0]

# 绘制填充三角形
# color,     填充颜色
# edgecolor, 边框颜色
# linewidth, 边框宽度
# alpha,     透明度
plt.fill(x, y, color='skyblue', edgecolor='black', linewidth=2, alpha=0.7)


# 添加标题和坐标轴标签
plt.title("Triangle")
plt.xlabel("X-axis")
plt.ylabel("Y-axis")

plt.axis('equal')  # 保持坐标轴比例一致，每个单位在x轴和y轴上的长度相等。
plt.grid(True)     # 开启网格线显示。
plt.show()
```

## 5.2. polygon
```python
import matplotlib
matplotlib.use('tkAgg')
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon

# 一组坐标，五边形顶点坐标
vertices = [[0, 0], [1, 0], [1.5, 1], [1, 2], [0, 2]]

fig, ax = plt.subplots()

# 创建一个 Polygon 多边形对象。
# closed=True 表示多边形是闭合的。
polygon = Polygon(vertices, closed=True, 
                  facecolor='lightgreen', edgecolor='red', 
                  linewidth=2, alpha=0.6)


# 添加多边形到坐标系
ax.add_patch(polygon)


# 设置坐标轴范围
ax.set_xlim(-1, 3)
ax.set_ylim(-1, 3)


# 显示图形
plt.title("Pentagon with Polygon Class")
plt.grid(True)
plt.axis('equal')
plt.show()
```