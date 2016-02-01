template features/mongodb/config;

include 'features/mongodb/rpms/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'mongod/on' = '';
'mongod/startstop' = true;

# Configuration file for MongoDB
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/mongod.conf}';
'module' = 'tiny';
'daemons/mongod' = 'restart';
'contents/bind_ip' = PRIMARY_IP;
