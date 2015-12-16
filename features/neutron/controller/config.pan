unique template features/neutron/controller/config;

# Install RPMs for compute part of neutron
include 'features/neutron/controller/rpms/config';

# Configure some usefull package for neutron
include 'features/httpd/config';
include 'features/memcache/config';

# network driver configuration
include 'features/neutron/controller/drivers/' + OS_NEUTRON_NETWORK_DRIVER;

# Include some common configuration
include 'features/neutron/common/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'neutron-server/on' = '';
'neutron-server/startstop' = true;

# Include configuration based on type of network (based on RDO documentation types)
# * provider-network
# * self-service
include 'features/neutron/controller/types/' + OS_NEUTRON_NETWORK_TYPE;