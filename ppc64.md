
## kvm

```bash
# baiduAI: 查看PPC64LE是否支持KVM
[root@MICS-CYY-1 oemaker]# grep -E -o '(vmx|svm)' /proc/cpuinfo
# modprobe
[root@MICS-CYY-1 oemaker]# lsmod | grep kvm
[root@MICS-CYY-1 oemaker]# modprobe kvm
[root@MICS-CYY-1 oemaker]# lsmod | grep kvm
kvm                   293757  0
[root@MICS-CYY-1 oemaker]# modprobe kvm-ppc
modprobe: FATAL: Module kvm-ppc not found in directory /lib/modules/5.10.0-60.47.0.75.ppc64le

# kvm-ok
[root@MICS-CYY-1 oemaker]# kvm-ok
-bash: kvm-ok: command not found
```


## ppc64

- virter
  - https://github.com/LINBIT/virter/releases `x64 only v0.29.0@25.3.28`
  - https://github.com/infrastlabs/fk-virter/releases `+arm64 latest@25.1.7`
- virt-mgr
  - https://github.com/virt-manager/virt-manager/blob/main/NEWS.md `v410@August 04, 2022; 2006年3月26日+`
  - https://registry.cyou/r/mber5/virt-manager/tags `RE; 23.2-arm-use; 182.75 MB=mber5/virt-manager Tags | Docker Hub`
  - https://github.com/m-bers/docker-virt-manager/blob/main/Dockerfile `FROM mber5/broadway-baseimage:latest`
  - https://github.com/m-bers/broadway-baseimage/blob/main/Dockerfile `FROM ubuntu:latest`
  - https://github.com/m-bers/docker-virt-manager `GTK3 Broadway; RE; m-bers/docker-virt-manager: Docker virt-manager`
  - https://github.com/tsl0922/ttyd/releases `non-ppc64le`

```bash
# image: registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-libvirtd:v2501-alpine319
# qemu-system-ppc64 
  # https://pkgs.alpinelinux.org/packages?name=*qemu-system-*&branch=edge&repo=&arch=x86_64&origin=&flagged=&maintainer=
# virter
  file=virter-linux-$arch;
  https://github.com/infrastlabs/fk-virter/releases/download/v24.12/$file;

# image: ${REPO}infrasync/v2025:mber5--virt-manager---latest
# mber5/virt-manager
  # https://registry.cyou/r/mber5/virt-manager/tags
  #  latest <x64,arm64 only>

```



