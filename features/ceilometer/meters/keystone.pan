unique template features/ceilometer/meters/keystone;

# Configuration file for cinder
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/keystone/keystone.conf}';
'module' = 'tiny';
'daemons/httpd' = 'restart';

# [DEFAULT] section
'contents/DEFAULT/notification_driver' = 'messagingv2';
'contents/DEFAULT/rpc_backend' = 'rabbit';
#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');
