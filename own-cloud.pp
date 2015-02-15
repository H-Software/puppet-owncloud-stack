#########################################################
#							#
# OwnCLoud manifest - main part				#
#							#
# create by czhujer (patrik.majer.pisek@gmail.com 	#
#							#
# version: 0.1						#	
#							#
#########################################################

import 'own-cloud-system.pp'

class { '::mysql::server':
  override_options => {
    'mysqld' => { 'bind-address' => '127.0.0.1' }
  },
}

class { 'owncloud': 
#  db_user => 'owncloud',
#  db_pass => 'nqrEtRid',

  ssl      => true,
  ssl_cert => '/etc/apache2/ssl/owncloud.hujer.info.crt',
  ssl_key  => '/etc/apache2/ssl/owncloud.hujer.info.key'
}

import 'own-cloud-accessories.pp'