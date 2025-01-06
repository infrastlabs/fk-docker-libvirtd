
- 平台工具 `轻量化:qemu/kvm+Virter+VirtManager; 容器化:易部署迁移/统配/快速验证`
  - 核心: kvm/qemu-kvm 直接启动/virt-install创建
  - 环境: ~~docker-libvirtd multiArch镜像, dcp启动容器~~ `kvm模块无需挂载`(qemu+libvirtd; 可远程接入)
  - 面板: ~~virt-manager: docker-libvirtd远程链接~~ (选配，iso安装创建)
  - 工具: libvert-virsh静编/~~virter新版更新.arm64编译(容器内外)~~, ~~virter配置项<verter.toml, images.toml, id_rsa预设>~~
- 机器适配
  - arm64: ~~40.251-hk1box~~, 23.2-kylin
  - amd64: ~~40.252-deb1013-pve~~
- VM客户机
  - iso的手动安装(virt-mgr/virt-install) `ref:url`
  - ~~CloudImage~~ (cloud-init: `cloud_config.yaml> cidata.img> CDROM驱动器`)
- 宿主部署
  - 手动deb包: ``(x64/arm64)
  - static程序+安装脚本


```bash
# 1.平台工具包
# 2.image镜像/iso系统盘
# 3.网络模式配置<nat,bridge>
# 4.VM访问: ssh, vnc/snapshot等>> pve@docker;

# TODO2
1)23.2机virbr0无法创建问题
~~2)deb,ubt ssh帐号密钥问题~~
3)barge: 升5.4内核, 编译arm64版
```

