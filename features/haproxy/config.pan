unique template features/haproxy/config;

include 'features/haproxy/rpms/config';

include 'components/filecopy/config';
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/haproxy-reload.tt}';
'config' = file_contents('features/haproxy/metaconfig/haproxy-reload.tt');
'perms' = '0644';
include 'components/filecopy/config';
prefix '/software/components/filecopy/services/{/usr/share/templates/quattor/metaconfig/haproxy.tt}';
'config' = file_contents('features/haproxy/metaconfig/haproxy.tt');
'perms' = '0644';

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'daemons/haproxy' = 'restart';
'contents/global/logs/{/dev/log}' = list('local0','notice');
'contents/global/config/tune.ssl.default-dh-param' = '2048';
'contents/global/config/chroot' = '/var/lib/haproxy';
'contents/global/config/pidfile' = '/var/run/haproxy.pid';
'contents/global/config/maxconn' = '4000';
'contents/global/config/user' = 'haproxy';
'contents/global/config/group' = 'haproxy';
'contents/global/config/daemon' = '';
'contents/global/stats/socket' = '/var/lib/haproxy/stats';
#'contents/global/stats/mode' = '600';
#'contents/global/stats/level' = 'admin';
'contents/defaults/config/log' = 'global';
#'contents/defaults/config/mode' = 'dontlognull';
'contents/defaults/config/retries' = '3';
'contents/defaults/config/maxconn' = '4000';
'contents/defaults/timeouts/check' = '3500ms';
'contents/defaults/timeouts/queue' = '3500ms';
'contents/defaults/timeouts/connect' = '3500ms';
'contents/defaults/timeouts/client' = '10000ms';
'contents/defaults/timeouts/server' = '10000ms';

# Zero-downtime HAProxy reload; see e.g. http://www.mail-archive.com/haproxy@formilux.org/msg06885.html
prefix '/software/components/metaconfig/services/{/usr/local/bin/haproxy-reload}';
'module' = 'haproxy-reload';
'contents/ports' =list();
'mode' = 0755;

# Services
include 'components/chkconfig/config';
prefix "/software/components/chkconfig/service";

"haproxy/on" = "";
"haproxy/startstop" = true;
