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
$mysql_override_options = {},
$mysql_server_version='5.7',
$php_extra_modules = [],
$libreoffice_pkg_name="libreoffice",
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
  elsif ($::operatingsystem == 'ubuntu' or $::operatingsystem == 'debian'){
    $require_mysql_server = []
    $documentroot = '/var/www/owncloud'
    $mysql_server_package = 'mysql-server'
    $mysql_server_service_name = undef
  }
  else{
    fail("${::osfamily} not supported")
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

  class { '::owncloudstack::system': } ->
  class { '::owncloudstack::services': } ->
  class { '::owncloudstack::mysql': } ->
  class { '::owncloudstack::owncloud': } ->
  class { '::owncloudstack::php': } ->
  Class['::owncloudstack']

}
