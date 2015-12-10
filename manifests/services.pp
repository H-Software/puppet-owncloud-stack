#########################################################
#							#
# OwnCLoud manifest - accesories part			#
#							#
# create by czhujer (patrik.majer.pisek@gmail.com) 	#
#							#
# version: 0.3						#
#							#
#########################################################

owncloudstack::services ()
{

  #
  # Antivirus part
  #

  if($::operatingsystem == "centos" and $::operatingsystemrelease >= 6 and $::operatingsystemrelease < 7) {
    $packages_clamav = ["clamav", "clamd", "clamav-db"]
    $service_clamav = "clamd"
  }
  else{
    $packages_clamav = ["clamav", "clamav-base", "clamav-daemon", "clamav-freshclam"]
    $service_clamav = "clamav-freshclam"
  }

  package { $packages_clamav:
      ensure => latest,
  }

  if($::operatingsystem == "ubuntu") {

    service { 'clamav-freshclam':
      ensure => running,
      enable => true,
      require => Package[$packages_clamav],
    }

  }

  service { 'clamav-daemon':
    name   => $service_clamav,
    ensure => running,
    enable => true,
    require => Package[$packages_clamav],
  }

  #
  # Cron part
  #

  if($::operatingsystem == "centos" and $::operatingsystemrelease >= 6 and $::operatingsystemrelease < 7) {
    $package_name = 'cronie'
    $service_name = 'crond'
  }
  else
  {
    $package_name = 'cron' 
    $service_name = 'cron'
  }

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

  $cron_file_owncloud = "*/15  *  *  *  * www-data php -f /var/www/owncloud/cron.php > /dev/null 2>&1\n"

  file { 'owcnloud cron file':
    name => '/etc/cron.d/owncloud',
    content => $cron_file_owncloud,
    require => Package["cron"],
  }

}
