unique template defaults/openstack/utils;

# Create Admin environment script

include 'components/filecopy/config';
prefix '/software/components/filecopy/services';
'{/root/admin-openrc.sh}' = dict(
  'config', format(file_contents('defaults/openstack/admin-openrc.sh'),
    OS_USERNAME,
    OS_PASSWORD,
    OS_KEYSTONE_CONTROLLER_HOST,
  ),
);

# Create a initialization script

variable CONTENTS_INIT_SCRIPT = {
  if (OS_NEUTRON_DEFAULT) {
    file_contents('defaults/openstack/init.sh') + file_contents('defaults/openstack/init.sh');
  } else {
    file_contents('defaults/openstack/init.sh');
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
