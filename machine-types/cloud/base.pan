unique template machine-types/cloud/base;

include 'machine-types/core';
# Load some usefull functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

prefix '/software/packages';

# Some usefull RPMs that should be automaticaly added
'{openstack-selinux}' ?= dict();
'{openstack-packstack}' ?= dict();
'{python-openstackclient}' ?= dict();
