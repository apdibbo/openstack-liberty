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
include if (OS_INCLUDE_HEAT) {
    'personality/heat/config';
} else {
    null;
} ;
include if (OS_INCLUDE_CINDER) {
    'personality/cinder/config';
} else {
    null;
};
include if (OS_INCLUDE_CEILOMETER) {
    'personality/ceilometer/config';
} else {
    null;
};

include 'defaults/openstack/utils';
