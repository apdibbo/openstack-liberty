unique template features/heat/ha;

variable OS_HEAT_CFN_PORT = 8000;
variable OS_HEAT_PORT = 8004;
variable OS_HEAT_PORTS = list(OS_HEAT_PORT,OS_HEAT_CFN_PORT);

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/usr/local/bin/haproxy-reload}';
'module' = 'haproxy-reload';
'contents/ports' = merge(SELF,list(OS_HEAT_PORTS));


prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'contents/vhosts/' = append(dict('name' , 'heat-cfn',
    'port' , OS_HEAT_CFN_PORT,
    'bind' , '*:'+to_string(OS_HEAT_CFN_PORT),
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
    'servers', OS_HEAT_SERVERS,)
);
'contents/vhosts/' = append(dict('name' , 'heat',
    'port' , OS_HEAT_PORT,
    'bind' , '*:'+to_string(OS_HEAT_PORT),
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
    'servers', OS_HEAT_SERVERS,)
);
