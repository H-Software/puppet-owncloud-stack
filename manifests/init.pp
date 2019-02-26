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
$manage_fail2ban=true,
$manage_sendmail=true,
$manage_ntp=true,
$manage_timezone=true,
$mysql_override_options = {},
$mysql_server_version='5.7',
$mysql_server_service_restart = true,
$php_extra_modules = [],
$libreoffice_pkg_name='libreoffice',
$owncloud_ssl = false,
$php_version = '5.6',
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

  validate_bool($manage_apache)

  validate_bool($manage_vhost)

  validate_bool($manage_clamav)

  validate_bool($manage_fail2ban)

  validate_bool($manage_sendmail)

  validate_bool($manage_ntp)

  validate_bool($manage_timezone)

  validate_bool($mysql_server_service_restart)

  validate_bool($owncloud_ssl)

  if ($::operatingsystem =~ /(?i:Centos|RedHat|Scientific|OracleLinux)/) {
      if(versioncmp($::operatingsystemmajrelease, '7') == 0){
        $mysql_repo_source_url = 'https://repo.mysql.com/mysql-community-release-el7.rpm'
        $mysql_server_service_name = 'mysqld'
      }
      elsif (versioncmp($::operatingsystemmajrelease, '6') == 0){
        $mysql_repo_source_url = 'https://repo.mysql.com/mysql-community-release-el6.rpm'
        $mysql_server_service_name = undef
      }
      else {
        fail("version ${::operatingsystemmajrelease} of ${::osfamily} not supported")
      }

      $require_mysql_server = Package['mysql-repo']
      $documentroot = '/var/www/html/owncloud'
      $mysql_server_package = 'mysql-community-server'
  }
  else{
    fail("${::osfamily} not supported")
  }

  if ($owncloud_version == '8.2'){
    $owncloud_manage_repo=false
  }
  elsif ($owncloud_version == '9' or $owncloud_version == '10'){
    $owncloud_manage_repo=true
  }
  else{
    fail("owncloud version ${owncloud_version} not supported")
  }

  class { '::owncloudstack::system': }
  -> class { '::owncloudstack::services': }
  -> class { '::owncloudstack::mysql': }
  -> class { '::owncloudstack::owncloud': }
  -> class { '::owncloudstack::php': }
  -> Class['::owncloudstack']

}
