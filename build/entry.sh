#!/bin/bash
cur=$(cd "$(dirname "$0")"; pwd)
cd $cur

function init() {
# file=virter-linux-amd64 @inner-image
# # curl -O -fSL https://ghproxy.com/https://github.com/LINBIT/virter/releases/download/v0.24.0/$file
# test -s $file || wget -O $file https://ghproxy.com/https://github.com/LINBIT/virter/releases/download/v0.24.0/$file
# chmod +x $file; test -s /bin/virter || \cp -a $file /bin/virter

file=vm.sh;      \cp -a $cur/bin/$file /bin/$file; chmod +x /bin/$file
file=sethost.sh; \cp -a $cur/bin/$file /bin/$file; chmod +x /bin/$file
rm -f /bin/vt; ln -s /bin/virter /bin/vt
rm -f /bin/sv; ln -s /usr/bin/supervisorctl /bin/sv
# virter completion bash |sed 's^virter^vt^g'
match0=$(cat /root/.bashrc |grep "virter completion bash")
test -z "$match0" && echo "source <(virter completion bash |sed 's^virter^vt^g')" >> /root/.bashrc 

# pre-conf
# mkdir -p /root/.config/virter /root/.local/share/virter
# \cp -a dot/share/images.toml /root/.local/share/virter/
# \cp -a dot/conf/* /root/.config/virter/; chmod 600 /root/.config/virter/id_rsa*; #virter.toml
# mkdir -p /var/lib/libvirt/images /root/.ssh
# \cp -a /root/.config/virter/id_rsa /root/.ssh/ #ssh bargee@xxx
\cp -a dot/. /root/; chmod 600 /root/.ssh/id_rsa*; #virter.toml

# StrictHostKeyChecking no
sed -i "s/.*StrictHostKeyChecking.*/StrictHostKeyChecking no/g" /etc/ssh/ssh_config
sed -i "s^.*UserKnownHostsFile.*^UserKnownHostsFile /dev/null^g" /etc/ssh/ssh_config
cat /etc/ssh/ssh_config |egrep "Stri|UserKnownHostsFile"

# links
mkdir -p /var/lib/libvirt/images
rm -f images; ln -s /var/lib/libvirt/images images
# rm -f conf; ln -s /root/.config/virter conf
# rm -f share; ln -s /root/.local/share/virter share

# virbr https://blog.csdn.net/hffwj/article/details/122322682
ifconfig virbr0 down
brctl delbr virbr0
}

# virshInit 2>&1 |tee -a init.log
init 2>&1 |tee -a init.log
virter  -v
exec /usr/bin/supervisord -c /etc/supervisord.conf
