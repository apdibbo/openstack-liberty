template features/cinder/controller/ceph;

# Configuration file for cinder
include 'components/metaconfig/config';
prefix '/software/components/metaconfig/services/{/etc/cinder/cinder.conf}';

'contents/DEFAULT/volume_driver' = 'cinder.volume.drivers.rbd.RBDDriver';
'contents/DEFAULT/rbd_pool' = OS_CEPH_CINDER_POOL;
'contents/DEFAULT/rbd_ceph_conf' = OS_CEPH_CINDER_CEPH_CONF;
'contents/DEFAULT/rbd_flatten_volume_from_snapshot' = 'false';
'contents/DEFAULT/rbd_max_clone_depth' = '5';
'contents/DEFAULT/rbd_store_chunk_size' = '4';
'contents/DEFAULT/rados_connect_timeout' = '-1';
'contents/DEFAULT/glance_api_version' = '2';

'contents/DEFAULT/rbd_user' = OS_CEPH_CINDER_USER;
'contents/DEFAULT/rbd_secret_uuid' = OS_CEPH_LIBVIRT_SECRET;

'contents/DEFAULT/backup_driver' = 'cinder.backup.drivers.ceph';
'contents/DEFAULT/backup_ceph_conf' = OS_CEPH_CINDER_BACKUP_CEPH_CONF;
'contents/DEFAULT/backup_ceph_user' = OS_CEPH_CINDER_BACKUP_USER;
'contents/DEFAULT/backup_ceph_chunk_size' = '134217728';
'contents/DEFAULT/backup_ceph_pool' = OS_CEPH_CINDER_BACKUP_POOL;
'contents/DEFAULT/backup_ceph_stripe_unit' = '0';
'contents/DEFAULT/backup_ceph_stripe_count' = '0';
'contents/DEFAULT/restore_discard_excess_bytes' = 'true';
