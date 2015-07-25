#########################################################
#							#
# OwnCLoud manifest - main part				#
#							#
# create by czhujer (patrik.majer.pisek@gmail.com 	#
#							#
# version: 0.1						#	
#							#
#########################################################

import 'system.pp'

class { 'mysql::server':
  override_options => {
    'mysqld' => { 'bind-address' => '127.0.0.1' }
  },
}

class { 'sendmail': 
}

if($::operatingsystem == "centos" and $::operatingsystemrelease >= 6 and $::operatingsystemrelease < 7) {

  class { 'owncloud': 
    require => Package["ius-release"],
  }

}
else{

  class { 'owncloud': 
  }

}

import 'accessories.pp'
