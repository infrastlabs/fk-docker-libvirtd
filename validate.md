

- x64:40.252-pve [x5+4] `界面卡死/qemu-x86:cpu 100%>> 添加virtio显卡即可;@virter新编译`
  - rocky-9 #582M `rocky8:1.9G; FAIL,界面卡死/qemu-x86:cpu 110%+;加virtio显卡: 正常启动 cloudInit OK, withPubKeyLog; rocky8:OK, nonTtyCloudInitLog`
  - alma-8-102 `cloudInit OK, withPubKeyLog`
  - ubuntu-v20-104 #587M `换focal-server-cloudimg-amd64-disk-kvm.img; cloudInit OK` disk-kvm.img(x64.ubt20/22才有)
  - debian-10-105 #241M `nocloud:不行>> 换genericcloud-amd64.qcow2; cloudInit OK` genericcloud(deb11/12:都有; deb10:只x64才有)
  - debian-11-106 #270M `换debian-11-genericcloud-amd64.qcow2; cloudInit OK, withPubKeyLog`
  - alpine-v320-107 #178M `cloudInit OK, withPubKeyLog; ssh-user-alpine/vmInit:--user`
  - opensuse-micro-v61-108 #1.2G `FAIL,界面卡死/qemu-x86:cpu 100%+; 加virtio显卡: 正常启动 cloudInit OK, nonTtyCloudInitLog`
  - openeuler-v24-103 #1.49G `无cloudInit, 固定帐号 root:openEuler12#$`
  - armbian-v22-109 #4.11G `FAIL,界面卡死/qemu-x86:cpu 100%+; x64.安装seabios:依旧不行; 加virtio显卡:界面无显，可ssh: root 1234`
- arm64:40.251-hk1box [x5+5]
  - rocky-9-arm64-160 #494M `cloudInit OK`
  - alma-8-arm64-161 #568M `cloudInit OK, nonTtyCloudInitLog; alma9:smaller,OK;`
  - ubuntu-v20-arm64-162 #579.92M `all.arm64:无disk-kvm.img; cloudInit OK,ttyCloudInitLog-nonePubKeyLog`
  - debian-10-arm64-163 #290M `genericcloud:none; cloudInit OK, withPubKeyLog`
  - debian-11-arm64-164 #251M `cloudInit OK, withPubKeyLog`
  - alpine-v320-arm64-165 #212M `hand.alpine-100,OK; cloudInit OK, withPubKeyLog; ssh-user-alpine/vmInit:--user`
  - opensuse-micro-v61-arm64-166 #1.2G `1st-pull:403 Forbidden; cloudInit OK, sshKeySha256`
  - openeuler-v24-arm64-167 #1.52G `无cloudInit, 固定帐号 root:openEuler12#$`
  - armbian-v22-arm64-168 #4.11G; skip
  - ophub-armbian-deb11-arm64-169 #1.85G `tooBig@/tmp:2G> retry:ok; 固定帐号 root:1234; FAIL,启动失败:回到UEFI Shell`


**virter-env**

- infrastlabs/docker-libvirtd:v2501 #v3.13
  - qemu-5.2.0-r3 x86_64, qemu-img-5.2.0-r3 x86_64, qemu-system-aarch64-5.2.0-r3 x86_64, qemu-system-x86_64-5.2.0-r3 x86_64
  - libvirt-6.10.0-r1 x86_64, libvirt-daemon-6.10.0-r1 x86_64, libvirt-client-6.10.0-r1 x86_64, libvirt-qemu-6.10.0-r1 x86_64
- infrastlabs/docker-libvirtd:v2501-alpine319 `virt-manager: 有监控指标了`
  - qemu-8.1.5-r0 x86_64, qemu-img-8.1.5-r0 x86_64, qemu-system-aarch64-8.1.5-r0 x86_64, qemu-system-x86_64-8.1.5-r0 x86_64
  - libvirt-9.10.0-r0 x86_64, libvirt-daemon-9.10.0-r0 x86_64, libvirt-client-9.10.0-r0 x86_64, libvirt-qemu-9.10.0-r0 x86_64

