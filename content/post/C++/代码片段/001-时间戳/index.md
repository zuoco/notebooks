---
title: "001 - 时间戳"
description: 
date: 2025-05-29T22:28:03+08:00
math: 
license: 
hidden: false
comments: true
draft: true
---

# 1. std::chrono
chrono是C++11引入的标准库组件，用于处理时间和时间间隔。chrono命名空间位于std命名空间下，它提供了类型安全、高精度的时间操作，避免了传统 C 时间函数（如 time_t）的类型错误和精度限制。

```cpp
#include <chrono>
```

## 1.1. 获取时间戳
```cpp
namespace TimeTools {
    // 秒级
	inline uint64_t time_s() {
		return std::chrono::duration_cast<std::chrono::seconds>(std::chrono::system_clock::now().time_since_epoch()).count();
	}

	// 毫秒
	inline uint64_t time_ms() {
		return std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::system_clock::now().time_since_epoch()).count();
	}

	// 微秒级
	inline uint64_t time_micros() {
		return std::chrono::duration_cast<std::chrono::microseconds>(std::chrono::system_clock::now().time_since_epoch()).count();
	}
}	
```

## 1.2. time_point类
```cpp
// (since C++11)
template<
    class Clock,
    class Duration = typename Clock::duration
> class time_point;
```

#### 1.2.0.1. public成员函数time_since_epoch()
```cpp
duration time_since_epoch() const;   // (since C++11)  (constexpr since C++14)
```
返回一个时间段，从纪元（Unix 时间的 1970-01-01 00:00:00 UTC）开始到当前时间点的持续时间。

## 1.3. duration类
```cpp
// (since C++11)
template<
    class Rep,
    class Period = std::ratio<1>
> class duration;
```
该类用于表示精确的时间间隔，编译时类型安全，零运行时开销（所有计算在编译期确定）。


## 1.4. system_clock类
```cpp
class system_clock;  # Defined in header <chrono>, since C++11
```

#### 1.4.0.1. 静态成员函数new()
```cpp
static std::chrono::time_point<std::chrono::system_clock> now() noexcept;      // (since C++11)
```
返回系统时钟的当前时间点，类型为std::chrono::time_point<std::chrono::system_clock>。

## 1.5. 模板函数duration_cast()
```cpp 
template< class ToDuration, class Rep, class Period >
constexpr ToDuration duration_cast( const std::chrono::duration<Rep, Period>& d );     // (since C++11)
```
这是一个时间单位的转换器, 就像把 "3小时" 转换成 "180分钟" 的计算器，专门用于处理 C++ 中的时间类型。



## 时间单位
C++ 提供了一套现成的时间单位类型，就像一套标准化的时间容器：
```cpp
std::chrono::nanoseconds	std::chrono::duration</* int64 */, std::nano>
std::chrono::microseconds	std::chrono::duration</* int55 */, std::micro>
std::chrono::milliseconds	std::chrono::duration</* int45 */, std::milli>
std::chrono::seconds	std::chrono::duration</* int35 */>
std::chrono::minutes	std::chrono::duration</* int29 */, std::ratio<60>>
std::chrono::hours	std::chrono::duration</* int23 */, std::ratio<3600>>
std::chrono::days (since C++20)	std::chrono::duration</* int25 */, std::ratio<86400>>
std::chrono::weeks (since C++20)	std::chrono::duration</* int22 */, std::ratio<604800>>
std::chrono::months (since C++20)	std::chrono::duration</* int20 */, std::ratio<2629746>>
std::chrono::years (since C++20)	std::chrono::duration</* int17 */, std::ratio<31556952>>
```
