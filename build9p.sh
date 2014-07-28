#!/bin/bash

for version
do
  dir="/root/build/$version"
  mkdir -p "$dir"
  cd "$dir"
  vpref=
  if [ "$version" == "1.1.2" ]
  then
    vpref=.
  fi
  curl "https://raw.githubusercontent.com/boot2docker/boot2docker/v$vpref$version/kernel_config" > config
  kernel="$(sed -n 's/# Linux.* \([0-9\.]\+\) .*/\1/p; 4 q' config)"
  echo "$kernel" > kernel
  curl "https://www.kernel.org/pub/linux/kernel/v3.x/linux-$kernel.tar.xz" | tar -xJ
  kdir="$dir/linux-$kernel"
  cp config "$kdir/.config"     
  cd "$kdir"
  echo 'CONFIG_NET_9P=m
CONFIG_9P_FS=m
# CONFIG_NET_9P_VIRTIO is not set
# CONFIG_NET_9P_DEBUG is not set
CONFIG_9P_FS_POSIX_ACL=y
CONFIG_9P_FS_SECURITY=y' >> .config
  make prepare
  make modules_prepare
  make -C "$kdir" M="$kdir/net/9p" modules
  make -C "$kdir" M="$kdir/fs/9p" modules
  cp net/9p/9pnet.ko "$dir"
  cp fs/9p/9p.ko "$dir"
  rm -rf "$kdir"
done
