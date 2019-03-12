#########################################################
#                                                       
# owncloudstack::owncloud
#    
#########################################################
class owncloudstack::owncloud ()
{
  #fix directory creating
  exec { "mkdir -p ${::owncloudstack::documentroot}/config":
    path   => ['/bin', '/usr/bin'],
    unless => "test -d ${::owncloudstack::documentroot}/config",
    before => File["${::owncloudstack::documentroot}/config/autoconfig.php"],
  }

  if($::owncloudstack::manage_owncloud_skeleton){
    #fix directory creating
    exec { "mkdir -p ${::owncloudstack::documentroot}/core/skeleton":
      path   => ['/bin', '/usr/bin'],
      unless => "test -d ${::owncloudstack::documentroot}/core/skeleton",
      before => File["${::owncloudstack::documentroot}/core/skeleton/documents"],
    }
  }

  class { '::owncloud':
    manage_repo   => $::owncloudstack::owncloud_manage_repo,
    manage_apache => $::owncloudstack::manage_apache,
    manage_vhost  => $::owncloudstack::manage_vhost,
    manage_skeleton => $::owncloudstack::manage_owncloud_skeleton,
    #manage_phpmysql => false,
    ssl           => $::owncloudstack::owncloud_ssl,
    #package_name  => $::owncloudstack::owncloud_package_name,
  }

}
