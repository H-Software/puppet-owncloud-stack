#########################################################
#                                                       
# owncloudstack::mysql
#    
#########################################################
class owncloudstack::mysql ()
{

  class { '::mysql::server':
    override_options => $::owncloudstack::mysql_override_options_merged,
    package_name     => 'mysql-community-server',
    package_ensure   => 'installed',
    service_enabled  => true,
    restart          => true,
    require          => $::owncloudstack::require_mysql_server,
  }

  # slow query log
  file { 'mysql-server slow query log':
    ensure    => present,
    path      => '/var/log/mysql-slow.log',
    owner     => 'mysql',
    group     => 'mysql',
    mode      => '0640',
    subscribe => Service['mysqld'],
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

}
