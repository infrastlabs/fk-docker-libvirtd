#!/bin/bash
cur=$(dirname $(readlink -f "$0"))
cd $cur

  # virbr https://blog.csdn.net/hffwj/article/details/122322682
  # # ifconfig virbr0 down
  # ip link set dev virbr0 down
  # brctl delbr virbr0

####baiduAI: "linux 删除桥接网卡" >> brctl|ip link|nmcli
  # brctl show
  # brctl delif virbr1 virbr1-nic
  # brctl delbr virbr1
  # 
  ip link show type bridge
  # 移除接口（例如，eth0）从桥接网络（例如，br0）
  ip link set dev virbr0-nic down
  ip link set dev virbr0-nic master none
  # 删除桥接网络（例如，br0）
  ip link set dev virbr0 down
  ip link delete dev virbr0
  # # add: try hand start
  # ip link add dev virbr0 type bridge
  # ip addr add 10.255.0.1/24 dev virbr0
  # ip link set dev virbr0 up #still down
  # 
  # nmcli con show --active | grep bridge
  # # 断开设备连接（例如，eth0连接到br0）
  # nmcli con mod <connection_name> connection.slave-type none
  # nmcli con down <connection_name>
  # # 删除桥接连接（例如，br0）
  # nmcli con del <connection_name>

# check
# cmd="virsh list --all > /dev/null 2>&1"
while true; do
  echo -n "."; sleep 1
  virsh list --all > /dev/null 2>&1; errCode=$?
  test "0" == "$errCode" && break;
done

vm.sh init

echo -e "\n==[net-start]"; virsh net-start virter
ls /etc/libvirt/qemu/autostart/ |while read one; do
  one=${one%.xml}
  echo "=[virsh start $one]"; virsh start $one
done


