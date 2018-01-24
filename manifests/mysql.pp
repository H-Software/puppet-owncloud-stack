#########################################################
#                                                       
# owncloudstack::mysql
#    
#########################################################
class owncloudstack::mysql ()
{

  if ($::operatingsystem =~ /(?i:Centos|RedHat|Scientific|OracleLinux)/ and
      versioncmp($::operatingsystemrelease, '6') and
      versioncmp($::operatingsystemrelease, '7')
    ) {

      if($::owncloudstack::mysql_server_version == '5.7'){
        # update repos
        ini_setting { 'mysql 5.7 repo enable':
          ensure  => present,
          path    => '/etc/yum.repos.d/mysql-community.repo',
          section => 'mysql57-community',
          setting => 'enabled',
          value   => '1',
          require => Package['mysql-repo'],
        }

        ini_setting { 'mysql 5.6 repo disable':
          ensure  => present,
          path    => '/etc/yum.repos.d/mysql-community.repo',
          section => 'mysql56-community',
          setting => 'enabled',
          value   => '0',
          require => Package['mysql-repo'],
  class { '::mysql::server':
    override_options => $::owncloudstack::mysql_override_options_merged,
    package_name     => $::owncloudstack::mysql_server_package,
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
