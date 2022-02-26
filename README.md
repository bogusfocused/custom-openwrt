## Packages

[nginx](packages/nginx-bare) 
 A pure nginx only package that is configured using /etc/nginx.conf. The official nginx package has buggy and odd utils that is difficult to manage. You do not need to learn anything new.

[rclone](packages/rclonex)
A rclone package that respects *all* rclone options. The official package has again utils and config that break this. This package optionally keeps config synchronized with changes made in rclone web ui. 

[usb-net-lan78xx](packages/usb-net-lan78xx)
This is linux kernel driver that is missing in stable builds but its on the way. This is temporary till it finds its way to stable build.

## Build
To build ipk packages for your arch. Substitute \<ARCH> with your arch. 

```console
git clone 
cd myopenwrt
docker --rm -v `pwd`:/data --entrypoint /data/build/build.sh openwrtorg/sdk:<ARCH>-openwrt-21.02
```

for example if you want to build for *x86_64* use 
```console
docker --rm -v `pwd`:/data --entrypoint /data/build/build.sh openwrtorg/sdk:x86_64-openwrt-21.02
```

You can find sdk for your version and architecture from [official docker hub](https://hub.docker.com/r/openwrtorg/sdk).
