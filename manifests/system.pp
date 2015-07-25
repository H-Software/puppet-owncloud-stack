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


if($::operatingsystem == "ubuntu") {

  class { 'fail2ban':
    package_ensure => 'latest',
    config_file_template => "fail2ban/${::lsbdistcodename}/etc/fail2ban/jail.conf.erb",
    bantime => 3600,
    require => Package['sendmail'],
  }

}

if($::operatingsystem == "centos" and $::operatingsystemrelease >= 6 and $::operatingsystemrelease < 7) {

  package { "epel-release":
    ensure => "latest",
  }

  package { "ius-release":
    ensure => "installed",
    provider => 'rpm',
    source => 'http://dl.iuscommunity.org/pub/ius/archive/CentOS/6/x86_64/ius-release-1.0-11.ius.centos6.noarch.rpm',
    require => Package["epel-release"],
  }

}

package{ 'office package':
    name => 'libreoffice',
    ensure => latest,
}

