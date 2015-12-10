#########################################################
#                                                       #
# OwnCLoud manifest - accesories part                   #
#                                                       #
# create by czhujer (patrik.majer.pisek@gmail.com)      #
#                                                       #
# version: 0.3                                          #
#                                                       #
#########################################################

class owncloudstack::system ()
{

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
      require => Ini_setting["centos base repo exclude php packages"],
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
            require    => [ Class['::remi'], Ini_setting["centos base repo exclude php packages2"], ]
      }

    }

    #repos for owncloud 8.2
    #
    if ($owncloudstack::owncloud_version == '8.2'){

      if ! defined(Yumrepo['isv_ownCloud_community']){

        yumrepo { 'isv_ownCloud_community':
            name       => 'isv_ownCloud_community',
            enabled    => 0,
            before     => Class["owncloud"],
        }

      }
      else{

          ini_setting { 'disable repo owncloud community':
             ensure  => present,
             path    => "/etc/yum.repos.d/isv_ownCloud_community.repo",
             section => 'isv_ownCloud_community',
             setting => 'enabled',
             value   => "0",
             before     => Class["owncloud"],
          }
      }

      yumrepo { 'owncloud-ce-8.2':
            name       => 'owncloud-ce-8.2',
            descr      => 'ownCloud Server 8.2 Community Edition (CentOS_6_PHP56)',
            baseurl    => 'http://download.owncloud.org/download/repositories/8.2/CentOS_6_PHP56',
            mirrorlist => absent,
            gpgcheck   => 1,
            gpgkey     => 'http://download.owncloud.org/download/repositories/8.2/CentOS_6_PHP56/repodata/repomd.xml.key',
            enabled    => 1,
            before     => Class["owncloud"],
            require    => [ Class['::remi'], Ini_setting["centos base repo exclude php packages2"], ]
      }


    }

  }

  package{ 'office package':
    name => 'libreoffice',
    ensure => latest,
  }

}

