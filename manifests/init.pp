#########################################################
#							#
# OwnCLoud manifest - main part				#
#							#
# create by czhujer (patrik.majer.pisek@gmail.com) 	#
#							#
# version: 0.3						#
#							#
#########################################################

class owncloudstack (
$owncloud_version="8",
)
{

  class { 'owncloudstack::system':
  }

  class { 'mysql::server':
    override_options => {
      'mysqld' => { 'bind-address' => '127.0.0.1' }
    },
  }

  class { 'sendmail': 
  }

  if ($owncloud_version == "8.2"){
     $owncloud_manage_repo=false
  }
  else{
     $owncloud_manage_repo=true
  }

  class { 'owncloud': 
      manage_repo => $owncloud_manage_repo,
  }

  class{ 'owncloudstack::services':
  }

}