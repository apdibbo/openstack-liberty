unique template features/nova/controller/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

# Install RPMs for compute part of neutron
include 'features/nova/controller/rpms/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'openstack-nova-api/on' = '';
'openstack-nova-api/startstop' = true;
'openstack-nova-cert/on' = '';
'openstack-nova-cert/startstop' = true;
'openstack-nova-consoleauth/on' = '';
'openstack-nova-consoleauth/startstop' = true;
'openstack-nova-scheduler/on' = '';
'openstack-nova-scheduler/startstop' = true;
'openstack-nova-conductor/on' = '';
'openstack-nova-conductor/startstop' = true;
'openstack-nova-novncproxy/on' = '';
'openstack-nova-novncproxy/startstop' = true;

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/nova/nova.conf}';
'module' = 'tiny';
#'daemons/openstack-nova-api'='restart';
#'daemons/openstack-nova-cert'='restart';
#'daemons/openstack-nova-consoleauth'='restart';
#'daemons/openstack-nova-scheduler'='restart';
#'daemons/openstack-nova-conductor'='restart';
#'daemons/openstack-nova-novncproxy'='restart';
# [DEFAULT] section
'contents/DEFAULT/rpc_backend' = 'rabbit';
'contents/DEFAULT/auth_strategy' = 'keystone';
'contents/DEFAULT/my_ip' = PRIMARY_IP;
'contents/DEFAULT/network_api_class' = 'nova.network.neutronv2.api.API';
'contents/DEFAULT/security_group_api' = 'neutron';
'contents/DEFAULT/linuxnet_interface_driver' = 'nova.network.linux_net.NeutronLinuxBridgeInterfaceDriver';
'contents/DEFAULT/firewall_driver' = 'nova.virt.firewall.NoopFirewallDriver';
'contents/DEFAULT/enabled_apis' = 'osapi_compute,metadata';
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);

# [database] section
'contents/database/connection' = 'mysql://' +
  OS_NOVA_DB_USERNAME + ':' +
  OS_NOVA_DB_PASSWORD + '@' +
  OS_NOVA_DB_HOST + '/nova';

# [glance] section
'contents/glance/host' = OS_GLANCE_CONTROLLER_HOST;

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_NOVA_USERNAME;
'contents/keystone_authtoken/password' = OS_NOVA_PASSWORD;

# [neutron] section
'contents/neutron/url' = 'http://' + OS_NEUTRON_CONTROLLER_HOST + ':9696';
'contents/neutron/auth_url' = 'http://' + OS_KEYSTONE_CONTROLLER_HOST + ':35357';
'contents/neutron/auth_plugin' = 'password';
'contents/neutron/project_domain_id' = 'default';
'contents/neutron/user_domain_id' = 'default';
'contents/neutron/region_name' = OS_REGION_NAME;
'contents/neutron/project_name' = 'service';
'contents/neutron/username' = OS_NEUTRON_USERNAME;
'contents/neutron/password' = OS_NEUTRON_PASSWORD;
'contents/neutron/service_metadata_proxy' = 'True';
'contents/neutron/metadata_proxy_shared_secret' = OS_METADATA_SECRET;

# [oslo_concurrency]
'contents/oslo_concurrency/lock_path' = '/var/lib/nova/tmp';
# [oslo_rabbit]
'contents/oslo_messaging_rabbit/rabbit_host' = OS_RABBITMQ_HOST;
'contents/oslo_messaging_rabbit/rabbit_userid' = OS_RABBITMQ_USERNAME;
'contents/oslo_messaging_rabbit/rabbit_password' = OS_RABBITMQ_PASSWORD;

# [vnc] section
'contents/vnc/vncserver_listen' = '$my_ip';
'contents/vnc/vncserver_proxyclient_address' = '$my_ip';
