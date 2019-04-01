# ansible-role-avise-kvm
Ansible Role to setup Avi Service Engines in KVM environment.

Requirements
------------
 - python >= 2.6
 - avisdk : It can be installed by `pip install avisdk --upgrade`
 - avinetworks.avisdk : It can be installed by `ansible-galaxy install -f avinetworks.avisdk` 
kvm_vm_os_disk_size
Role Variables
--------------

| Variable | Required | Default | Comments |
|----------|----------|---------|----------|
|kvm_vm_hostname|Yes||Name for VM|
|kvm_vm_base_img|No||se.qcow2 or controller.qcow2 file|
|kvm_vm_vcpus|No|4|How many cpus the service engine will use.|
|kvm_vm_ram|No|8912|How much memory the service engine will use.|
|kvm_vm_os_disk_size|Yes|40|How much disk size the service engine will use.|
|host_mgmt_intf|Yes||host management interface name|
|vm_ctrl_ip|Yes||The IP address of the controller.|
|vm_ctrl_username|Yes||The username to login into the controller.|
|vm_ctrl_password|Yes||The password to login into the controller.|
|vm_ctrl_version|Yes||The controller version.|
|state|Yes|present|If present then create service engine and for absent destroy the service engine.|
|se_auth_token|No||If defined it will be the token used to register the service engine to the controller|
|bond_seq|Yes||Bonding sequence|
|se_mgmt_ip|Yes||Management Ip for the service engine|
|se_mgmt_mask|Yes||Subnet mask|
|se_def_gw|Yes||Default gateway for service engine|
|pinning_option|Yes||If you want to enable pinning CPU for the VM|
|total_num_vfs|Yes||Numbers VFs will be pass-through to VM|
|kvm_host_ip|Yes||KVM host IP|
|kvm_host_username|Yes||KVM host Username|
|kvm_host_password|Yes||KVM host Password|
|virt_intf_name|Yes||Virtual Function name will be pass-through to VM|


### Standard Example
```

- hosts: kvm
  vars:
    kvm_vm_hostname: "se1"
    kvm_vm_base_img: se.qcow2
    kvm_vm_vcpus: "4"
    kvm_vm_ram: "8192"
    host_mgmt_intf: eno1.100
    vm_ctrl_ip: "10.170.5.21"
    vm_ctrl_username: "admin"
    vm_ctrl_password: "<controller password>"
    vm_ctrl_version: "18.2.2"
    bond_seq: "1,2,3,4"
    se_mgmt_ip: "10.170.5.15"
    se_mgmt_mask: "255.255.255.0"
    se_def_gw: "10.170.5.1"
    pinning_option: "yes"
    total_num_vfs: 4
    kvm_host_ip: "10.170.5.51"
    kvm_host_username: "<host username>"
    kvm_host_password: "<host password>"
    virt_intf_name:
      - enp24s17f1
      - enp24s17f3
      - enp24s17f5
      - enp24s17f7
  tasks:
    - name: Create KVM VM
      include_role:
        name: ansible-avise-kvm

```
