---
title: "04 Pve显卡直通"
description: 
date: 2025-06-08T18:36:28+08:00
image: 
math: 
license: 
hidden: false
comments: true
draft: true
categories:
    - 虚拟化
---

# 1. 软硬件环境
`宿主机：  `    
- PVE 8.4.0 (Debian12);     
- AMD Ryzen 7 PRO 8845HS;     
- NVIDIA GeForce RTX 5060Ti;     

`客户机： `  
- Ubuntu24 LTS   

# 2. 宿主机准备工作
## 2.1. 启用硬件支持  
- BIOS 设置中开启虚拟化(一般默认开启);   
- BIOS PCI设置中开启SR-IOV;   

## 2.2. Grub配置

```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on iommu=pt initcall_blacklist=sysfb_init pcie_acs_override=downstream"
```
- amd_iommu=on : 启用AMD平台的IOMMU，IOMMU 是硬件虚拟化技术的关键，允许将物理设备（如 GPU）直通给虚拟机。   
- iommu=pt :     仅对直通设备启用 IOMMU（Passthrough 模式），减少未直通设备的性能开销。   
- initcall_blacklist=sysfb_init ： 止内核初始化函数 sysfb_init，防止宿主机占用显卡的帧缓冲区（framebuffer），传统参数 video=efifb:off,vesafb:off 在旧版本中用于禁用帧缓冲，但新版本（如 PVE 8.4）推荐使用此参数替代。   
- pcie_acs_override=downstream ： 强制拆分 PCIe IOMMU Groups，解决某些主板/芯片组的 ACS（Access Control Services）限制问题，确保显卡及其相关设备（如 USB 控制器）能被独立直通到虚拟机。

```bash
update-grub
```
- 修改完更新grub。  

## 2.3. 内核模块配置
```bash
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
```
- 上面内容添加到/etc/modules中，重启系统。   



## 2.4. 查看IOMMU是否开启
```bash
root@pve:/etc/default# dmesg | grep -E "DMAR|IOMMU"
[    0.392770] pci 0000:00:00.2: AMD-Vi: IOMMU performance counters supported
[    0.396162] perf/amd_iommu: Detected AMD IOMMU #0 (2 banks, 4 counters/bank).
```

## 2.5. 绑定显卡到VFIO驱动
`1. 查看显卡设备ID：`       
```bash
root@pve:/etc/default# lspci -nn | grep NVIDIA
01:00.0 VGA compatible controller [0300]: NVIDIA Corporation Device [10de:2d04] (rev a1)
01:00.1 Audio device [0403]: NVIDIA Corporation Device [10de:22eb] (rev a1)
```
- 显卡设备ID:  10de:2d04   

`2. 查看一下VFIO`     
```bash
root@pve:/etc/default# dmesg | grep -i vfio      
[    1.915949] VFIO - User Level meta-driver version: 0.3   # 系统加载了 VFIO 的用户空间元驱动（vfio），版本为 0.3。
```
- VFIO 是 Linux 内核的一个框架，用于安全地将硬件设备（如 GPU、网卡）直接暴露给用户空间或虚拟机。    
- 元驱动（meta-driver）是 VFIO 的核心组件，负责协调设备管理和 IOMMU（输入/输出内存管理单元）保护。   

`3. 绑定显卡到VFIO驱动`  
```bash
echo "options vfio-pci ids=10de:2d04 disable_vga=1" > /etc/modprobe.d/vfio.conf
```
- disable_vga=1： 禁用设备的 VGA 功能（如显卡的帧缓冲），避免与主机或其他虚拟机的 VGA 冲突，在 GPU 直通场景中，通常需要此参数以确保虚拟机独占设备。当你将物理显卡（如 NVIDIA GPU）通过 VFIO 直通给虚拟机时，disable_vga=1 会强制禁用该显卡在主机操作系统中的 VGA 功能（如帧缓冲、显示输出等）。这是为了避免主机和其他虚拟机同时尝试使用该显卡的 VGA 接口，主机将完全放弃对该显卡的显示控制权，将其完整交给虚拟机。   

`4. 查看中断重映射状态`  
```bash  
root@pve:/etc/default# dmesg | grep 'remapping'  
[    0.072012] x2apic: IRQ remapping doesn't support X2APIC mode
[    0.394008] AMD-Vi: Interrupt remapping enabled
```
- X2APIC 模式下的中断重映射功能不被支持, 可能是硬件不支持或者BIOS中没有开启，可能影响某些高级功能（如超大规模虚拟机部署）。     
- AMD-Vi（AMD IOMMU 虚拟化技术）的中断重映射功能已成功启用，这是设备直通（如 GPU、网卡）的关键功能，用于防止恶意虚拟机通过中断注入攻击主机。  

`5. 宿主机禁用NVIDIA GPU`   
```bash
echo "# NVIDIA" >> /etc/modprobe.d/blacklist.conf 
echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf 
echo "blacklist nvidia" >> /etc/modprobe.d/blacklist.conf 
echo "blacklist nvidiafb" >> /etc/modprobe.d/blacklist.conf
echo "blacklist nvidia_drm" >> /etc/modprobe.d/blacklist.conf
echo "" >> /etc/modprobe.d/blacklist.conf
```

## 2.6. 其他设置
```bash
echo "options vfio_iommu_type1 allow_unsafe_interrupts=1" > /etc/modprobe.d/iommu_unsafe_interrupts.conf
```
- vfio_iommu_type1： 这是 VFIO 的 IOMMU 驱动模块，用于设备直通时的地址翻译和隔离。    
- allow_unsafe_interrupts=1： 允许不安全的中断重映射（Interrupt Remapping），用于绕过某些硬件/固件对中断安全性的限制。   


```bash
echo "options kvm ignore_msrs=1 report_ignored_msrs=0" > /etc/modprobe.d/kvm.conf
```
为 NVIDIA 卡添加稳定性修复和优化，忽略异常，防止虚拟机异常导致宿主机崩溃
- ignore_msrs             :   忽略异常
- report_ignored_msrs     :   是否报告异常

## 2.7. 更新内核引导文件
```bash
update-initramfs -k all -u
reboot
```

## 2.8. 查看直通结果
```bash
root@pve:~# lspci -nn | grep NVIDIA
01:00.0 VGA compatible controller [0300]: NVIDIA Corporation Device [10de:2d04] (rev a1) # 01:00.0
01:00.1 Audio device [0403]: NVIDIA Corporation Device [10de:22eb] (rev a1)
root@pve:~# 
root@pve:~# 
root@pve:~# lspci -nnk -s 01:00.0   # 01:00.0
01:00.0 VGA compatible controller [0300]: NVIDIA Corporation Device [10de:2d04] (rev a1)
        Subsystem: CardExpert Technology Device [10b0:205e]
        Kernel driver in use: vfio-pci    # vfio-pci
        Kernel modules: nvidiafb, nouveau
```

# 3. 客户机工作

根据显卡型号安装驱动即可。

勾选所有功能，

不勾选主GPU，点击添加
