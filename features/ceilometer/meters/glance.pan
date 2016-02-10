unique template features/ceilometer/meters/glance;

# Configuration file for cinder
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/glance/glance-api.conf}';
'module' = 'tiny';
'daemons/openstack-glance-api' = 'restart';

# [DEFAULT] section
'contents/DEFAULT/notification_driver' = 'messagingv2';
#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');

prefix '/software/components/metaconfig/services/{/etc/glance/glance-registry.conf}';
'module' = 'tiny';
'daemons/openstack-glance-registry' = 'restart';

# [DEFAULT] section
'contents/DEFAULT/notification_driver' = 'messagingv2';
#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');
