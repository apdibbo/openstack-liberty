unique template features/ceilometer/meters/neutron;

# Configuration file for cinder
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}';
'module' = 'tiny';
'daemons/neutron-server' = 'restart';
'daemons/neutron-dhcp-agent' = 'restart';
'daemons/neutron-l3-agent' = 'restart';
'daemons/neutron-metadata-agent' = 'restart';
'daemons/neutron-linuxbridge-agent' = 'restart';

'contents/DEFAULT/notification_driver'='messagingv2';
'contents/DEFAULT/rpc_backend' = 'rabbit';
#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');
