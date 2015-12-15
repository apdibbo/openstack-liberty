unique template features/nova/compute/config;


# Include RPMS for nova hypervisor configuration
include 'features/nova/compute/rpms/config';


# Restart nova specific daemon
include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'libvirtd/on' = '';
'libvirtd/startstop' = true;
'openstack-nova-compute/on' = '';
'openstack-nova-compute/startstop' = true;

# Configuration file for nova
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}';
'module' = 'tiny';
'daemons/openstack-nova-compute'='restart';
'daemons/libvirtd'='restart';

# [DEFAULT] section
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT/rcp_backend' = 'rabbit';
'contents/DEFAULT/auth_strategy' = 'keystone';
'contents/DEFAULT/my_ip' = DB_IP[escape(FULL_HOSTNAME)];
'contents/DEFAULT/network_api_class' = 'nova.network.neutronv2.api.API';
'contents/DEFAULT/security_group_api' = 'neutron';
'contents/DEFAULT/linuxnet_interface_driver' = 'nova.network.linux_net.NeutronLinuxBridgeInterfaceDriver';
'contents/DEFAULT/firewall_driver' = 'nova.virt.firewall.NoopFirewallDriver';

# [glance] section
'contents/glance/host' = OS_GLANCE_CONTROLLER_HOST;

# [keystone_authtoken] section
'contents/keystone_authtoken/auth_uri' = 'http://' + OS_KEYSTONE_CONTROLLER_HOST + ':5000';
'contents/keystone_authtoken/auth_url' = 'http://' + OS_KEYSTONE_CONTROLLER_HOST + ':35357';
'contents/keystone_authtoken/auth_plugin' = 'password';
'contents/keystone_auth/project_domain_id' = 'default';
'contents/keystone_auth/user_domain_id' = 'default';
'contents/keystone_auth/project_name' = 'service';
'contents/keystone_auth/username' = OS_NOVA_USERNAME;
'contents/keystone_auth/password' = OS_NOVA_PASSWORD;

# [libvirtd] section
'contents/libvirt/virt_type' = 'qemu';

# [neutron] section
'contents/neutron/url' = 'http://' + OS_NEUTRON_CONTROLLER_HOST + ':9696';
'contents/neutron/auth_url' = 'http://' + OS_KEYSTONE_CONTROLLER_HOST + ':35357';
'contents/neutron/auth_plugin' = 'password';
'contents/neutron/project_domain_id' = 'default';
'contents/neutron/user_domain_id' = 'default';
'contents/neutron/region_name' = OS_REGION_NAME;
'contents/neutron/project_name' = 'service';
'contents/neutron/username' = OS_NEUTRON_USERNAME;
'contents/neutron/password' = OS_NEUTRON_PASSWORD;

# [oslo_concurrency]
'contents/oslo_concurrency/lock_path' = '/var/lib/nova/tmp';
# [oslo_messaging_rabbit]
'contents/oslo_messaging_rabbit/rabbit_host' = OS_RABBITMQ_HOST;
'contents/oslo_messaging_rabbit/rabbit_userid' = OS_RABBITMQ_USERNAME;
'contents/oslo_messaging_rabbit/rabbit_password' = OS_RABBITMQ_PASSWORD;

# [vnc] section
'contents/vnc/enabled' = 'True';
'contents/vnc/vncserver_listen' = '0.0.0.0';
'contents/vnc/vncserver_proxyclient_address' = '$my_ip';
'contents/vnc/novncproxy_base_url' = 'http://' + OS_NOVA_CONTROLLER_HOST + ':6080/vnc_auto.html';
