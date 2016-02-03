unique template features/keystone/identity/ldap;

# keystone.conf file is already populate with some common variable
# We add ldap configuration variable
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/keystone/keystone.conf}';
'contents/identity/driver' = OS_KEYSTONE_IDENTITY_DRIVER;
'contents/identity/domain_specific_drivers_enabled' = 'True';
'contents/identity/domain_config_dir' = '/etc/keystone/domains';

# All ldap configuration is put on /etc/keystone/domains/keystone.DOMAIN_NAME.conf
prefix '/software/components/metaconfig';
'services' = {
  foreach(domain;params;OS_KEYSTONE_IDENTITY_LDAP_PARAMS) {
    # Populate configuration file with some default value
    SELF[escape('/etc/keystone/domains/keystone.'+domain+'.conf')] = dict(
      'module', 'tiny',
      'contents', dict('ldap',dict()),
    );
    SELF[escape('/etc/keystone/domains/keystone.'+domain+'.conf')]['contents']['ldap'] = dict(
      'use_dump_member', 'False',
      'allow_subtree_delete', 'False',
      'user_objectclass', 'inetOrgPerson',
      'user_allow_create', 'False',
      'user_allow_update', 'False',
      'user_allow_delete', 'False',
      'group_objectclass', 'groupOfNames',
      'group_allow_create', 'False',
      'group_allow_update', 'False',
      'group_allow_delete', 'False',
    );
    # Verify if all needed parameters exists
    if (!exists(params['url'])) {
      error('LDAP identity need params [url]');
        };
    if (!exists(params['user'])) {
      error('LDAP identity need params [user]');
    };
    if (!exists(params['password'])) {
      error('LDAP identity need params [password]');
    };
    if (!exists(params['suffix'])) {
      error('LDAP identity need params [suffix]');
    };
    if (!exists(params['user_tree_dn'])) {
      error('LDAP identity need params [user_tree_dn]');
    };
    if (!exists(params['group_tree_dn'])) {
      error('LDAP identity need params [group_tree_dn]');
    };

    foreach(attribute;attribute_value;params) {
      SELF[escape('/etc/keystone/domains/keystone.'+domain+'.conf')]['contents']['ldap'][attribute] = attribute_value;
    };
  };
  SELF;
};