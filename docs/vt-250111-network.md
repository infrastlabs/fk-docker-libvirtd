### 1）VT操作

- ok: `nat bridge route`

```bash
# ok: nat bridge route
vt network add virter -n 10.255.0.1/24 -m nat #iptable内核模块 REJECT ERR
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

- virt-manager `#nat bridge route, none; #open, isolated, SR-IOV`

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

