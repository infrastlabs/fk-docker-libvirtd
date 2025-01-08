# FROM alpine
# 3.13.12> 3.19
FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-libvirtd:v2501 as virter-alpine313
FROM registry.cn-shenzhen.aliyuncs.com/infrasync/library-alpine:3.19
ARG TARGETPLATFORM
RUN domain="mirrors.tuna.tsinghua.edu.cn"; \
  echo "http://$domain/alpine/v3.19/main" > /etc/apk/repositories; \
  echo "http://$domain/alpine/v3.19/community" >> /etc/apk/repositories
  # echo "http://$domain/alpine/edge/testing" >> /etc/apk/repositories;
  # seabios \ #none @arm64 [3.13/3.19]
  # edk2 ovmf \ #ovmf已有, edk2非必须
  # ovmf \ #v3.19 none
RUN apk add --no-cache \
    supervisor \
    libvirt-client \
    libvirt-daemon \
    libvirt-common-drivers \
    libvirt-qemu \
    qemu-system-x86_64 \
    qemu-system-aarch64 \
    # edk2 ovmf \
    qemu-audio-alsa \
    qemu-audio-oss \
    qemu-audio-pa \
    qemu-audio-sdl \
    qemu-audio-spice \
    qemu-block-curl \
    qemu-block-dmg-bz2 \
    qemu-block-nfs \
    qemu-block-ssh \
    qemu-chardev-spice \
    qemu-hw-display-qxl \
    qemu-hw-display-virtio-gpu \
    qemu-hw-display-virtio-gpu-pci \
    qemu-hw-display-virtio-vga \
    qemu-hw-usb-redirect \
    qemu-img \
    && addgroup -S mumble-server && adduser -S mumble-server -G mumble-server

# +ref: kube-cmd
RUN apk add --no-cache \
  ca-certificates tzdata curl  wget \
  sed grep gawk findutils sudo tree unzip procps htop \
  expect shadow xterm bash bash-completion coreutils busybox-extras \
  \
  bind-tools tmux lftp jq sysstat git 
# ssh-conn
RUN apk add --no-cache \
  dropbear openssh-sftp-server openssh-client \
  libevent ncurses openssl

# ohmybash: font> axin(badColorView@alpine3.13) >> axin-viewOK @3.13.12;
RUN \
  sh -c "$(wget https://gitee.com/g-system/oh-my-bash/raw/sam-custom/tools/install.sh -O -)"; \
  sed -i 's/OSH_THEME.*/OSH_THEME="axin"/g' /root/.bashrc; cat /root/.bashrc |grep axin; 

# tini,gosu
# https://github.com/krallin/tini/releases/download/v0.19.0/tini-static-muslc-amd64
# https://github.com/tianon/gosu/releases/download/1.11/gosu-$arch

# virter-v0.24.0
RUN \
  case ${TARGETPLATFORM} in \
    "linux/amd64")  arch=amd64    ;; \
    "linux/arm64")  arch=arm64    ;; \
    "linux/arm/v7") arch=arm      ;; \
    "linux/arm/v6") arch=NONE_armel ;; \
    "linux/386")    arch=NONE_i386  ;; \
  esac; \
  file=virter-linux-$arch; \
  # curl -O -fSL https://ghproxy.com/https://github.com/LINBIT/virter/releases/download/v0.24.0/$file
  # https://github.com/LINBIT/virter/releases/download/v0.28.1/virter-linux-amd64 ##amd64 only
  # https://ghproxy.com/>> https://ghgo.xyz
  # 
  # https://gitee.com/g-golang/fk-virter/releases/download/v25.01-2/virter-v2501-250108-linux-amd64.tar.gz
  # test -s $file || wget -O $file.tar.gz https://gitee.com/g-golang/fk-virter/releases/download/v25.01-2/virter-v2501-250108-linux-$arch.tar.gz; \
  # tar -zxf $file.tar.gz; mv $file /bin/virter;
  # 
  # https://github.com/infrastlabs/fk-virter/releases/download/v24.12/virter-linux-amd64 #none: xx-upx.tar.gz (err@23.2-kylin)
  test -s $file || wget -O $file https://github.com/infrastlabs/fk-virter/releases/download/v24.12/$file; \
  chmod +x $file; mv $file /bin/virter;

RUN \
  echo "welcome! virter." > /etc/motd; \
  TIMEZONE=Asia/Shanghai; \
  ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && echo $TIMEZONE > /etc/timezone; \
  #bin-link
  mv /bin/sh /bin/busy_sh && ln -s /bin/bash /bin/sh; \
  \
  mkdir -p /etc/dropbear /var/log/supervisor; \
  # echo -e "#!/bin/bash\ntest -z "\$1" && exit 0; supervisord ctl \$@" > /usr/local/bin/sv; chmod +x /usr/local/bin/sv; \
  \
  # + ##ssh
  sed -i "s^/bin/ash^/bin/bash^g" /etc/passwd; \
  echo "root:root" |chpasswd;

ENV \
  TERM=xterm \
  SHELL=/bin/bash \
  # TIMEZONE=Asia/Shanghai \
  # LANG=C.UTF-8 \
  # SSHD_ENABLE=true \
  SSHD_PORT=60022

  
COPY --from=virter-alpine313 /usr/share/qemu/edk2-arm-vars.fd /usr/share/qemu/edk2-arm-vars.fd
# .profile> .bashrc> ohmybash (for: ssh_dropbear)
# ADD ./dot/.profile /root/.profile
ADD ./dot/ /root/
COPY supervisord.conf /etc/supervisord.conf

VOLUME ["/var/run/libvirt/", "/var/lib/libvirt"]
# ENTRYPOINT ["/sbin/tini","--"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
