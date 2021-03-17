#!/bin/bash

read -p 'Enter device codename: ' DEVICE
read -p 'Enter kernel upstreamed version: ' VERSION

if [[ $DEVICE != X00T ]]; then
    echo Invalid Device codename. Edith build.sh according to your device codename.
    echo STOP!
    exit 1
fi
echo ''
echo Starting kernel build.
echo ''

TOP=$(realpath ../)

export KBUILD_BUILD_USER=prabhat774
export KBUILD_BUILD_HOST=linux

PATH="$TOP/tools/build-tools/linux-x86/bin:$PATH"
PATH="$TOP/tools/build-tools/path/linux-x86:$PATH"
PATH="$TOP/tools/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin:$PATH"
PATH="$TOP/tools/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin:$PATH"
PATH="$TOP/tools/clang/host/linux-x86/clang-r353983d/bin:$PATH"
PATH="$TOP/tools/misc/linux-x86/lz4:$PATH"
PATH="$TOP/tools/misc/linux-x86/dtc:$PATH"
PATH="$TOP/tools/misc/linux-x86/libufdt:$PATH"
export LD_LIBRARY_PATH="$TOP/tools/clang/host/linux-x86/clang-r353983d/lib64:$LD_LIBRARY_PATH"

rm -rf "$TOP/Output/$DEVICE-kernel"
rm -rf "$TOP/ZIPS/stock/Image.gz-dtb"
rm -rf "$TOP/ZIPS/Kernel_ZIP/STOCK"
rm -rf out

make \
    clean \
    mrproper \
    O=out \
    ARCH=arm64 \
    SUBARCH=ARM64 \
    CC=clang \
    HOSTCC=clang \
    HOSTCXX=clang++ \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-android- \
    CROSS_COMPILE_ARM32=arm-linux-androideabi- \
    ${DEVICE}_defconfig
    
make \
    -j$(nproc --all) \
    O=out \
    ARCH=arm64 \
    SUBARCH=ARM64 \
    CC=clang \
    HOSTCC=clang \
    HOSTCXX=clang++ \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-android- \
    CROSS_COMPILE_ARM32=arm-linux-androideabi-

FILE='out/arch/arm64/boot/Image.gz-dtb'
DIR="$TOP/ZIPS"
if [[ -f "$FILE" ]] 
   then    
   mkdir -p "$TOP/Output/$DEVICE-kernel"
   if [[ ! -d "$DIR" ]] 
      then
      echo ZIPS Folder not found !
      echo Image.gz-dtb file is saved in $TOP/Output/$DEVICE-kernel folder.
      exit 1
   else
   mkdir -p "$TOP/ZIPS/Kernel_ZIP/STOCK"
   cp out/arch/arm64/boot/Image.gz-dtb "$TOP/Output/$DEVICE-kernel"
   cp out/arch/arm64/boot/Image.gz-dtb "$TOP/ZIPS/stock"
   cd "$TOP/ZIPS/stock"
   zip -r "$TOP/ZIPS/Kernel_ZIP/STOCK/ProjectInfinity_STOCK-v$VERSION.zip" *
   echo ''
   echo ''
   echo 'Kernel Build Successful !!!!'
   fi
else
echo ''
echo ''
echo 'Kernel build Unsuccessfull !!!!'
echo ''
fi




