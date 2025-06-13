---
title: "输入输出"
description: "本文介绍C++的输入输出。"
date: 2020-09-09
draft: false
categories:
    现代C++
---

# 1. 非格式化IO

非格式化IO不涉及数据表示形式的变化。

非格式化输入： get、read、getline、gcount  
格式化输出： put、write

# 2. 格式化IO

使用移位操作符（“<<”、“>>”）来进行格式化输出，类型通过重载移位操作符来提供格式化IO功能。

## 2.1. 格式控制

**位掩码类型**

```
int main() {
    int x =  888;
    int y = -888;
    char z = '6';
    std::cout.setf(std::ios_base::showpos);
    std::cout << x << std::endl;
    std::cout << y << std::endl;
    std::cout << z << std::endl;  // showpos对于char类型无效
}
```

**输出：**  
+999  
\-888  
6

*   **输出宽度控制**

```
int main() {
    int x = 100;
    std::cout.width(10);
    std::cout.setf(std::ios_base::showpos);
    std::cout << x << std::endl;
}
// 输出， 以空格填充：      +100
```

```
int main() {
    int x = 100;
    std::cout.width(10);  // 触发后就会被重置为0
    std::cout.fill('.');
    std::cout.setf(std::ios_base::showpos);
    std::cout << x << std::endl;
}
// 输出: ......+100
```

*   **操纵符**

```
#include <iostream>
#include <iomanip>

int main() {
    int x = 666;
    int y = 888;

    // std::setw()出发后就会被重置
    std::cout << std::showpos << std::setw(10) << x << std::setw(10) << y << std::endl;
}
```

