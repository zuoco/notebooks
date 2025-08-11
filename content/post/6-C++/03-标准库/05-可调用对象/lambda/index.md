---
title: "可调用对象之 Lambda"
description: 
date: 2023-05-28
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
    - "C++"
    - "C++ STL"
---

参考书籍： 《C++ Lambda Story》
1. [1. lambdab表达式组成部分](#1-lambdab表达式组成部分)
2. [2. lambda被编译器翻译成类](#2-lambda被编译器翻译成类)
3. [3. 参数捕获](#3-参数捕获)
  1. [3.1. 值捕获](#31-值捕获)
    1. [3.1.1. 捕获指定变量](#311-捕获指定变量)
    2. [3.1.2. 捕获全部用到的变量](#312-捕获全部用到的变量)
  2. [3.2. 引用捕获](#32-引用捕获)
    1. [3.2.1. 捕获指定变量](#321-捕获指定变量)
    2. [3.2.2. 捕获全部用到的变量](#322-捕获全部用到的变量)
  3. [3.3. 混合捕获](#33-混合捕获)
  4. [3.4. this捕获与\*this捕获](#34-this捕获与this捕获)
  5. [3.5. 初始化捕获](#35-初始化捕获)
4. [4. 修饰符](#4-修饰符)
  1. [4.1. mutalbe](#41-mutalbe)
  2. [4.2. constexpr和conxteval](#42-constexpr和conxteval)
5. [5. 形参修饰](#5-形参修饰)
  1. [5.1. C++20 模板形参](#51-c20-模板形参)
  2. [5.2. const auto\&](#52-const-auto)
6. [6. 涉及到函数重载时](#6-涉及到函数重载时)
7. [7. Lambda递归](#7-lambda递归)


# 1. lambdab表达式组成部分
Lambda表达式的格式为：  
```cpp
[capture list](parameters) -> return type {       };
// 捕获列表     ，函数参数，        返回值，     函数体
```
例如：  
```cpp
#include <iostream>

int main()
{
  auto f = [](int a) -> int { return a > 6 && a < 9 ; };
  std::cout << f(7) << std::endl;
}
```
- **[capture list]**: 参数捕获。   
- **(parameters)**： 形参。  
- **-> return type**： 返回类型，能够自动推导时，可以省略。   
- **{}**： 函数体，和普通函数一样。   

# 2. lambda被编译器翻译成类
上面的代码被翻译成类，并重载函数调用符`()`，也就是仿函数：   
```cpp
#include <iostream>

int main()
{
    
  class __lambda_5_12
  {
    public: 
    inline /*constexpr */ int operator()(int a) const
    {
      return static_cast<int>((a > 6) && (a < 9));
    }
    
    using retType_5_12 = auto (*)(int) -> int;
    inline constexpr operator retType_5_12 () const noexcept
    {
      return __invoke;
    };
    
    private: 
    static inline /*constexpr */ int __invoke(int a)
    {
      return __lambda_5_12{}.operator()(a);
    }
    
    
    public:
    // /*constexpr */ __lambda_5_12() = default;
    
  };
  
  __lambda_5_12 f = __lambda_5_12{};
  std::cout.operator<<(f.operator()(7)).operator<<(std::endl);
  return 0;
}
```
&emsp;&emsp;从上面代码中可以看出，lambda表达式，会被翻译成一个类，捕获的变量用在类的构造函数中，初始化成员变量。并且该类还重载了函数调用运算符“（）”，重载函数的函数体就是lambda的函数体。     

# 3. 参数捕获
&emsp;&emsp;一个Lambda处于一个作用域内部，可以捕获该作用域中的局部变量，而对于静态变量，全局变量直接使用即可。对于局部变量的捕获有多种情况，

## 3.1. 值捕获
&emsp;&emsp;在创建类的时候，定义相应的类成员变量，然后在构造lambda对象时，使用捕获的变量初始化类成员变量。    

### 3.1.1. 捕获指定变量
&emsp;&emsp;不管Lambda函数体中有没有用到这些变量，都会创建对应的成员变量，并且调用构造函数时传入参数来初始化这些成员变量。   
```cpp
#include <iostream>

int main()
{
  int x = 10;

  auto f = [x](int a) -> int { return a > 6 && a < 9 ; };
  std::cout << f(7) << std::endl;
}
```
上面代码翻译成：  
```cpp
#include <iostream>

int main()
{
  int x = 10;

  class __lambda_7_12
  {
    public: 
    inline /*constexpr */ int operator()(int a) const
    {
      return static_cast<int>((a > 6) && (a < 9));
    }
    
    private: 
    int x;
    
    
    public:
    // 构造函数
    __lambda_7_12(int & _x)
    : x{_x}
    {}
    
  };
  
  // 调用构造函数时，会将x的值复制给类的成员变量x中。
  __lambda_7_12 f = __lambda_7_12{x};  
  std::cout.operator<<(f.operator()(7)).operator<<(std::endl);
  return 0;
}
```

### 3.1.2. 捕获全部用到的变量
&emsp;&emsp;对于lamdba函数体中没有用到的变量，类就不会定义这个成员变量，这是一种比较智能的捕获方法。
```cpp
#include <iostream>

int main()
{
  int x = 10;
  int y = 20;
  int z = 30;

  auto f = [=](int a)    // [=]
  { 
      return a > x && a < y ; 
  };

  std::cout << f(7) << std::endl;
}
```
翻译后：  
```cpp
#include <iostream>

int main()
{
  int x = 10;
  int y = 20;
  int z = 30;
    
  class __lambda_9_12
  {
    public: 
    inline /*constexpr */ bool operator()(int a) const
    {
      return (a > x) && (a < y);
    }
    
    private: 
    int x;
    int y;
    
    public:
    __lambda_9_12(int & _x, int & _y)
    : x{_x}
    , y{_y}
    {}
    
  };
  
  __lambda_9_12 f = __lambda_9_12{x, y};
  std::cout.operator<<(f.operator()(7)).operator<<(std::endl);
  return 0;
}
```

## 3.2. 引用捕获
&emsp;&emsp;引用捕获，就会定义对应的引用类型的成员变量，这种情况下，lambda对于对于自身成员变量的操作会影响对应的外部变量。   
### 3.2.1. 捕获指定变量
&emsp;&emsp;同样，无论函数体中是否使用捕获列表中的参数，都会创建对应的成员变量。   
```cpp
#include <iostream>

int main()
{
  int x = 10;

  auto f = [&x](int a) 
  { 
      ++x;
      return a > x ; 
  };

  std::cout << f(7) << std::endl;
}
```
翻译后：
```cpp
#include <iostream>

int main()
{
  int x = 10;
    
  class __lambda_7_12
  {
    public: 
    inline /*constexpr */ bool operator()(int a) const
    {
      ++x;
      return a > x;
    }
    
    private: 
    int & x;  // 引用捕获，就会定义对应的引用类型的成员变量
    
    public:
    __lambda_7_12(int & _x)
    : x{_x}
    {}
  };
  
  __lambda_7_12 f = __lambda_7_12{x};
  std::cout.operator<<(f.operator()(7)).operator<<(std::endl);
  return 0;
}
```

### 3.2.2. 捕获全部用到的变量
[&]，只有创建使用到的成员变量。   


## 3.3. 混合捕获
- `[&, x]`, x使用值捕获，其他变量使用引用捕获。  
- `[=, &y]`, y使用引用捕获，其他变量使用值捕获。  
- `[x, &y]`, x使用值捕获，y使用引用捕获。  



## 3.4. this捕获与*this捕获
请看下面案例：  
```cpp
class str {

    auto fun() 
    {
      int a = 10;
      auto f = [a, x] () 
      {
          return a > x;    // 这样捕获是错的。
      };
    };

    int x;
};
```
上面的案例中，虽然说fun和x都是类成员，但是fun中的lambda是不能直接捕获x的，fun中的局部变量倒是可以捕获。正确做法：  
```cpp
class str {

    auto fun() 
    {
      int a = 10;
      auto f = [a, this] () 
      {
          return a > x; 
      };
    };

    int x;
};
```      
翻译后：  
```cpp
class str
{
  inline void fun()
  {
    int a = 10;
        
    class __lambda_6_16
    {
      public: 
      inline /*constexpr */ bool operator()() const
      {
        return a > __this->x;  // 通过 Str* 类型的成员变量访问对象的成员
      }
      
      private: 
      int a;
      str * __this;   // 一个Str* 类型的成员变量
      
      public:
      __lambda_6_16(str * _this, int & _a)
      : __this{_this}
      , a{_a}
      {}
      
    };
    
    __lambda_6_16 f = __lambda_6_16{this, a};
  }
  
  int x;
};
```
&emsp;&emsp;但是，要注意`this指向的对象的生命周期`，这个很危险，Lambda表示式很多时候用来创建一个可调用对象，但是并不是马上就要调用，所以要确保调用的时候参数都是有效的，所以C++17中提供了`*this`捕获。


## 3.5. 初始化捕获
Demo1：   
```cpp
int main()
{
    int x = 10;
    auto f = [y = x] (int a) { return a > y; };  // 类似于值捕获
    std::cout << f(11) << std::endl;
}
```

Demo2：  
```cpp
int main()
{
    std::string str = "Are You OK!";

    auto f = [ss = std::move(str)] () 
    { 
        std::cout << ss << std::endl; 
    };
  
    std::cout << str << std::endl;  // str为空
    f();  // 打印 Are You OK!
}
```


Demo3:  
```cpp
int main()
{
    int x = 10;
    int y = 10;

    auto f = [z = y + x] (int a) 
    { 
        return a > z;   // 其实也是值捕获
    };
}
```

# 4. 修饰符
## 4.1. mutalbe
```cpp
#include <iostream>

int main()
{
  int x = 10;

  auto f = [x](int a) { return a > 6 && a < 9 ; };
  std::cout << f(7) << std::endl;
}
```
翻译后：  
```cpp
#include <iostream>

int main()
{
  int x = 10;
    
  class __lambda_7_12
  {
    public: 
    inline /*constexpr */ int operator()(int a) const   // 这个const是修饰this的
    {
      return static_cast<int>((a > 6) && (a < 9));
    }
    
    private: 
    int x;
    
    public:
    __lambda_7_12(int & _x)
    : x{_x}
    {}
    
  };
  
  __lambda_7_12 f = __lambda_7_12{x};
  std::cout.operator<<(f.operator()(7)).operator<<(std::endl);
  return 0;
}
```
上面的代码中，重载函数的this是const的，所以重载函数中不能修改成员变量，使用mutalbe修饰符。     
```cpp
#include <iostream>

int main()
{
  int x = 10;

  auto f = [x](int a) mutable
  { 
     return a > 6 && a < 9 ; 
  };

  std::cout << f(7) << std::endl;
}
```
翻译后:  
```cpp
#include <iostream>

int main()
{
  int x = 10;
    
  class __lambda_7_12
  {
    public: 
    inline /*constexpr */ bool operator()(int a)  // 没有const了
    {
      return (a > 6) && (a < 9);
    }
    
    private: 
    int x;
    
    public:
    __lambda_7_12(int & _x)
    : x{_x}
    {}
    
  };
  
  __lambda_7_12 f = __lambda_7_12{x};
  std::cout.operator<<(f.operator()(7)).operator<<(std::endl);
  return 0;
}
```

## 4.2. constexpr和conxteval
- constexpr：  声明Lambda可以在编译期执行。  
- conxteval： 声明表达式不会抛出异常， 这个特性在《 C++异常 》篇章讲解。   

# 5. 形参修饰
## 5.1. C++20 模板形参
C++20引入，没用过。  
```cpp
#include <iostream>

int main()
{
  int x = 10;

  auto f = [x]<typename T>(T a)  // 模板形参
  { 
     return a > 6 && a < 9 ; 
  };

  std::cout << f(7) << std::endl;
}
```
翻译后：  
```cpp
#include <iostream>

int main()
{
  int x = 10;
    
  class __lambda_7_12
  {
    public: 
    template<typename T>      // 函数模板
    inline /*constexpr */ auto operator()(T a) const
    {
      return (a > 6) && (a < 9);
    }
    
    #ifdef INSIGHTS_USE_TEMPLATE
    template<>
    inline /*constexpr */ bool operator()<int>(int a) const
    {
      return (a > 6) && (a < 9);
    }
    #endif
    
    private: 
    int x;
    
    public:
    __lambda_7_12(int & _x)
    : x{_x}
    {}
    
  };
  
  __lambda_7_12 f = __lambda_7_12{x};
  std::cout.operator<<(f.operator()(7)).operator<<(std::endl);
  return 0;
}
```

## 5.2. const auto&
```cpp
#include <map>
#inclide <iostream>
#include <functional>  

int main()
{
   std::map<int, int> m{6, 8}
   auto lam = [](const auto& x)     // 等效于： const std::pair<const int, int>& x
   {
        return p.first + p.second;
   }

   std::cout << lam(*m.begin()) << std::endl;
}
```
我们看翻译后的：
```cpp
#include <map>
#include <iostream>
#include <functional>

int main()
{
  std::map<int, int, std::less<int>, std::allocator<std::pair<const int, int> > > m = std::map<int, int, std::less<int>, std::allocator<std::pair<const int, int> > >{std::initializer_list<std::pair<const int, int> >{std::pair<const int, int>{6, 8}}, std::less<int>(), std::allocator<std::pair<const int, int> >()};
    
  class __lambda_8_15
  {
    public: 
    template<class type_parameter_0_0>
    inline /*constexpr */ auto operator()(const type_parameter_0_0 & x) const
    {
      return x.first + x.second;
    }
    
    #ifdef INSIGHTS_USE_TEMPLATE
    // 重点
    template<>                                                      // 此处形参的形参为 const std::pair<const int, int>& 是由const auto& 推导出来的
    inline /*constexpr */ int operator()<std::pair<const int, int> >(const std::pair<const int, int> & x) const
    {
      return x.first + x.second;
    }
    #endif
    
    private: 
    template<class type_parameter_0_0>
    static inline /*constexpr */ auto __invoke(const type_parameter_0_0 & x)
    {
      return __lambda_8_15{}.operator()<type_parameter_0_0>(x);
    }
    
  };
  
  __lambda_8_15 lam = __lambda_8_15{};
  std::cout.operator<<(lam.operator()(m.begin().operator*())).operator<<(std::endl);
  return 0;
}
```

# 6. 涉及到函数重载时
```cpp
auto fun(int x)
{
  return ++x;
}

auto fun(int x)
{
    return ++x;
}

int main()
{
    auto lam = [](auto x) 
    { 
        return fun(x); 
    };
}
```
根据参数类型来选择对应的函数，内部实现为模板函数。   

# 7. Lambda递归
```cpp
#include <iostream>

int main()
{
    // 使用了两层Lambda
    auto factorial = [](int n)
    {
        // 递归Lambda, 在执行前就定义好
        auto fact = [](int n, const auto& f) -> int
        {
            return n > 1 ?  n * f(n - 1, f) : 1;
        };

        // 开始递归，此时fact的类型已经定义
        return fact(n, fact);
    };

    std::cout << factorial(5) << std::endl;
}
```
