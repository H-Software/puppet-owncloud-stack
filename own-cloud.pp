#########################################################
#							#
# OwnCLoud manifest					#
#							#
# create by czhujer (patrik.majer.pisek@gmail.com 	#
#							#
# version: 0.1						#	
#							#
#########################################################

class { '::mysql::server':
  override_options => {
    'mysqld' => { 'bind-address' => '127.0.0.1' }
  },
  restart       => true,
  root_password => 'DVCjItuA=',
}

class { 'owncloud': 
  db_user => 'owncloud',
  db_pass => 'nqrEtRid',

  ssl      => true,
  ssl_cert => '/etc/apache2/ssl/owncloud.hujer.info.crt',
  ssl_key  => '/etc/apache2/ssl/owncloud.hujer.info.key'
}
