unique template personality/keystone/config;

include 'features/keystone/config';
include {
  if (OS_CEILOMETER_METERS_ENABLED) {
    'features/ceilometer/meters/keystone';
  } else {
    null;
  };
};
