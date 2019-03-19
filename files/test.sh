#!/bin/bash -x
# Host Physical Function
        echo -n "Enter parent interface name from which Virtual Function will be pass-through to VM: "
        read intf_name
       	
	    ifup $intf_name 
        phy_func_bdf=`ethtool -i $intf_name | grep "bus-info" | cut -f2 -d " "`
        echo 16 > /sys/bus/pci/devices/$phy_func_bdf/sriov_numvfs
        total_virt_func_bdf=`lspci | grep "Ethernet" | grep "Intel Corporation" | grep "Virtual Function" | egrep  -i "82599|X520|X540|X550|X552|X710|XL710"| head -n16 | cut -d " " -f1`
	    echo $total_virt_func_bdf > bdf_list
	    vf_num=0
	    for word in $total_virt_func_bdf; do
		    echo "testing bdf: $word"
		    driver_in_use=($(lspci -s $word -vvv | grep "Kernel driver in use" | cut -f5 -d " "))
		    echo "driver_in_use: $driver_in_use"
		    if [[ $driver_in_use == "vfio-pci" ]]; then
			    vf_num=$((vf_num + 1))
			    continue	
		    fi
		    virt_func_bdf="$word"
		    break
	    done 
	    echo "chosen virtual function: $virt_func_bdf"
	    virt_func_bdf="${virt_func_bdf//./_}" 
        virt_func_bdf="${virt_func_bdf//:/_}"
        host_device="pci_0000_$virt_func_bdf"
        
        # Cloud init files
        USER_DATA=user-data
        META_DATA=avi_meta-data
        CI_ISO=/var/lib/libvirt/images/$vm_name-cidata.iso
        
	    # Host Physical Function
        echo -n "Enter vlan-id in which Virtual Function will be hosted [Press Enter to take PF's native vlan by default]"
        read vf_vlan_id	
 	
	    vf_mac=($(ip link show eno2 | grep "vf $vf_num" | cut -f8 -d " " | sed 's/,$//'))
 	    ifdown $intf_name
	    ip link set dev $intf_name vf $vf_num trust on
	    ip link set $intf_name vf $vf_num vlan $vf_vlan_id
	    ip link set $intf_name vf $vf_num mac $vf_mac
	    ifup $intf_name
	
