unique template defaults/openstack/config;

##################################
# Define site specific variables #
##################################
include if_exists('site/openstack/config');

##############
# RegionName #
##############
variable OS_REGION_NAME ?= 'RegionOne';

############################################
# Virtual Machine interface for hypervisor #
############################################
variable OS_INTERFACE_MAPPING ?= boot_nic();

# Force user to specify OS_ADMIN_TOKEN
variable OS_ADMIN_TOKEN ?= error('OS_ADMIN_TOKEN must be declared');
variable OS_USERNAME ?= 'admin';
variable OS_PASSWORD ?= 'admin';
variable OS_METADATA_SECRET ?= error('OS_METADATA_SECRET must be declared');

###############################
# Define OS_CONTROLLER_HOST  #
##############################
variable OS_CONTROLLER_HOST ?= error('OS_CONTROLLER_HOST must be declared');

#############################
# Mariadb specific variable #
#############################
variable OS_DB_HOST ?= 'localhost';
variable OS_DB_ADMIN_USERNAME ?= 'root';
variable OS_DB_ADMIN_PASSWORD ?= 'root';

##############################
# Metadata specific variable #
##############################
variable OS_METADATA_HOST ?= OS_CONTROLLER_HOST;

############################
# Glance specific variable #
############################
variable OS_GLANCE_CONTROLLER_HOST ?= OS_CONTROLLER_HOST;
variable OS_GLANCE_DB_HOST ?= OS_DB_HOST;
variable OS_GLANCE_DB_USERNAME ?= 'glance';
variable OS_GLANCE_DB_PASSWORD ?= 'GLANCE_DBPASS';
variable OS_GLANCE_USERNAME ?= 'glance';
variable OS_GLANCE_PASSWORD ?= 'glance';

##############################
# Keystone specific variable #
##############################
variable OS_KEYSTONE_CONTROLLER_HOST ?= OS_CONTROLLER_HOST;
variable OS_KEYSTONE_DB_HOST ?= OS_DB_HOST;
variable OS_KEYSTONE_DB_USERNAME ?= 'keystone';
variable OS_KEYSTONE_DB_PASSWORD ?= 'KEYSTONE_DBPASS';

#############################
# Memcache specfic variable #
#############################
variable OS_MEMCACHE_HOST ?= 'localhost';

##########################
# Nova specific variable #
##########################
variable OS_NOVA_CONTROLLER_HOST ?= OS_CONTROLLER_HOST;
variable OS_NOVA_DB_HOST ?= OS_DB_HOST;
variable OS_NOVA_DB_USERNAME ?= 'nova';
variable OS_NOVA_DB_PASSWORD ?= 'NOVA_DBPASS';
variable OS_NOVA_USERNAME ?= 'nova';
variable OS_NOVA_PASSWORD ?= 'nova';

#############################
# Neutron specific variable #
#############################
variable OS_NEUTRON_CONTROLLER_HOST ?= OS_CONTROLLER_HOST;
variable OS_NEUTRON_DB_HOST ?= OS_DB_HOST;
variable OS_NEUTRON_DB_USERNAME ?= 'neutron';
variable OS_NEUTRON_DB_PASSWORD ?= 'NEUTRON_DBPASS';
variable OS_NEUTRON_USERNAME ?= 'neutron';
variable OS_NEUTRON_PASSWORD ?= 'neutron';
variable OS_NEUTRON_DEFAULT ?= true;
variable OS_NEUTRON_DEFAULT_NETWORKS ?= "192.168.0.0/24";
variable OS_NEUTRON_DEFAULT_DHCP_POOL ?= dict(
  'start', '192.168.0.10',
  'end', '192.168.0.254',
);
variable OS_NEUTRON_DEFAULT_GATEWAY ?= '192.168.0.1';
variable OS_NEUTRON_DEFAULT_NAMESERVER ?= '192.168.0.1';

##############################
# RabbitMQ specific variable #
##############################
variable OS_RABBITMQ_HOST ?= OS_CONTROLLER_HOST;
variable OS_RABBITMQ_USERNAME ?= 'openstack';
variable OS_RABBITMQ_PASSWORD ?= 'RABBIT_PASS';