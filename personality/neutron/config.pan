unique template personality/neutron/config;

# NODE_TYPE is 'compute' or 'controller'
variable OS_NODE_TYPE ?= 'compute';

include 'personality/neutron/' + OS_NODE_TYPE;