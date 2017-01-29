#########################################################
#                                                       
# owncloudstack::owncloud
#    
#########################################################
class owncloudstack::owncloud ()
{
  #fix directory creating
  exec { "mkdir -p ${::owncloudstack::documentroot}/config":
    path    => ['/bin', '/usr/bin'],
    unless  => "test -d ${::owncloudstack::documentroot}/config",
    before  => File["${::owncloudstack::documentroot}/config/autoconfig.php"],
  }

  class { '::owncloud':
    manage_repo   => $::owncloudstack::owncloud_manage_repo,
    manage_apache => $::owncloudstack::manage_apache,
    manage_vhost  => $::owncloudstack::manage_vhost,
    #manage_phpmysql => false,
  }

}
