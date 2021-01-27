#!/bin/bash

#read -p 'Enter kernel compiler: (GCC or CLANG) ' TOOL

echo ''
echo Starting kernel build.
echo ''

export KBUILD_BUILD_USER=Ultra
export KBUILD_BUILD_HOST=GCC

TOP=$(realpath ../)

PATH="$TOP/tools/build-tools/linux-x86/bin:$PATH"
PATH="$TOP/tools/build-tools/path/linux-x86:$PATH"
PATH="$TOP/tools/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin:$PATH"
PATH="$TOP/tools/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin:$PATH"
PATH="$TOP/tools/clang/host/linux-x86/clang-r399163b/bin:$PATH"
PATH="$TOP/tools/misc/linux-x86/lz4:$PATH"
PATH="$TOP/tools/misc/linux-x86/dtc:$PATH"
PATH="$TOP/tools/misc/linux-x86/libufdt:$PATH"
export LD_LIBRARY_PATH="$TOP/tools/clang/host/linux-x86/clang-r399163b/lib64:$LD_LIBRARY_PATH"
	
	make \
	     O=out \
	     ARCH=arm64 \
	     SUBARCH=ARM64 \
	     CLANG_TRIPLE=aarch64-linux-gnu- \
	     CROSS_COMPILE=aarch64-linux-android- \
	     CROSS_COMPILE_ARM32=arm-linux-androideabi- \
	     X00T_defconfig
    
	time make \
	     O=out \
	     ARCH=arm64 \
	     SUBARCH=ARM64 \
	     CLANG_TRIPLE=aarch64-linux-gnu- \
	     CROSS_COMPILE=aarch64-linux-android- \
	     CROSS_COMPILE_ARM32=arm-linux-androideabi- \
	     -j$(nproc --all)



