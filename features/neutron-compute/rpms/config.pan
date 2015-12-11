unique template features/neutron/rpms/config;

prefix '/software/packages';
# Install Neutron Hypervisor part
'{openstack-neutron}' ?= dict();
'{openstack-neutron-linuxbridge}' ?= dict();
'{ebtables}' ?= dict();
'{ipset}' ?= dict();
