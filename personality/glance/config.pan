unique template personality/glance/config;

include 'personality/glance/rpms/config';

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
# [DEFAULT] section
'contents/DEFAULT/notification_driver' = 'noop';
'contents/DEFAULT/verbose' = 'True';

# [database] section
'contents/database/connection' = 'mysql://' +
  OS_GLANCE_DB_USERNAME + ':' +
  OS_GLANCE_DB_PASSWORD + '@' +
  OS_GLANCE_DB_HOST + '/glance';

# [glance_store] section
'contents/glance_store/default_store' = 'file';
'contents/glance_store/filesystem_store_datadir' = '/var/lib/glance/images/';

# [keystone_authtoken] section
'contents/keystone_authtoken/auth_uri' = 'http://' + OS_KEYSTONE_CONTROLLER_HOST + ':5000';
'contents/keystone_authtoken/auth_url' = 'http://' + OS_KEYSTONE_CONTROLLER_HOST + ':35357';
'contents/keystone_authtoken/auth_plugin' = 'password';
'contents/keystone_authtoken/project_domain_id' = 'default';
'contents/keystone_authtoken/user_domain_id' = 'default';
'contents/keystone_authtoken/project_name' = 'service';
'contents/keystone_authtoken/username' = OS_GLANCE_USERNAME;
'contents/keystone_authtoken/password' = OS_GLANCE_PASSWORD;

# [paste_deploy] section
'contents/paste_deploy/flavor' = 'keystone';

prefix '/software/components/metaconfig/services/{/etc/glance/glance-registry.conf}';
'module' = 'tiny';
# [DEFAULT] section
'contents/DEFAULT/notification_driver' = 'noop';
'contents/DEFAULT/verbose' = 'True';

# [database] section
'contents/database/connection' = 'mysql://' +
  OS_GLANCE_DB_USERNAME + ':' +
  OS_GLANCE_DB_PASSWORD + '@' +
  OS_GLANCE_DB_HOST + '/glance';

# [keystone_authtoken] section
'contents/keystone_authtoken/auth_uri' = 'http://' + OS_KEYSTONE_CONTROLLER_HOST + ':5000';
'contents/keystone_authtoken/auth_url' = 'http://' + OS_KEYSTONE_CONTROLLER_HOST + ':35357';
'contents/keystone_authtoken/auth_plugin' = 'password';
'contents/keystone_authtoken/project_domain_id' = 'default';
'contents/keystone_authtoken/user_domain_id' = 'default';
'contents/keystone_authtoken/project_name' = 'service';
'contents/keystone_authtoken/username' = OS_GLANCE_USERNAME;
'contents/keystone_authtoken/password' = OS_GLANCE_PASSWORD;

# [paste_deploy] section
'contents/paste_deploy/flavor' = 'keystone';
