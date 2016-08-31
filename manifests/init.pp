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
$manage_apache=true,
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
  elsif ($owncloud_version == "9"){
     $owncloud_manage_repo=true
  }
  else{
     $owncloud_manage_repo=true
  }

  class { 'owncloud': 
      manage_repo => $owncloud_manage_repo,
      manage_apache => $manage_apache,
  }

  class{ 'owncloudstack::services':
  }

}