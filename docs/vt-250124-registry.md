### 1）preTry

- preTry.`@vt-250108-images` **push/pull**

```bash
root @ armbian in .../local/libvirt |11:53:52  |sam-custom U:2 ?:9 ?. 
$ vt image ls
Name                Top Layer                                                                Created       
alpine              sha256:584760a4809c9d27ead880a549733db5adeb8da445a702d19099e5eaa2b605a9  19 hours ago  
barge214x           sha256:355685a6bee55e945239b282a0c75786ba8a7d3f8a67b50496e1912fa17aae60  46 hours ago  
deb-12-arm64        sha256:0a4972c17b60d56504069ffd2846fa135210b51850e5cb020089b2cf1b231126  19 hours ago  
debian-10-arm64     sha256:9c76240d75ae9fe1ed855c3f930c0a3ef50d8b9181881032f53107dce6efbcf5  24 hours ago  
ubuntu-focal-arm64  sha256:23bb59a11a87596c701ad2acf128eee80541461616dc0f361597a5b63b01cac1  25 hours ago  

root @ armbian in .../local/libvirt |11:54:52  |sam-custom U:2 ?:9 ?. 
$ vt image push alpine harbor.pcitech.com/base/virt-alpine:latest
FATA[0000] not allowed to push                           error="creating push check transport for harbor.pcitech.com failed: Get \"https://harbor.pcitech.com/v2/\": dial tcp: lookup harbor.pcitech.com on 114.114.114.114:53: no such host"


# 初始ca, .docker/config.json
root @ armbian in .../local/libvirt |11:54:59  |sam-custom U:2 ?:9 ?. 
$ curl -fSL -o- http://172.25.23.205:82/sam/docs-devops/raw/branch/dev/settings/harbor/regcert.sh |bash -s
...
==[doLogin]================================
echo XXX |docker login harbor.pcitech.com --username=admin --password-stdin
main: line 117: docker: command not found

root @ armbian in .../local/libvirt |11:56:48  |sam-custom U:2 ?:9 ?. 
$ vt image push alpine harbor.pcitech.com/base/virt-alpine:latest
FATA[0000] not allowed to push                           error="creating push check transport for harbor.pcitech.com failed: Get \"https://harbor.pcitech.com/v2/\": tls: failed to verify certificate: x509: certificate signed by unknown authority"  ##/etc/docker/certs.d/harbor.pcitech.com/ca.crt无效; TODO /etc/trusted-ca..

```

### 2）testPush(aliFail, harborOK)

- cert,auth

```bash
# cert
root @ deb1013 in ~ |09:22:39  
  $ curl -fSL -o- http://172.25.23.205:82/sam/docs-devops/raw/branch/dev/settings/harbor/regcert.sh |bash -s
  $ cat  /etc/docker/certs.d/harbor.pcitech.com/ca.crt
    -----BEGIN CERTIFICATE-----
    MIIDpDCCAoygAwIBAgIUAfr7FX5mAHhc2ztvlgtJc+HegGQwDQYJKoZIhvcNAQEL
    -----END CERTIFICATE-----
  $ mkdir -p /etc/ssl/certs; cat  /etc/docker/certs.d/harbor.pcitech.com/ca.crt  > /etc/ssl/certs/harbor115-ca.pem
  root @ deb1013 in ~ |09:27:08  
  $ vt image push debian-10 harbor.pcitech.com/infrastlabs/vm-images:debian-10
  FATA[0000] not allowed to push                           error="POST https://harbor.pcitech.com/v2/infrastlabs/vm-images/blobs/uploads/: UNAUTHORIZED: project infrastlabs not found: project infrastlabs not found" #ns不存在
  root @ armbian in ~ |13:50:39  
  $ vt image push alpine-v320-arm64 harbor.pcitech.com/base/vm-images:alpine-v320-arm64
  FATA[0000] not allowed to push                           error="POST https://harbor.pcitech.com/v2/base/vm-images/blobs/uploads/: UNAUTHORIZED: unauthorized to access repository: base/vm-images, action: push: unauthorized to access repository: base/vm-images, action: push" #未auth

# auth
mkdir -p ~/.docker; dockconf=~/.docker/config.json
MOD_UNDOCK_REPO=harbor.pcitech.com #registry.cn-shenzhen.aliyuncs.com
MOD_UNDOCK_AUTH="$(echo admin:suntek |tr -d '\n' |base64)"
# MOD_UNDOCK_AUTH=$aliAuth

  if [ ! -z "$MOD_UNDOCK_AUTH" ]; then
  echo """{
  \"auths\": {
    \"$MOD_UNDOCK_REPO\": {
      \"auth\": \"$MOD_UNDOCK_AUTH\"
    }
  },
  \"HttpHeaders\": {
    \"User-Agent\": \"Docker-Client/19.03.15 (linux)\"
  }
}""" |tee $dockconf
  fi
```

- ali-pushFail

```bash
# push
root @ deb1013 in ~ |09:18:47  
$ vt image push debian-10 registry.cn-shenzhen.aliyuncs.com/infrastlabs/vm-images:debian-10
sha256:913c245aac3642cfb compress done [====] 282.41MiB / 282.41MiB
sha256:913c245aac3642cfb push          [======>------------------] 90.00MiB / 280.51MiB
FATA[0072] failed to push image        error="PUT https://registry.cn-shenzhen.aliyuncs.com/v2/infrastlabs/vm-images/manifests/debian-10: DENIED: unknown manifest class for application/vnd.com.linbit.virter.image.v1"
```

- harbor115-certs,pushOK

```bash
# auth,pushOK
# 0.cert: ref upper
# 1.auth: ref upper
# 2.push
root @ deb1013 in ~ |09:28:48  
  $ vt image push debian-10 harbor.pcitech.com/base/vm-images:debian-10
  sha256:913c245aac3642cfb compress done [====] 282.41MiB / 282.41MiB
  sha256:913c245aac3642cfb push done     [====] 280.51MiB / 280.51MiB
  Pushed harbor.pcitech.com/base/vm-images:debian-10
```

### 3）allPush.Harbor115<x64,arm64>

- all-push/pull @x64 `src:genM.deb1013, test:x64.ubt-21.18`

```bash
###########genMachine-PUSH
$ vt image ls |awk '{print $1}' |grep -v "^Name$"
alma-8
alpine-v320
barge214c
barge214d
barge214x
cirros-v063
debian-10
debian-11
openeuler-v24
rocky-8
rocky-9
ubuntu-v20
root @ deb1013 in ~ |10:08:55  
$ vt image ls |awk '{print $1}' |grep -v "^Name$" |tr '\n' ','
alma-8,alpine-v320,barge214c,barge214d,barge214x,cirros-v063,debian-10,debian-11,openeuler-v24,rocky-8,rocky-9,ubuntu-v20,

root @ deb1013 in ~ |09:47:34  
$ vt image ls |awk '{print $1}' |grep -v "^Name$" |while read one; do echo $one; vt image push $one harbor.pcitech.com/base/vm-images:$one; done
  alma-8
  sha256:669bd580dcef5491d compress done [====] 678.56MiB / 678.56MiB
  sha256:669bd580dcef5491d push done     [====] 671.38MiB / 671.38MiB
  Pushed harbor.pcitech.com/base/vm-images:alma-8
  alpine-v320
  sha256:0947c391f5bf4f305 compress done [====] 178.12MiB / 178.12MiB
  sha256:0947c391f5bf4f305 push done     [====] 108.14MiB / 108.14MiB
  Pushed harbor.pcitech.com/base/vm-images:alpine-v320
  barge214c
  sha256:fd01527eae851f763 compress done [======] 15.12MiB / 15.12MiB
  sha256:fd01527eae851f763 push done     [======] 13.23MiB / 13.23MiB
  Pushed harbor.pcitech.com/base/vm-images:barge214c

###########21.18PULL
# echo "alma-8,alpine-v320,barge214c,barge214d,barge214x,cirros-v063,debian-10,debian-11,openeuler-v24,rocky-8,rocky-9,ubuntu-v20" |tr ',' '\n'
root @ host-172-25-21-18 in ~ |10:12:33  
$ echo "alma-8,alpine-v320,barge214c,barge214d,barge214x,cirros-v063,debian-10,debian-11,openeuler-v24,rocky-8,rocky-9,ubuntu-v20" |tr ',' '\n' |while read one; do echo $one; vt image pull $one harbor.pcitech.com/base/vm-images:$one; done
  alma-8
  sha256:669bd580dcef5491d pull done         [========================] 671.38MiB / 671.38MiB
  virter:layer:sha256:669b buffer layer done [========================] 678.56MiB / 678.56MiB
  virter:layer:sha256:669b upload layer done [========================] 678.56MiB / 678.56MiB
  Pulled alma-8
  alpine-v320
  sha256:0947c391f5bf4f305 pull done         [========================] 108.14MiB / 108.14MiB
  virter:layer:sha256:0947 buffer layer done [========================] 178.12MiB / 178.12MiB
  virter:layer:sha256:0947 upload layer done [========================] 178.12MiB / 178.12MiB
  Pulled alpine-v320
  barge214c
  sha256:fd01527eae851f763 pull done         [==========================] 13.23MiB / 13.23MiB
  virter:layer:sha256:fd01 buffer layer done [==========================] 15.12MiB / 15.12MiB
  virter:layer:sha256:fd01 upload layer done [==========================] 15.12MiB / 15.12MiB
  Pulled barge214c

```


- all-push/pull @arm64 `src:hk1box.armbian, test:x64.ubt-21.18`

```bash
# - auth
# - harbor115-certs

root @ armbian in ~ |13:50:39  
  $ vt image push alpine-v320-arm64 harbor.pcitech.com/base/vm-images:alpine-v320-arm64
  FATA[0000] not allowed to push                           error="POST https://harbor.pcitech.com/v2/base/vm-images/blobs/uploads/: UNAUTHORIZED: unauthorized to access repository: base/vm-images, action: push: unauthorized to access repository: base/vm-images, action: push"
  $ vt image push alpine-v320-arm64 harbor.pcitech.com/base/vm-images:alpine-v320-arm64
  sha256:584760a4809c9d27e compress done [============] 212.38MiB / 212.38MiB
  sha256:584760a4809c9d27e push done     [============] 109.01MiB / 109.01MiB
  Pushed harbor.pcitech.com/base/vm-images:alpine-v320-arm64

###########hk1box-PUSH
root @ armbian in ~ |13:52:30  
  $ vt image ls |awk '{print $1}' |grep -v "^Name$"
  alma-8-arm64
  alma-9-arm64
  alpine-v320-arm64
  cirros-v063-arm64
  debian-10-arm64
  debian-11-arm64
  openeuler-v24-arm64
  opensuse-micro-v61-arm64
  ophub-armbian-deb11-arm64
  rocky-9-arm64
  ubuntu-v20-arm64
  $ vt image ls |awk '{print $1}' |grep -v "^Name$" |tr '\n' ','
  alma-8-arm64,alma-9-arm64,alpine-v320-arm64,cirros-v063-arm64,debian-10-arm64,debian-11-arm64,openeuler-v24-arm64,opensuse-micro-v61-arm64,ophub-armbian-deb11-arm64,rocky-9-arm64,ubuntu-v20-arm64,
  # root @ armbian in ~ |13:54:19  
  $ vt image ls |awk '{print $1}' |grep -v "^Name$" |while read one; do echo $one; vt image push $one harbor.pcitech.com/base/vm-images:$one; done
    alma-8-arm64
    sha256:cec6736cbc562d068 compress done [============] 568.38MiB / 568.38MiB
    sha256:cec6736cbc562d068 push done     [============] 562.59MiB / 562.59MiB
    Pushed harbor.pcitech.com/base/vm-images:alma-8-arm64
    alma-9-arm64
    sha256:5ede4affaad0a997a compress done [============] 383.00MiB / 383.00MiB
    sha256:5ede4affaad0a997a push done     [============] 380.26MiB / 380.26MiB
    Pushed harbor.pcitech.com/base/vm-images:alma-9-arm64
    alpine-v320-arm64
    sha256:584760a4809c9d27e compress done [============] 212.38MiB / 212.38MiB
    Pushed harbor.pcitech.com/base/vm-images:alpine-v320-arm64
    cirros-v063-arm64
    sha256:611879b8299363fe6 compress done [==============] 24.00MiB / 24.00MiB
    sha256:611879b8299363fe6 push done     [==============] 23.51MiB / 23.51MiB
    Pushed harbor.pcitech.com/base/vm-images:cirros-v063-arm64

###########21.18PULL
# - pull-pub仓,无需auth
# - harbor115-certs
  # echo "alma-8-arm64,alma-9-arm64,alpine-v320-arm64,cirros-v063-arm64,debian-10-arm64,debian-11-arm64,openeuler-v24-arm64,opensuse-micro-v61-arm64,rocky-9-arm64,ubuntu-v20-arm64" |tr ',' '\n'
  root @ host-172-25-21-18 in ~ |10:12:33  
  $ echo "alma-9-arm64,alpine-v320-arm64,cirros-v063-arm64,debian-11-arm64,openeuler-v24-arm64,rocky-9-arm64,ubuntu-v20-arm64" |tr ',' '\n' |while read one; do echo $one; vt image pull $one harbor.pcitech.com/base/vm-images:$one; done
    alma-9-arm64
    sha256:5ede4affaad0a997a pull done         [===] 380.26MiB / 380.26MiB
    virter:layer:sha256:5ede buffer layer done [===] 383.00MiB / 383.00MiB
    virter:layer:sha256:5ede upload layer done [===] 383.00MiB / 383.00MiB
    Pulled alma-9-arm64
    alpine-v320-arm64
    sha256:584760a4809c9d27e pull done         [===] 109.01MiB / 109.01MiB
    virter:layer:sha256:5847 buffer layer done [===] 212.38MiB / 212.38MiB
    virter:layer:sha256:5847 upload layer done [===] 212.38MiB / 212.38MiB
    Pulled alpine-v320-arm64
    cirros-v063-arm64
    sha256:611879b8299363fe6 pull done         [=====] 23.51MiB / 23.51MiB
    virter:layer:sha256:6118 buffer layer done [=====] 24.00MiB / 24.00MiB
    virter:layer:sha256:6118 upload layer done [=====] 24.00MiB / 24.00MiB
    Pulled cirros-v063-arm64
    debian-11-arm64
    sha256:f84198324eb8ebc7a pull done [===========] 248.66MiB / 248.66MiB
    Pulled debian-11-arm64
    openeuler-v24-arm64
    sha256:e151e6e173e4af1b2 pull done         [===] 740.76MiB / 740.76MiB
    virter:layer:sha256:e151 buffer layer done [=======] 1.53GiB / 1.53GiB
    virter:layer:sha256:e151 upload layer done [=======] 1.53GiB / 1.53GiB
    Pulled openeuler-v24-arm64
    rocky-9-arm64
    sha256:5443bcc0507fadc3d pull done         [==================] 491.06MiB / 491.06MiB
    virter:layer:sha256:5443 buffer layer done [==================] 493.94MiB / 493.94MiB
    virter:layer:sha256:5443 upload layer done [==================] 493.94MiB / 493.94MiB
    Pulled rocky-9-arm64
    ubuntu-v20-arm64
    sha256:23bb59a11a87596c7 pull done         [==================] 578.05MiB / 578.05MiB
    virter:layer:sha256:23bb buffer layer done [==================] 579.92MiB / 579.92MiB
    virter:layer:sha256:23bb upload layer done [==================] 579.92MiB / 579.92MiB
    Pulled ubuntu-v20-arm64
```


