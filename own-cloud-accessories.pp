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

#
# Antivirus part
#

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

#
# Cron part
#
$package_name = 'cron' 
$service_name = 'cron'

package {'cron':
    ensure      => 'present',
    name        => $package_name,
}

service {'cron':
    enable      => "true",                     # true (start on boot)
    ensure      => "true",                     # true (running), false (stopped)
    name        => $service_name,
    require     => Package['cron'],
    subscribe	=> File['owcnloud cron file'],
}

$cron_file_owncloud = "*/15  *  *  *  * www-data php -f /var/www/owncloud/cron.php > /dev/null 2>&1
"

file { 'owcnloud cron file':
    name => '/etc/cron.d/owncloud',
    content => $cron_file_owncloud,
    require => Package["cron"],
}
