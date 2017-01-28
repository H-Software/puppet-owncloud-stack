#########################################################
#                                                       
# owncloudstack class
#
#########################################################
class owncloudstack (
$owncloud_version='8',
$manage_apache=true,
$manage_vhost=true,
$manage_clamav=true,
$mysql_override_options = {},
)
{

  $mysql_override_options_profile = { 'mysqld' => {
      'bind-address'         => '127.0.0.1',
      'log_warnings'         => '4',
      'slow_query_log'       => '1',
      'slow_query_log_file'  => '/var/log/mysql-slow.log',
      'log_output'           => 'table,file', #!! for GENERAL and SLOW-QUERY
      'long_query_time'      => '3',
      'query_cache_type'     => '1',
      'query_cache_size'     => '64M',
  } }

  $mysql_override_options_merged = deep_merge($mysql_override_options, $mysql_override_options_profile)

  if ($::operatingsystem =~ /(?i:Centos|RedHat|Scientific|OracleLinux)/ and
      versioncmp($::operatingsystemrelease, '6') and
      versioncmp($::operatingsystemrelease, '7') < 1
    ) {
    $require_mysql_server = Package['mysql-repo']
  }
  elsif ($::operatingsystem == 'ubuntu' or $::operatingsystem == 'debian'){
    $require_mysql_server = []
  }
  else{
    fail("${::osfamily} not supported")
  }

  class { '::owncloudstack::system':
  }

  class { '::mysql::server':
    override_options => $mysql_override_options_merged,
    package_name     => 'mysql-community-server',
    package_ensure   => 'installed',
    service_enabled  => true,
    restart          => true,
    require          => $require_mysql_server,
  }

    # slow query log
    file { 'mysql-server slow query log':
      ensure => present,
      path   => '/var/log/mysql-slow.log',
      owner  => 'mysql',
      group  => 'mysql',
      mode   => '0640',
      notify => Service['mysqld'],
      #require => Class['::mysql::server::service'],
    }

    # logrotate for mysql slow-query log
    file { 'mysql-server slow query log logrotate':
      ensure  => present,
      path    => '/etc/logrotate.d/mysql-slow',
      content => template('owncloudstack/logrotate.conf.mysql-slow.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

  class { '::sendmail':
  }

  if ($owncloud_version == '8.2'){
    $owncloud_manage_repo=false
  }
  elsif ($owncloud_version == '9'){
    $owncloud_manage_repo=true
  }
  else{
    $owncloud_manage_repo=true
  }

  class { '::owncloud':
    manage_repo     => $owncloud_manage_repo,
    manage_apache   => $manage_apache,
    manage_vhost    => $manage_vhost,
    manage_phpmysql => false,
  }

  class{ '::owncloudstack::services':
  }

}
