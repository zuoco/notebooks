---
title: "09 跨平台抽象层之 —— 字符编码转换"
description: 
date: 2024-09-16
image: 
math: 
license: 
hidden: false
comments: true
draft: false
categories:
    - "跨平台抽象层-C++"
---


跨平台字符串编码转换工具类，封装平台相关的编码特性，提供多字节字符串与宽字符的双向转换，支持不同宽字符编码格式（UCS2/UCS4/UTF16/UTF32），实现平台相关的字符串编码规范（Windows 使用 UTF-16，其他系统使用 UCS-4）。   
```cpp
class ArchString : public IInterface
{
public:
    ArchString() = default;
    ArchString(const ArchString &) = delete;
    ArchString(ArchString &&) = delete;
    ~ArchString() override;

    ArchString &operator=(const ArchString &) = delete;
    ArchString &operator=(ArchString &&) = delete;

    // 宽字符编码类型
    enum class EWideCharEncoding : uint8_t
    {
        kUCS2,  // UCS-2
        kUCS4,  // UCS-4
        kUTF16, // UTF-16
        kUTF32, // UTF-32
        kPlatformDetermined
    };

    // 将多字节编码（例如，UTF-8，GBK）的字符转换以固定宽度编码（例如，UTF-16、UTF-32）的字符串
    int convStringMBToWC(wchar_t *, const char *, uint32_t n, bool *errors) const;

    int convStringWCToMB(char *, const wchar_t *, uint32_t n, bool *errors) const;

    // 返回当前系统架构下宽字符（wchar_t）的原生编码方式（如UTF-16或UTF-32）
    EWideCharEncoding getWideCharEncoding() const;
};
```