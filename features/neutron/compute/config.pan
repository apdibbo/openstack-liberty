unique template features/neutron/compute/config;

# Install RPMs for compute part of neutron
include 'features/neutron/compute/rpms/config';

# network driver configuration
include 'features/neutron/compute/drivers/' + OS_NEUTRON_NETWORK_DRIVER;

# Include some common configuration
include 'features/neutron/common/config';

# Include configuration based on type of network (based on RDO documentation types)
# * provider-network
# * self-service
include 'features/neutron/compute/types/' + OS_NEUTRON_NETWORK_TYPE;