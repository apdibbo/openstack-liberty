#!/bin/bash
echo "load variable"
# RabbitMQ variable
export RABBITMQ_USERNAME=%s
export RABBITMQ_PASSWORD=%s

# Default Region
export REGION=%s

# Keystone URL
export KEYSTONE_URI="http://%s:5000"
export KEYSTONE_URL="http://%s:35357"
export GLANCE_URL="http://%s:9292"
export NOVA_URL="http://%s:8774/v2/%%\(tenant_id\)s"
export NEUTRON_URL="http://%s:9696"
export HEAT_ORCHESTRATION_URL="http://%s:8004/v1/%%\(tenant_id\)s"
export HEAT_CLOUDFORMATION_URL="http://%s:8000/v1"
export CINDER_URL="http://%s:8776/v1/%%\(tenant_id\)s"
export CINDERV2_URL="http://%s:8776/v2/%%\(tenant_id\)s"
#

export ADMIN_USERNAME=%s
export ADMIN_PASSWORD=%s
export GLANCE_USER=%s
export GLANCE_PASSWORD=%s
export NOVA_USER=%s
export NOVA_PASSWORD=%s
export NEUTRON_USER=%s
export NEUTRON_PASSWORD=%s
export HEAT_USER=%s
export HEAT_PASSWORD=%s
export HEAT_STACK_DOMAIN=%s
export HEAT_DOMAIN_ADMIN_USER=%s
export HEAT_DOMAIN_ADMIN_PASSWORD=%s
export CINDER_USER=%s
export CINDER_PASSWORD=%s
export OS_TOKEN=%s
export NEUTRON_DEFAULT_NETWORK=%s
export NEUTRON_DEFAULT_DHCP_START=%s
export NEUTRON_DEFAULT_DHPC_END=%s
export NEUTRON_DEFAULT_GATEWAY=%s
export NEUTRON_DEFAULT_NAMESERVER=%s
#
export OS_PROJECT_DOMAIN_ID=default
export OS_USER_DOMAIN_ID=default
export OS_PROJECT_NAME=admin
export OS_TENANT_NAME=admin
export OS_USERNAME=$ADMIN_USERNAME
export OS_PASSWORD=$ADMIN_PASSWORD
export OS_URL=$KEYSTONE_URL/v3
export OS_AUTH_URL=$OS_URL
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2

# Internal variables
export ENDPOINT_TYPES="public internal"
export ADMIN_ENDPOINT_TYPE="admin"

export DEBUG_RABBITMQ=$DEBUG
export DEBUG_DOMAINS=$DEBUG
export DEBUG_DATABASES=$DEBUG
export DEBUG_SERVICES=$DEBUG
export DEBUG_ENDPOINTS=$DEBUG
export DEBUG_PROJECTS=$DEBUG
export DEBUG_ROLES=$DEBUG
export DEBUG_USERS=$DEBUG
export DEBUG_USERS_TO_ROLES=$DEBUG
export DEBUG_NETWORKS=$DEBUG

echo "[START] Rabbitmq configuration"
$DEBUG_RABBITMQ rabbitmqctl add_user $RABBITMQ_USERNAME $RABBITMQ_PASSWORD
$DEBUG_RABBITMQ rabbitmqctl set_permissions $RABBITMQ_USERNAME ".*" ".*" ".*"
echo "[DONE] Rabbitmq configuration"

echo "[START] Domain configuration"
$DEBUG_DOMAINS openstack domain create --description "Stack projects and users" $HEAT_STACK_DOMAIN
echo "[DONE] Domain configuration"

echo "[START] Databases configuration"
echo "  Identity service"
$DEBUG_DATABASES su -s /bin/sh -c "keystone-manage db_sync" keystone
echo "  Network service"
$DEBUG_DATABASES su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
echo "  Image service"
$DEBUG_DATABASES su -s /bin/sh -c "glance-manage db_sync" glance
echo "  Compute service"
$DEBUG_DATABASES su -s /bin/sh -c "nova-manage db sync" nova
echo "  Orchestration service"
$DEBUG_DATABASES su -s /bin/sh -c "heat-manage db_sync" heat
echo "  Block service"
$DEBUG_DATABASES su -s /bin/sh -c "cinder-manage db sync" cinder
echo "[DONE] Database configuration"

echo "[START] service configuration"
systemctl start openstack-keystone
echo "  keystone"
$DEBUG_SERVICES openstack service create --name keystone --description "Openstack Identity" identity
echo "  glance"
$DEBUG_SERVICES openstack service create --name glance   --description "OpenStack Image service" image
echo "  nova"
$DEBUG_SERVICES openstack service create --name nova   --description "OpenStack Compute" compute
echo "  neutron"
$DEBUG_SERVICES openstack service create --name neutron   --description "OpenStack Networking" network
echo "  heat"
$DEBUG_SERVICES openstack service create --name heat --description "Orchestration" orchestration
echo "  heat cfn"
$DEBUG_SERVICES openstack service create --name heat-cfn --description "Orchestration"  cloudformation
echo "  cinder volume"
$DEBUG_SERVICES openstack service create --name cinder   --description "OpenStack Block Storage" volume
echo "  cinder volumev2"
$DEBUG_SERVICES openstack service create --name cinder   --description "OpenStack Block Storage" volumev2
echo "[END] service configuration"

echo "[START] endpoints configuration"
echo "  Identity endpoint"
for endpoint_type in $ENDPOINT_TYPES
do
  $DEBUG_ENDPOINTS openstack endpoint create --region $REGION identity $endpoint_type $KEYSTONE_URI/v2.0
done
$DEBUG_ENDPOINTS openstack endpoint create --region $REGION identity $ADMIN_ENDPOINT_TYPE $KEYSTONE_URL/v2.0
echo "  Glance endpoint"
for endpoint_type in $ENDPOINT_TYPES $ADMIN_ENDPOINT_TYPE
do
  $DEBUG_ENDPOINTS openstack endpoint create --region $REGION image $endpoint_type $GLANCE_URL
done
echo "  Nova endpoint"
for endpoint_type in $ENDPOINT_TYPES $ADMIN_ENDPOINT_TYPE
do
  $DEBUG_ENDPOINTS openstack endpoint create --region $REGION \
     compute $endpoint_type \
     $NOVA_URL
done
echo "  Neutron endpoint"
for endpoint_type in $ENDPOINT_TYPES $ADMIN_ENDPOINT_TYPE
do
  $DEBUG_ENDPOINTS openstack endpoint create --region $REGION \
     network $endpoint_type \
     $NEUTRON_URL
done
echo "  Heat endpoint"
for endpoint_type in $ENDPOINT_TYPES $ADMIN_ENDPOINT_TYPE
do
  $DEBUG_ENDPOINTS openstack endpoint create --region $REGION \
     orchestration $endpoint_type \
     $HEAT_ORCHESTRATION_URL
  $DEBUG_ENDPOINTS openstack endpoint create --region $REGION \
     cloudformation $endpoint_type \
     $HEAT_CLOUDFORMATION_URL
done
echo "  Cinder endpoint"
for endpoint_type in $ENDPOINT_TYPES $ADMIN_ENDPOINT_TYPE
do
  $DEBUG_ENDPOINTS openstack endpoint create --region $REGION volume $endpoint_type $CINDER_URL
  $DEBUG_ENDPOINTS openstack endpoint create --region $REGION volumev2 $endpoint_type $CINDERV2_URL
done
echo "[END] endpoints configuration"

echo "[START] Project configuration"
echo "  service project"
$DEBUG_PROJECTS openstack project create --domain default   --description "Service Project" service
echo "  admin project"
$DEBUG_PROJECTS openstack project create --domain default --description "Admin project" admin
echo "[END] Project configuration"

echo "[START] Role configuration"
echo "  admin role"
$DEBUG_ROLES openstack role create admin
echo "  role user"
$DEBUG_ROLES openstack role create user
echo "  role heat_stack_owner"
$DEBUG_ROLES openstack role create heat_stack_owner
echo "[END] Role configuration"

echo "[START] User configuration"
echo "  admin user [$ADMIN_USERNAME]"
$DEBUG_USERS openstack user create --domain default --password $ADMIN_PASSWORD $ADMIN_USERNAME
echo "  glance user [$GLANCE_USER]"
$DEBUG_USERS openstack user create --domain default --password $GLANCE_PASSWORD $GLANCE_USER
echo "  nova user [$NOVA_USER]"
$DEBUG_USERS openstack user create --domain default --password $NOVA_PASSWORD $NOVA_USER
echo "  neutron user [$NEUTRON_USER]"
$DEBUG_USERS openstack user create --domain default --password $NEUTRON_PASSWORD $NEUTRON_USER
<<<<<<< HEAD
echo "  heat user [$HEAT_USER]"
$DEBUG_USERS openstack user create --domain default --password $HEAT_PASSWORD $HEAT_USER
echo "  heat domain admin user [$HEAT_USER]"
$DEBUG_USERS openstack user create --domain $HEAT_STACK_DOMAIN --password $HEAT_DOMAIN_ADMIN_PASSWORD $HEAT_DOMAIN_ADMIN_USER
=======
echo "  cinder user [$CINDER_USER]"
$DEBUG_USERS openstack user create --domain default --password $CINDER_PASSWORD $CINDER_USER
>>>>>>> 2638171... add cinder feature
echo "[END] User configuration"

echo "[START] Role configuration"
echo "  Role for admin"
$DEBUG_USERS_TO_ROLES openstack role add --project admin --user $ADMIN_USERNAME admin
echo "  Role for glance"
$DEBUG_USERS_TO_ROLES openstack role add --project service --user $GLANCE_USER admin
echo "  Role for nova"
$DEBUG_USERS_TO_ROLES openstack role add --project service --user $NOVA_USER admin
echo "  Role for Neutron"
$DEBUG_USERS_TO_ROLES openstack role add --project service --user $NEUTRON_USER admin
<<<<<<< HEAD
echo "  Role for Heat"
$DEBUG_USERS_TO_ROLES openstack role add --project service --user $HEAT_USER admin
=======
echo "  Role for cinder"
$DEBUG_USERS_TO_ROLES openstack role add --project service --user $CINDER_USER admin
>>>>>>> 2638171... add cinder feature
echo "[END] Role configuration"
