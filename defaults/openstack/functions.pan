unique template defaults/openstack/functions;

function openstack_load_config = {
  if (ARGC != 1 ) {
    error('openstack_load_config need a argument');
  };

  if (is_string(ARGV[0])) {
    config = create(ARGV[0]);
  } else if (!is_dict(ARGV[0])) {
    error('openstack_load_config need a string or a dict as argument');
  } else {
    config = ARGV[0];
  };

  foreach(k;v;config) {
    SELF[k] = v;
  };
  SELF;
};