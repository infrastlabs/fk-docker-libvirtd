
```bash

# ref fk-virter//examples\hello-world\README.md
virter vm exec <vm_name> --provision hello-world.toml

# https://gitee.com/g-golang/fk-virter/blob/sam-custom/doc/provisioning.md
virter vm exec my-vm -p examples/hello-world/hello-world.toml --set values.Image=my-image-name


root @ armbian in .../local/libvirt |13:53:20  |sam-custom ?:8 ✗| 
$ vt vm exec 105 -p provisioning/hello-world.toml 
WARN[0001] Retrying SSH connection due to failure: ssh: handshake failed: ssh: host key mismatch 
WARN[0002] Retrying SSH connection due to failure: ssh: handshake failed: ssh: host key mismatch 
WARN[0003] Retrying SSH connection due to failure: ssh: handshake failed: ssh: host key mismatch
```

