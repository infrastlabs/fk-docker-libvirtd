
## net.autostart

```bash
# virtnetworkd: 
#  ubt中无,apt-file查找也无;
#  alpine中有, 启之再启libvirtd会报错:Initialization of bridge state driver failed: Failed to acquire pid file '/var/run/libvirt/network/driver.pid': Resource temporarily unavailable
# 
# root @ deb11-11 in .../apps/fk-docker-libvirtd |22:11:58  |sam-custom U:2 ?:9 _| 
$ apt-file search virtnetworkd
$ history |tail -6
  475  2025-08-16 21:48:08 git pull; dcp up -d
  476  2025-08-16 22:10:30 apt-get install apt-file
  477  2025-08-16 22:10:53 apt-file update
  478  2025-08-16 22:11:58 apt-file search abc
  479  2025-08-16 22:12:09 apt-file search virtnetworkd
  480  2025-08-16 22:12:30 history |tail -6

# sysd ubt2004
# /usr/lib/libvirt/libvirt-guests.sh start
root @ ce4b289210ad in /etc/systemd |08:43:46  
$ find |grep virt |while read one; do echo "==$one"; cat $one |grep Exec; done
==./system/multi-user.target.wants/libvirtd.service
ExecStart=/usr/sbin/libvirtd $libvirtd_opts
ExecReload=/bin/kill -HUP $MAINPID
==./system/multi-user.target.wants/libvirt-guests.service
ExecStart=/usr/lib/libvirt/libvirt-guests.sh start
ExecStop=/usr/lib/libvirt/libvirt-guests.sh stop
==./system/sockets.target.wants/virtlockd-admin.socket
==./system/sockets.target.wants/virtlogd-admin.socket
==./system/sockets.target.wants/libvirtd.socket
==./system/sockets.target.wants/virtlockd.socket
==./system/sockets.target.wants/virtlogd.socket
==./system/sockets.target.wants/libvirtd-ro.socket
==./system/sockets.target.wants/libvirtd-admin.socket

$ cat ./system/multi-user.target.wants/libvirtd.service |egrep -v "^#|^$"
  [Unit]
  Description=Virtualization daemon
  Requires=virtlogd.socket
  Requires=virtlockd.socket
  Wants=libvirtd.socket
  Wants=libvirtd-ro.socket
  Wants=libvirtd-admin.socket
  Wants=systemd-machined.service
  After=network.target
  After=local-fs.target
  After=remote-fs.target
  After=dbus.service
  After=iscsid.service
  After=apparmor.service
  After=systemd-logind.service
  After=systemd-machined.service
  After=xencommons.service
  Before=libvirt-guests.service
  Conflicts=xendomains.service
  Documentation=man:libvirtd(8)
  Documentation=https://libvirt.org
  [Service]
  Type=notify
  EnvironmentFile=-/etc/default/libvirtd
  ExecStart=/usr/sbin/libvirtd $libvirtd_opts ###
  ExecReload=/bin/kill -HUP $MAINPID
  KillMode=process
  Restart=on-failure
  LimitNOFILE=8192
  TasksMax=32768
  LimitMEMLOCK=64M
  [Install]
  WantedBy=multi-user.target
  Also=virtlockd.socket
  Also=virtlogd.socket
  Also=libvirtd.socket
  Also=libvirtd-ro.socket

# root @ ce4b289210ad in /etc/systemd |08:47:15  
$ cat /etc/default/libvirtd
  # Defaults for libvirtd initscript (/etc/init.d/libvirtd)
  # This is a POSIX shell fragment

  # Start libvirtd to handle qemu/kvm:
  start_libvirtd="yes" ###

  # options passed to libvirtd, see man libvirtd for details.
  # For example to enable listening on tcp add -l here
  # and set up the TLS Certificates that libvirtd will need.
  #libvirtd_opts=""

  # pass in location of kerberos keytab
  #export KRB5_KTNAME=/etc/libvirt/libvirt.keytab

  # Whether to mount a systemd like cgroup layout (only
  # useful when not running systemd)
  #mount_cgroups=yes
  # Which cgroups to mount
  #cgroups="memory devices"

# conf
root @ ce4b289210ad in /etc/libvirt |08:50:32  
$ find |sort |grep conf |while read one; do echo "==$one"; cat $one |grep Exec; done
==./libvirt-admin.conf
==./libvirt.conf
==./libvirtd.conf
==./qemu-lockd.conf
==./qemu-sanlock.conf
==./qemu.conf
==./virt-login-shell.conf
==./virtlockd.conf
==./virtlogd.conf
==./libxl-lockd.conf
==./libxl-sanlock.conf
==./libxl.conf
==./lxc.conf
```



## conf

- ct-virter|/etc/libvirt/

```bash
# ct-virter
# root @ deb11-11 in ~ |14:11:12  
$ tree /etc/libvirt/
/etc/libvirt/
|-- hooks
|-- libvirt-admin.conf
|-- libvirt.conf
|-- libvirtd.conf
|-- libxl-lockd.conf
|-- libxl-sanlock.conf
|-- libxl.conf
|-- lxc.conf
|-- nwfilter
|   |-- allow-arp.xml
|   |-- allow-dhcp-server.xml
|   |-- allow-dhcp.xml
|   |-- allow-ipv4.xml
..
|   `-- qemu-announce-self.xml
|-- qemu
|   |-- cirros-v063-109.xml
|   `-- networks ##
|       |-- autostart
|       |   `-- virter.xml -> /etc/libvirt/qemu/networks/virter.xml
|       |-- default.xml
|       `-- virter.xml
|-- qemu-lockd.conf
|-- qemu-sanlock.conf
|-- qemu.conf
|-- secrets
|-- storage
|   |-- autostart
|   |   `-- default.xml -> /etc/libvirt/storage/default.xml
|   `-- default.xml
|-- virtlockd.conf
`-- virtlogd.conf
9 directories, 42 files

# img
root @ 4c85c86abf20 in / |14:21:41  
$ find /etc/libvirt/ -type f |sort
  /etc/libvirt/libvirt-admin.conf
  /etc/libvirt/libvirt.conf
  /etc/libvirt/libvirtd.conf
  /etc/libvirt/libxl-lockd.conf
  /etc/libvirt/libxl-sanlock.conf
  /etc/libvirt/libxl.conf
  /etc/libvirt/lxc.conf
  /etc/libvirt/virt-login-shell.conf
  /etc/libvirt/virtlockd.conf
  /etc/libvirt/virtlogd.conf
  /etc/libvirt/qemu-lockd.conf
  /etc/libvirt/qemu-sanlock.conf
  /etc/libvirt/qemu.conf
  /etc/libvirt/qemu/networks/default.xml
  /etc/libvirt/nwfilter/allow-arp.xml
  /etc/libvirt/nwfilter/allow-dhcp-server.xml
  ..
  /etc/libvirt/nwfilter/qemu-announce-self.xml
  # $ find /etc/libvirt/ -type f |sort |grep ".conf$" |while read one; do echo ==$one; cat $one |egrep -v "^#|^$"; done
  ==/etc/libvirt/libvirt-admin.conf
  ==/etc/libvirt/libvirt.conf
  ==/etc/libvirt/libvirtd.conf
  unix_sock_group = "libvirt"
  unix_sock_ro_perms = "0777"
  unix_sock_rw_perms = "0770"
  auth_unix_ro = "none"
  auth_unix_rw = "none"
  ==/etc/libvirt/libxl-lockd.conf
  ==/etc/libvirt/libxl-sanlock.conf
  ==/etc/libvirt/libxl.conf
  ==/etc/libvirt/lxc.conf
  ==/etc/libvirt/qemu-lockd.conf
  ==/etc/libvirt/qemu-sanlock.conf
  ==/etc/libvirt/qemu.conf
  user = "root"
  group = "root"
  ==/etc/libvirt/virt-login-shell.conf
  ==/etc/libvirt/virtlockd.conf
  ==/etc/libvirt/virtlogd.conf

# src
# Administrator@WIN-2208071245 MINGW64 /d/Development/Projects/_ee/fk-docker-libvirtd (sam-custom)
$ find build/etc/libvirt -type f |sort
  build/etc/libvirt/libvirt.conf
  build/etc/libvirt/libvirtd.conf
  build/etc/libvirt/network.conf
  build/etc/libvirt/qemu.conf
  build/etc/libvirt/virtlockd.conf
  build/etc/libvirt/virtlogd.conf
  # $ find build/etc/libvirt -type f |sort |while read one; do echo ==$one; cat $one |egrep -v "^#|^$"; done
  ==build/etc/libvirt/libvirt.conf
  ==build/etc/libvirt/libvirtd.conf
  ==build/etc/libvirt/network.conf
  firewall_backend = "iptables"
  ==build/etc/libvirt/qemu.conf
  ==build/etc/libvirt/virtlockd.conf
  ==build/etc/libvirt/virtlogd.conf
```

- libvirtd src's

```bash
$ cat libvirtd.conf |grep =
#listen_tls = 0
#listen_tcp = 1
# activation with systemd version >= 227
#tls_port = "16514"
# activation with systemd version >= 227
#tcp_port = "16509"
#listen_addr = "192.168.0.1"
#unix_sock_group = "libvirt"
#unix_sock_ro_perms = "0777"
#unix_sock_rw_perms = "0770"
#unix_sock_admin_perms = "0700"
# activation with systemd version >= 227
#unix_sock_dir = "/var/run/libvirt"
#auth_unix_ro = "polkit"
# the systemd .socket files will use SocketMode=0600 by default
# the systemd .socket files will use SocketMode=0666 which
#auth_unix_rw = "polkit"
#auth_tcp = "sasl"
#auth_tls = "none"
#access_drivers = [ "polkit" ]
#key_file = "/etc/pki/libvirt/private/serverkey.pem"
#cert_file = "/etc/pki/libvirt/servercert.pem"
#ca_file = "/etc/pki/CA/cacert.pem"
#crl_file = "/etc/pki/CA/crl.pem"
#tls_no_sanity_certificate = 1
#tls_no_verify_certificate = 1
#    "C=GB,ST=London,L=London,O=Red Hat,CN=*"
#tls_allowed_dn_list = ["DN1", "DN2"]
#tls_priority="NORMAL"
#sasl_allowed_username_list = ["joe@EXAMPLE.COM", "fred@EXAMPLE.COM" ]
#max_clients = 5000
#max_queued_clients = 1000
#max_anonymous_clients = 20
#min_workers = 5
#max_workers = 20
#prio_workers = 5
#max_client_requests = 5
#admin_min_workers = 1
#admin_max_workers = 5
#admin_max_clients = 5
#admin_max_queued_clients = 5
#admin_max_client_requests = 5
#log_level = 3
#log_filters="1:qemu 1:libvirt 4:object 4:json 4:event 1:util"
#log_outputs="3:syslog:libvirtd"
#   audit_level == 0  -> disable all auditing
#   audit_level == 1  -> enable auditing, only if enabled on host (default)
#   audit_level == 2  -> enable auditing, and exit if disabled on host
#audit_level = 2
#audit_logging = 1
#host_uuid = "00000000-0000-0000-0000-000000000000"
#host_uuid_source = "smbios"
#keepalive_interval = 5
#keepalive_count = 5
#keepalive_required = 1
#admin_keepalive_required = 1
#admin_keepalive_interval = 5
#admin_keepalive_count = 5
#ovs_timeout = 5
```

- qemu

```bash
$ cat qemu.conf |grep =
#default_tls_x509_cert_dir = "/etc/pki/qemu"
#default_tls_x509_verify = 1
#default_tls_x509_secret_uuid = "00000000-0000-0000-0000-000000000000"
#vnc_listen = "0.0.0.0"
# type=address but without any address specified. This setting takes
#vnc_auto_unix_socket = 1
#vnc_tls = 1
# If the path is not provided, but vnc_tls = 1, then the
#vnc_tls_x509_cert_dir = "/etc/pki/libvirt-vnc"
#vnc_tls_x509_secret_uuid = "00000000-0000-0000-0000-000000000000"
#vnc_tls_x509_verify = 1
#vnc_password = "XYZ12345"
#vnc_sasl = 1
#vnc_sasl_dir = "/some/directory/sasl2"
#vnc_allow_host_audio = 0
#spice_listen = "0.0.0.0"
#spice_tls = 1
# If the path is not provided, but spice_tls = 1, then the
#spice_tls_x509_cert_dir = "/etc/pki/libvirt-spice"
# type=address but without any address specified. This setting takes
#spice_auto_unix_socket = 1
#spice_password = "XYZ12345"
#spice_sasl = 1
#spice_sasl_dir = "/some/directory/sasl2"
#chardev_tls = 1
# If the path is not provided, but chardev_tls = 1, then the
#chardev_tls_x509_cert_dir = "/etc/pki/libvirt-chardev"
#chardev_tls_x509_verify = 1
#chardev_tls_x509_secret_uuid = "00000000-0000-0000-0000-000000000000"
#vxhs_tls = 1
# If the path is not provided, but vxhs_tls = 1, then the
#vxhs_tls_x509_cert_dir = "/etc/pki/libvirt-vxhs"
#vxhs_tls_x509_secret_uuid = "00000000-0000-0000-0000-000000000000"
#nbd_tls = 1
# If the path is not provided, but nbd_tls = 1, then the
#nbd_tls_x509_cert_dir = "/etc/pki/libvirt-nbd"
#nbd_tls_x509_secret_uuid = "00000000-0000-0000-0000-000000000000"
#migrate_tls_x509_cert_dir = "/etc/pki/libvirt-migrate"
#migrate_tls_x509_verify = 1
#migrate_tls_x509_secret_uuid = "00000000-0000-0000-0000-000000000000"
#migrate_tls_force = 0
#backup_tls_x509_cert_dir = "/etc/pki/libvirt-backup"
#backup_tls_x509_verify = 1
#backup_tls_x509_secret_uuid = "00000000-0000-0000-0000-000000000000"
#nographics_allow_host_audio = 1
#remote_display_port_min = 5900
#remote_display_port_max = 65535
#remote_websocket_port_min = 5700
#remote_websocket_port_max = 65535
#       security_driver = [ "selinux", "apparmor" ]
#security_driver = "selinux"
#security_default_confined = 1
#security_require_confined = 1
#       user = "qemu"   # A user named "qemu"
#       user = "+0"     # Super user (uid=0)
#       user = "100"    # A user named "100" or a user with uid=100
#user = "root"
#group = "root"
#dynamic_ownership = 1
#remember_owner = 1
#cgroup_controllers = [ "cpu", "devices", "memory", "blkio", "cpuset", "cpuacct" ]
#cgroup_device_acl = [
#save_image_format = "raw"
#dump_image_format = "raw"
#snapshot_image_format = "raw"
#auto_dump_path = "/var/lib/libvirt/qemu/dump"
#auto_dump_bypass_cache = 0
#auto_start_bypass_cache = 0
#     hugetlbfs_mount = ["/dev/hugepages2M", "/dev/hugepages1G"]
#hugetlbfs_mount = "/dev/hugepages"
# is used to create <source type='bridge'> interfaces when libvirtd is
#bridge_helper = "/usr/libexec/qemu-bridge-helper"
#set_process_name = 1
#max_processes = 0
#max_files = 0
#max_threads_per_process = 0
#   <memory dumpcore="on">...guest ram...</memory>
#max_core = "unlimited"
#dump_guest_core = 1
#mac_filter = 1
#relaxed_acs_check = 1
#lock_manager = "lockd"
#max_queued = 0
#keepalive_interval = 5
#keepalive_count = 5
# 1 == seccomp enabled, 0 == seccomp disabled
# only if QEMU >= 2.11.0 is detected, otherwise it is
#seccomp_sandbox = 1
#migration_address = "0.0.0.0"
#migration_host = "host.example.com"
#migration_port_min = 49152
#migration_port_max = 49215
#log_timestamp = 0
#nvram = [
#stdio_handler = "logd"
#gluster_debug_level = 9
#virtiofsd_debug = 1
#namespaces = [ "mount" ]
#memory_backing_dir = "/var/lib/libvirt/qemu/ram"
#pr_helper = "/usr/bin/qemu-pr-helper"
#slirp_helper = "/usr/bin/slirp-helper"
#dbus_daemon = "/usr/bin/dbus-daemon"
#swtpm_user = "tss"
#swtpm_group = "tss"
#capability_filters = [ "capname" ]

```

- virtlock/log

```bash
Administrator@WIN-2208071245 MINGW64 /d/Development/Projects/_ee/fk-docker-libvirtd/build/etc/libvirt (sam-custom)
$ cat virtlockd.conf |grep =
#log_level = 3
#log_filters="1:locking 4:object 4:json 4:event 1:util"
#log_outputs="3:syslog:virtlockd"
#max_clients = 1024
#admin_max_clients = 5
$ cat virtlogd.conf |grep =
#log_level = 3
#log_filters="1:logging 4:object 4:json 4:event 1:util"
#log_outputs="3:syslog:virtlogd"
#max_clients = 1024
#admin_max_clients = 5
#max_size = 2097152
#max_backups = 3

```

- network.conf/libvirt.conf

```bash
# network.conf
# ref https://wiki.archlinux.org/title/Libvirt
# default: #firewall_backend = "nftables"
firewall_backend = "iptables"

# libvirt.conf
#uri_aliases = [
#  "hail=qemu+ssh://root@hail.cloud.example.com/system",
#  "sleet=qemu+ssh://root@sleet.cloud.example.com/system",
#]
#uri_default = "qemu:///system"
```


- mnt|var-lib-libvirt,var-run-libvirt

```bash
# out-ct
# root @ deb11-11 in .../apps/fk-docker-libvirtd |13:49:24  |sam-custom U:2 ?:7 _| 
$ tree -h var-lib-libvirt/
var-lib-libvirt/
|-- [4.0K]  dnsmasq
|   |-- [   0]  default.addnhosts
|   |-- [ 619]  default.conf
|   |-- [   0]  default.hostsfile
|   |-- [   0]  virbr0.status
|   |-- [  91]  virbr1.macs
|   |-- [ 157]  virbr1.status
|   |-- [   0]  virter.addnhosts
|   |-- [ 570]  virter.conf
|   `-- [ 279]  virter.hostsfile
|-- [4.0K]  images
|   |-- [ 21M]  virter:layer:sha256:7d6355852aeb6dbcd191bcda7cd74f1536cfe5cbf8a10495a7283a8396e4b75b
|   |-- [192K]  virter:tag:cirros-v063
|   |-- [192K]  virter:work:cirros-v063-101
|   |-- [ 44K]  virter:work:cirros-v063-101-cidata
..
|   |-- [530M]  virter:work:cirros-v063-109
|   `-- [ 44K]  virter:work:cirros-v063-109-cidata
`-- [4.0K]  qemu
    |-- [4.0K]  channel
    |   `-- [4.0K]  target
    |-- [4.0K]  checkpoint
    |-- [4.0K]  domain-1-cirros-v063-109
    |   |-- [  32]  master-key.aes
    |   `-- [   0]  monitor.sock
    |-- [4.0K]  dump
    |-- [4.0K]  nvram
    |-- [4.0K]  ram
    |   `-- [4.0K]  libvirt
    |       `-- [4.0K]  qemu
    |-- [4.0K]  save
    `-- [4.0K]  snapshot
14 directories, 31 files

# root @ deb11-11 in .../apps/fk-docker-libvirtd |13:49:39  |sam-custom U:2 ?:7 _| 
$ tree -h var-run-libvirt/
var-run-libvirt/
|-- [4.0K]  common
|   `-- [  32]  system.token
|-- [4.0K]  hostdevmgr
|-- [4.0K]  interface
|   `-- [   2]  driver.pid
|-- [   0]  libvirt-admin-sock
|-- [   0]  libvirt-sock
|-- [   0]  libvirt-sock-ro
|-- [4.0K]  network
|   |-- [   0]  autostarted
|   |-- [   4]  default.pid
|   |-- [ 758]  default.xml
|   |-- [   2]  driver.pid
|   |-- [   0]  nwfilter.leases
|   |-- [4.0K]  virter
|   |   `-- [4.0K]  ports
|   |       `-- [ 532]  02c7d862-a1d5-499e-97fc-a28723d64639.xml
|   |-- [   4]  virter.pid
|   `-- [1.2K]  virter.xml
|-- [4.0K]  nodedev
|   `-- [   2]  driver.pid
|-- [4.0K]  nwfilter
|   `-- [   2]  driver.pid
|-- [4.0K]  nwfilter-binding
|-- [4.0K]  qemu
|   |-- [   0]  autostarted
|   |-- [4.0K]  channel
|   |   `-- [4.0K]  1-cirros-v063-109
|   |-- [   3]  cirros-v063-109.pid
|   |-- [ 14K]  cirros-v063-109.xml
|   |-- [4.0K]  dbus
|   |-- [   2]  driver.pid
|   |-- [4.0K]  passt
|   `-- [4.0K]  slirp
|-- [4.0K]  secrets
|   `-- [   2]  driver.pid
|-- [4.0K]  storage
|   |-- [   0]  autostarted
|   |-- [ 587]  default.xml
|   `-- [   2]  driver.pid
|-- [   0]  virtlockd-admin-sock
|-- [   0]  virtlockd-sock
|-- [   0]  virtlogd-admin-sock
`-- [   0]  virtlogd-sock
17 directories, 27 files
```
