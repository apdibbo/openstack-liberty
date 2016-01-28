unique template defaults/openstack/config;

##################################
# Define site specific variables #
##################################
include if_exists('site/openstack/config');
variable PRIMARY_IP ?= DB_IP[escape(FULL_HOSTNAME)];

############################
# Active SSL configuration #
############################
variable OS_SSL ?= false;
variable OS_SSL_CERT ?= '/etc/certs/' + FULL_HOSTNAME + '.crt';
variable OS_SSL_KEY ?= '/etc/certs/' + FULL_HOSTNAME + '.key';
variable OS_SSL_CHAIN ?= null;

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

##########################################
# NODE_TYPE is 'compute' or 'controller' #
##########################################
variable OS_NODE_TYPE ?= 'compute';
#
variable OS_LOGGING_TYPE ?= 'file';
variable OS_AUTH_CLIENT_CONFIG ?= 'features/keystone/client/config';

###############################
# Define OS_CONTROLLER_HOST  #
##############################
variable OS_CONTROLLER_HOST ?= error('OS_CONTROLLER_HOST must be declared');
variable OS_CONTROLLER_PROTOCOL ?= if (OS_SSL) {
  'https';
} else {
  'http';
};

#############################
# Mariadb specific variable #
#############################
variable OS_DB_HOST ?= 'localhost';
variable OS_DB_ADMIN_USERNAME ?= 'root';
variable OS_DB_ADMIN_PASSWORD ?= 'root';

############################
# Glance specific variable #
############################
variable OS_GLANCE_CONTROLLER_HOST ?= OS_CONTROLLER_HOST;
variable OS_GLANCE_CONTROLLER_PROTOCOL ?= OS_CONTROLLER_PROTOCOL;
variable OS_GLANCE_DB_HOST ?= OS_DB_HOST;
variable OS_GLANCE_DB_USERNAME ?= 'glance';
variable OS_GLANCE_DB_PASSWORD ?= 'GLANCE_DBPASS';
variable OS_GLANCE_USERNAME ?= 'glance';
variable OS_GLANCE_PASSWORD ?= 'GLANCE_PASS';
variable OS_GLANCE_STORE_DIR ?= '/var/lib/glance/images/';

##############################
# Keystone specific variable #
##############################
variable OS_KEYSTONE_CONTROLLER_HOST ?= OS_CONTROLLER_HOST;
variable OS_KEYSTONE_CONTROLLER_PROTOCOL ?= OS_CONTROLLER_PROTOCOL;
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
variable OS_NOVA_VNC_HOST ?= OS_NOVA_CONTROLLER_HOST;
variable OS_NOVA_CONTROLLER_PROTOCOL ?= OS_CONTROLLER_PROTOCOL;
variable OS_NOVA_VNC_PROTOCOL ?= OS_NOVA_CONTROLLER_PROTOCOL;
variable OS_NOVA_DB_HOST ?= OS_DB_HOST;
variable OS_NOVA_DB_USERNAME ?= 'nova';
variable OS_NOVA_DB_PASSWORD ?= 'NOVA_DBPASS';
variable OS_NOVA_USERNAME ?= 'nova';
variable OS_NOVA_PASSWORD ?= 'NOVA_PASS';

#############################
# Neutron specific variable #
#############################
variable OS_NEUTRON_CONTROLLER_HOST ?= OS_CONTROLLER_HOST;
variable OS_NEUTRON_NETWORK_PROVIDER ?= OS_NEUTRON_CONTROLLER_HOST;
variable OS_NEUTRON_CONTROLLER_PROTOCOL ?= OS_CONTROLLER_PROTOCOL;
variable OS_NEUTRON_DB_HOST ?= OS_DB_HOST;
variable OS_NEUTRON_DB_USERNAME ?= 'neutron';
variable OS_NEUTRON_DB_PASSWORD ?= 'NEUTRON_DBPASS';
variable OS_NEUTRON_USERNAME ?= 'neutron';
variable OS_NEUTRON_PASSWORD ?= 'NEUTRON_PASS';
variable OS_NEUTRON_NETWORK_TYPE ?= 'provider-service';
variable OS_NEUTRON_OVERLAY_IP ?= PRIMARY_IP;
variable OS_NEUTRON_BASE_MAC ?= null;
variable OS_NEUTRON_DVR_BASE_MAC ?= null;
variable OS_NEUTRON_DEFAULT ?= true;
variable OS_NEUTRON_DEFAULT_NETWORKS ?= "192.168.0.0/24";
variable OS_NEUTRON_DEFAULT_DHCP_POOL ?= dict(
  'start', '192.168.0.10',
  'end', '192.168.0.254',
);
variable OS_NEUTRON_DEFAULT_GATEWAY ?= '192.168.0.1';
variable OS_NEUTRON_DEFAULT_NAMESERVER ?= '192.168.0.1';

############################
# Cinder specific variable #
############################
# Cinder Controller
variable OS_CINDER_ENABLED ?= false;
variable OS_CINDER_CONTROLLER_HOST ?= OS_CONTROLLER_HOST;
variable OS_CINDER_CONTROLLER_PROTOCOL ?= OS_CONTROLLER_PROTOCOL;
variable OS_CINDER_DB_HOST ?= OS_DB_HOST;
variable OS_CINDER_DB_USERNAME ?= 'cinder';
variable OS_CINDER_DB_PASSWORD ?= 'CINDER_DBPASS';
variable OS_CINDER_USERNAME ?= 'cinder';
variable OS_CINDER_PASSWORD ?= 'CINDER_PASS';
# Cinder Storage
variable OS_CINDER_STORAGE_HOST ?= OS_CINDER_CONTROLLER_HOST;
variable OS_CINDER_STORAGE_TYPE ?= 'lvm';

##############################
# RabbitMQ specific variable #
##############################
variable OS_RABBITMQ_HOST ?= OS_CONTROLLER_HOST;
variable OS_RABBITMQ_USERNAME ?= 'openstack';
variable OS_RABBITMQ_PASSWORD ?= 'RABBIT_PASS';

###########
# Horizon #
###########
variable OS_HORIZON_HOST ?= OS_CONTROLLER_HOST;
variable OS_HORIZON_ALLOWED_HOSTS ?= list('*');
variable OS_HORIZON_DEFAULT_ROLE ?= 'users';
variable OS_HORIZON_SECRET_KEY ?= error('OS_HORIZON_SECRET_KEY must be defined');

##############################
# Metadata specific variable #
##############################
variable OS_METADATA_HOST ?= OS_NOVA_CONTROLLER_HOST;
