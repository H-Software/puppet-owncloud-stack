#########################################################
#							#
# OwnCLoud manifest - accesories part			#
#							#
# create by czhujer (patrik.majer.pisek@gmail.com) 	#
#							#
# version: 0.3						#
#							#
#########################################################

class owncloudstack::services ()
{

  #
  # Antivirus part
  #

  if($::operatingsystem == 'centos' and versioncmp($::operatingsystemrelease, '6') and versioncmp($::operatingsystemrelease, '7') < 1) {
    $packages_clamav = ['clamav', 'clamd', 'clamav-db']
    $service_clamav = 'clamd'
  }
  else{
    $packages_clamav = ['clamav', 'clamav-base', 'clamav-daemon', 'clamav-freshclam']
    $service_clamav = 'clamav-freshclam'
  }

  if($::owncloudstack::manage_clamav){
    package { $packages_clamav:
      ensure => latest,
    }

    if($::operatingsystem == 'ubuntu') {

      service { 'clamav-freshclam':
        ensure  => running,
        enable  => true,
        require => Package[$packages_clamav],
      }

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

  if($::operatingsystem == 'centos' and versioncmp($::operatingsystemrelease, '6') and versioncmp($::operatingsystemrelease, '7') < 1) {
    $package_name = 'cronie'
    $service_name = 'crond'
    $apache_user  = 'apache'
  }
  else
  {
    $package_name = 'cron'
    $service_name = 'cron'
    $apache_user  = 'www-run'
  }

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

}
