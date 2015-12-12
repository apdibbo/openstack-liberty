unique template personality/keystone/config;

include 'personality/keystone/rpms/config';

# Include some usefull configuration
include 'features/httpd/config';
include 'features/memcache/config';

# Configuration file for keystone
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/keystone/keystone.conf}';
'module' = 'tiny';

# [DEFAULT] section
'contents/DEFAULT/admin_token' ?= OS_ADMIN_TOKEN;
'contents/DEFAULT/verbose' ?= 'True';

# [database] section
'contents/database/connection' = 'mysql://' +
  OS_KEYSTONE_DB_USERNAME + ':' +
  OS_KEYSTONE_DB_PASSWORD + '@' +
  OS_KEYSTONE_DB_HOST +
  '/keystone';

# [memcache] section
'contents/memcache/servers' = OS_MEMCACHE_HOST + ':11211';

# [revoke] section
'contents/revoke/driver' = 'sql';

# [token] section
'contents/token/provider' = 'uuid';
'contents/token/driver' = 'memcache';