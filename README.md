# openstack-liberty

## Installation
* Install repository under cfg/openstack-liberty
* Add cfg/openstack-liberty into cluster.build.properties

## Usage
* Create a template site/openstack/config

The following variables is mandatory
* OS_CONTROLLER_HOST : name of controller
* OS_METADATA_SECRET : used as a shared secret for metadata
* OS_ADMIN_TOKEN : used as a super-user token for initialisation

## Some comment
* Default username and password are the same than those you have on RDO documentation
* By default, all stuff are put under 1 controller

## TODO
* metaconfig is NOT typed yet
* httpd is not configure for keystone
  * ServerName is not put correctly
  * wgsi-keystone.conf is not created
* Database is not populate
  * a init.sh script is created but not sure it work well (with fileconfig)
* Configuration must be splited into structure template to allow more flexibility
