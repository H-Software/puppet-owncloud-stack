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

  include ::remi

  package { "epel-release":
    ensure => "latest",
  }

  ini_setting { 'centos base repo exclude php packages':
    ensure  => present,
    path    => "/etc/yum.repos.d/CentOS-Base.repo",
    section => 'base',
    setting => 'exclude',
    value   => "php-*",
  }

  ini_setting { 'centos base repo exclude php packages2':
    ensure  => present,
    path    => "/etc/yum.repos.d/CentOS-Base.repo",
    section => 'updates',
    setting => 'exclude',
    value   => "php-*",
    require => Ini_setting["'centos base repo exclude php packages"],
  }

  if ! defined(Yumrepo['remi-php56']){

    yumrepo { 'remi-php56':
            name       => 'remi-php56',
            descr      => 'Les RPM de remi de PHP 5.6 pour Enterprise Linux 6 - $basearch',
            baseurl    => absent,
            mirrorlist => 'http://rpms.famillecollet.com/enterprise/6/php56/mirror',
            gpgcheck   => 1,
            gpgkey     => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi',
            enabled    => 1,
            before     => Class["owncloud"],
            require    => [ Class['::remi'], Ini_setting["'centos base repo exclude php packages2"], ]
    }

  }

}

package{ 'office package':
    name => 'libreoffice',
    ensure => latest,
}

