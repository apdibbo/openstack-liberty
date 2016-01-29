unique template features/glance/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

include 'features/glance/rpms/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'openstack-glance-api/on' = '';
'openstack-glance-api/startstop' = true;
'openstack-glance-registry/on' = '';
'openstack-glance-registry/startstop' = true;

# Configuration file for glance
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/glance/glance-api.conf}';
'module' = 'tiny';
#'daemons/openstack-glance-api' = 'restart';
# [DEFAULT] section
'contents/DEFAULT/notification_driver' = 'messagingv2';
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
'contents/DEFAULT/registry_client_protocol' = OS_CONTROLLER_PROTOCOL;
'contents/DEFAULT/show_image_direct_url' = if (OS_CEPH) {
    'True';
} else {
    null;
};

#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');

# [database] section
'contents/database/connection' = 'mysql://' +
  OS_GLANCE_DB_USERNAME + ':' +
  OS_GLANCE_DB_PASSWORD + '@' +
  OS_GLANCE_DB_HOST + '/glance';

# [glance_store] section
'contents/glance_store/default_store' = if (OS_CEPH) {
    'rbd';
} else {
    'file';
};
'contents/glance_store/stores' = if (OS_CEPH) {
    'rbd';
} else {
    null;
};
'contents/glance_store/rbd_store_pool' = if (OS_CEPH) {
    OS_CEPH_GLANCE_POOL;
} else {
    null;
};
'contents/glance_store/rbd_store_user' = if (OS_CEPH) {
    OS_CEPH_GLANCE_USER;
} else {
    null;
};
'contents/glance_store/rbd_store_ceph_conf' = if (OS_CEPH) {
    OS_CEPH_GLANCE_CEPH_CONF;
} else {
    null;
};
'contents/glance_store/rbd_store_chunk_size' = if (OS_CEPH) {
    '8';
} else {
    null;
};
'contents/glance_store/filesystem_store_datadir' = OS_GLANCE_STORE_DIR;

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_GLANCE_USERNAME;
'contents/keystone_authtoken/password' = OS_GLANCE_PASSWORD;

# [paste_deploy] section
'contents/paste_deploy/flavor' = 'keystone';

prefix '/software/components/metaconfig/services/{/etc/glance/glance-registry.conf}';
'module' = 'tiny';
#'daemons/openstack-glance-registry' = 'restart';
# [DEFAULT] section
'contents/DEFAULT/notification_driver' = 'messagingv2';
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

#[oslo_messaging_rabbit] section
'contents/oslo_messaging_rabbit' = openstack_load_config('features/rabbitmq/client/openstack');

# [database] section
'contents/database/connection' = 'mysql://' +
  OS_GLANCE_DB_USERNAME + ':' +
  OS_GLANCE_DB_PASSWORD + '@' +
  OS_GLANCE_DB_HOST + '/glance';

# [keystone_authtoken] section
'contents/keystone_authtoken' = openstack_load_config(OS_AUTH_CLIENT_CONFIG);
'contents/keystone_authtoken/username' = OS_GLANCE_USERNAME;
'contents/keystone_authtoken/password' = OS_GLANCE_PASSWORD;

# [paste_deploy] section
'contents/paste_deploy/flavor' = 'keystone';
