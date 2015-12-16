unique template features/neutron/network/types/provider-network;

include 'components/metaconfig/config';

prefix '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}';
'module' = 'tiny';
# [DEFAULT]
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT/core_plugin' = 'ml2';
'contents/DEFAULT/service_plugins' = 'router';
'contents/DEFAULT/allow_overlapping_ips' = 'True';
'contents/DEFAULT/rpc_backend' = 'rabbit';
'contents/DEFAULT/auth_strategy' = 'keystone';

# [keystone_authtoken]
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
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
'contents/DEFAULT' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/DEFAULT/username' = OS_NEUTRON_USERNAME;
'contents/DEFAULT/password' = OS_NEUTRON_PASSWORD;
'contents/DEFAULT/auth_regions' = OS_REGION_NAME;
'contents/DEFAULT/nova_metadata_ip' = OS_METADATA_HOST;
'contents/DEFAULT/metadata_proxy_shared_secret' = OS_METADATA_SECRET;
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
