#!/bin/bash
cur=$(dirname $(readlink -f "$0"))
cd $cur

function init() {
  # bin,etc,usr,dot
  chmod +x bin/*; \cp -a bin/* /bin/
  \cp -a etc/libvirt0 /etc/
  if [ ! -s "/usr/bin/apt" ]; then
    \cp -a usr/* /usr/
  else
    # sed -i 's/#user = "root"/user = "root"/' /etc/libvirt/qemu.conf;
    # sed -i 's/#group = "root"/group = "root"/' /etc/libvirt/qemu.conf;
    echo 'user = "root"' > /etc/libvirt/qemu.conf;
    echo 'group = "root"' >> /etc/libvirt/qemu.conf;
  fi
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

  # ohos-docker.kvm:
  # virter容器内: https://blog.csdn.net/hkking/article/details/120996413
  mkdir -p /dev/net
  mknod /dev/net/tun c 10 200
  chmod 600 /dev/net/tun

  # ubt
  mkdir -p /run/lock #/var/lock> /run/lock
}

# virshInit 2>&1 |tee -a init.log
init 2>&1 |tee -a init.log
virter  -v
cat supervisord.conf> /etc/supervisord.conf
mkdir -p /var/log $cur/../log; rm -rf /var/log/supervisor; ln -s $cur/../log /var/log/supervisor
exec /usr/bin/supervisord -c /etc/supervisord.conf
