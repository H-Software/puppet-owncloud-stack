#########################################################
#                                                       
# owncloudstack::owncloud
#    
#########################################################
class owncloudstack::owncloud ()
{

  class { '::owncloud':
    manage_repo   => $::owncloudstack::owncloud_manage_repo,
    manage_apache => $::owncloudstack::manage_apache,
    manage_vhost  => $::owncloudstack::manage_vhost,
    #manage_phpmysql => false,
  }

}
