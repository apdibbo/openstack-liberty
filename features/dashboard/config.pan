unique template features/dashboard/config;

# Load some useful functions
include 'defaults/openstack/functions';

# Include general openstack variables
include 'defaults/openstack/config';

# Fix list of Openstack user that should not be deleted
include 'features/accounts/config';

include 'features/dashboard/rpms/config';

include 'components/filecopy/config';
variable OS_DASHBOARD_ALLOWED_HOSTS = "['*',]";
variable OS_DASHBOARD_DEFAULT_ROLE = 'users';
prefix '/software/components/filecopy/services/{/etc/openstack-dashboard/local_settings}';
'config' = format(file_contents('features/dashboard/local_settings'),OS_DASHBOARD_ALLOWED_HOSTS,OS_CONTROLLER_HOST,OS_CONTROLLER_HOST,OS_DASHBOARD_DEFAULT_ROLE);
'perms' = '0644';
'restart' = 'systemctl restart httpd.service';
