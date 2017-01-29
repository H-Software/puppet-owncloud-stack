require 'spec_helper'

describe 'owncloudstack' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "owncloudstack class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('owncloudstack') }
          it { is_expected.to contain_class('owncloudstack::system') }
          it { is_expected.to contain_class('owncloudstack::services') }
          it { is_expected.to contain_class('owncloudstack::mysql') }
          it { is_expected.to contain_class('owncloudstack::owncloud') }
          it { is_expected.to contain_class('owncloudstack::system').that_comes_before('owncloudstack::services') }
          it { is_expected.to contain_class('owncloudstack::services').that_comes_before('owncloudstack::mysql') }
          it { is_expected.to contain_class('owncloudstack::mysql').that_comes_before('owncloudstack::owncloud') }

#          it { is_expected.to contain_package('owncloud').with_ensure('installed') }
#          it { is_expected.to contain_package('php').with_ensure('installed') }
#          it { is_expected.to contain_package('php-ldap').with_ensure('installed') }
#          it { is_expected.to contain_package('php-mysqlnd').with_ensure('installed') }
          it { is_expected.to contain_package('fail2ban').with_ensure('latest') }
#          it { is_expected.to contain_package('libreoffice').with_ensure('latest') }

#          it { is_expected.to contain_service('mysqld').with(
#                'ensure'     => 'running',
#                'enable'     => 'true',
#                'hasrestart' => 'true',
#               ) }

#          it { is_expected.to contain_service('sendmail').with(
#                'ensure'     => 'running',
#                'enable'     => 'true',
#                'hasrestart' => 'true',
#               ) }

          it { is_expected.to contain_service('fail2ban').with(
                'ensure'     => 'running',
                'enable'     => 'true',
                'hasrestart' => 'true',
               ) }




        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'owncloudstack class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('owncloudstack') }.to raise_error(Puppet::Error, /Solaris not supported/) }
    end
  end

  context 'RedHat/CentOS 6 operaton system' do
    describe 'owncloudstack class without any parameters on RedHat/CentOS 6' do
       let (:facts) {{
         :osfamily                  => 'RedHat',
         :operatingsystem           => 'CentOS',
         :operatingsystemmajrelease => '6',
         :operatingsystemrelease    => '6.8',
         :architecture              => 'x86_64',
         :ipaddress                 => '10.42.42.42',
         :is_virtual                => true
       }}

#         it { is_expected.to contain_package('mysql-community-server').with_ensure('installed') }
         it { is_expected.to contain_package('httpd').with_ensure('installed') }
         it { is_expected.to contain_package('sendmail').with_ensure('present') }

         it { is_expected.to contain_service('clamav-daemon').with(
                'ensure'     => 'running',
                'enable'     => 'true',
               ) }

#         it { is_expected.to contain_service('ntpd').with(
#                'ensure'     => 'running',
#                'enable'     => 'true',
#                'hasrestart' => 'true',
#               ) }

         it { is_expected.to contain_service('cron').with(
                'ensure'     => 'true',
                'enable'     => 'true',
                #'hasrestart' => 'true',
               ) }


         it { is_expected.to contain_service('httpd').with(
                'ensure'     => 'running',
                'enable'     => 'true',
                'hasrestart' => 'true',
               ) }

         it { is_expected.to contain_file('/var/www/html/owncloud').with({
              'ensure' => 'directory',
              'owner'  => 'root',
              #'mode'   => '0755',
              'group'  => 'root',
            })
          }

    end
  end

  context 'Debian operation system' do
    describe 'owncloudstack class without any parameters on Debian' do
       let (:facts) {{
         :osfamily                  => 'Debian',
         :lsbdistid                 => 'Debian',
         :operatingsystem           => 'Debian',
         :operatingsystemmajrelease => '',
         :operatingsystemrelease    => '7.11',
         :lsbdistcodename           => 'wheezy',
         :ipaddress                 => '10.42.42.42',
         :is_virtual                => true
       }}
       it {

         #is_expected.to contain_package('apache2.2-bin').with_ensure('installed')
         #is_expected.to contain_package('apache2-utils').with_ensure('installed')
       }

       #it { is_expected.to contain_package('sendmail-bin').with_ensure('installed') }

       it { is_expected.to contain_service('clamav-daemon').with(
                'ensure'     => 'running',
                'enable'     => 'true',
                'hasrestart' => 'true',
               ) }

       it { is_expected.to contain_service('clamav-freshclam').with(
                'ensure'     => 'running',
                'enable'     => 'true',
                'hasrestart' => 'true',
               ) }

       it { is_expected.to contain_service('ntp').with(
                'ensure'     => 'running',
                'enable'     => 'true',
                'hasrestart' => 'true',
               ) }

       it { is_expected.to contain_service('cron').with(
                'ensure'     => 'running',
                'enable'     => 'true',
                'hasrestart' => 'true',
               ) }


       it { is_expected.to contain_service('apache2').with(
                'ensure'     => 'running',
                'enable'     => 'true',
                'hasrestart' => 'true',
               ) }

       it { is_expected.to contain_file('/var/www/html/owncloud').with({
              'ensure' => 'directory',
              'owner'  => 'www-data',
              'mode'   => '0755',
              'group'  => 'www-data',
            })
          }

    end
  end

  context 'Ubuntu operation system' do
    describe 'owncloudstack class without any parameters on Ubuntu' do
       let (:facts) {{
         :osfamily                  => 'Debian',
         :lsbdistid                 => 'Ubuntu',
         :operatingsystem           => 'Ubuntu',
         :operatingsystemmajrelease => '12.04',
         :lsbdistcodename           => 'precise',
         :ipaddress                 => '10.42.42.42',
         :is_virtual                => true
       }}
       it {
         is_expected.to contain_package('apache2.2-bin').with_ensure('installed')
         is_expected.to contain_package('apache2-utils').with_ensure('installed')
       }
       it { is_expected.to contain_package('sendmail-bin').with_ensure('installed') }

       it { is_expected.to contain_service('clamav-daemon').with(
                'ensure'     => 'running',
                'enable'     => 'true',
                'hasrestart' => 'true',
               ) }

       it { is_expected.to contain_service('clamav-freshclam').with(
                'ensure'     => 'running',
                'enable'     => 'true',
                'hasrestart' => 'true',
               ) }

       it { is_expected.to contain_service('ntp').with(
                'ensure'     => 'running',
                'enable'     => 'true',
                'hasrestart' => 'true',
               ) }

       it { is_expected.to contain_service('cron').with(
                'ensure'     => 'running',
                'enable'     => 'true',
                'hasrestart' => 'true',
               ) }

 
       it { is_expected.to contain_service('apache2').with(
                'ensure'     => 'running',
                'enable'     => 'true',
                'hasrestart' => 'true',
               ) }

       it { is_expected.to contain_file('/var/www/html/owncloud').with({
              'ensure' => 'directory',
              'owner'  => 'www-data',
              'mode'   => '0755',
              'group'  => 'www-data',
            })
          }
    end
  end

end

