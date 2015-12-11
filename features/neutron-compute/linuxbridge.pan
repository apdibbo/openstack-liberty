template features/neutron-compute/linuxbridge;

include 'features/neutron-compute/rpms/linuxbridge';

# Restart neutron specific daemon
include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'neutron-linuxbridge-agent/on' = '';
'neutron-linuxbridge-agent/startstop' = true;

# Configuration file for linuxbridge_agent.ini
prefix '/software/components/metaconfig/services/{/etc/neutron/plugins/ml2/linuxbridge_agent.ini}';
'module' = 'tiny';

# [linux_bridge] section
#TODO: eth0 must be compute
'contents/linux_bridge/physical_interface_mappings' = 'public:' + OS_INTERFACE_MAPPING;

# [vxlan] section
'contents/vxlan/enable_vxlan' = 'False';

# [agent] section
'contents/agent/prevent_arp_spoofing' = 'True';

# [securitygroup] section
'contents/securitygroup/enable_security_group' = 'True';
'contents/securitygroup/firewall_driver' = 'neutron.agent.linux.iptables_firewall.IptablesFirewallDriver';
