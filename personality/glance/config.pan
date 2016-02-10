unique template personality/glance/config;

include 'features/glance/config';
include {
  if (OS_CEILOMETER_METERS_ENABLED) {
    'features/ceilometer/meters/glance';
  } else {
    null;
  };
};
