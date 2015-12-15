unique template features/neutron/network/config;

# Install RPMs for compute part of neutron
include 'features/neutron/network/rpms/config';

# Configure some usefull package for neutron
include 'features/httpd/config';
include 'features/memcache/config';

# network driver configuration
include 'features/neutron/network/'+OS_NEUTRON_NETWORK_DRIVER;

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'neutron-server/on' = '';
'neutron-server/startstop' = true;

include 'components/metaconfig/config';

prefix '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}';
'module' = 'tiny';
# [DEFAULT]
'contents/DEFAULT/verbose' = 'True';
'contents/DEFAULT/core_plugin' = 'ml2';
'contents/DEFAULT/service_plugins' = 'router';
'contents/DEFAULT/allow_overlapping_ips' = 'True';
'contents/DEFAULT/rpc_backend' = 'rabbit';
'contents/DEFAULT/auth_strategy' = 'keystone';

# [keystone_authtoken]
'contents/keystone_authtoken/auth_uri' = 'http://' + OS_KEYSTONE_CONTROLLER_HOST + ':5000';
'contents/keystone_authtoken/auth_url' = 'http://' + OS_KEYSTONE_CONTROLLER_HOST + ':35357';
'contents/keystone_authtoken/auth_plugin' = 'password';
'contents/keystone_authtoken/project_domain_id' = 'default';
'contents/keystone_authtoken/user_domain_id' = 'default';
'contents/keystone_authtoken/project_name' = 'service';
'contents/keystone_authtoken/username' = OS_NEUTRON_USERNAME;
'contents/keystone_authtoken/password' = OS_NEUTRON_PASSWORD;

# [oslo_messaging_rabbit]
'contents/oslo_messaging_rabbit/rabbit_host' = OS_RABBITMQ_HOST;
'contents/oslo_messaging_rabbit/rabbit_userid' = OS_RABBITMQ_USERNAME;
'contents/oslo_messaging_rabbit/rabbit_password' = OS_RABBITMQ_PASSWORD;

# /etc/neutron/metadata_agent.ini
prefix '/software/components/metaconfig/services/{/etc/neutron/metadata_agent.ini}';
'module' = 'tiny';
# [DEFAULT] section
'contents/DEFAULT/auth_uri' = 'http://' + OS_KEYSTONE_CONTROLLER_HOST + ':5000';
'contents/DEFAULT/auth_url' = 'http://' + OS_KEYSTONE_CONTROLLER_HOST + ':35357';
'contents/DEFAULT/auth_region' = OS_REGION_NAME;
'contents/DEFAULT/auth_plugin' = 'password';
'contents/DEFAULT/project_domain_id' = 'default';
'contents/DEFAULT/user_domain_id' = 'default';
'contents/DEFAULT/project_name' = 'service';
'contents/DEFAULT/username' = OS_NEUTRON_USERNAME;
'contents/DEFAULT/password' = OS_NEUTRON_PASSWORD;
'contents/DEFAULT/nova_metadata_ip' = OS_METADATA_HOST;
'contents/DEFAULT/metadata_proxy_shared_secret' = OS_METADATA_SECRET;
'contents/DEFAULT/verbose' = 'True';

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
