#!/bin/bash
cur=$(dirname $(readlink -f "$0"))
# cd $cur; #echo $cur

function init() {
# socket to '/var/run/libvirt/libvirt-sock': Connection refused
# pool(first init)
  virsh pool-define-as --name default --type dir --target /var/lib/libvirt/images
  virsh pool-autostart default; virsh pool-start default
# PoolPersist
  virsh pool-dumpxml default> /tmp/pool-persist.xml
  virsh pool-define /tmp/pool-persist.xml
  rm -f /etc/libvirt/storage/autostart/default.xml
  virsh pool-autostart default
  virsh pool-list --all --persistent 

# net (existedXML> persist)
# mkdir -p /etc/libvirt/qemu/networks
# cat etc/libvirt/qemu/networks/default.xml > /etc/libvirt/qemu/networks/default.xml
# NetPersist https://qastack.cn/server/401704/how-do-i-make-a-persistent-domain-with-virsh
  net=default
  virsh net-define /etc/libvirt0/qemu/networks/$net.xml
  virsh net-dumpxml $net> /tmp/$net-persist.xml
  virsh net-define /tmp/$net-persist.xml
  rm -f /etc/libvirt/qemu/networks/autostart/$net.xml
  virsh net-autostart $net
  virsh net-start $net

  # virter(staticnet); vt create first
  net=virter
  vt network add $net -m nat -n 10.255.0.1/24 \
   |grep -v "no network with matching name 'virter'" #gen: /etc/libvirt/qemu/networks/$net.xml
  # [reCreated]could not add DHCP entry: Requested operation is not valid: cannot change persistent config of a transient network
  virsh net-define /etc/libvirt/qemu/networks/$net.xml
  virsh net-dumpxml $net> /tmp/$net-persist.xml #转存
  virsh net-define /tmp/$net-persist.xml
  rm -f /etc/libvirt/qemu/networks/autostart/$net.xml #删vt生成的配置项
  virsh net-autostart $net
  virsh net-start $net
  # view
  virsh net-list --all --persistent 

}
function persist() {
  mkdir -p vm
  # virsh.vm.persist
  # dumpxml
  virsh list --all |grep -v Name|awk '{print $2}' |egrep -v "^#|^$" |while read id; do 
    virsh dumpxml $id> vm/$id.xml; 
  done
  ls -l vm/

  # define
  ls vm/*.xml |while read one; do
    virsh define $one; #vm/$id.xml; 
  done
  virsh list --all --persistent
}
function start() {
  virsh list --all --persistent
  virsh list --all --persistent |grep -v Name|awk '{print $2}' |egrep -v "^#|^$" |while read id; do 
    virsh start $id;
  done
}
function stop() {
  virsh list --all --persistent
  virsh list --all --persistent |grep -v Name|awk '{print $2}' |egrep -v "^#|^$" |while read id; do 
    virsh destroy $id; #destroy (stop)
  done
}

# init 2>&1 |tee -a init.log
# init

# case: init,persist,start,stop, list,env,run,
case "$1" in
init|persist|start|stop)
    $1
    ;;
*)
    # doBuildx $1 src/Dockerfile.$1
    echo "call with one params: init,persist,start,stop"
    ;;          
esac