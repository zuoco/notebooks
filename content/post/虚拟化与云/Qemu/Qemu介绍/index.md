---
title: "Qemu介绍"
description: ""
date: 2025-05-05T23:36:36+08:00
image: AAA.jpg
comments: true
draft: false
categories:
    - 虚拟化
    - Qemu
---

# Qemu介绍
- Qemu（Quick Emulator），一款开源的硬件虚拟化和仿真工具，Qemu本身可以运行在多种平台上（x86、ARM、RISC-V），并且能够模拟多种虚拟机。WMware、VirtualBox等虚拟化虚拟化平台只能运行在x86平台上，也只能模拟X86环境，而Qemu可以运行在多种平台，并且能够模拟多种虚拟机。
- Qemu的系统模式和用户模式，系统模式就是模拟出一套硬件环境，在这个虚拟的硬件上安装操作系统，用户模式就是直接运行为另一个操作系统开发的程序。

`qmu仓库`     
https://gitlab.com/qemu-project/qemu
`wiki`    
https://wiki.qemu.org/Hosts/Linux

# AMD64平台编译Qemu
以Fedora42为例，编译Qemu。
```shell
Build targets in project: 643

qemu 9.2.2

  Build environment
    Build directory                 : /home/zcli/test/qemu-9.2.2/build
    Source path                     : /home/zcli/test/qemu-9.2.2
    Download dependencies           : YES

  Directories
    Build directory                 : /home/zcli/test/qemu-9.2.2/build
    Source path                     : /home/zcli/test/qemu-9.2.2
    Download dependencies           : YES
    Install prefix                  : /usr/local
    BIOS directory                  : share/qemu
    firmware path                   : share/qemu-firmware
    binary directory                : /usr/local/bin
    library directory               : /usr/local/lib64
    module directory                : lib64/qemu
    libexec directory               : /usr/local/libexec
    include directory               : /usr/local/include
    config directory                : /usr/local/etc
    local state directory           : /var/local
    Manual directory                : /usr/local/share/man
    Doc directory                   : /usr/local/share/doc

  Host binaries
    python                          : /home/zcli/test/qemu-9.2.2/build/pyvenv/bin/python3 (version: 3.13)
    sphinx-build                    : NO
    gdb                             : /usr/bin/gdb
    iasl                            : NO
    genisoimage                     : 

  Configurable features
    Documentation                   : NO
    system-mode emulation           : YES
    user-mode emulation             : NO
    block layer                     : YES
    Install blobs                   : YES
    module support                  : NO
    fuzzing support                 : NO
    Audio drivers                   : oss
    Trace backends                  : log
    D-Bus display                   : YES
    QOM debugging                   : YES
    Relocatable install             : YES
    vhost-kernel support            : YES
    vhost-net support               : YES
    vhost-user support              : YES
    vhost-user-crypto support       : YES
    vhost-user-blk server support   : YES
    vhost-vdpa support              : YES
    build guest agent               : YES

  Compilation
    host CPU                        : x86_64
    host endianness                 : little
    C compiler                      : cc -m64
    Host C compiler                 : cc -m64
    C++ compiler                    : NO
    Objective-C compiler            : NO
    Rust support                    : NO
    CFLAGS                          : -g -O2
    QEMU_CFLAGS                     : -mcx16 -msse2 -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -fno-strict-aliasing -fno-common -fwrapv -ftrivial-auto-var-init=zero -fzero-call-used-regs=used-gpr -fstack-protector-strong
    QEMU_LDFLAGS                    : -fstack-protector-strong -Wl,-z,relro -Wl,-z,now
    link-time optimization (LTO)    : NO
    PIE                             : YES
    static build                    : NO
    malloc trim support             : YES
    membarrier                      : NO
    debug graph lock                : NO
    debug stack usage               : NO
    mutex debugging                 : NO
    memory allocator                : system
    avx2 optimization               : YES
    avx512bw optimization           : YES
    gcov                            : NO
    thread sanitizer                : NO
    CFI support                     : NO
    strip binaries                  : NO
    sparse                          : NO
    mingw32 support                 : NO

  Cross compilers
    x86_64                          : cc

  Targets and accelerators
    KVM support                     : YES
    HVF support                     : NO
    WHPX support                    : NO
    NVMM support                    : NO
    Xen support                     : NO
    Xen emulation                   : YES
    TCG support                     : YES
    TCG backend                     : native (x86_64)
    TCG plugins                     : YES
    TCG debug enabled               : NO
    target list                     : x86_64-softmmu
    default devices                 : YES
    out of process emulation        : YES
    vfio-user server                : NO

  Block layer support
    coroutine backend               : ucontext
    coroutine pool                  : YES
    Block whitelist (rw)            : 
    Block whitelist (ro)            : 
    Use block whitelist in tools    : NO
    VirtFS (9P) support             : YES
    replication support             : YES
    bochs support                   : YES
    cloop support                   : YES
    dmg support                     : YES
    qcow v1 support                 : YES
    vdi support                     : YES
    vhdx support                    : YES
    vmdk support                    : YES
    vpc support                     : YES
    vvfat support                   : YES
    qed support                     : YES
    parallels support               : YES
    FUSE exports                    : NO
    VDUSE block exports             : YES

  Crypto
    TLS priority                    : NORMAL
    GNUTLS support                  : YES 3.8.9
      GNUTLS crypto                 : YES
    libgcrypt                       : NO
    nettle                          : NO
    SM4 ALG support                 : NO
    SM3 ALG support                 : NO
    AF_ALG support                  : NO
    rng-none                        : NO
    Linux keyring                   : YES
    Linux keyutils                  : YES 1.6.3

  User interface
    SDL support                     : NO
    SDL image support               : NO
    GTK support                     : YES
    pixman                          : YES 0.44.2
    VTE support                     : YES 0.80.1
    PNG support                     : YES 1.6.44
    VNC support                     : YES
    VNC SASL support                : YES
    VNC JPEG support                : YES 3.1.0
    spice protocol support          : YES 0.14.4
      spice server support          : YES 0.15.1
    curses support                  : YES
    brlapi support                  : NO

  Graphics backends
    VirGL support                   : NO
    Rutabaga support                : NO

  Audio backends
    OSS support                     : YES
    sndio support                   : NO
    ALSA support                    : NO
    PulseAudio support              : NO
    PipeWire support                : NO
    JACK support                    : NO

  Network backends
    AF_XDP support                  : NO
    slirp support                   : NO
    vde support                     : NO
    netmap support                  : NO
    l2tpv3 support                  : YES

  Dependencies
    libtasn1                        : YES 4.20.0
    PAM                             : NO
    iconv support                   : YES
    blkio support                   : NO
    curl support                    : NO
    Multipath support               : NO
    Linux AIO support               : NO
    Linux io_uring support          : NO
    ATTR/XATTR support              : YES
    RDMA support                    : NO
    fdt support                     : YES
    libcap-ng support               : NO
    bpf support                     : NO
    rbd support                     : NO
    smartcard support               : YES 2.8.1
    U2F support                     : NO
    libusb                          : YES 1.0.28
    usb net redir                   : YES 0.15.0
    OpenGL support (epoxy)          : YES 1.5.10
    GBM                             : YES 25.0.4
    libiscsi support                : NO
    libnfs support                  : NO
    seccomp support                 : NO
    GlusterFS support               : NO
    hv-balloon support              : YES
    TPM support                     : YES
    libssh support                  : NO
    lzo support                     : NO
    snappy support                  : NO
    bzip2 support                   : YES
    lzfse support                   : NO
    zstd support                    : YES 1.5.7
    Query Processing Library support: NO
    UADK Library support            : NO
    qatzip support                  : NO
    NUMA host support               : NO
    capstone                        : NO
    libpmem support                 : NO
    libdaxctl support               : NO
    libcbor support                 : NO
    libudev                         : YES 257
    FUSE lseek                      : NO
    selinux                         : YES 3.8
    libdw                           : YES 0.192

  Subprojects
    berkeley-softfloat-3            : YES
    berkeley-testfloat-3            : YES
    keycodemapdb                    : YES
    libvduse                        : YES
    libvhost-user                   : YES

  User defined options
    Native files                    : config-meson.cross
    docs                            : disabled
    plugins                         : true

Found ninja-1.12.1 at /usr/bin/ninja
Running postconf script '/home/zcli/test/qemu-9.2.2/build/pyvenv/bin/python3 /home/zcli/test/qemu-9.2.2/scripts/symlink-install-tree.py'
```

# Fedora42安装virt-manager
virt-manager是一个图形化的虚拟机管理工具，它可以管理虚拟机的创建、启动、停止、删除等操作。安装virt-manager时会安装平台对应的Qemu组件。
```shell
zcli@fedora:~$ sudo yum install virt-manager.noarch 
仓库更新和加载中:
仓库加载完成。
Package                                                       Arch           Version                                                       Repository                             Size
Installing:
 virt-manager                                                 noarch         5.0.0-2.fc42                                                  fedora                              3.5 MiB
Installing dependencies:
 SDL2_image                                                   x86_64         2.8.8-1.fc42                                                  fedora                            209.7 KiB
 device-mapper-multipath-libs                                 x86_64         0.10.0-5.fc42                                                 fedora                            873.7 KiB
 kf5-filesystem                                               x86_64         5.116.0-4.fc42                                                fedora                              1.4 KiB
 libblkio                                                     x86_64         1.5.0-2.fc41                                                  fedora                            664.2 KiB
 libburn                                                      x86_64         1.5.6-6.fc42                                                  fedora                            357.5 KiB
 libisoburn                                                   x86_64         1.5.6-7.fc42                                                  fedora                              1.1 MiB
 libisofs                                                     x86_64         1.5.6-6.fc42                                                  fedora                            508.3 KiB
 libnfs                                                       x86_64         6.0.2-2.fc42                                                  fedora                            518.1 KiB
 libvirt-ssh-proxy                                            x86_64         11.0.0-1.fc42                                                 fedora                             19.9 KiB
 python3-libxml2                                              x86_64         2.12.10-1.fc42                                                fedora                              1.2 MiB
 qemu-audio-alsa                                              x86_64         2:9.2.3-1.fc42                                                updates                            28.5 KiB
 qemu-audio-dbus                                              x86_64         2:9.2.3-1.fc42                                                updates                           268.0 KiB
 qemu-audio-jack                                              x86_64         2:9.2.3-1.fc42                                                updates                            19.9 KiB
 qemu-audio-oss                                               x86_64         2:9.2.3-1.fc42                                                updates                            19.7 KiB
 qemu-audio-pa                                                x86_64         2:9.2.3-1.fc42                                                updates                            27.8 KiB
 qemu-audio-pipewire                                          x86_64         2:9.2.3-1.fc42                                                updates                            44.6 KiB
 qemu-audio-sdl                                               x86_64         2:9.2.3-1.fc42                                                updates                            19.7 KiB
 qemu-audio-spice                                             x86_64         2:9.2.3-1.fc42                                                updates                            15.7 KiB
 qemu-block-blkio                                             x86_64         2:9.2.3-1.fc42                                                updates                            36.1 KiB
 qemu-block-curl                                              x86_64         2:9.2.3-1.fc42                                                updates                            32.2 KiB
 qemu-block-dmg                                               x86_64         2:9.2.3-1.fc42                                                updates                            11.2 KiB
 qemu-block-gluster                                           x86_64         2:9.2.3-1.fc42                                                updates                            31.5 KiB
 qemu-block-iscsi                                             x86_64         2:9.2.3-1.fc42                                                updates                            50.5 KiB
 qemu-block-nfs                                               x86_64         2:9.2.3-1.fc42                                                updates                            28.8 KiB
 qemu-block-rbd                                               x86_64         2:9.2.3-1.fc42                                                updates                            40.9 KiB
 qemu-block-ssh                                               x86_64         2:9.2.3-1.fc42                                                updates                            42.5 KiB
 qemu-char-baum                                               x86_64         2:9.2.3-1.fc42                                                updates                            19.5 KiB
 qemu-char-spice                                              x86_64         2:9.2.3-1.fc42                                                updates                            20.4 KiB
 qemu-device-display-qxl                                      x86_64         2:9.2.3-1.fc42                                                updates                            88.6 KiB
 qemu-device-display-vhost-user-gpu                           x86_64         2:9.2.3-1.fc42                                                updates                           746.1 KiB
 qemu-device-display-virtio-gpu-ccw                           x86_64         2:9.2.3-1.fc42                                                updates                            11.4 KiB
 qemu-device-display-virtio-gpu-gl                            x86_64         2:9.2.3-1.fc42                                                updates                            46.3 KiB
 qemu-device-display-virtio-gpu-pci                           x86_64         2:9.2.3-1.fc42                                                updates                            15.5 KiB
 qemu-device-display-virtio-gpu-pci-gl                        x86_64         2:9.2.3-1.fc42                                                updates                            11.0 KiB
 qemu-device-display-virtio-gpu-pci-rutabaga                  x86_64         2:9.2.3-1.fc42                                                updates                            11.2 KiB
 qemu-device-display-virtio-gpu-rutabaga                      x86_64         2:9.2.3-1.fc42                                                updates                            38.3 KiB
 qemu-device-display-virtio-vga-gl                            x86_64         2:9.2.3-1.fc42                                                updates                            11.2 KiB
 qemu-device-display-virtio-vga-rutabaga                      x86_64         2:9.2.3-1.fc42                                                updates                            11.2 KiB
 qemu-device-usb-host                                         x86_64         2:9.2.3-1.fc42                                                updates                            48.8 KiB
 qemu-device-usb-redirect                                     x86_64         2:9.2.3-1.fc42                                                updates                            68.8 KiB
 qemu-device-usb-smartcard                                    x86_64         2:9.2.3-1.fc42                                                updates                            32.6 KiB
 qemu-kvm                                                     x86_64         2:9.2.3-1.fc42                                                updates                             0.0   B
 qemu-pr-helper                                               x86_64         2:9.2.3-1.fc42                                                updates                           973.1 KiB
 qemu-system-x86                                              x86_64         2:9.2.3-1.fc42                                                updates                             0.0   B
 qemu-ui-curses                                               x86_64         2:9.2.3-1.fc42                                                updates                            39.6 KiB
 qemu-ui-egl-headless                                         x86_64         2:9.2.3-1.fc42                                                updates                            15.5 KiB
 qemu-ui-gtk                                                  x86_64         2:9.2.3-1.fc42                                                updates                            78.3 KiB
 qemu-ui-opengl                                               x86_64         2:9.2.3-1.fc42                                                updates                            36.3 KiB
 qemu-ui-sdl                                                  x86_64         2:9.2.3-1.fc42                                                updates                            44.8 KiB
 qemu-ui-spice-app                                            x86_64         2:9.2.3-1.fc42                                                updates                            15.4 KiB
 qemu-ui-spice-core                                           x86_64         2:9.2.3-1.fc42                                                updates                            59.8 KiB
 rutabaga-gfx-ffi                                             x86_64         0.1.3-3.fc42                                                  fedora                            607.3 KiB
 virglrenderer                                                x86_64         1.1.0-2.fc42                                                  fedora                              1.1 MiB
 virt-manager-common                                          noarch         5.0.0-2.fc42                                                  fedora                              6.2 MiB
 virtiofsd                                                    x86_64         1.13.0-2.fc42                                                 fedora                              2.5 MiB
 xorriso                                                      x86_64         1.5.6-7.fc42                                                  fedora                            341.6 KiB
Installing weak dependencies:
 libvirt-daemon-kvm                                           x86_64         11.0.0-1.fc42                                                 fedora                              0.0   B

Transaction Summary:
 Installing:        58 packages

```





