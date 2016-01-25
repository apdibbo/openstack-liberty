unique template features/cinder/rpms/config;

# Include some useful RPMs
include 'defaults/openstack/rpms';

prefix '/software/packages';
'{openstack-cinder}' ?= dict();
'{python-cinderclient}' ?= dict();
