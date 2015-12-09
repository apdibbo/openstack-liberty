unique template defaults/openstack/utils;

variable CONTENTS = <<EOF;
export OS_PROJECT_DOMAIN_ID=default
export OS_USER_DOMAIN_ID=default
export OS_PROJECT_NAME=admin
export OS_TENANT_NAME=admin
export OS_USERNAME=%s
export OS_PASSWORD=%s
export OS_AUTH_URL=http://%s:35357/v3
export OS_IDENTITY_API_VERSION=3
EOF

include 'components/filecopy/config';
prefix '/software/components/filecopy/services';
'{/root/admin-openrc.sh}' = dict(
  'config', format(CONTENTS,
    OS_USERNAME,
    OS_PASSWORD,
    OS_KEYSTONE_CONTROLLER_HOST,
  ),
);

# Create a initialization script
variable CONTENTS_INIT_SCRIPT = <<EOF;
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
#
export ADMIN_USERNAME=%s
export ADMIN_PASSWORD=%s
export GLANCE_USER=%s
export GLANCE_PASSWORD=%s
export NOVA_USER=%s
export NOVA_PASSWORD=%s
export NEUTRON_USER=%s
export NEUTRON_PASSWORD=%s
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

echo "[START] Databases configuration"
echo "  Identity service"
$DEBUG_DATABASES su -s /bin/sh -c "keystone-manage db_sync" keystone
echo "  Network service"
$DEBUG_DATABASES su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
echo "  Image service"
$DEBUG_DATABASES su -s /bin/sh -c "glance-manage db_sync" glance
echo "  Compute service"
$DEBUG_DATABASES su -s /bin/sh -c "nova-manage db sync" nova
echo "[DONE] Database configuration"

echo "[START] service configuration"
echo "  keystone"
$DEBUG_SERVICES openstack service create --name keystone --description "Openstack Identity" identity
echo "  glance"
$DEBUG_SERVICES openstack service create --name glance   --description "OpenStack Image service" image
echo "  nova"
$DEBUG_SERVICES openstack service create --name nova   --description "OpenStack Compute" compute
echo "  neutron"
$DEBUG_SERVICES openstack service create --name neutron   --description "OpenStack Networking" network
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
echo "[END] Role configuration"
EOF

variable CONTENTS_INIT_SCRIPT_NETWORK = <<EOF;
echo "[START] Network"
echo "  flat network"
$DEBUG_NETWORKS neutron net-create public --shared --provider:physical_network public \
  --provider:network_type flat
echo "  DHCP pool"
$DEBUG_NETWORKS neutron subnet-create public $NEUTRON_DEFAULT_NETWORK \
  --name public --allocation-pool \
  start=$NEUTRON_DEFAULT_DHCP_START,end=$NEUTRON_DEFAULT_DHPC_END \
  --dns-nameserver $NEUTRON_DEFAULT_NAMESERVER \
  --gateway $NEUTRON_DEFAULT_GATEWAY
echo "  Allow ping and SSH"
$DEBUG_NETWORKS nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
$DEBUG_NETWORKS nova secgroup-add-rule default tcp 22 22 0.0.0.0/0
echo "[START] Network"
EOF

variable CONTENTS_INIT_SCRIPT = {
  if (OS_NEUTRON_DEFAULT) {
    CONTENTS_INIT_SCRIPT + CONTENTS_INIT_SCRIPT_NETWORK;
  } else {
    SELF;
  };
};
include 'components/filecopy/config';
prefix '/software/components/filecopy/services';
'{/root/init.sh}' = dict(
  'config', format(
    CONTENTS_INIT_SCRIPT,
    OS_RABBITMQ_USERNAME,
    OS_RABBITMQ_PASSWORD,
    OS_REGION_NAME,
    OS_KEYSTONE_CONTROLLER_HOST,
    OS_KEYSTONE_CONTROLLER_HOST,
    OS_GLANCE_CONTROLLER_HOST,
    OS_NOVA_CONTROLLER_HOST,
    OS_NEUTRON_CONTROLLER_HOST,
    OS_USERNAME,
    OS_PASSWORD,
    OS_GLANCE_USERNAME,
    OS_GLANCE_PASSWORD,
    OS_NOVA_USERNAME,
    OS_NOVA_PASSWORD,
    OS_NEUTRON_USERNAME,
    OS_NEUTRON_PASSWORD,
    OS_ADMIN_TOKEN,
    OS_NEUTRON_DEFAULT_NETWORKS,
    OS_NEUTRON_DEFAULT_DHCP_POOL['start'],
    OS_NEUTRON_DEFAULT_DHCP_POOL['end'],
    OS_NEUTRON_DEFAULT_GATEWAY,
    OS_NEUTRON_DEFAULT_NAMESERVER,
  ),
);