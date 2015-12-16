template features/neutron/controller/drivers/linuxbridge;

include 'features/neutron/controller/rpms/linuxbridge';

# /etc/neutron/plugins/ml2/ml2_conf.ini
prefix '/software/components/metaconfig/services/{/etc/neutron/plugins/ml2/ml2_conf.ini}';
'module' = 'tiny';
# [ml2] section
'contents/ml2/type_drivers' = 'flat,vlan';
'contents/ml2/mechanism_drivers' = 'linuxbridge';
'contents/ml2/tenant_network_types' = '';
'contents/ml2/extension_drivers' = 'port_security';

# [ml2_type_flat]
'contents/ml2_type_flat/flat_networks' = 'public';

# [securitygroup]
'contents/securitygroup/enable_ipset' = 'True';

# /etc/neutron/plugins/ml2/linuxbridge_agent.ini
prefix '/software/components/metaconfig/services/{/etc/neutron/plugins/ml2/linuxbridge_agent.ini}';
'module' = 'tiny';

# [linux_bridge] section
'contents/linux_bridge/physical_interface_mappings' = 'public:' + OS_INTERFACE_MAPPING;

# [vxlan] section
'contents/vxlan/enable_vxlan' = 'False';

# [agent] section
'contents/agent/prevent_arp_spoofing' = 'True';

# [securitygroup] section
'contents/securitygroup/enable_security_group' = 'True';
'contents/securitygroup/firewall_driver' = 'neutron.agent.linux.iptables_firewall.IptablesFirewallDriver';
