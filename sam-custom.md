
## 一、2025.1

- virter升版/arm编译
  - https://gitee.com/g-golang/fk-virter/blob/gh-pages/images.toml

```bash
# ff 2023.3-issue-13
# https://github.com/LINBIT/virter/issues/13    #23.69-cent7/deb10-pve >> docker-libvirtd;
# https://wiki.debian.org/KVM#Libvirt_default_network
root @ armbian in .../local/libvirt |09:35:02  |sam-custom ?:9 ✗| 
$ virsh capabilities #q35> pc; @arch.go


# 2508
  vm.sh init
  id=102; vt network host add --id=$id; vt vm run --id=$id cirros-v063
  # ubt20: ok
  # ubt22: cgroupErr
    root @ deb11-11 in ~ |02:04:56  
    $ id=107; vt network host add --id=$id; vt vm run --id=$id cirros-v063
    FATA[0001] Failed to start VM 107: could not create (start) domain: unable to open '/sys/fs/cgroup/machine/qemu-2-cirros-v063-107.libvirt-qemu/': No such file or directory  
  # ubt24: cgroupErr
    root @ deb11-11 in ~ |09:54:34  
    $ id=105; vt network host add --id=$id; vt vm run --id=$id cirros-v063
    FATA[0001] Failed to start VM 105: could not create (start) domain: unable to open '/sys/fs/cgroup/machine/qemu-5-cirros-v063-105.libvirt-qemu/': No such file or directory  
  # ubt22/2404>> fix: @dcp
    # https://gitlab.com/libvirt/libvirt/-/issues/163
    # https://github.com/docker/compose/issues/8167
    # --cgroupns=host
    cgroup: host
    # 
    root @ deb11-11 in ~ |12:01:42  
    $ id=109; vt network host add --id=$id; vt vm run --id=$id cirros-v063
    cirros-v063-109
  # vm autostart
  # dcp: - ./data/etc-libvirt-qemu:/etc/libvirt/qemu
  # dcp换版: 24>> 22> 2004: 不能向下兼容;
  root @ deb11-11 in ~ |14:45:01  
  $ virsh list --all
  $ virsh autostart cirros-v063-102

# imgs
  root @ deb11-11 in .../apps/fk-docker-libvirtd |14:48:33  |sam-custom U:3 ?:10 _| 
  $ docker images |grep v2501
  registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-libvirtd  v2501-ubt2004   813f898fb792   8 minutes ago   721MB
  registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-libvirtd  v2501-ubt2204   101c69bc90f4   9 minutes ago   847MB
  registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-libvirtd  v2501-ubt2404   a8135794bc4c   9 minutes ago   606MB
  registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-libvirtd  v2501-alpine319      1813ebe44040   7 months ago    448MB
  registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-libvirtd  v2501      6f29925cefdb   7 months ago    504MB
```

## 二、2023.3

- jdx-arch-draft:/2023/libvirt.md
- k3s-kedge-iot:/virter/README.md
- 
- https://gitee.com/g-system/fk-barge-os (barge.iso)
- https://gitee.com/g-system/fk-barge-packer//qemu (barge.img; barge.qcow2)


### 1）quickStart

```bash
root@armbian:/opt/apps/fk-docker-libvirtd# dcp exec virter bash #补充(进入virter容器内操作)
05:52:24 root@armbian libvirt → 

# vm.sh init ##(storage, net)
06:58:38 root@pve03 ~ → vt image pull barge214d #更新qcow conf/virter.toml>pull = "IfNotExist"

# single(barge214c > barge214c_sshPubKey)
mnt='--mount=host=/_ext,vm=tag_ext'
id=120; virter vm run --name=$id --id=$id --vcpus=4 --memory=10G --user=barge $mnt barge214c; sethost.sh $id; 
# vt vm rm 120

# staticnet
# vt network add virter -m nat -n 10.255.0.1/24
id=200; vt network host add --id $id; virter vm run --name=$id --id=$id --vcpus=4 --memory=8G --user=barge $mnt barge214x; 
sethost.sh $id; 
ssh bargee@10.255.0.$id
virsh reboot $id;

# batch(staticnet)
# --mount="host=/_ext,vm=tag_ext"
for id in {222..229};do echo $id; vt network host add --id $id; virter vm run --name=$id --id=$id --vcpus=4 --memory=8G --user=barge $mnt barge214x; done
for id in {222..229};do echo $id; sethost.sh $id; done
# for id in {120..129}; do echo $id; virsh reboot $id; done
# for id in {150..159};do echo $id; vt vm rm $id; done

# cdrom try:
# mnt='--mount=host=/_ext,vm=tag_ext'
id=171; vt network host add --id $id; virter vm run --name=$id --id=$id --vcpus=4 --memory=8G --user=barge $mnt ubuntu-focal #621.25M 1M/s

```

- barge-x(barge214x)

```bash
02:20:58 root@pve2372 ~ → id=200; vt network host add --id $id; virter vm run --name=$id --id=$id --vcpus=4 --memory=8G --user=barge $mnt barge214x; 
FATA[0000] preset ID '200' already used  
barge214x pull done    [=============================================================================================] 26.44MiB / 26.44MiB
virter:layer:sha256:3556 buffer layer done [==============================================================================] 26.44MiB / 26.44MiB
virter:layer:sha256:3556 upload layer done [==============================================================================] 26.44MiB / 26.44MiB
FATA[0053] Failed to start VM 200: domain '200' already defined 
02:23:07 root@pve2372 ~ → vm vm rm 200
-bash: vm: command not found

# 未清kvm; 重启容器；
02:23:23 root@pve2372 ~ → vt vm rm 200
INFO[0000] deleted layer   layer="virter:work:200"
INFO[0000] deleted layer   layer="virter:work:200-cidata"
INFO[0000] Undefine VM  

# 再次启OK>> ssh进入
# 1.支持mutlArchImg: registry.cn-shenzhen.aliyuncs.com/infrasync/alpine:3.13.12
# 2.pt-agent支持容器管理(v1.10.3不支持)

```

### 2）fullInit 手动版，详细初始

```bash
# root @ pve2372 in ~ |22:00:27  
$lsmod|grep kvm
kvm_intel   253952  0
kvm   659456  1 kvm_intel
irqbypass  16384  1 kvm

# https://virtio-fs.gitlab.io/ #红帽在2018年12月10号在kata社区提出
# virtfsd: 共享宿主机目录 (replace: 9p-virtio) https://gitlab.com/virtio-fs/virtiofsd
Linux 5.4(guestVM机内核), QEMU 5.0(ct_5.2.0), libvirt 6.2(ct_6.10.0) >> 满足版本要求

# v0.24.0
# wget https://github.com/LINBIT/virter/releases/download/v0.24.0/virter-linux-amd64
# curl -O -fSL https://ghproxy.com/https://github.com/LINBIT/virter/releases/download/v0.21.0/virter-linux-amd64
# v0.21.0
# root @ pve2372 in ~ |21:24:01  
$ virter  -v
virter version 0.21.0

# cmdRun
docker run --privileged \
    -v $(pwd)/run:/var/run/libvirt \
    -v $(pwd)/var:/var/lib/libvirt \
    ghcr.io/speedy37/docker-libvirtd/libvirtd:main

# dcpRun (gcr.io> reBuildImg_with_alpine_misc)
# Pulling virter (registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-libvirtd:latest)...
latest: Pulling from infrastlabs/docker-libvirtd
72cfd02ff4d0: Already exists
abf743d9e8e0: Pull complete
38e34897edf8: Downloading [========>   ]   13.8MB/78.72MB
fc261701be9f: Downloading [===========>     ]  13.34MB/18.57MB
505974503259: Download complete
15782b2939e4: Verifying Checksum

dcp up -d; dcp exec virter bash

# virter.Run
id=103; virter vm run --name $id --id $id --wait-ssh barge215 #centos-7

# virter.barge
cd .local/share/virter/; cp images.toml  images.toml-bk1; vi images.toml
# [root@host23-69 virter]# cat images.toml
    ...
    [barge215]
    url= "https://ghproxy.com/https://github.com/bargees/barge-packer/releases/download/2.15.0/barge.qcow2"
# mem: 1024*1024=1048576Kb (1G);  1024*1024*1024=1073741824 byte
id=110; virter vm run --name=$id --id=$id --vcpus=4 --memory=10G --user=barge --mount="host=/_ext,vm=/_ext" barge214c
vt vm rm 110

# qemu-system-x86_64: failed to initialize kvm: Out of memory
# virsh start 123

# virsh.vm.persist
# vm.sh persist
virsh list |grep -v Name|awk '{print $2}' |egrep -v "^#|^$" |while read id; do virsh dumpxml $id> $id.xml; virsh define $id.xml; done
virsh list --all --persistent
virsh dominfo 108

# domain-cmds
  setmem     change memory allocation
  setvcpus   change number of virtual CPUs
  shutdown   gracefully shutdown a domain
  start      start a (previously defined) inactive domain
  reset
  suspend
  destroy
```

### 3）virter-ssh 预设登陆密钥

```bash
# 07:01:58 root@pve03 ~ → cat .config/virter/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJQ3ig6FIzlyOlyqPxXPu3OynIJ8fdrRuivEcxikEz+NAfatBsk+cdEnJXLhtfN8H1NRB+P3SCbvg/G5buqrmbmzYfNiUvXgQ5K8wH1y1p1FyjvzjMItLaUYGSzX7dZLRNAUKHdlf95iUnCqbDjNnkEfminJ+1frUO8eTcNmkXeAmX77/0eWRrRiK/zOynfNmO3i0uX79GbjM7xRMMR+JGjLaFfokyyWgPJmPWM9lbjnEcG/G0ZNcCF1InRJCgjR5Vb8V03P8OWbuHxO9MIdyjisk73iCZOBL+JzrhRihUvWOk282k4fFeWjxdxpiCjlIYHHrNFxHSkH37LzOrhczX
07:02:14 root@pve03 ~ → 
07:02:38 root@pve03 ~ → 
# 07:02:38 root@pve03 ~ →vt vm host-key 170 
10.255.0.170,170 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcul33vAJ1yQXqvsUkgnfeJh8i34/j8ckz2aixLr983Wa3Fx+4V4CfaVGOHNHCWKkcnmvK+yQwYcKiqwvcWz7eldW8mNBE4qhVZOU0dbPc76DJPpA0nPCgDtBJe1aEoGnpQ8EKn34wQTG2KG3ulCEjmmFyYTp1ZhMlODd8tq8pqDuwYC7LxvM6rqUin+KpXqopBfu1OcqoYAsQ+uOBOv0kzJ/19xd8tv/r/pQC3ckvz/3qzq2tj689KyOFDAnImThJQW+hGdbH3cwD/AVeOeHI2/oOaxsUKBDo8Cz9bQWwlZWMjhM5LNgktLifKEuDK1QMef0utkZCNvSmU3D68iqZ

# 07:13:40 root@pve03 vm ±|sam-custom ✗|→ cat 170.xml  |grep ssh
      <hostkey>ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5F5t5vHW1qxfd0nB9cjEapiDmnvQif+Lt6vKodt7RSZNrq9o69kBenyZt+F143tZ0510wNNVt0PpBOueEsQPr0yXS4+sR7qNtWXFyupfXcb4D7nbh1Rh65ILeGFeDkFfugPT/KzLcpH92xuMTjwRjIojHsPisntW/IAg2lLtFxcM1t8lPhMJx4c2dthuLTgjjDVP+j+oCbaGhVAVcLLlxfhczFqjx6qswJ7UZ9QdjVJKBfGxBdClnnXC8fLHN+xyygfIj9TjAvZXeyMVUKCn2zEIqVJ4IbjQsmdRzexXZFYF61vB1Mp815mGbgf8PO1eWPNbMXk9RI7OY0cxqOPEZ
      <ssh-user-name>barge</ssh-user-name>
# 07:13:45 root@pve03 vm ±|sam-custom ✗|→ vt vm host-key 170 
10.255.0.170,170 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5F5t5vHW1qxfd0nB9cjEapiDmnvQif+Lt6vKodt7RSZNrq9o69kBenyZt+F143tZ0510wNNVt0PpBOueEsQPr0yXS4+sR7qNtWXFyupfXcb4D7nbh1Rh65ILeGFeDkFfugPT/KzLcpH92xuMTjwRjIojHsPisntW/IAg2lLtFxcM1t8lPhMJx4c2dthuLTgjjDVP+j+oCbaGhVAVcLLlxfhczFqjx6qswJ7UZ9QdjVJKBfGxBdClnnXC8fLHN+xyygfIj9TjAvZXeyMVUKCn2zEIqVJ4IbjQsmdRzexXZFYF61vB1Mp815mGbgf8PO1eWPNbMXk9RI7OY0cxqOPEZ
07:14:00 root@pve03 vm ±|sam-custom ✗|→ 


# conf/virter.toml
user_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJQ3ig6FIzlyOlyqPxXPu3OynIJ8fdrRuivEcxikEz+NAfatBsk+cdEnJXLhtfN8H1NRB+P3SCbvg/G5buqrmbmzYfNiUvXgQ5K8wH1y1p1FyjvzjMItLaUYGSzX7dZLRNAUKHdlf95iUnCqbDjNnkEfminJ+1frUO8eTcNmkXeAmX77/0eWRrRiK/zOynfNmO3i0uX79GbjM7xRMMR+JGjLaFfokyyWgPJmPWM9lbjnEcG/G0ZNcCF1InRJCgjR5Vb8V03P8OWbuHxO9MIdyjisk73iCZOBL+JzrhRihUvWOk282k4fFeWjxdxpiCjlIYHHrNFxHSkH37LzOrhczX"
```


```bash
# go-src: internal/virter/vm.go
	log.Print("Create cloud-init volume")
	_, err = v.createCIData(vmConfig, hostkey) // mount a disk(vm\s name sshkeys), vm-mount-use??
	if err != nil {
		return err
	}

# barge内未找到其它盘；
# 07:23:34 root@pve03 vm ±|sam-custom ✗|→ ssh bargee@10.255.0.170
Warning: Permanently added '10.255.0.170' (ECDSA) to the list of known hosts.
Welcome to Barge 2.14.0-rc2, Docker version 1.10.3, build 20f81dd
[bargee@barge ~]$ sudo su 
[root@barge bargee]# fdisk -l
Disk /dev/vda: 40 GB, 42949672960 bytes, 83886080 sectors
83220 cylinders, 16 heads, 63 sectors/track
Units: sectors of 1 * 512 = 512 bytes

Device  Boot StartCHS    EndCHS   StartLBA     EndLBA    Sectors  Size Id Type
/dev/vda1 *  0,1,1  1,179,18  63      27359      27297 13.3M  4 FAT16 <32M
/dev/vda2    1023,15,63  1023,15,63     2124512   83886079   81761568 38.9G 83 Linux
/dev/vda3    2,74,19     187,62,26   27360    2124511    2097152 1024M 82 Linux swap

Partition table entries are not in disk order
[root@barge bargee]# 

# 07:49:29 root@pve03 vm ±|sam-custom ✗|→ cat 170.xml 
<domain type='kvm' id='35'>
  <name>170</name>
  <uuid>53387b4c-bf69-4707-be36-2cf0cec2c97c</uuid>
  <metadata>
    <meta xmlns="https://github.com/LINBIT/virter">
      <hostkey>ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCo1oUR5VJ4upGdMNTpzg/jujuv1XcgCeRNFEc6lmdHv68m6TN/6UsINTO1FrDcL39xv4JFrAz/4P9WR+C1wC8ofODzTJD38Shv76D/y8zJvDuGm/MG8hFB6hnMFecThGQDlNWaZmi8veqC5PuyVZ0yWcKb8yjGnPncDDBsi2dnjnZkKaK99k8cUHJBWTjf96H2CmWXKwpzAAwpsV6Tpk/6EGMONTfvZ+3r3l8GK6Wq1QYDB6FkFM0uSgs0FbIR01ryzfrBJacTFyXTB/ApTTWw1rWM65XZUyV+OlSIdzJ2eSYm3TNFeXutASOxp1CkZlms0Pjo0+xPo5+WJTEk1jQR
      </hostkey>
      <ssh-user-name>barge</ssh-user-name>
    </meta>
  </metadata>
  ...
  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type='volume' device='disk'>
      <driver name='qemu' type='qcow2' discard='unmap'/>
      <source pool='default' volume='virter:work:170' index='2'/>
      <backingStore type='file' index='3'>
   <format type='qcow2'/>
   <source file='/var/lib/libvirt/images/./virter:layer:sha256:09ca0fabd66ba5eb67988e7322db53fc1469508f04813fd7881213bce3cc360c'/>
   <backingStore/>
      </backingStore>
      <target dev='vda' bus='virtio'/>
      <alias name='virtio-disk0'/>
      <address type='pci' domain='0x0000' bus='0x04' slot='0x00' function='0x0'/>
    </disk>
    # cdrom>>>
    <disk type='volume' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <source pool='default' volume='virter:work:170-cidata' index='1'/>
      <backingStore/>
      <target dev='sda' bus='scsi'/>
      <readonly/>
      <alias name='scsi0-0-0-0'/>
      <address type='drive' controller='0' bus='0' target='0' unit='0'/>
    </disk>

# try mount: 
mount /dev/cdrom /dvd/ #无cdrom设备.. (barge不支持?)
# target dev='sda' #fdisk -l 无此设备


# try2 ubuntu-focal 2004
08:01:42 root@pve03 vm ±|sam-custom ✗|→ id=171; vt network host add --id $id; virter vm run --name=$id --id=$id --vcpus=4 --memory=8G --user=barge $mnt ubuntu-focal
INFO[0000] Add DHCP entry from 52:54:00:00:00:ab to 10.255.0.171 
ubuntu-focal pull done    [========================================================================================] 621.25MiB / 621.25MiB
virter:layer:sha256:a911 buffer layer done [============================================================================] 621.25MiB / 621.25MiB
virter:layer:sha256:a911 upload layer done [============================================================================] 621.25MiB / 621.25MiB
INFO[0180] Create host key     
INFO[0180] Define VM      
INFO[0180] Create boot volume  
INFO[0180] Create cloud-init volume      
INFO[0180] Start VM  
171
08:04:47 root@pve03 vm ±|sam-custom ✗|→ 
08:09:49 root@pve03 vm ±|sam-custom ✗|→ 
08:09:49 root@pve03 vm ±|sam-custom ✗|→ 
08:09:49 root@pve03 vm ±|sam-custom ✗|→ ssh 10.255.0.171
Warning: Permanently added '10.255.0.171' (ECDSA) to the list of known hosts.
root@10.255.0.171: Permission denied (publickey).
08:09:57 root@pve03 vm ±|sam-custom ✗|→ ssh ubuntu@10.255.0.171
Warning: Permanently added '10.255.0.171' (ECDSA) to the list of known hosts.
ubuntu@10.255.0.171: Permission denied (publickey).

08:14:27 root@pve03 bin ±|sam-custom ✗|→ vt vm ssh 171
FATA[0000] ssh: handshake failed: ssh: host key mismatch 
```

### 4）virshInit virsh命令/容器内环境初始(vm.sh init)

```bash
# virsh
  virsh list
  virsh -c qemu:///system "list --all"
# virsh-pool
  virsh pool-define-as --name default --type dir --target /var/lib/libvirt/images
  virsh pool-autostart default; virsh pool-start default
  # PoolPersist
  virsh pool-dumpxml default> /tmp/pool-persist.xml
  virsh pool-define /tmp/pool-persist.xml
  rm /etc/libvirt/storage/autostart/default.xml
  virsh pool-autostart default
  virsh pool-list --all --persistent 

# virsh-net
  # touch default.xml; vi default.xml  (/etc/libvirt/qemu/networks/default.xml已有)
  # virsh --connect=qemu:///system net-create default.xml
  # virsh --connect=qemu:///system net-start default
  # virsh net-edit default #改动一下，保存即非transient临时网了(不能改uuid)
  virsh net-list --all
  virsh net-info default
  # NetPersist
  virsh net-dumpxml default> /tmp/default-persist.xml
  virsh net-define /tmp/default-persist.xml
  rm /etc/libvirt/qemu/networks/autostart/default.xml
  virsh net-autostart default
  virsh net-list --all --persistent 
  # https://blog.csdn.net/weixin_30651273/article/details/99660277
  net-dumpxml   XML中的网络信息
  net-define    定义不活动的永久虚拟网络或从XML文件修改现有的永久虚拟网络

# VM-Persist: virter建后images在，但重启后vm列表丢失;
# TODO
  # https://qastack.cn/server/401704/how-do-i-make-a-persistent-domain-with-virsh
  virsh dumpxml vm_name > vm_name.xml
  virsh define vm_name.xml
  virsh list --all --persistent
  virsh dominfo vm_name #应该在Persistent：yes行中添加一行
```

**test** (23.72-pve-deb10)

```bash
# test@23.72 (drop link first)
# root @ pve2372 in /opt/fk-docker-libvirtd |22:10:26  |sam-custom ✓| 
$ ll /var/lib/libvirt
# lrwxrwxrwx 1 root root 14 May  6 02:06 /var/lib/libvirt -> /data1/libvirt/
# root @ pve2372 in /opt/fk-docker-libvirtd |22:10:52  |sam-custom ✓| 
$ rm -f /var/lib/libvirt
# root @ pve2372 in /opt/fk-docker-libvirtd |22:12:17  |sam-custom ✓| 
$ ll /var/run/ |grep libv
drwxr-xr-x  8 root     root  300 May  6 02:06 libvirt/

# /var/run -> /run/

# stat /run/libvirt: no such file or directory
# 0355de6332a2  ghcr.io/speedy37/docker-libvirtd/libvirtd:main  "/usr/bin/supervisor…"   2 months ago  Up 3 days  frosty_davinci
root @ pve2372 in /opt/fk-docker-libvirtd |22:15:23  |sam-custom ✓| 
$ docker kill 0355de6332a2
0355de6332a2
# kill后一样； (/run/libvirt目录存在的，其下有文件； 直接挂./run-libvirt)
```

### 5）预设配置验证（pool池，net网，barge-ssh登录）

- exec进入使用

```bash
# exec进入使用：
# bash-5.1# virter vm run --name cent7-hello-sam103 --id 103 --wait-ssh centos-7
INFO[0000] Config file does not exist, creating default: /root/.config/virter/virter.toml
WARN[0000] could not look up storage pool default 

# bash-5.1# virsh pool-define-as --name default --type dir --target /var/lib/libvirt/images
Pool default defined
# Requested operation is not valid: storage pool 'default' is not active 
/var/lib/libvirt/images

# bash-5.1# virter vm run --name cent7-hello-sam103 --id 103 --wait-ssh centos-7
INFO[0000] Builtin image registry does not exist, writing to /root/.local/share/virter/images.toml
# down-cent7: timeout..

# bash-5.1# find /root/
/root/
/root/.bash_history
/root/.local
/root/.local/share
/root/.local/share/virter
/root/.local/share/virter/images.toml
/root/.config
/root/.config/virter
/root/.config/virter/virter.toml
/root/.config/virter/id_rsa
/root/.config/virter/id_rsa.pub
```

- pre-conf后

```bash
# bash-5.1# virter vm run --name barge-v215-sam105 --id 105 --wait-ssh barge215
barge215 pull done    [ =========] 15.88MiB / 15.88MiB
virter:layer:sha256:fbdd buffer layer done [  ========================] 15.88MiB / 15.88MiB
virter:layer:sha256:fbdd upload layer done [  ========================] 15.88MiB / 15.88MiB
INFO[0011] Create host key     
INFO[0011] Define VM      
INFO[0012] Create boot volume  
INFO[0012] Create cloud-init volume      
INFO[0012] Add DHCP entry from 52:54:00:00:00:69 to 192.168.122.105 
# FATA[0013] Failed to start VM 105: could not add DHCP entry: Requested operation is not valid: cannot change persistent config of a transient network 
####cannot change persistent config of a transient network

# bash-5.1# cat /etc/libvirt/qemu/networks/default.xml  (容器内有)
<network>
  <name>default</name>
  <uuid>45fe999a-040d-4e84-8b95-ff49450d19db</uuid>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0'/>
  <mac address='52:54:00:d4:e5:52'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
    </dhcp>
  </ip>
</network>

# 改：start='192.168.122.12' （不能动uuid> err提示，卡死cmd）
bash-5.1# virsh net-edit default
Network default XML configuration edited.

# Net/PoolPersist (Autostart> rm/操作后yes> 再重启则为no)
bash-5.1# virsh pool-info default
Name:      default
UUID:      a5d1325c-f264-40d3-8802-c83c2bfb2ca3
State:     running
Persistent:     yes
Autostart:      no
Capacity:  12.00 GiB
Allocation:     5.24 GiB
Available:      6.75 GiB

# bash-5.1# id=107; virter vm run --name barge-v215-sam$id --id $id --wait-ssh barge215
INFO[0000] Create host key     
INFO[0000] Define VM      
INFO[0000] Create boot volume  
INFO[0000] Create cloud-init volume      
INFO[0000] Add DHCP entry from 52:54:00:00:00:6b to 192.168.122.107 
INFO[0001] Start VM  
INFO[0008] Wait for VM to get ready  ##wait中，实际上可以进了；


# TODO VM-Persist
bash-5.1# id=107; virter vm run --name barge-v215-sam$id --id $id --wait-ssh barge215
FATA[0000] Failed to start VM 107: one of the images already exists
```

- ping,ssh连接到barge

```bash
# root @ pve2372 in /opt/fk-docker-libvirtd |23:07:00  |sam-custom ?:6 ✗| 
$ ip a 
# 12: virbr0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 52:54:00:80:88:ab brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.1/24 brd 192.168.122.255 scope global virbr0
  valid_lft forever preferred_lft forever

# root @ pve2372 in /opt/fk-docker-libvirtd |23:07:54  |sam-custom ?:6 ✗| 
$ ping 192.168.122.107 
PING 192.168.122.107 (192.168.122.107) 56(84) bytes of data.
64 bytes from 192.168.122.107: icmp_seq=1 ttl=64 time=0.250 ms
# root @ pve2372 in /opt/fk-docker-libvirtd |23:08:10  |sam-custom ?:6 ✗| 
$ ssh bargee@192.168.122.107 
bargee@192.168.122.107/s password: 
Welcome to Barge 2.15.0, Docker version 1.10.3, build 662b14f
[bargee@barge ~]$ 

# bash-5.1# virsh list --all --persistent
 Id   Name      State
------------------------------------
 1    barge-v215-sam107   running
 -    barge-v215-sam105   shut off
 -    barge-v215-sam106   shut off
```


## 附

**virter-staticnet**

```bash
# 10.255.0.199

  191  2023-05-12 23:32:23 vt vm exists 
  192  2023-05-12 23:32:30 vt vm exists 143
  193  2023-05-12 23:33:22 vt vm run 122
  194  2023-05-12 23:33:35 vt vm run --id 122
  # network add
  195  2023-05-12 23:35:12 cat /root/.config/virter/virter.toml
  197  2023-05-12 23:43:13 vt network add virter
  198  2023-05-12 23:44:25 vt network add virter --dhcp --network-cidr 10.255.0.1/24
  199  2023-05-12 23:45:10 vi /root/.config/virter/virter.toml
  200  2023-05-12 23:45:48 virsh net-list 
  201  2023-05-12 23:46:08 vt network add virter --network-cidr 10.255.0.1/24
  # list-attached
  196  2023-05-12 23:38:40 mnt='--mount=host=/_ext,vm=tag_ext'
  202  2023-05-12 23:46:17 id=199; virter vm run --name=$id --id=$id --vcpus=4 --memory=10G --user=barge $mnt barge214c
  203  2023-05-12 23:48:42 vt network list-attached default 
  204  2023-05-12 23:48:58 vt network list-attached virter 
  205  2023-05-12 23:49:42 vt network ls
  206  2023-05-12 23:50:17 vt network rm virter 
  # network host add
  208  2023-05-12 23:52:28 vt network add virter -m nat -n 10.255.0.1/24
  209  2023-05-12 23:52:35 vt network host add --id 199
  210  2023-05-12 23:53:03 id=199; virter vm run --name=$id --id=$id --vcpus=4 --memory=10G --user=barge $mnt --nic type=network,source=virter barge214c

# 11:57:07 root@host23-69 vm ±|sam-custom ✗|→ cat 199.xml |grep 199
  <name>199</name>
      <source pool='default' volume='virter:work:199' index='2'/>
      <source pool='default' volume='virter:work:199-cidata' index='1'/>

# default-net-kedge: virsh启后首次docker拉起注册; 之后init.d/start.sh执行完即重置了IP；
# virer-net-host-add: virsh-stop/start看效果>> IP不变

# 创建即persist的
/etc/libvirt/qemu
/etc/libvirt/qemu/networks
/etc/libvirt/qemu/networks/autostart
/etc/libvirt/qemu/networks/autostart/default.xml
/etc/libvirt/qemu/networks/autostart/virter.xml
/etc/libvirt/qemu/networks/default.xml
/etc/libvirt/qemu/networks/virter.xml
```

**/2023/libvirt.md** (一、二、三、四、五: lite版整理)

```bash
# 一、virt-host-validate  (23.69-fat cent7-bare)
    dmesg | grep kvm
    lscpu | grep -q Virtualization || echo "No Virtualization"
    lsmod|grep kvm

# 二、libvirtd未装： (23.23-pve)
    # apt install libvirt-clients libvirt-daemon-system

    # virsh start尝试：无VM?  (23.23-pve)
    12:59:20 root@pve03 images → virsh list
    Id   Name   State
    --------------------
    # vm run参数： --arch --disk --vnc --nic --user

    # virsh -c qemu:///system "list --all"
    # https://superuser.com/questions/298426/kvm-image-failed-to-start-with-virsh-permission-denied
    01:21:23 root@pve03 images → virsh -c qemu:///system "list --all"
    Id   Name   State
    -----------------------------------
    -    alma-8-hello   shut off
    -    alma-8-hello-sam   shut off


# 三、再转23.69-cent7 (virter重编译: `q35> pc`)

# 四、Speedy37/docker-libvirtd （SUC!）   ( @host23-69-cent7 )
    # https://github.com/Speedy37/docker-libvirtd
    # /var/lib/libvirt: 复用物理机已有的images目录；#######################
    # [root@host23-69 ct-virt]# docker run --privileged     -v $(pwd)/run:/var/run/libvirt     -v /var/lib/libvirt:/var/lib/libvirt     ghcr.io/speedy37/docker-libvirtd/libvirtd:main

    # link容器的libvirt-sock################################################
    1074  cd /run/libvirt/
    1075  ln -s /root/ct-virt/run/libvirt-sock /run/libvirt/
    # ct内/host外: 重建pool
    # https://gitee.com/g-golang/fk-virter
    virsh pool-define-as --name default --type dir --target /var/lib/libvirt/images
    virsh pool-autostart default
    virsh pool-start default

    # 建立default网################################################
    # 参考1: self_kvm_nat.xml #https://zhuanlan.zhihu.com/p/359594964
    # 参考2:
    [root@host23-69 _t1]# cat /etc/libvirt/qemu/networks/default.xml
  8  touch default.xml
  9  vi default.xml 
  6  virsh capabilities |egrep "<arch|q35" -n
  7  virsh --connect=qemu:///system net-create default
    # bash-5.1# virsh --connect=qemu:///system net-create default.xml 
    Network default created from default.xml

    # bash-5.1# virsh --connect=qemu:///system net-start default
    error: Failed to start network default
    error: Requested operation is not valid: network is already active

    # startVM>> 错误：cannot change persistent config of a transient network 
    ################################################
    ### virsh net-edit default #改动一下###############################
    # https://blog.csdn.net/qq_23662505/article/details/126627342
    [root@host23-69 _t1]# virsh net-edit default #改动一下，保存即非transient临时网了
    已编辑网络 default XML 配置
    # 不用重复建了；
    [root@host23-69 _t1]# virsh --connect=qemu:///system net-autostart default
    错误：把网络default标记为自动启动失败
    错误：Failed to create symlink '/etc/libvirt/qemu/networks/autostart/default.xml' to '/etc/libvirt/qemu/networks/default.xml': File exists


    # **3）startVM-02**  OK
    ##启动成功！#############################
    [root@host23-69 _t1]# 
    [root@host23-69 _t1]# virter vm run --name cent7-hello-sam103 --id 103 --wait-ssh centos-7
    INFO[0000] Create host key  
    INFO[0000] Define VM  
    INFO[0000] Create boot volume   
    INFO[0000] Create cloud-init volume   
    INFO[0000] Add DHCP entry from 52:54:00:00:00:67 to 192.168.122.103 
    INFO[0000] Start VM   
    INFO[0001] Wait for VM to get ready 


    # **4）startVM-02 容器内连接到VM** 
    ###容器内连接到VM：#############################
    bash-5.1# apk add openssh-client
    bash-5.1# ssh  192.168.122.103
    root@192.168.122.103/s password: 
# 五、try bargee ok   
    # (1)手改img-bargee模板：+bargee:
    [root@host23-69 virter]# pwd
    /root/.local/share/virter
    root@pve2372:~# cd .local/share/virter/
    root@pve2372:~/.local/share/virter# cp images.toml  images.toml-bk1
    # 修改
    root@pve2372:~/.local/share/virter# vi images.toml
    [root@host23-69 virter]# cat images.toml
    ...
    [bargee-215]
    url= "https://ghproxy.com/https://github.com/bargees/barge-packer/releases/download/2.15.0/barge.qcow2"

    # (2)启动bargee-VM;
    root@pve2372:~/.local/share/virter# virter vm run --name bargee215-sam105 --id 105 --wait-ssh bargee-215
    bargee-215 pull done   [===========================] 15.88MiB / 15.88MiB
    INFO[0013] Create host key  
    INFO[0013] Define VM  
    INFO[0013] Create boot volume   
    INFO[0013] Create cloud-init volume   
    INFO[0013] Add DHCP entry from 52:54:00:00:00:69 to 192.168.122.105 
    INFO[0015] Start VM   
    INFO[0015] Wait for VM to get ready

    # (3)ct>> SSH进入bargee
    root@pve2372:~# docker exec -it 0355 bash
    bash-5.1# virsh list
    Id   Name   State
    ----------------------------------
    1    bargee215-sam105   running
    # 装ssh-cli，SSH进入bargee
    bash-5.1# apk add openssh-client
    bash-5.1# ssh bargee@192.168.122.105
    bargee@192.168.122.105\'s password: 
```


**virter-cmds**

```bash
# bash-5.1# vt image
Available Commands:
  pull   Pull an image
  push   Push an image
  ls     List images
  rm     Remove images
  build  Build an image
  load   Load an image
  save   Save an image
  prune  Prune unreferenced image layers

# bash-5.1# vt network
Available Commands:
  add      Add a new network
  ls  List available networks
  rm  Remove a network
  host     Network host related subcommands
  list-attached List VMs attached to a network

# bash-5.1# vt vm
Available Commands:
  run    Start a virtual machine with a given image
  rm     Remove virtual machines
  cp     Copy files and directories from and to VM
  ssh    Run an interactive ssh shell in a VM
  exec   Run provisioning steps on VMs
  exists      Check whether a VM exists
  commit      Commit a virtual machine
  host-key    Get the host key for a VM

# 03:12:48 root@host23-69 libvirt ±|sam-custom ✗|→ vt vm run 
Flags:
      --arch arch     CPU architecture to use. Will use kvm if host and VM use the same architecture (default amd64)
      --bootcapacity unit  Capacity of the boot volume (values smaller than base image capacity will be ignored) (default 10G)
  -c, --console string     Directory to save the VMs console outputs to
      --container-pull-policy pull   Whether or not to pull container images used durign provisioning. Overrides the pull value of every provision step. Valid values: [Always, IfNotExist, Never]
      --count uint    Number of VMs to start (default 1)
  -n, --name string   name of new VM
  -m, --memory unit   Set amount of memory for the VM (default 1G) ###
  -v, --mount stringArray  Mount a host path in the VM, like a bind mount. Format: "host=/path/on/host,vm=/path/in/vm" ###
  -u, --user string   Remote user for ssh session (default "root")
      --vcpus uint    Number of virtual CPUs to allocate for the VM (default 1)
      --vm-pull-policy pullPolicy    Whether or not to pull the source image. Valid values: [Always, IfNotExist, Never] (default IfNotExist)
      --vnc      whether to configure VNC (remote GUI access) for the VM (defaults to false)
      --vnc-bind-ip string      VNC IPv4 address to bind VNC listening socket to (default "127.0.0.1")
      --vnc-port int  VNC port. Defaults to 6000+id of this VM
  -d, --disk stringArray   Add a disk to the VM. Format: "name=disk1,size=100MiB,format=qcow2,bus=virtio". Can be specified multiple times
      --gdb-port uint      Enable gdb remote connection on this port (if --count is used, the ID will be added to this port number)
  -i, --nic stringArray    Add a NIC to the VM. Format: "type=network,source=some-net-name". Type can also be "bridge", in which case the source is the bridge device name. Additional config options are "model" (default: virtio) and "mac" (default chosen by libvirt). Can be specified multiple times
  -p, --provision string   name of toml file containing provisioning steps
      --pull-policy pullPolicy  Whether or not to pull the source image. (default IfNotExist)
      --secure-boot   whether to enable secure boot
  -s, --set stringArray    set/override provisioning steps
  -w, --wait-ssh      whether to wait for SSH port (default false)
  -h, --help     help for run
      --id uint  ID for VM which determines the IP address
```

**virsh-cmds**

```bash
#  Domain Management (help keyword 'domain')
    attach-device   attach device from an XML file
    attach-disk     attach disk device
    attach-interface     attach network interface
    autostart  autostart a domain
    blkdeviotune    Set or query a block device I/O tuning parameters.
    blkiotune  Get or set blkio parameters
    blockcommit     Start a block commit operation.
    blockcopy  Start a block copy operation.
    blockjob   Manage active block operations
    blockpull  Populate a disk from its backing image.
    blockresize     Resize block device of domain.
    change-media    Change media of CD or floppy drive
    console    connect to the guest console
    cpu-stats  show domain cpu statistics
    # create     create a domain from an XML file
    # define     define (but don't start) a domain from an XML file
    # destroy    destroy (stop) a domain
    desc  show or set domain\'s description or title
    detach-device   detach device from an XML file
    detach-device-alias  detach device from an alias
    detach-disk     detach disk device
    detach-interface     detach network interface
      domdisplay      domain display connection URI
      domfsfreeze     Freeze domain\'s mounted filesystems.
      domfsthaw  Thaw domain\'s mounted filesystems.
      domfsinfo  Get information of domain\'s mounted filesystems.
      domfstrim  Invoke fstrim on domain\'s mounted filesystems.
      domhostname     print the domain\'s hostname
      domid      convert a domain name or UUID to domain id
      domif-setlink   set link state of a virtual interface
      domiftune  get/set parameters of a virtual interface
      domjobabort     abort active domain job
      domjobinfo      domain job information
      domname    convert a domain id or UUID to domain name
      domrename  rename a domain
      dompmsuspend    suspend a domain gracefully using power management functions
      dompmwakeup     wakeup a domain from pmsuspended state
      domuuid    convert a domain name or id to domain UUID
      domxml-from-native   Convert native config to domain XML
      domxml-to-native     Convert domain XML to native config
    dump  dump the core of a domain to a file for analysis
    dumpxml    domain information in XML
    edit  edit XML configuration for a domain
    event      Domain Events
    get-user-sshkeys     list authorized SSH keys for given user (via agent)
    inject-nmi      Inject NMI to the guest
    send-key   Send keycodes to the guest
    send-process-signal  Send signals to processes
    lxc-enter-namespace  LXC Guest Enter Namespace
      iothreadinfo    view domain IOThreads
      iothreadpin     control domain IOThread affinity
      iothreadadd     add an IOThread to the guest domain
      iothreadset     modifies an existing IOThread of the guest domain
      iothreaddel     delete an IOThread from the guest domain
      managedsave     managed save of a domain state
      managedsave-remove   Remove managed save of a domain
      managedsave-edit     edit XML for a domain\'s managed save state file
      managedsave-dumpxml  Domain information of managed save state file in XML
      managedsave-define   redefine the XML for a domain\'s managed save state file
      migrate    migrate domain to another host
      migrate-setmaxdowntime    set maximum tolerable downtime
      migrate-getmaxdowntime    get maximum tolerable downtime
      migrate-compcache    get/set compression cache size
      migrate-setspeed     Set the maximum migration bandwidth
      migrate-getspeed     Get the maximum migration bandwidth
      migrate-postcopy     Switch running migration from pre-copy to post-copy
      qemu-attach     QEMU Attach
      qemu-monitor-command      QEMU Monitor Command
      qemu-monitor-event   QEMU Monitor Events
      qemu-agent-command   QEMU Guest Agent Command
      guest-agent-timeout  Set the guest agent timeout
    save  save a domain state to a file
    save-image-define    redefine the XML for a domain\'s saved state file
    save-image-dumpxml   saved state domain information in XML
    save-image-edit      edit XML for a domain\'s saved state file
    memtune    Get or set memory parameters
    perf  Get or set perf event
    metadata   show or set domain\'s custom XML metadata
    numatune   Get or set numa parameters
      # reboot     reboot a domain
      # reset      reset a domain
      # restore    restore a domain from a saved state in a file
      # resume     resume a domain
    schedinfo  show/set scheduler parameters
    screenshot      take a screenshot of a current domain console and store it into a file
    set-lifecycle-action      change lifecycle actions
    # set-user-sshkeys     manipulate authorized SSH keys file for given user (via agent)
    # set-user-password    set the user password inside the domain
    # setmaxmem  change maximum memory limit
    # setmem     change memory allocation
    # setvcpus   change number of virtual CPUs
    # shutdown   gracefully shutdown a domain
    # start      start a (previously defined) inactive domain
    # suspend    suspend a domain
    ttyconsole      tty console
    undefine   undefine a domain
    update-device   update device from an XML file
      vcpucount  domain vcpu counts
      vcpuinfo   detailed domain vcpu information
      vcpupin    control or query domain vcpu affinity
    emulatorpin     control or query domain emulator affinity
    vncdisplay      vnc display
    guestvcpus      query or modify state of vcpu in the guest (via agent)
    setvcpu    attach/detach vcpu or groups of threads
    domblkthreshold      set the threshold for block-threshold event for a given block device or it\'s backing chain element
    guestinfo  query information about the guest (via agent)
```



