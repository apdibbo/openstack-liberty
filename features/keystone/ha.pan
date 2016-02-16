unique template features/keystone/ha;

variable OS_KEYSTONE_PORT = 5000;
variable OS_KEYSTONE_ADMIN_PORT = 35357;
variable OS_KEYSTONE_PORTS = list(OS_KEYSTONE_PORT,OS_KEYSTONE_ADMIN_PORT);

prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'contents/vhosts/' = append(dict('name' , 'keystone',
    'port' , OS_KEYSTONE_PORT,
    'bind' , '*:'+to_string(OS_KEYSTONE_PORT),
    'config' , dict(
        'mode' , 'tcp',
        'balance' , 'source',),
    'options' , list('tcpka','httplog','ssl-hello-chk'),
    'serveroptions',dict(
        'inter', '2s',
        'downinter', '5s',
        'rise', 3,
        'fall', 2,
        'slowstart', '60s',
        'maxqueue', 128,
        'weight', 100,),
    'servers', OS_KEYSTONE_SERVERS,)
);
'contents/vhosts/' = append(dict('name' , 'keystone-admin',
    'port' , OS_KEYSTONE_ADMIN_PORT,
    'bind' , '*:'+to_string(OS_KEYSTONE_ADMIN_PORT),
    'config' , dict(
        'mode' , 'tcp',
        'balance' , 'source',),
    'options' , list('tcpka','httplog','ssl-hello-chk'),
    'serveroptions',dict(
        'inter', '2s',
        'downinter', '5s',
        'rise', 3,
        'fall', 2,
        'slowstart', '60s',
        'maxqueue', 128,
        'weight', 100,),
    'servers', OS_KEYSTONE_SERVERS,)
);

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/usr/local/bin/haproxy-reload}';
'module' = 'haproxy-reload';
'contents/ports' = merge(SELF,list(OS_KEYSTONE_PORTS));
