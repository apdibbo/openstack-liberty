template features/neutron/controller/ha;

variable OS_NEUTRON_PORT = 9696;

include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/usr/local/bin/haproxy-reload}';
'module' = 'haproxy-reload';
'contents/ports' = merge(SELF,list(OS_NEUTRON_PORT));

prefix '/software/components/metaconfig/services/{/etc/haproxy/haproxy.cfg}';
'module' = 'haproxy';
'contents/vhosts/' = append(dict('name' , 'neutron',
    'port' , OS_NEUTRON_PORT,
    'bind' , '*:'+to_string(OS_NEUTRON_PORT),
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
    'servers', OS_NEUTRON_SERVERS,)
);

# Configuration file for neutron
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/neutron/neutron.conf}';
'module' = 'tiny';
# [DEFAULT] section
'contents/DEFAULT/memcached_servers' = { hosts = '';
foreach(k;v;OS_MEMCACHE_HOSTS) {
        if ( hosts != '') {
            hosts = hosts + ',' + v + ':11211';
        } else {
            hosts = v + ':11211';
        };

        hosts;
    };
};
