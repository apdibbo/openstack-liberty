unique template features/neutron/network/config;

# Install RPMs for compute part of neutron
include 'features/neutron/network/rpms/config';

# Configure some usefull package for neutron
include 'features/httpd/config';
include 'features/memcache/config';

# network driver configuration
include 'features/neutron/network/drivers/' + OS_NEUTRON_NETWORK_DRIVER;

# Include some common configuration
include 'features/neutron/common/config';

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'neutron-server/on' = '';
'neutron-server/startstop' = true;

# Include configuration based on type of network (based on RDO documentation types)
# * provider-network
# * self-service
include 'features/neutron/network/types/' + OS_NEUTRON_NETWORK_TYPE;
