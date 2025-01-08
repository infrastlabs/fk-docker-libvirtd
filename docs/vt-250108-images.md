
- virter-libvirt @k8s
  - https://github.com/kubevirt/kubevirt `2.2w/5.7k/v140; @2016年7月31日+ x337-pers` https://kubevirt.io/
  - https://github.com/Mirantis/virtlet `2.0k/733/v151/6Years-ago; @2016年2月14日+ x23-pers` kube/virtlet
  - https://github.com/karelvanhecke/libvirt-operator `160/new@2024年10月13日+; x2-pers`

### 1）OrgDocs

**OrgDocs**

- images https://gitee.com/g-golang/fk-virter/blob/sam-custom/doc/images.md
  - pull-http `virter image pull ubuntu-bionic https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img`
  - pull-reg `virter image pull local-image my.registry.com/my-namespace/my-image:tag` #`imgName: my-namespace--my-image-tag`
  - push-reg `virter image push local-image my.registry.com/my-namespace/my-image:tag`
  - save-qcow `virter image save local-image my-img.qcow2`
  - load-qcow `virter image load local-image my-img.qcow2`
  - Virter Image Registry
    - Shipped Registry `$XDG_DATA_HOME/virter` (defaults to `$HOME/.local/share/virter`).
    - User-Defined Registry `$CONFIG_DIR/images.toml` [where virters configuration file (virter.toml) is stored]
    - list-view `virter image ls --available` [The combined contents of the image registries]
- import-vagrant https://gitee.com/g-golang/fk-virter/blob/sam-custom/doc/import-vagrant.md
  - LocateURL `curl -fsSL https://oracle.github.io/vagrant-projects/boxes/oraclelinux/8.json | jq '.versions[] | select(.providers | any(.name == "libvirt")) | { "version": .version, "url": .providers[].url}'`
  - LoadIMG `curl -fsSL https://yum.oracle.com/boxes/oraclelinux/ol8/OL8U4_x86_64-vagrant-libvirt-b257.box | tar xvzO box.img | virter image load vagrant-import`
  - StartVM> ins-cloud-init> ShutDown/Commit `virsh shutdown oracle-8 /virter vm commit oracle-8`
- network https://gitee.com/g-golang/fk-virter/blob/sam-custom/doc/networks.md
  - add `virter network add net1 --dhcp --network-cidr 10.255.0.1/24`; `vm run alma-8 --id 8 --nic type=network,source=net1`
  - list `vt network list-attached net1`
- provision https://gitee.com/g-golang/fk-virter/blob/sam-custom/doc/provisioning.md
  - build `virter image build -p provisioning.toml centos7 centos7-provisioned`
  - vm-exec `virter vm exec -p provisioning.toml centos-1 centos-2 centos-3` tpl
  - vm-exec `virter vm exec --set steps[0].shell.script=env centos-1 centos-2 centos-3` cmds
  - build-push `virter image build ubuntu-focal registry.example.com/my-image:latest --push --build-id my-latest-build -p provision.toml` --no-cache
- sshconn https://gitee.com/g-golang/fk-virter/blob/sam-custom/doc/ssh.md
  - conf `~/.ssh/config` User IdentityAgent IdentityFile KnownHostsCommand 
  - dns `/etc/nsswitch.conf` libvirt NSS modules
  - net-domain `Host *.test` @ `~/.ssh/config`
- win https://gitee.com/g-golang/fk-virter/blob/sam-custom/doc/windows.md
  - make `cygwin> sshd > Enable IPv4 pings> cloud-init-for-windows> ShutDown/Copy-qcow`

### 2）http-reg.available

**http-reg-available**

```bash
root @ armbian in .../local/libvirt |13:56:22  |sam-custom ?:8 ✗| 
$ vt image ls --available
Name                URL 
alma-8              https://repo.almalinux.org/almalinux/8/cloud/x86_64/images/AlmaLinux-8-GenericCloud-latest.x86_64.qcow2
alma-9              https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2
amazonlinux-2       https://cdn.amazonlinux.com/os-images/2.0.20241217.0/kvm/amzn2-kvm-2.0.20241217.0-x86_64.xfs.gpt.qcow2 
amazonlinux-2023    https://cdn.amazonlinux.com/al2023/os-images/2023.6.20241212.0/kvm/al2023-kvm-2023.6.20241212.0-kernel-6.1-x86_64.xfs.gpt.qcow2  
barge214c           https://gitee.com/g-system/fk-barge-packer/releases/download/v23.0510/barge.qcow2                      
barge214d           https://gitee.com/g-system/fk-barge-packer/releases/download/v23.0514/barge.qcow2                      
barge214x           https://gitee.com/g-system/fk-barge-packer/releases/download/v23.0514/barge-x-v214-17.12.1-ce.qcow2    
barge215            https://ghproxy.com/https://github.com/bargees/barge-packer/releases/download/2.15.0/barge.qcow2       
centos-6            https://cloud.centos.org/centos/6/images/CentOS-6-x86_64-GenericCloud.qcow2  
centos-7            https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2  
centos-8            https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2 
debian-10           https://cloud.debian.org/images/cloud/buster/latest/debian-10-generic-amd64.qcow2                      
debian-10-arm64     https://cloud.debian.org/images/cloud/buster/latest/debian-10-generic-arm64.qcow2                      
debian-11           https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-generic-amd64.qcow2                    
debian-12           https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2                    
debian-9            https://cdimage.debian.org/cdimage/openstack/current-9/debian-9-openstack-amd64.qcow2                  
rocky-8             https://download.rockylinux.org/pub/rocky/8/images/x86_64/Rocky-8-GenericCloud.latest.x86_64.qcow2     
rocky-9             https://download.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2     
ubuntu-bionic       https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img                        
ubuntu-focal        https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
ubuntu-focal-arm64  https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-arm64.img
ubuntu-jammy        https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
ubuntu-noble        https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
ubuntu-xenial       https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img 
```

### 3）ophub-armbian

**ophub/amlogic-s9xxx-armbian** 2025.01 (Assets-232: `rootfs.tar.gz, rootfs.tar.gz.sha; .img.gz, .img.gz.sha `)

> SoC |	Device |	Kernel |	Armbian
> s905x3 |	X96-Max+, HK1-Box, Vontar-X3, H96-Max-X3, Ugoos-X3, TX3(QZ), TX3(BZ), X96-Air, X96-Max+_A100, A95X-F3-Air, Tencent-Aurora-3Pro(s905x3-b), X96-Max+Q1, X96-Max+100W, X96-Max+_2101, Infinity-B32, Whale, X88-Pro-X3, X99-Max-Plus, Transpeed-X3-Plus |	All |	amlogic_s905x3.img
> rk3588 |	Radxa-Rock5B, Radxa-Rock5C, Orange-Pi-5-Plus, Beelink-IPC-R, HLink-H88K, HLink-H88K-V3, NanoPC-T6 |	rk3588 |	rockchip_boxname.img
> rk3568 |	FastRhino-R66S, FastRhino-R68S, Radxa-E25, NanoPi-R5S, NanoPi-R5C, HLink-H66K, HLink-H68K, HLink-H69K, Seewo-sv21, Mrkaio-m68s, Swan1-w28, Ruisen-box, DG-TN3568 |	rk35xx |	rk35xx 6.x.y
> rk3566 |	Panther-X2, JP-TvBox, LCKFB-Taishan-Pi |	rk35xx 6.x.y |	rockchip_boxname.img

- **ubt24-noble**
  - https://github.com/ophub/amlogic-s9xxx-armbian/releases/download/Armbian_noble_save_2025.01/Armbian_25.02.0-noble_rootfs.tar.gz #273 MB
  - `https://github.com/ophub/amlogic-s9xxx-armbian/releases/download/Armbian_noble_save_2025.01/Armbian_25.02.0-trunk_5.02.0.img.gz` #783 MB
  - https://github.com/ophub/amlogic-s9xxx-armbian/releases/download/Armbian_noble_save_2025.01/Armbian_25.02.0_amlogic_s905x3_noble_6.1.122_server_2025.01.01.img.gz #**808 MB** <s905x3_noble_6.1.122/68>
  - https://github.com/ophub/amlogic-s9xxx-armbian/releases/download/Armbian_noble_save_2025.01/Armbian_25.02.0_amlogic_s905x3_noble_6.6.68_server_2025.01.01.img.gz #812 MB
  - https://github.com/ophub/amlogic-s9xxx-armbian/releases/download/Armbian_noble_save_2025.01/Armbian_25.02.0_rockchip_rock5b_noble_5.10.160_server_2025.01.01.img.gz #774 MB <rock5b/5c_noble_5.10.160>
- **ubt22-jammy** `allwinner,amlogic; size:BIG`
  - https://github.com/ophub/amlogic-s9xxx-armbian/releases/download/Armbian_jammy_save_2025.01/Armbian_25.02.0-jammy_rootfs.tar.gz #293 MB
  - `https://github.com/ophub/amlogic-s9xxx-armbian/releases/download/Armbian_jammy_save_2025.01/Armbian_25.02.0-trunk_5.02.0.img.gz` #1.12 GB
  - https://github.com/ophub/amlogic-s9xxx-armbian/releases/download/Armbian_jammy_save_2025.01/Armbian_25.02.0_amlogic_s905x3_jammy_6.1.122_server_2025.01.01.img.gz #**1.14 GB** <s905x3_jammy_6.1.122/68>
  - https://github.com/ophub/amlogic-s9xxx-armbian/releases/download/Armbian_jammy_save_2025.01/Armbian_25.02.0_amlogic_s905x3_jammy_6.6.68_server_2025.01.01.img.gz #1.15 GB
  - https://github.com/ophub/amlogic-s9xxx-armbian/releases/download/Armbian_jammy_save_2025.01/Armbian_25.02.0_rockchip_rock5b_jammy_5.10.160_server_2025.01.01.img.gz #1.11 GB <rock5b/5c_jammy_5.10.160>
  - 
- **deb12-bookworm**
  - https://github.com/ophub/amlogic-s9xxx-armbian/releases/download/Armbian_bookworm_save_2025.01/Armbian_25.02.0-bookworm_rootfs.tar.gz #294 MB
  - `https://github.com/ophub/amlogic-s9xxx-armbian/releases/download/Armbian_bookworm_save_2025.01/Armbian_25.02.0-trunk_5.02.0.img.gz` #687 MB
  - https://github.com/ophub/amlogic-s9xxx-armbian/releases/download/Armbian_bookworm_save_2025.01/Armbian_25.02.0_amlogic_s905x3-x88-pro-x3_bookworm_6.1.122_server_2025.01.01.img.gz #**710 MB** <s905x3_bookworm_6.1.122/68>
  - https://github.com/ophub/amlogic-s9xxx-armbian/releases/download/Armbian_bookworm_save_2025.01/Armbian_25.02.0_amlogic_s905x3-x88-pro-x3_bookworm_6.6.68_server_2025.01.01.img.gz #715 MB
  - https://github.com/ophub/amlogic-s9xxx-armbian/releases/download/Armbian_bookworm_save_2025.01/Armbian_25.02.0_rockchip_rock5b_bookworm_5.10.160_server_2025.01.01.img.gz #676 MB <rock5b/5c_bookworm_5.10.160>
- **deb11-bullseye**
  - https://github.com/ophub/amlogic-s9xxx-armbian/releases/download/Armbian_bullseye_save_2025.01/Armbian_25.02.0-bullseye_rootfs.tar.gz #277 MB
  - `https://github.com/ophub/amlogic-s9xxx-armbian/releases/download/Armbian_bullseye_save_2025.01/Armbian_25.02.0-trunk_5.02.0.img.gz` #656 MB
  - https://github.com/ophub/amlogic-s9xxx-armbian/releases/download/Armbian_bullseye_save_2025.01/Armbian_25.02.0_amlogic_s905x3_bullseye_6.1.122_server_2025.01.01.img.gz #**681 MB** <s905x3_bullseye_6.1.122/68>
  - https://github.com/ophub/amlogic-s9xxx-armbian/releases/download/Armbian_bullseye_save_2025.01/Armbian_25.02.0_amlogic_s905x3_bullseye_6.6.68_server_2025.01.01.img.gz #686 MB
  - https://github.com/ophub/amlogic-s9xxx-armbian/releases/download/Armbian_bullseye_save_2025.01/Armbian_25.02.0_rockchip_rock5b_bullseye_5.10.160_server_2025.01.01.img.gz #648 MB <rock5b/5c_bullseye_5.10.160>


