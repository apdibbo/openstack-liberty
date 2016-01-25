unique template machine-types/cloud/controller;

variable OS_NODE_TYPE ?= 'controller';
include 'machine-types/cloud/base';

include 'features/mariadb/config';
include 'features/rabbitmq/config';
include 'features/mongodb/config';

include 'personality/keystone/config';
include 'personality/glance/config';
include 'personality/nova/config';
include 'personality/neutron/config';
include 'features/neutron/network/config';
include 'personality/dashboard/config';
include 'personality/heat/config';
include 'personality/cinder/config';
include 'personality/ceilometer/config';

include 'defaults/openstack/utils';
