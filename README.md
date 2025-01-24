
**Docs**

- arm64
  - [250107a-arm64-vm.md](./docs/250107a-arm64-vm.md) 「alpine313.ARM环境虚机: virter.vm模板调整+`share/qemu/firmware/60-edk2-aarch64.json`修正」
  - [250107b-arm64-images.md](./docs/250107b-arm64-images.md) 「Debian/Ubuntu, Alma/Rocky, Alpine的尝试」
  - [250113-arm64-rk3588.md](./docs/250113-arm64-rk3588.md) 「两台AIEC板子，Linaro系统下的KVM运行尝试」
- virter
  - [vt-250108-images.md](./docs/vt-250108-images.md) 「vtOrgDocs, http-reg.availabel, ophub-armbian」
    - vtOrgDocs:`images,import,network,provision,ssh.nux/win`
    - ophub-armbian:`ubt22-jammy,ubt24-noble; deb11-bullseye, deb12-bookworm`
  - [vt-250111-network.md](./docs/vt-250111-network.md) 「vt/virtMgr网络模式: `nat bridge route, none; +open, isolated, SR-IOV`」
  - [vt-250124-registry.md](./docs/vt-250124-registry.md) 「testPush`(aliFail, harborOK)`；镜像转存harbor」
- kubeVirt
  - [kvirt-250509-ins01.md](./docs/kvirt-250509-ins01.md) 「citydev集群-v1.21.10版、k3s,ke集群-v1.26版」
  - [kvirt-250512-use01.md](./docs/kvirt-250512-use01.md) 「vmi vmCreate vmAccess vmTypes,Refs」

## docker-libvirtd

Alpine Linux libvirt (qemu+kvm) docker image, GitHub action is setup ~~so this image is __updated every week__.~~

**QuickStart**

_docker run_:

```sh
mkdir -p run var
# img=ghcr.io/speedy37/docker-libvirtd/libvirtd:main
# img=registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-libvirtd:v2501
img=registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-libvirtd:v2501-alpine319
docker run --privileged \
    -v $(pwd)/run:/var/run/libvirt \
    -v $(pwd)/var:/var/lib/libvirt \
    $img

# dcp
echo REPO=registry.cn-shenzhen.aliyuncs.com/ > .env
dcp pull; dcp up -d
```

_libvirtd clients_ examples:

```sh
virsh -c qemu:///system?socket=$(pwd)/run/libvirt-sock

virt-manager -c qemu:///system?socket=$(pwd)/run/libvirt-sock
```