#########################################################
#
# owncloudstack::services class
#
#########################################################

class owncloudstack::services ()
{

  #
  # Antivirus part
  #

  $packages_clamav = ['clamav', 'clamd', 'clamav-db']
  $service_clamav = 'clamd'

  if($::owncloudstack::manage_clamav){
    package { $packages_clamav:
      ensure => latest,
    }

    service { 'clamav-daemon':
      ensure  => running,
      name    => $service_clamav,
      enable  => true,
      require => Package[$packages_clamav],
    }

  }

  #
  # Cron part
  #
  $package_name = 'cronie'
  $service_name = 'crond'
  $apache_user  = 'apache'

  package {'cron':
      ensure => 'present',
      name   => $package_name,
  }

  service {'cron':
    ensure    => true,
    enable    => true,
    name      => $service_name,
    require   => Package['cron'],
    subscribe => File['owncloud cron file'],
  }

  $cron_file_owncloud = "*/15  *  *  *  * ${apache_user} php -f /var/www/owncloud/cron.php > /dev/null 2>&1\n"

  file { 'owncloud cron file':
    name    => '/etc/cron.d/owncloud',
    content => $cron_file_owncloud,
    require => Package['cron'],
  }

  #
  # sendmail
  #

  if($::owncloudstack::manage_sendmail){
    class { '::sendmail':
    }
  }

}
