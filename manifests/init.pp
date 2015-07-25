#########################################################
#							#
# OwnCLoud manifest - main part				#
#							#
# create by czhujer (patrik.majer.pisek@gmail.com) 	#
#							#
# version: 0.2						#
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

class { 'owncloud': 
}

import 'accessories.pp'
