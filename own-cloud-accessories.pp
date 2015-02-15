#########################################################
#							#
# OwnCLoud manifest					#
#							#
# create by czhujer (patrik.majer.pisek@gmail.com 	#
#							#
# version: 0.1						#	
#							#
#########################################################

include '::ntp'

class { 'timezone':
  timezone => 'Europe/Prague',
}

class { 'fail2ban':
  package_ensure => 'latest',
  config_file_template => "fail2ban/${::lsbdistcodename}/etc/fail2ban/jail.conf.erb",
  jails => ["ssh"],
  bantime => 3600,
  email => 'patrik.majer.pisek@gmail.com',
  require => Package['sendmail'],
}

package { 'sendmail':
    name => 'sendmail-bin',
    ensure => latest,
}

$packages_clamav = ["clamav", "clamav-base", "clamav-daemon", "clamav-freshclam"]

package { $packages_clamav:
    ensure => latest,
}

service { 'clamav-freshclam':
    ensure => running,
    enable => true,
    require => Package[$packages_clamav],
}

service { 'clamav-daemon':
    ensure => running,
    enable => true,
    require => [ 
		Package[$packages_clamav],
		Service["clamav-freshclam"],
	       ]
}
