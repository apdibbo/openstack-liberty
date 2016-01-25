template features/cinder/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# include useful stuff
include 'defaults/openstack/utils';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

include 'features/cinder/rpms/config';

# Configuration file for cinder
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/cinder/cinder.conf}';
'module' = 'tiny';

# [DEFAULT] section
'contents/DEFAULT/rpc_backend' = 'rabbit';
'contents/DEFAULT/auth_strategy' = 'keystone';
'contents/DEFAULT/my_ip' = PRIMARY_IP;
'contents/DEFAULT' = openstack_load_config('features/openstack/logging/' + OS_LOGGING_TYPE);
'contents/DEFAULT/cert_file' = if (OS_SSL) {
  OS_SSL_CERT;
} else {
  null;
};
'contents/DEFAULT/key_file' = if (OS_SSL) {
  OS_SSL_KEY;
} else {
  null;
};

# [oslo_concurrency]
'contents/oslo_concurrency/lock_path' = '/var/lib/cinder/tmp';
#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');

# [keystone_authtoken]
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_NEUTRON_USERNAME;
'contents/keystone_authtoken/password' = OS_NEUTRON_PASSWORD;

# [database] section
'contents/database/connection' = 'mysql://' +
  OS_CINDER_DB_USERNAME + ':' +
  OS_CINDER_DB_PASSWORD + '@' +
  OS_CINDER_DB_HOST + '/cinder';
