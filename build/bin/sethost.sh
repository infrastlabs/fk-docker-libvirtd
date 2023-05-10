#!/bin/bash
cur=$(dirname $(readlink -f "$0"))
cd $cur;

# 1.virter-sshkeys/user_public_key: 经cdrom挂到sda(barge内cdrom设备无效)
# 2.barge内已预设：virter-ssh-pubkey

ID=$1
test -z "$USER" && USER=bargee #root,bargee
test -z "$NET" && NET=10.255.0.0
NET1=${NET%.*} #10.255.0

# 直接在ct-verrter内调用该脚本执行hostname xxx
# https://www.likecs.com/show-307832685.html #linux 修改 hostname 立即生效的四种方法 
echo "wait ssh:"
while true; do
    echo -n "."
    nc -vz -w 1 $NET1.$ID 22 > /dev/null 2>&1; errCode=$?
    test "0" == "$errCode" && break
    sleep 1.1
done

hname0=$(hostname); hname=b$ID-$hname0 #barge
ssh $USER@$NET1.$ID """
# view0
hostname; ip a |grep inet |grep eth0;

# setHost
# sudo hostname $hname
sudo sysctl kernel.hostname=$hname

# up: /etc/hostname; /etc/hosts
echo $hname |sudo tee /etc/hostname > /dev/null 2>&1
sudo sed -i \"s/barge.*/$hname/g\" /etc/hosts

# view1
hostname; cat /etc/hostname
cat /etc/hosts
"""


# TODO: init.d/start.sh等待barge主机名变后再continue;