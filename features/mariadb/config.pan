unique template features/mariadb/config;

include 'features/mariadb/rpms/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'mariadb/on' = '';
'mariadb/startstop' = true;

include 'components/mysql/config';
prefix '/software/components/mysql';
'servers' = {
  # Keystone server configuration
  SELF[OS_KEYSTONE_DB_HOST]['adminpwd'] = OS_DB_ADMIN_PASSWORD;
  SELF[OS_KEYSTONE_DB_HOST]['adminuser'] = OS_DB_ADMIN_USERNAME;

  # Glance server configuration
  SELF[OS_GLANCE_DB_HOST]['adminpwd'] = OS_DB_ADMIN_PASSWORD;
  SELF[OS_GLANCE_DB_HOST]['adminuser'] = OS_DB_ADMIN_USERNAME;

  # Nova server configuration
  SELF[OS_NOVA_DB_HOST]['adminpwd'] = OS_DB_ADMIN_PASSWORD;
  SELF[OS_NOVA_DB_HOST]['adminuser'] = OS_DB_ADMIN_USERNAME;

  # Neutron server configuration
  SELF[OS_NEUTRON_DB_HOST]['adminpwd'] = OS_DB_ADMIN_PASSWORD;
  SELF[OS_NEUTRON_DB_HOST]['adminuser'] = OS_DB_ADMIN_USERNAME;
  SELF;
};
'serviceName' = 'mariadb';

# Configure each database
include 'features/mariadb/keystone';
include 'features/mariadb/glance';
include 'features/mariadb/neutron';
include 'features/mariadb/nova';