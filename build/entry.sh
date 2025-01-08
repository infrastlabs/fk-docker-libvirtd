#!/bin/bash
cur=$(dirname $(readlink -f "$0"))
cd $cur

function init() {
  # bin,etc,usr,dot
  chmod +x bin/*.sh; \cp -a bin/* /bin/
  \cp -a etc/* /etc/
  \cp -a usr/* /usr/
  \cp -a dot/. /root/; chmod 600 /root/.ssh/id_rsa*; #virter.toml
  dst=/root/.local/share/virter; mkdir -p $dst; : > $dst/images.toml #clear org's img-list

  # virter completion bash |sed 's^virter^vt^g'
  match0=$(cat /root/.bashrc |grep "virter completion bash")
  test -z "$match0" && echo "source <(virter completion bash |sed 's^virter^vt^g')" >> /root/.bashrc 

  # ssh| StrictHostKeyChecking no
  sed -i "s/.*StrictHostKeyChecking.*/StrictHostKeyChecking no/g" /etc/ssh/ssh_config
  sed -i "s^.*UserKnownHostsFile.*^UserKnownHostsFile /dev/null^g" /etc/ssh/ssh_config
  cat /etc/ssh/ssh_config |egrep "Stri|UserKnownHostsFile"

  # .bashrc
  sed -i 's/OSH_THEME.*/OSH_THEME="axin"/g' /root/.bashrc; cat /root/.bashrc |grep axin

  # links
  rm -f /bin/vt; ln -s /bin/virter /bin/vt
  rm -f /bin/sv; ln -s /usr/bin/supervisorctl /bin/sv
  mkdir -p /var/lib/libvirt/images
  rm -f images; ln -s /var/lib/libvirt/images images
  # rm -f conf; ln -s /root/.config/virter conf
  # rm -f share; ln -s /root/.local/share/virter share

  # virbr https://blog.csdn.net/hffwj/article/details/122322682
  ifconfig virbr0 down
  brctl delbr virbr0


  # ohos-docker.kvm:
  # virter容器内: https://blog.csdn.net/hkking/article/details/120996413
  mkdir -p /dev/net
  mknod /dev/net/tun c 10 200
  chmod 600 /dev/net/tun
}

# virshInit 2>&1 |tee -a init.log
init 2>&1 |tee -a init.log
virter  -v
exec /usr/bin/supervisord -c /etc/supervisord.conf
