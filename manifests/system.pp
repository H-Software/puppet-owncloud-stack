#########################################################
#                                                       #
# OwnCLoud manifest - accesories part                   #
#                                                       #
# create by czhujer (patrik.majer.pisek@gmail.com       #
#                                                       #
# version: 0.1                                          #
#                                                       #
#########################################################

include ntp

include timezone

class { 'fail2ban':
  package_ensure => 'latest',
  config_file_template => "fail2ban/${::lsbdistcodename}/etc/fail2ban/jail.conf.erb",
  bantime => 3600,
  require => Package['sendmail'],
}

package{ 'office package':
    name => 'libreoffice',
    ensure => latest,
}

