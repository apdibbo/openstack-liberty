unique template personality/nova/config;

# Variable can be 'compute' or 'controller'
variable OS_NODE_TYPE ?= 'compute';

include 'personality/nova/' + OS_NODE_TYPE;