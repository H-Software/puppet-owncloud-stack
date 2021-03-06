#########################################################
#                                                       
# owncloudstack::system
#    
#########################################################
class owncloudstack::system ()
{

  include ::ntp

  include ::timezone

  if($::owncloudstack::manage_fail2ban){

    if($::operatingsystem == ubuntu or $::operatingsystem == 'debian') {
      class { '::fail2ban':
        package_ensure       => 'latest',
        config_file_template => "fail2ban/${::lsbdistcodename}/etc/fail2ban/jail.conf.erb",
        bantime              => 3600,
        require              => Class['::sendmail'],
      }
    }
    else{
      class { '::fail2ban':
        package_ensure => 'latest',
        bantime        => 3600,
        require        => Class['::sendmail'],
      }
    }
  }

  if ($::operatingsystem =~ /(?i:Centos|RedHat|Scientific|OracleLinux)/) {

    #include ::remi
    class { '::remi':
      use_epel           => false,
      remi_enabled       => '1',
      remi_php56_enabled => '1',
      require            => Package['epel-release'],
    }

    if ! defined(Package['epel-release']){
      package { 'epel-release':
        ensure => 'latest',
      }
    }

    package { 'mysql-repo':
      ensure   => 'installed',
      name     => 'mysql-community-release',
      provider => 'rpm',
      source   => $::owncloudstack::mysql_repo_source_url,
    }

    ini_setting { 'centos base repo exclude php packages':
      ensure  => present,
      path    => '/etc/yum.repos.d/CentOS-Base.repo',
      section => 'base',
      setting => 'exclude',
      value   => 'php-*',
    }

    ini_setting { 'centos base repo exclude php packages2':
      ensure  => present,
      path    => '/etc/yum.repos.d/CentOS-Base.repo',
      section => 'updates',
      setting => 'exclude',
      value   => 'php-*',
      require => Ini_setting['centos base repo exclude php packages'],
    }

    #if ! defined(Yumrepo['remi-php56']){

    #  yumrepo { 'remi-php56':
    #    name       => 'remi-php56',
    #    descr      => 'Les RPM de remi de PHP 5.6 pour Enterprise Linux 6 - $basearch',
    #    baseurl    => absent,
    #    mirrorlist => 'http://rpms.famillecollet.com/enterprise/6/php56/mirror',
    #    gpgcheck   => 1,
    #    gpgkey     => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi',
    #    enabled    => 1,
    #    before     => Class['owncloud'],
    #    require    => [ Class['::remi'], Ini_setting['centos base repo exclude php packages2'], ],
    #  }

    #}

    # changes for owncloud 9.x
    #
    if ($owncloudstack::owncloud_version == '9'){

      yumrepo { 'owncloud-ce-8.2':
        ensure => absent,
      }

      #packages
      package { 'rhscl-httpd24-epel-6-x86_64':
        ensure => 'absent',
        before => Class['owncloud'],
      }

      package { 'rhscl-rh-php56-epel-6-x86_64':
        ensure => 'absent',
        before => Class['owncloud'],
      }

    }
    # changes for owncloud 8.2
    #
    elsif ($owncloudstack::owncloud_version == '8.2'){

      if ! defined(Yumrepo['isv_ownCloud_community']){

        yumrepo { 'isv_ownCloud_community':
          name    => 'isv_ownCloud_community',
          enabled => 0,
          before  => Class['owncloud'],
        }

      }
      else{

        ini_setting { 'disable repo owncloud community':
          ensure  => present,
          path    => '/etc/yum.repos.d/isv_ownCloud_community.repo',
          section => 'isv_ownCloud_community',
          setting => 'enabled',
          value   => '0',
          before  => Class['owncloud'],
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
        before     => Class['owncloud'],
        require    => [ Class['::remi'], Ini_setting['centos base repo exclude php packages2'], ],
      }

      #packages
      package { 'rhscl-httpd24-epel-6-x86_64':
        ensure   => 'installed',
        provider => rpm,
        source   => 'https://www.softwarecollections.org/en/scls/rhscl/httpd24/epel-6-x86_64/download/rhscl-httpd24-epel-6-x86_64.noarch.rpm',
        before   => Class['owncloud'],
      }

      package { 'rhscl-rh-php56-epel-6-x86_64':
        ensure   => 'installed',
        provider => rpm,
        source   => 'https://www.softwarecollections.org/en/scls/rhscl/rh-php56/epel-6-x86_64/download/rhscl-rh-php56-epel-6-x86_64.noarch.rpm',
        before   => Class['owncloud'],
      }


    }

  }
  elsif($::operatingsystem == 'ubuntu'){

    if ! defined(Package['software-properties-common']){
      package {'software-properties-common':
        ensure => 'installed',
      }
    }

    if ! defined(Package['python-software-properties']){
      package {'python-software-properties':
        ensure => 'installed',
      }
    }

    apt::ppa { 'ppa:ondrej/mysql-5.6':
      require => [Package['software-properties-common'],
                  Package['python-software-properties'] ],
      before  => Class['::mysql::server'],
    }

  }

  package{ 'office package':
    ensure => installed,
    name   => $::owncloudstack::libreoffice_pkg_name,
  }

}

