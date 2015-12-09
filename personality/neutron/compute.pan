unique template personality/neutron/compute;

# Install RPMs for compute part of neutron
include 'personality/neutron/rpms/compute';

# Restart neutron specific daemon
include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'neutron-linuxbridge-agent/on' = '';
'neutron-linuxbridge-agent/startstop' = true;

# Configuration file for neutron
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}';
'module' = 'tiny';

# [DEFAULT] section
'contents/DEFAULT/auth_strategy' = 'keystone';
'contents/DEFAULT/rpc_backend' = 'rabbit';
'contents/DEFAULT/verbose' = 'True';

# [keystone_authtoken] section
'contents/keystone_authtoken/auth_uri' = 'http://' + OS_KEYSTONE_CONTROLLER_HOST + ':5000';
'contents/keystone_authtoken/auth_url' = 'http://' + OS_KEYSTONE_CONTROLLER_HOST + ':35357';
'contents/keystone_authtoken/auth_plugin' = 'password';
'contents/keystone_authtoken/project_domain_id' = 'default';
'contents/keystone_authtoken/user_domain_id' = 'default';
'contents/keystone_authtoken/project_name' = 'service';
'contents/keystone_authtoken/username' = OS_NEUTRON_USERNAME;
'contents/keystone_authtoken/password' = OS_NEUTRON_PASSWORD;

# [oslo_concurency] section
'contents/oslo_concurency/lock_path' = '/var/lib/neutron/tmp';
#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit/rabbit_host' = OS_RABBITMQ_HOST;
'contents/oslo_messaging_rabbit/rabbit_userid' = OS_RABBITMQ_USERNAME;
'contents/oslo_messaging_rabbit/rabbit_password' = OS_RABBITMQ_PASSWORD;

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

# Create symlink from /etc/neutron/plugins/ml2/ml2_conf.ini to /etc/neutron/plugin.ini
include 'components/symlink/config';
prefix '/software/components/symlink';
'links' = {
  SELF[length(SELF)] = dict(
    'exists', false,
    'name', '/etc/neutron/plugin.ini',
    'replace', dict( 'all', 'yes'),
    'target', '/etc/neutron/plugins/ml2/ml2_conf.ini'
  );
  SELF;
};
