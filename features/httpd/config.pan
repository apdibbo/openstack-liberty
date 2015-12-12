unique template features/httpd/config;

include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'httpd/on' = '';
'httpd/startstop' = true;

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/httpd/conf.d/01-servername.conf}';
'module' = 'general';
'daemons/httpd' = 'restart';

'contents/ServerName' = OS_KEYSTONE_CONTROLLER_HOST;
