
- Mark1
  - http://172.29.40.252:8185/ #x64
  - http://172.29.40.251:8185/ #arm64
  - https://github.com/m-bers/docker-virt-manager #attached @dcp.yaml
  - https://github.com/LINBIT/virter/releases `ver: v0.21.0 > v0.28.1`
- Urls
  - https://blog.csdn.net/huang987246510/article/details/107869142 #base; /etc/libvirt/qemu.conf=ARM虚拟化环境搭建
  - https://blog.csdn.net/m0_61994139/article/details/144473653 #如何使用 QEMU 快速搭建 ARM 虚拟机
  - https://blog.csdn.net/nanhai_happy/article/details/135837822 #qemu-kvm: `kvm_init_vcpu: kvm_arch_init_vcpu failed (0): Invalid argument`
- CloudImages
  - deb: debian/ubuntu armbian/ophub
  - rpm: opensuse/fedora/ alma/rocket
  - apk: alpine


**deb/ubt**

```bash
# virter-images模板
# https://gitee.com/g-golang/fk-virter/blob/gh-pages/images.toml

# https://blog.csdn.net/m0_61994139/article/details/144473653 #如何使用 QEMU 快速搭建 ARM 虚拟机
wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-arm64.img

# arm-vm-run:
# dcp exec virter bash
vm.sh init
id=102; vt network host add --id $id; virter vm run --name=$id --id=$id --vcpus=2 --memory=256M --user=barge $mnt barge214x; sethost.sh $id; 
ssh bargee@10.255.0.$id
virsh reboot $id;

# 579.92M
id=104; vt network host add --id $id; virter vm run --name=$id --id=$id --vcpus=2 --memory=256M --user=root $mnt ubuntu-focal-arm64;

# 289.78M
id=105; vt network host add --id $id; virter vm run --name=$id --id=$id --vcpus=2 --memory=956M --user=root $mnt debian-10-arm64;



# **arm64.alpine-qcow2/x64.alma-8** OK >>> deb10/deb12/ubt2004不行??
# debian-10-arm64>> --wait-ssh: 也不可进入(同bargee?: 不支持载入文件)
  id=105; 
  virter vm rm $id
  virter vm run --name=$id --id=$id --vcpus=2 --memory=956M $mnt --user root --wait-ssh debian-10-arm64;

  root @ armbian in /etc/libvirt |17:06:11  
  $ virter vm rm $id
  INFO[0001] deleted layer                                 layer="virter:work:105"
  INFO[0001] deleted layer                                 layer="virter:work:105-cidata"
  root @ armbian in /etc/libvirt |17:06:13  
  $ virter vm run --name=$id --id=$id --vcpus=2 --memory=956M $mnt --user root --wait-ssh debian-10-arm64;
  FATA[0347] Failed to connect to VM 105 over SSH: VM not ready: ssh: handshake failed: ssh: host key mismatch ##long-wait无日志
  root @ armbian in ~ |17:07:50  
  $ virter vm ssh 105
  FATA[0000] ssh: handshake failed: ssh: host key mismatch 

# try deb12
  virter image pull deb-12-arm64 https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-arm64.qcow2 #406M
  vt network host add --id 106;
  virter vm run --id 106 --name=106 --user root --wait-ssh deb-12-arm64
  virter vm ssh 106

# try ubt2004
  id=107; vt network host add --id $id; virter vm run --name=$id --id=$id --vcpus=2 --memory=956M --user=root $mnt ubuntu-focal-arm64;

  root @ armbian in ~ |17:46:38  
  $ id=107; vt network host add --id $id; virter vm run --name=$id --id=$id --vcpus=2 --memory=956M --user=root $mnt ubuntu-focal-arm64;
  107
  root @ armbian in ~ |17:46:47  
  $ ssh root@10.255.0.107
  Warning: Permanently added '10.255.0.107' (ECDSA) to the list of known hosts.
  root@10.255.0.107: Permission denied (publickey).  ##root禁登录??

  id=107; 
  virter vm rm $id
  virter vm run --name=$id --id=$id --vcpus=2 --memory=956M --user=ubuntu $mnt ubuntu-focal-arm64; #换用ubuntu用户
  # 换ubuntu用户, sshKey也不行;
  root @ armbian in ~ |17:53:37  
  $ ssh ubuntu@10.255.0.107
  Warning: Permanently added '10.255.0.107' (ECDSA) to the list of known hosts.
  ubuntu@10.255.0.107: Permission denied (publickey).  
```

**cloud image** cloud-init/无登陆密码;

- try1: qcow2解开-修改密码; FAIL

```bash
# guestfs-tools 
# https://www.cnblogs.com/xiexun/p/17953608  #修改qcow2镜像格式默认密码以及qcow2镜像下载地址
# https://pkgs.alpinelinux.org/packages?name=*guestfs*&branch=edge&repo=&arch=aarch64&origin=&flagged=&maintainer=
root @ armbian in /etc/apk |16:28:00  
$ cat repositories 
http://mirrors.tuna.tsinghua.edu.cn/alpine/v3.13/main
http://mirrors.tuna.tsinghua.edu.cn/alpine/v3.13/community
root @ armbian in /etc/apk |16:28:02  
$ vi repositories 
root @ armbian in /etc/apk |16:28:23  
$ apk add guestfs-tools 
fetch http://mirrors.tuna.tsinghua.edu.cn/alpine/edge/testing/aarch64/APKINDEX.tar.gz
ERROR: unable to select packages:
  cmd:mkisofs (virtual):
    provided by: xorriso cdrkit
    required by: libguestfs-1.52.0-r1[cmd:mkisofs]
root @ armbian in /etc/apk |16:28:29  
$ apk add xorriso
(1/4) Installing libburn (1.5.2-r0)
(2/4) Installing libisofs (1.5.2-r0)
(3/4) Installing libisoburn (1.5.2-r0)
(4/4) Installing xorriso (1.5.2-r0)
Executing busybox-1.32.1-r9.trigger
OK: 481 MiB in 247 packages
root @ armbian in /etc/apk |16:29:02  
$ apk add guestfs-tools 
(1/6) Installing libconfig (1.7.2-r0)
(2/6) Installing fuse-common (3.10.2-r0)
(3/6) Installing fuse (2.9.9-r1)
(4/6) Installing jansson (2.13.1-r0)
(5/6) Installing libguestfs (1.52.0-r1)
(6/6) Installing guestfs-tools (1.52.0-r1)
Executing busybox-1.32.1-r9.trigger
OK: 484 MiB in 253 packages
root @ armbian in /etc/apk |16:29:08  
$ cat repositories 
http://mirrors.tuna.tsinghua.edu.cn/alpine/v3.13/main
http://mirrors.tuna.tsinghua.edu.cn/alpine/v3.13/community
http://mirrors.tuna.tsinghua.edu.cn/alpine/edge/testing


# ERR:
root @ armbian in .../libvirt/t1 |16:33:50  |sam-custom ?:9 ✗| 
$ guestfish --rw -a barge.qcow2
Warning: program compiled against libxml 212 using older 209
Welcome to guestfish, the guest filesystem shell for
editing virtual machine filesystems and disk images.
Type: ‘help’ for help on commands
      ‘man’ to read the manual
      ‘quit’ to quit the shell
><fs> run
libguestfs: error: cannot find any suitable libguestfs supermin, fixed or old-style appliance on LIBGUESTFS_PATH (search path: /usr/local/lib/guestfs)
><fs> 

# https://blog.csdn.net/nightwindnw/article/details/130747105
root @ armbian in .../libvirt/t1 |16:36:12  |sam-custom ?:9 ✗| 
$ apk add libguestfs 
OK: 484 MiB in 253 packages
root @ armbian in .../libvirt/t1 |16:36:18  |sam-custom ?:9 ✗| 
$ apk add libguestfs-appliance
ERROR: unable to select packages:
  libguestfs-appliance (no such package):
    required by: world[libguestfs-appliance]
```

**arm64.alpine-qcow2/x64.alma-8** OK (`--user alpine --wait-ssh`)

```bash
# https://github.com/LINBIT/virter/issues/27
  virter image pull alpine https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/cloud/nocloud_alpine-3.20.3-x86_64-bios-cloudinit-r0.qcow2 #178M
  virter vm run --id 100 --user alpine --wait-ssh alpine
  virter vm ssh alpine-100

  root @ armbian in .../libvirt/t1 |16:46:05  |sam-custom ?:9 ✗| 
  $ virter image pull alpine https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/cloud/nocloud_alpine-3.20.0-aarch64-uefi-cloudinit-r0.qcow2 #212M

  root @ armbian in .../libvirt/t1 |16:51:05  |sam-custom ?:9 ✗| 
  $ virter vm run --id 100 --user alpine --wait-ssh alpine
  alpine-100

  root @ armbian in /etc/libvirt |16:54:49  
  $ virter vm ssh alpine-100
    Welcome to Alpine!
    The Alpine Wiki contains a large amount of how-to guides and general
    information about administrating Alpine systems.
    See <https://wiki.alpinelinux.org>.
    Alpine release notes:
    * <https://alpinelinux.org/posts/Alpine-3.20.0-released.html>
    NOTE: 'sudo' is not installed by default, please use 'doas' instead.
    You may change this message by editing /etc/motd.
  alpine-100:~$ 
  alpine-100:~$ 


# virter-快速例子 @252-pve-x64机; OK
  virter image pull alma-8 # also would be auto-pulled in next step
  virter vm run --name alma-8-hello --id 100 --wait-ssh alma-8
  virter vm ssh alma-8-hello
  # virter vm rm alma-8-hello

  04:58:45 root@deb1013 libvirt ±|sam-custom ✗|→ vt network host add --id 100
  04:59:56 root@deb1013 libvirt ±|sam-custom ✗|→ virter vm run --name alma-8-hello --id 100 --wait-ssh alma-8
  alma-8-hello
  05:00:14 root@deb1013 libvirt ±|sam-custom ✗|→ virter vm ssh alma-8-hello
  Activate the web console with: systemctl enable --now cockpit.socket
  [root@alma-8-hello ~]# 
  [root@alma-8-hello ~]# 


# alpine-100: 尝试改密码; FAIL (alpine用户)
root @ armbian in ~ |17:23:42  
$ virter vm ssh alpine-100
  Welcome to Alpine!
  # 改密要之前的密码;
  alpine-100:~$ echo alpine:alpine |chpasswd 
  Changing password for alpine.
  chpasswd: (user alpine) pam_chauthtok() failed, error:
  Authentication failure
  chpasswd: (line 1, user alpine) password not changed
  alpine-100:~$ passwd 
  Changing password for alpine.
  Current password: 
  passwd: Authentication failure
  passwd: password unchanged

# ssh 按IP可进入; OK
root @ armbian in ~ |17:29:12  
$ ssh alpine@10.255.0.100
  Warning: Permanently added '10.255.0.100' (ECDSA) to the list of known hosts.
  Welcome to Alpine!
  alpine-100:~$
  alpine-100:~$ pwd
  /home/alpine
  alpine-100:~$ cd .ssh/
  alpine-100:~/.ssh$ ls
  authorized_keys
  alpine-100:~/.ssh$ cat authorized_keys 
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJQ3ig6FIzlyOlyqPxXPu3OynIJ8fdrRuivEcxikEz+NAfatBsk+cdEnJXLhtfN8H1NRB+P3SCbvg/G5buqrmbmzYfNiUvXgQ5K8wH1y1p1FyjvzjMItLaUYGSzX7dZLRNAUKHdlf95iUnCqbDjNnkEfminJ+1frUO8eTcNmkXeAmX77/0eWRrRiK/zOynfNmO3i0uX79GbjM7xRMMR+JGjLaFfokyyWgPJmPWM9lbjnEcG/G0ZNcCF1InRJCgjR5Vb8V03P8OWbuHxO9MIdyjisk73iCZOBL+JzrhRihUvWOk282k4fFeWjxdxpiCjlIYHHrNFxHSkH37LzOrhczX   ##与id_rsa.pub对应上的;

# 尝试 alpine-root帐号; FAIL
  # https://github.com/LINBIT/virter/issues/27
  virter image pull alpine https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/cloud/nocloud_alpine-3.20.3-x86_64-bios-cloudinit-r0.qcow2 #178M
  vt network host add --id 99; ##100: 之前其它vm加过?
  virter vm run --id 99 --user root --wait-ssh alpine #--user alpine
  virter vm ssh alpine-99

  root @ armbian in ~ |18:50:36  
  $ virter vm run --id 99 --user root --wait-ssh alpine #--user alpine
  root @ armbian in /etc/libvirt |17:21:18  
  $ virter vm ssh alpine-99
  FATA[0000] ssh: handshake failed: ssh: unable to authenticate, attempted methods [none publickey], no supported methods remain 

# try alma-9-arm64; root-ssh-OK
root @ armbian in ~ |14:13:21  
$ vt network host add --id=108
root @ armbian in ~ |14:13:34  
$ vt vm run --id 108 alma-9-arm64

root @ armbian in ~ |14:16:03  
$ vt vm ssh alma-9-arm64-108
[root@alma-9-arm64-108 ~]# 
[root@alma-9-arm64-108 ~]# free -h
               total        used        free      shared  buff/cache   available
Mem:           889Mi       192Mi       637Mi       2.0Mi       136Mi       697Mi
Swap:             0B          0B          0B
```

**deb/ubt02** (ubt:`disk-kvm`, deb:`generic/nocloud/genericcloud`) x64.OK;

```bash
# ubt20换img: focal-server-cloudimg-amd64-disk-kvm.img ##x64下可初始密钥OK; (启动UI: 有导入pubKey的log提示)
  root @ deb1013 in ~ |17:43:57  
  $ vt network host add --id=104
  root @ deb1013 in ~ |17:44:25  
  $ vt vm run --id=104 ubuntu-v20 ##不指定args, 默认:1c,1G
  ubuntu-v20-104
  # vt-ssh
  root @ deb1013 in ~ |17:45:23  
  $ vt vm ssh ubuntu-v20-104
  Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-1125-kvm x86_64)
  # ssh: ipOK, hostDomain:TODO
  root @ deb1013 in ~ |17:48:57  
  $ ssh root@ubuntu-v20-104
  ssh: Could not resolve hostname ubuntu-v20-104: Name does not resolve
  root @ deb1013 in ~ |17:49:09  
  $ ssh root@10.255.0.104
  Warning: Permanently added '10.255.0.104' (RSA) to the list of known hosts.
  Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-1125-kvm x86_64)

# debian-10: nocloud版; FAIL02; (看日志:无cloud-init相关日志??)
  root @ deb1013 in ~ |17:51:14  
  $ vt network host add --id=105
  root @ deb1013 in ~ |17:52:29  
  $ vt vm run --id=105 debian-10
  debian-10-105
  # vt-ssh
  root @ deb1013 in ~ |17:54:05  
  $ vt vm ssh debian-10-105
  FATA[0000] dial tcp 10.255.0.105:22: connect: connection refused 
  # ssh
  root @ deb1013 in ~ |17:52:54  
  $ ssh root@10.255.0.105
  ssh: connect to host 10.255.0.105 port 22: Connection refused

# debian-11: genericcloud版; OK; [deb10: 只x64有genericcloud.qcow2文件]
  root @ deb1013 in ~ |18:11:16  
  $ vt image pull debian-11
  debian-11 pull done         [=========] 269.50MiB / 269.50MiB
  INFO[0022] deleted layer                                 layer="virter:tag:debian-11"
  INFO[0022] deleted layer                                 layer="virter:layer:sha256:c50fcc260d1f6035ab333f8f38733f78197932b3f8520565f7f1a13e4cf4d75b"
  Pulled debian-11
  # net-host-add, vm-run
  root @ deb1013 in ~ |18:12:05  
  $ vt network host add --id=106
  root @ deb1013 in ~ |18:12:22  
  $ vt vm run --id=106 debian-11
  debian-11-106
  # vt-ssh
  root @ deb1013 in ~ |18:12:39  
  $ vt vm ssh debian-11-106
  Linux debian-11-106 5.10.0-33-cloud-amd64 #1 SMP Debian 5.10.226-1 (2024-10-03) x86_64
  root@debian-11-106:~# 
  # ssh
  root @ deb1013 in ~ |18:13:26  
  $ ssh root@10.255.0.106
  Last login: Thu Jan  9 10:13:15 2025 from 10.255.0.1

```

**virtio-fs** ref barge

```bash
# https://github.com/bargees/barge-os/issues/112
 huapox commented May 13, 2023 •
When with KVM-qemu, guest os with Kernel 5.4 will benifits to share folders with host. Passthrough mode with a higher performance (relative to 9p-virtio)
  refs
    https://virtio-fs.gitlab.io/ Linux 5.4, QEMU 5.0, libvirt 6.2
    https://virtio-fs.gitlab.io/howto-qemu.html


```
