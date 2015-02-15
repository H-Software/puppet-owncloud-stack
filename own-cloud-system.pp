#########################################################
#                                                       #
# OwnCLoud manifest - accesories part                   #
#                                                       #
# create by czhujer (patrik.majer.pisek@gmail.com       #
#                                                       #
# version: 0.1                                          #
#                                                       #
#########################################################

#include '::ntp'

include ntp

include timezone

#class { 'timezone':
#  timezone => 'Europe/Prague',
#}

class { 'fail2ban':
  package_ensure => 'latest',
  config_file_template => "fail2ban/${::lsbdistcodename}/etc/fail2ban/jail.conf.erb",
#  jails => ["ssh"],
  bantime => 3600,
#  email => 'patrik.majer.pisek@gmail.com',
  require => Package['sendmail'],
}

package { 'sendmail':
    name => 'sendmail-bin',
    ensure => latest,
}

package{ 'office package':
    name => 'libreoffice',
    ensure => latest,
}

