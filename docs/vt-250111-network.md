- vt-network
  - ok: `nat bridge route`
    - `vt network add virter  -m nat` -n 10.255.0.1/24
    - `vt network add virter3 -m route` -n 10.255.3.1/24
    - `vt network add virter2 -m bridge`
  - ok:`none`; ERR:`direct internal user` `local,host-only`; 
    - `vt network add virter7 -m none`
  - virt-manager ``open` [UI: nat,routed,open,isolated,sr-iov]
    - `vt network add virter9 -m open` -n 10.255.4.1/24 
- TODO项
  - br桥接网卡: 手动设定IP/旁路dhcp
  - virter-nat网: 自动dhcp/手动指定IP`vt network host add --id=xx`
  - vm内bond聚合: cirros>openEuler-v2203`nmcli操作`

```bash
root @ deb11-11 in ~ |16:53:49  
$ vt network add -h
  Add a new network. VMs can be attached to such a network in addition to the default network used by virter. DHCP entries can be added directly to the new network.
  Usage:
    virter network add <name> [flags]
  Flags:
    -p, --dhcp                     #Configure DHCP. Use together with '--network-cidr'. DHCP range is configured starting from --network-cidr+1 until the broadcast address
        --dhcp-count uint          Number of host entries to add
        --dhcp-id uint             ID which determines the MAC and IP addresses to associate
        --dhcp-mac string          Base MAC address to which ID is added. The default can be used to populate a virter access network (default "52:54:00:00:00:00")
    -d, --domain string            Configure DNS names for the network
    -m, --forward-mode string      Set the forward mode, for example 'nat'
    -h, --help                     help for add
    -n, --network-cidr string      Configure the network range (IPv4) in CIDR notation. The IP will be assigned to the host device.
    -6, --network-v6-cidr string   Configure the network range (IPv6) in CIDR notation. The IP will be assigned to the host device.
  Global Flags:
        --config string      config file (default is /root/.config/virter/virter.toml)
        --logformat string   Log format, current options: short (default "default")
    -l, --loglevel string    Log level, default may be set with environment variable "VIRTER_LOG_LEVEL" (default "info")
```


### 1）VT操作

- ok: `nat bridge route`

```bash
# ok: nat bridge route
vt network add virter  -m nat -n 10.255.0.1/24 #iptable内核模块 REJECT ERR
vt network add virter2 -m bridge #-n 10.255.2.1/24 #active, 但virsh net-start失败(网络存在?);
vt network add virter3 -m route -n 10.255.3.1/24 #OK1, iptable内核模块 REJECT ERR
vt network add virter8 -m bridge #try02, bridge-n2n?


# bridge
root @ linaro-alip in ~ |07:55:59  
$ vt network add virter -n 10.255.0.1/24 -m bridge 
FATA[0000] could not define network 'virter': unsupported configuration: Unsupported <ip> element in network virter with forward mode='bridge' 
# bridge.virter2
root @ linaro-alip in ~ |07:58:58  
$ vt network add virter2 -m bridge 
root @ deb1013 in ~ |08:08:12  
$   virsh net-start $net
error: Failed to start network virter2
error: Requested operation is not valid: network is already active

  net=virter3 #2
  virsh net-define /etc/libvirt/qemu/networks/$net.xml
  virsh net-dumpxml $net> /tmp/$net-persist.xml
  virsh net-define /tmp/$net-persist.xml
  rm -f /etc/libvirt/qemu/networks/autostart/$net.xml
  virsh net-autostart $net
  virsh net-start $net
  # view
  virsh net-list --all --persistent 

# route.virter3
root @ deb1013 in ~ |08:05:35  
$ vt network add virter3 -m route
FATA[0000] could not define network 'virter3': XML error: route forwarding requested, but no IP address provided for network 'virter3' 
root @ deb1013 in ~ |08:05:51  
$ vt network add virter3 -m route -n 10.255.3.1/24
root @ deb1013 in ~ |08:08:16  
$ route  -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         240.0.0.1       0.0.0.0         UG    1      0        0 tunsocks1
10.255.0.0      0.0.0.0         255.255.255.0   U     0      0        0 virbr1
10.255.3.0      0.0.0.0         255.255.255.0   U     0      0        0 virbr2 ##virter3-add


# bridge02.virter8
root @ linaro-alip in ~ |09:28:16  
  $ vt network add virter7 -m bridge
  FATA[0000] could not define network 'virter7': operation failed: network 'virter7' already exists with uuid 570d8775-de16-4604-8735-20affbf64e19 
  root @ linaro-alip in ~ |09:29:28  
  $ vt network add virter8 -m bridge
```

- ERR:`direct internal user`; ERR:`local,host-only`; ok:`none`;

```bash
# ERR:direct internal user; 
# ERR:local,host-only; ok:none;
vt network add virter4 -m direct #ERR
vt network add virter5 -m internal #ERR
vt network add virter6 -m user #ERR
vt network add virter7 -m none; #local,host-only ##iptable内核模块 REJECT ERR

# direct 
root @ deb1013 in ~ |08:08:22  
$ vt network add virter4 -m direct
FATA[0000] could not define network 'virter4': unsupported configuration: unknown forwarding type 'direct'
# internal
root @ deb1013 in ~ |08:12:58  
$ vt network add virter5 -m internal
FATA[0000] could not define network 'virter5': unsupported configuration: unknown forwarding type 'internal' 
# user
root @ deb1013 in ~ |08:15:03  
$ vt network add virter6 -m user
FATA[0000] could not define network 'virter6': unsupported configuration: unknown forwarding type 'user'

# ERR:local,host-only; ok:none;
root @ linaro-alip in ~ |09:26:36  
$ vt network add virter7 -m host-only
  FATA[0000] could not define network 'virter7': unsupported configuration: unknown forwarding type 'host-only' 
  root @ linaro-alip in ~ |09:26:38  
  $ vt network add virter7 -m host
  FATA[0000] could not define network 'virter7': unsupported configuration: unknown forwarding type 'host'
# local
root @ linaro-alip in ~ |09:28:03  
$ vt network add virter7 -m local
  FATA[0000] could not define network 'virter7': unsupported configuration: unknown forwarding type 'local' 
# none:ok
root @ linaro-alip in ~ |09:28:08  
$ vt network add virter7 -m none
  FATA[0000] failed to start network 'virter7': internal error: Failed to apply firewall rules /sbin/iptables -w --table filter --insert LIBVIRT_FWO --in-interface virbr3 --jump REJECT: iptables v1.8.6 (legacy): Couldn't load target `REJECT':No such file or directory
  Try 'iptables -h' or 'iptables --help' for more information. 

```

### 2）virtMgr参考

- virt-manager `#nat bridge route, none;` `#open, isolated, SR-IOV`

```bash

# open:OK;
# vt network add virter9 -m open -n 10.255.4.1/24 #ok2;
root @ linaro-alip in ~ |07:01:55  
  $ vt network add virter9 -m open 
  FATA[0000] could not define network 'virter9': XML error: open forwarding requested, but no IP address provided for network 'virter9'
  root @ linaro-alip in ~ |07:02:14  
  $ vt network add virter9 -m open -n 10.255.4.1/24 

# isolated
root @ linaro-alip in ~ |07:02:58  
$ vt network add virter10
  FATA[0000] failed to start network 'virter10': internal error: Failed to apply firewall rules /sbin/iptables -w --table filter --insert LIBVIRT_FWO --in-interface virbr5 --jump REJECT: iptables v1.8.6 (legacy): Couldn't load target `REJECT':No such file or directory
  Try 'iptables -h' or 'iptables --help' for more information.
```

### 3）RK3588's VM

> （Linaro系统下，iptables.REJECT不支持; 改open网尝试）

```bash
##调整默认virter为open网络;
##virter(vt's default)############
# vt network rm virter
root @ linaro-alip in ~ |07:24:39  
$ vt network ls
  WARN[0000] could not look up network virter              error="Network not found: no network with matching name 'virter'"
  Name      Forward-Type  IP-Range          Domain  DHCP          Bridge  
  virter10     virbr5  
  virter9   open          10.255.4.1/24          virbr4  
# vt network add virter -m open -n 10.255.0.1/24 
root @ linaro-alip in ~ |07:25:25  
$ vt network ls
  Name    Forward-Type  IP-Range          Domain  DHCP          Bridge  
  virter2 bridge     
  virter8 bridge     
  virter7    virbr3  
  virter3 route         10.255.3.1/24          virbr2  
  default nat           192.168.122.1/24          192.168.122.2-192.168.122.254  virbr0  
  virter10   virbr5  
  virter9 open          10.255.4.1/24          virbr4  
  virter (virter default)  open          10.255.0.1/24          virbr1 

##启VM,进到下一个错
# VM ##########
root @ linaro-alip in ~ |07:26:41  
$ vt network host add --id=101
root @ linaro-alip in ~ |07:28:53  
$ vt image ls
  Name             Top Layer                                                                Created        
  debian-11-arm64  sha256:f84198324eb8ebc7abe91ced9445753b51c44873b143ad34892792f8b986b4fa  7 minutes ago  
root @ linaro-alip in ~ |07:29:01  
$ vt vm run --id=101 debian-11-arm64
  FATA[0000] Failed to start VM 101: could not define domain: unsupported configuration: Emulator '/usr/bin/qemu-system-aarch64' does not support virt type 'kvm' 
  root @ linaro-alip in ~ |07:29:15  
  $ virsh capabilities

# 最终: 调整vt模型后>> 该机现有kernel未打开KVM特性; 不能跑libvirtd-qemu-kvm
```

### 4）250821|bridge桥接网卡

- info
  - vt建的bridge网 开启时不提示不可用(`vt network add virter2 -m bridge` vm-start-err: `virter2 is a direct mode, but has no forward dev and no interface pool`)
  - virtMgr:只nat/routed/open,无bridge

```bash
# libvirt+添加桥接网络 #https://metaso.cn/search/8646786746017411072?q=libvirt+%E6%B7%BB%E5%8A%A0%E6%A1%A5%E6%8E%A5%E7%BD%91%E7%BB%9C

# 1. 准备工作
  # 安装bridge-utils和libvirt相关的软件包
  sudo apt install bridge-utils libvirt-daemon-system libvirt-clients virt-manager

  # 禁用NetworkManager（如果需要）：某些情况下，NetworkManager可能会覆盖手动配置，因此需要禁用它
  sudo systemctl disable NetworkManager; sudo systemctl stop NetworkManager
  sudo systemctl enable network; sudo systemctl start network

# 2. 创建物理桥接接口
  # 创建桥接接口：假设物理接口为eth0，创建名为br0的桥接接口。
  sudo brctl addbr br0
  sudo brctl addif br0 eth0
  sudo ip link set br0 up
  sudo ip link set eth0 up

  # 配置IP地址：将物理接口的IP地址转移到桥接接口上。
  sudo ip addr del 192.168.1.131/24 dev eth0
  sudo ip addr add 192.168.1.131/24 dev br0

  # 持久化配置：编辑网络配置文件以确保重启后配置仍然有效
    # 对于Debian/Ubuntu系统，编辑/etc/network/interfaces
    auto eth0
    iface eth0 inet manual

    auto br0
    iface br0 inet static
        address 192.168.1.131
        netmask 255.255.255.0
        gateway 192.168.1.1
        bridge_ports eth0
        bridge_stp off
        bridge_fd 0
        bridge_maxwait 0

    # CentOS/RHEL系统，编辑/etc/sysconfig/network-scripts/ifcfg-eth0和/etc/sysconfig/network-scripts/ifcfg-br0
    # ifcfg-eth0
    DEVICE=eth0
    NAME=eth0
    TYPE=Ethernet
    BOOTPROTO=none
    ONBOOT=yes
    BRIDGE=br0

    # ifcfg-br0
    DEVICE=br0
    NAME=br0
    TYPE=Bridge
    BOOTPROTO=static
    IPADDR=192.168.1.131
    NETMASK=255.255.255.0
    GATEWAY=192.168.1.1
    ONBOOT=yes
    DELAY=0

# 3. 配置libvirt网络
  # 创建libvirt网络XML文件：创建一个XML文件来定义libvirt网络
  <network connections='1'>
    <name>br0</name>
    <forward mode='bridge'/>
    <bridge name='br0'/>
    # mac,ip不允许存在; virtualport.openvswitch:允许存在但vm机启动报错>改配需先top/rm之再新加; 
    <virtualport type='openvswitch'/>
    <mac address='52:54:00:48:3f:0c'/>
    <ip address='192.168.1.1' netmask='255.255.255.0'>
      <dhcp>
        <range start='192.168.1.100' end='192.168.1.200'/>
      </dhcp>
    </ip>
  </network>

  # 定义并启动libvirt网络：
  sudo virsh net-define /path/to/your/network.xml
  sudo virsh net-start br0
  sudo virsh net-autostart br0

# 4. 验证配置
  # 检查桥接状态：
  brctl show
  ip addr show br0

  # 检查libvirt网络状态：
  virsh net-list --all
  virsh net-info br0

```


- 250827|genM-deb11:参考上1条先手动加br0后,virsh配置xml指向br0

```bash
##################################
# 01:br0网卡可用于vm，但无dhcp
  244  2025-08-27 10:50:39 ip a |grep "inet "
  # 手动加br0
  246  2025-08-27 10:53:29 brctl addbr br0
  247  2025-08-27 10:53:41 apt install bridge-utils
  # 已装/需sudo brctl xx
  249  2025-08-27 10:53:54 sudo brctl addbr br0
  251  2025-08-27 10:54:23 sudo brctl addif br0  enx000ec6a566e5
  252  2025-08-27 10:54:32 sudo ip link set br0 up
  253  2025-08-27 10:54:42 sudo ip link set enx000ec6a566e5 up
  254  2025-08-27 10:55:02 ip a |grep "state UP"
  255  2025-08-27 10:55:54 sudo ip addr add 172.29.40.238/24 dev br0
  # virsh加网
  256  2025-08-27 10:57:05 cd /_ext/; mkdir t2_virt_br0; cd t2_virt_br0/
  259  2025-08-27 10:57:38 touch br0.xml
  260  2025-08-27 10:57:40 vi br0.xml 
  261  2025-08-27 10:59:16 cp br0.xml  br0.xml-bk0
  262  2025-08-27 10:59:30 vi br0.xml #改配:mac,ip不允许存在; virtualport.openvswitch:允许存在但vm机启动报错>改配需先top/rm之再新加; 
  # root @ deb11-11 in /_ext/t2_virt_br0 |13:12:13  
  $ cat br0.xml
    <network connections='1'>
      <name>br0</name>
      <forward mode='bridge'/>
      <bridge name='br0'/>
    </network>
  263  2025-08-27 10:59:41 sudo virsh net-define br0.xml 
  264  2025-08-27 10:59:49 sudo virsh net-start br0
  265  2025-08-27 10:59:54 sudo virsh net-autostart br0
  # 调改再加网后:
  #  1.vm可启
  #  2.cirros双卡都未取得IP:[virter网:使用的新卡mac不一样了]
  #  3.virtMgr可看到网卡mac, 卡2手动设定IP后:内外可互ping通

###########
# 隔天,拔usb卡后 重使用:
  # enx000ec6a566e5 #网卡明未变
  sudo ip link set enx000ec6a566e5 up
  sudo brctl addif br0  enx000ec6a566e5
  # 手动up后灯亮+addif后vm方可ping通

##################################
# 02:尝试旁路dhcp tftpd32@本子40.241
#  1.原未开tftpd:br0-vm-cirros获取的ipv6地址;
#  2.开tftpd:一样情况; <pool.30: 40.128有一条对应cirros-vm-mac:00:66的分配记录, 其它全被某一固定mac占满了>
#  3.pool全占满: 30>5; 拔交换机进线/拔本子usb网卡;> 清理已配纪录:右键删/conf文件删还会加回来; > 再插本子usb网卡/cirros-vm重启:有crirros的记录了>>但其获取的依旧为ipv6..;
#  4.cirros下无nmcli,改用openeuler-v22: virter加挂两张新卡;

# ff
  vm.sh init
  id=102; vt network host add --id=$id; vt vm run --id=$id cirros-v063

# https://gitee.com/g-golang/fk-virter
# Usage: virter vm run:
  Adding additional disk(s): --disk "name=disk1,size=20GiB,format=qcow2,bus=virtio"
  Adding a bridged interface --nic "type=bridge,source=br0,mac=1a:2b:3c:4d:5e:01"
  Adding a NAT\ed interface: --nic "type=network,source=default,mac=1a:2b:3c:4d:5e:02"

# 默认virter, +另两张网卡;
# virter vm run openeuler-v22 --nic "type=bridge,source=br0,mac=1a:2b:3c:4d:5e:01" --nic "type=network,source=default,mac=1a:2b:3c:4d:5e:02"
# --id=103 
$ virter vm run openeuler-v22 --id=103 --nic "type=bridge,source=br0,mac=1a:2b:3c:4d:5e:01" --nic "type=network,source=default,mac=1a:2b:3c:4d:5e:02"
FATA[0000] Failed to start VM 103: DHCP host entry for ID '103' not found (static DHCP mode) 
vt network host add --id=103 #再retry:ok

# auth
# https://docs.openeuler.org/zh/docs/24.03_LTS_SP1/docs/Releasenotes/帐号清单.html
root	openEuler12#$  ##24.03; 22.03可用
# 登录后:3张卡，两张已设IP，br0卡无IP(tftpd有新的分配记录); 有nmcli命令;


##################################
# 03:获取到IPV6,无IPV4

# tryC1:系统禁用IPV6(ctVirter内操作)
cat >> /etc/sysctl.conf<<EOF
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF

# 禁用netfilter对桥接流量的处理
cat >> /etc/sysctl.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 0
net.bridge.bridge-nf-call-iptables = 0
net.bridge.bridge-nf-call-arptables = 0
EOF
sudo sysctl -p #sudo有效:默认PATH无/sbin; sysctl@procps包;

# tryC2:拔主网线免干扰，新启vm:还是取的ipv6;
#  1.拔主网线后:台机需重auth认证方可上网;
vt network host add --id=104
virter vm run openeuler-v22 --id=104 --nic "type=bridge,source=br0,mac=1a:2b:3c:4d:51:01" --nic "type=network,source=default,mac=1a:2b:3c:4d:51:02"


# tryC3:排查ct-virter内dnsmasq:停止了还是取得ipv6;
#  1.停止default/virter两个nat网:相应dnsmasq程序停止,对应udp67端口释放
#  2.vm机: cirros/openeu-104:直接重启不受nat网停用的影响; 关停再启:则提示网络未启用>> 
#  3.oe-104删另两网络+改mac后做启动: 获取到的ip还是v6版; (tftpd太旧不兼容??)
# 
#  4.停止tftpd+改mac后启: 还是ipv6; (网络中有多个dhcp服务器 分配逻辑会怎么样:  客户端通常会选择最先收到响应的DHCP服务器进行IP分配。其他服务器会释放为客户端保留的IP地址)
#   https://metaso.cn/search/8648951728296378368?q=%E7%BD%91%E7%BB%9C%E4%B8%AD%E6%9C%89%E5%A4%9A%E4%B8%AAdhcp%E6%9C%8D%E5%8A%A1%E5%99%A8+%E5%88%86%E9%85%8D%E9%80%BB%E8%BE%91%E4%BC%9A%E6%80%8E%E4%B9%88%E6%A0%B7
# 
#  5.拔桥接usb网卡的网线; br0及usb网卡都在且为up; >> oe-104:改mac后启:取得ipv6;
```

- 250827|home.ap34-virter

```bash
  # 手动加br0
  brctl addbr br0; apt install bridge-utils
  # 已装/需sudo brctl xx; env.PATH
  iface=enp1s0
  sudo brctl addbr br0
  sudo brctl addif br0  $iface
  sudo ip link set br0 up
  sudo ip link set $iface up

  ip a |grep "state UP"
  sudo ip addr add 172.17.0.123/24 dev br0
  sudo ip addr del 172.17.0.123/24 dev $iface
  # virsh加网
  # cd /_ext/; mkdir t2_virt_br0; cd t2_virt_br0/
  cat > br0.xml<<EOF
    <network connections='1'>
      <name>br0</name>
      <forward mode='bridge'/>
      <bridge name='br0'/>
    </network>
EOF
  sudo virsh net-define br0.xml 
  sudo virsh net-start br0; sudo virsh net-autostart br0

###########
# 隔天,重使用:
  iface=enp1s0
  sudo ip link set $iface up
  sudo brctl addif br0  $iface


# vm-multiCard
vt network host add --id=100
virter vm run cirros-v063 --id=100 --nic "type=bridge,source=br0,mac=1a:2b:3c:4d:51:01" --nic "type=network,source=default,mac=1a:2b:3c:4d:51:02"
# 启动后，vm经br0可获得dhcp分配的ip: 172.17.0.124


vt network host add --id=101
virter vm run barge214x --id=101 --nic "type=bridge,source=br0,mac=1a:2b:3c:4d:52:01" --nic "type=network,source=default,mac=1a:2b:3c:4d:52:02"
```

### 5）250827|oe-v22,bond双网卡做主备

> ref WXWork/xx/Cache/File/2025-08/CentOS7多网卡绑定.pdf

- vm103-oe2203-bond

```bash
# ens4>>br0
[root@localhost network-scripts]# cat ifcfg-ens4 
TYPE=Ethernet
DEFROUTE=yes
DEVICE=ens4
ONBOOT=yes
# 
IPADDR=172.29.40.233
NETMASK=255.255.255.0
#GATEWAY=
DNS1=114.114.114.114


# bond
net=10.255.0
nmcli connection add type bond ifname bond0 mode 1 ip4 $net.199/24 gw4 $net.1
nmcli connection add type bond-slave ifname ens3 master bond0
nmcli connection add type bond-slave ifname ens5 master bond0

# cleanIP
# sudo ip addr add 192.168.1.131/24 dev br0
sudo ip addr del 10.255.0.103/24 dev ens3
sudo ip addr del 192.168.122.47/24 dev ens5

# 未能就绪:找不到profile?
nmcli connection reload
nmcli connection
# 
ifup bond0
cat /proc/net/bonding/bond0
```

- reboot后验证

```bash
# reboot后:
[root@localhost network-scripts]# ls
  ifcfg-bond-bond0  ifcfg-bond-slave-ens3  ifcfg-bond-slave-ens5  
  ifcfg-ens3  ifcfg-ens4  ifcfg-ens5
# 两个slave配置项;
[root@localhost network-scripts]# cat ifcfg-bond-slave-ens3
  TYPE=Ethernet
  NAME=bond-slave-ens3
  UUID=ba207a79-c850-42e7-bddb-f76e583c4cdf
  DEVICE=ens3
  ONBOOT=yes
  MASTER=bond0
  SLAVE=yes
  [root@localhost network-scripts]# cat  ifcfg-bond-slave-ens5
  TYPE=Ethernet
  NAME=bond-slave-ens5
  UUID=4647af46-8e7e-4c89-9149-5352ec6e64f7
  DEVICE=ens5
  ONBOOT=yes
  MASTER=bond0
  SLAVE=yes

# 之前手动配置的 不要它了;(有之干扰,导致slave-ens3未生效)
[root@localhost network-scripts]# cat ifcfg-ens3
  TYPE=Ethernet
  PROXY_METHOD=none
  BROWSER_ONLY=no
  BOOTPROTO=none
  DEFROUTE=no
  IPV4_FAILURE_FATAL=no
  IPV6INIT=no
  IPV6_AUTOCONF=no
  IPV6_DEFROUTE=no
  IPV6_FAILURE_FATAL=no
  IPV6_ADDR_GEN_MODE=stable-privacy
  NAME=ens3
  #UUID=06630a45-7c95-42ec-9dd4-ab0d569312ac
  DEVICE=ens3
  ONBOOT=yes

[root@localhost network-scripts]# nmcli connection
  NAME             UUID                                  TYPE      DEVICE 
  bond-bond0       16fb0819-2b73-45f2-b220-d4ecb04727e2  bond      bond0  
  System ens4      e27f182b-d125-2c43-5a30-43524d0229ac  ethernet  ens4   
  bond-slave-ens5  4647af46-8e7e-4c89-9149-5352ec6e64f7  ethernet  ens5   
  ens3             21d47e65-8523-1a06-af22-6f121086f085  ethernet  ens3   
  bond-slave-ens3  ba207a79-c850-42e7-bddb-f76e583c4cdf  ethernet  --     
  ens5             8126c120-a964-e959-ff98-ac4973344505  ethernet  -- 


# 删两个ifcfg-ens3/5后
[root@localhost network-scripts]# nmcli connection reload
  [root@localhost network-scripts]# nmcli connection
  NAME             UUID                                  TYPE      DEVICE 
  bond-bond0       16fb0819-2b73-45f2-b220-d4ecb04727e2  bond      bond0  
  System ens4      e27f182b-d125-2c43-5a30-43524d0229ac  ethernet  ens4   
  bond-slave-ens3  ba207a79-c850-42e7-bddb-f76e583c4cdf  ethernet  ens3   
  bond-slave-ens5  4647af46-8e7e-4c89-9149-5352ec6e64f7  ethernet  ens5

[root@localhost network-scripts]# cat /proc/net/bonding/bond0
  Ethernet Channel Bonding Driver: v5.10.0-216.0.0.115.oe2203sp4.x86_64

  Bonding Mode: fault-tolerance (active-backup)
  Primary Slave: None
  Currently Active Slave: ens5
  MII Status: up
  MII Polling Interval (ms): 100
  Up Delay (ms): 0
  Down Delay (ms): 0
  Peer Notification Delay (ms): 0

  Slave Interface: ens5
  MII Status: up
  Speed: Unknown
  Duplex: Unknown
  Link Failure Count: 0
  Permanent HW addr: 1a:2b:3c:4d:5e:02
  Slave queue ID: 0

  Slave Interface: ens3
  MII Status: up
  Speed: Unknown
  Duplex: Unknown
  Link Failure Count: 0
  Permanent HW addr: 52:54:00:00:00:67
  Slave queue ID: 0
[root@localhost network-scripts]# ip route
  default via 10.255.0.1 dev bond0 proto static metric 300 
  10.255.0.0/24 dev bond0 proto kernel scope link src 10.255.0.199 metric 300 
  172.29.40.0/24 dev ens4 proto kernel scope link src 172.29.40.233 metric 100 
```

- 固定MAC

```bash
# mac: 1a:2b:3c:4d:5e:02
[root@localhost network-scripts]# ip a
  2: ens3: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc fq_codel master bond0 state UP group default qlen 1000
      link/ether 1a:2b:3c:4d:5e:02 brd ff:ff:ff:ff:ff:ff permaddr 52:54:00:00:00:67
  3: ens4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
      link/ether 1a:2b:3c:4d:5e:01 brd ff:ff:ff:ff:ff:ff
      inet 172.29.40.233/24 brd 172.29.40.255 scope global noprefixroute ens4
        valid_lft forever preferred_lft forever
  4: ens5: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc fq_codel master bond0 state UP group default qlen 1000
      link/ether 1a:2b:3c:4d:5e:02 brd ff:ff:ff:ff:ff:ff
  5: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
      link/ether 1a:2b:3c:4d:5e:02 brd ff:ff:ff:ff:ff:ff
      inet 10.255.0.199/24 brd 10.255.0.255 scope global noprefixroute bond0
        valid_lft forever preferred_lft forever
      inet6 fe80::a51a:cce8:8500:26c6/64 scope link noprefixroute 
        valid_lft forever preferred_lft forever
[root@localhost network-scripts]# ls
ifcfg-bond-bond0  ifcfg-bond-slave-ens3  ifcfg-bond-slave-ens5  ifcfg-ens4
[root@localhost network-scripts]# cat ifcfg-bond-bond0 
  BONDING_OPTS=mode=active-backup
  BONDING_MASTER=yes
  TYPE=Bond
  NAME=bond-bond0
  UUID=16fb0819-2b73-45f2-b220-d4ecb04727e2
  DEVICE=bond0
  ONBOOT=yes
  PROXY_METHOD=none
  BROWSER_ONLY=no
  BOOTPROTO=none
  IPADDR=10.255.0.199
  PREFIX=24
  GATEWAY=10.255.0.1
  DEFROUTE=yes
  IPV4_FAILURE_FATAL=no
  IPV6INIT=yes
  IPV6_AUTOCONF=yes
  IPV6_DEFROUTE=yes
  IPV6_FAILURE_FATAL=no
  IPV6_ADDR_GEN_MODE=stable-privacy
[root@localhost network-scripts]# cat ifcfg-bond-slave-ens3 
  TYPE=Ethernet
  NAME=bond-slave-ens3
  UUID=ba207a79-c850-42e7-bddb-f76e583c4cdf
  DEVICE=ens3
  ONBOOT=yes
  MASTER=bond0
  SLAVE=yes


[root@localhost network-scripts]# ls
ifcfg-bond-bond0  ifcfg-bond-slave-ens3  ifcfg-bond-slave-ens5  ifcfg-ens4
[root@localhost network-scripts]# vi ifcfg-bond-bond0 
[root@localhost network-scripts]# echo MACADDR=1a:2b:3c:4d:5e:02 >> ifcfg-bond-slave-ens3
[root@localhost network-scripts]# echo MACADDR=1a:2b:3c:4d:5e:02 >> ifcfg-bond-slave-ens5
[root@localhost network-scripts]# pwd
  /etc/sysconfig/network-scripts
# [root@localhost network-scripts]# ls |while read one; do echo $one; cat $one |grep MACADDR; done
  ifcfg-bond-bond0
  MACADDR=1a:2b:3c:4d:5e:02
  ifcfg-bond-slave-ens3
  MACADDR=1a:2b:3c:4d:5e:02
  ifcfg-bond-slave-ens5
  MACADDR=1a:2b:3c:4d:5e:02
  ifcfg-ens4

```

- 配置检测时长`BONDING_OPTS="mode=1 miimon=100"`

```bash
[root@localhost network-scripts]# cat ifcfg-bond-bond0 
  BONDING_OPTS=mode=active-backup
  BONDING_MASTER=yes

[root@localhost network-scripts]# cat ifcfg-bond-bond0 
  BONDING_OPTS="mode=1 miimon=100"
  BONDING_MASTER=yes

# connection reload
[root@localhost network-scripts]# nmcli connection reload
[root@localhost network-scripts]# nmcli connection
NAME             UUID                                  TYPE      DEVICE 
bond-bond0       16fb0819-2b73-45f2-b220-d4ecb04727e2  bond      bond0  
System ens4      e27f182b-d125-2c43-5a30-43524d0229ac  ethernet  ens4   
bond-slave-ens3  ba207a79-c850-42e7-bddb-f76e583c4cdf  ethernet  ens3   
bond-slave-ens5  4647af46-8e7e-4c89-9149-5352ec6e64f7  ethernet  ens5
```

- nmcli改配ip, 测试换主

```bash
# nmcli改IP
  # net=10.255.0
  net=192.168.122
  nmcli connection modify "bond-bond0" ipv4.addresses "$net.199/24" \
  ipv4.gateway "$net.1" ipv4.dns "8.8.8.8 114.114.114.114" ipv4.method manual
  nmcli connection up "bond-bond0"

# 测试换主
  111  cat /proc/net/bonding/bond0
  112  ifdown ens5 #无此配置

  # 如下在机器内停止网卡可换主
  #bond-slave-ens3
  114  ifdown bond-slave-ens3
  115  cat /proc/net/bonding/bond0
  116  ifup bond-slave-ens3
  117  cat /proc/net/bonding/bond0
  # bond-slave-ens5
  118  ifup bond-slave-ens5
  119  cat /proc/net/bonding/bond0
  120  ifdown bond-slave-ens5
  121  cat /proc/net/bonding/bond0
  122  ifup bond-slave-ens5
  123  cat /proc/net/bonding/bond0

  # 停vm网络
  #  1.把ens3在vm层停用,可切到ens5;
  #  2.停止vm网络，不会触发换主操作;
  # ff.mac: (对应上virtMgr的网卡MAC)
    [root@localhost ~]# ip a 
    3: ens4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
        link/ether 1a:2b:3c:4d:5e:01 brd ff:ff:ff:ff:ff:ff
        inet 172.29.40.233/24 brd 172.29.40.255 scope global noprefixroute ens4
          valid_lft forever preferred_lft forever
    2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
        link/ether 52:54:00:00:00:67 brd ff:ff:ff:ff:ff:ff
    4: ens5: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc fq_codel master bond0 state UP group default qlen 1000
        link/ether 1a:2b:3c:4d:5e:02 brd ff:ff:ff:ff:ff:ff
    5: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
        link/ether 1a:2b:3c:4d:5e:02 brd ff:ff:ff:ff:ff:ff
        inet 10.255.0.199/24 brd 10.255.0.255 scope global noprefixroute bond0
          valid_lft forever preferred_lft forever

```

- 0828次日周四|genM-deb11-virter环境二验

```bash
##br0#########
# 隔天,拔usb卡后 重使用:
  # enx000ec6a566e5 #网卡明未变
  sudo ip link set enx000ec6a566e5 up
  sudo brctl addif br0  enx000ec6a566e5
  # 手动up后灯亮+addif后vm方可ping通


##bond#########
1.添加arp_interval/iptarget ##arp_interval=200 arp_ip_target=192.168.122.1
  [root@localhost ~]# cd /etc/sysconfig/network-scripts/
  [root@localhost network-scripts]# cat ifcfg-bond-bond0 
  BONDING_OPTS="mode=active-backup miimon=100 arp_interval=200 arp_ip_target=192.168.122.1"
  TYPE=Bond
  BONDING_MASTER=yes

2.换ens3,5到同一default网
3.ping -i 0.3的验证
  1.vm-active的操作:可互切换/恢复
  2.default网络的停止:停后不能再互通了; 需vm停止后再启动方可(直接reset还不行)



# 下午16:00
##iperf3加压#########
root @ deb11-11 in ~ |16:00:37  
$ iperf3 -s -i 1
[root@localhost network-scripts]# iperf3 -c 192.168.122.1 -i 1 -t 3600 -P 2 #-b 100G
- - - - - - - - - - - - - - - - - - - - - - - - -
[  5] 101.00-102.00 sec   980 MBytes  8.22 Gbits/sec    0   1.86 MBytes       
[  7] 101.00-102.00 sec   981 MBytes  8.23 Gbits/sec    0   1.88 MBytes       
[SUM] 101.00-102.00 sec  1.92 GBytes  16.5 Gbits/sec    0             
^C- - - - - - - - - - - - - - - - - - - - - - - - -
[  5] 102.00-102.78 sec   786 MBytes  8.50 Gbits/sec    0   1.93 MBytes       
[  7] 102.00-102.78 sec   790 MBytes  8.55 Gbits/sec    0   1.88 MBytes       
[SUM] 102.00-102.78 sec  1.54 GBytes  17.1 Gbits/sec    0             
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-102.78 sec  94.0 GBytes  7.86 Gbits/sec  4009            sender
[  5]   0.00-102.78 sec  0.00 Bytes  0.00 bits/sec                  receiver
[  7]   0.00-102.78 sec  93.1 GBytes  7.78 Gbits/sec  4190            sender
[  7]   0.00-102.78 sec  0.00 Bytes  0.00 bits/sec                  receiver
[SUM]   0.00-102.78 sec   187 GBytes  15.6 Gbits/sec  8199             sender
[SUM]   0.00-102.78 sec  0.00 Bytes  0.00 bits/sec                  receiver
iperf3: interrupt - the client has terminated


##monitRec.bondChange#########
[root@localhost ~]# touch vals.txt; while true; do sleep 0.3; rq=$(date +%s.%N); val1=$(cat /proc/net/bonding/bond0 |grep Slave |grep Active |cut -d':' -f2 |awk '{print $1}'); val2=$(cat vals.txt |tail -1 |cut -d'|' -f1); test "$val1" != "$val2" && echo "$val1|$rq" >> vals.txt; done
^C
[root@localhost ~]# cat vals.txt 
ens5|Thu Aug 28 07:26:53 AM UTC 2025
ens3|1756366599.489801936
ens5|1756366606.430280150
ens3|1756366617.471193238
ens5|1756366622.819769747
ens3|1756366626.604647041
ens5|1756367164.113782157
ens3|1756367167.742887639
ens5|1756367172.320771249
ens3|1756367175.929728713
ens5|1756367179.842796373
ens3|1756367183.478345236
ens5|1756367187.732110094


# ping -D 记录时间搓
ping -i 0.3 192.168.122.1 -D 
```




