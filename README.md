# puppet-owncloud-stack
puppet module for OwnCloud Stack

tested on Ubuntu 12.04 LTS
tested on Centos 6.6 x64_64

### Authors

* Patrik Majer (@czhujer) <patrik.majer.pisek@gmail.com>

### Instalation - Manual

* install packages: git, puppet (puppet module)

```
linux#wget https://raw.githubusercontent.com/czhujer/puppet-bootstrap/master/ubuntu.sh
linux# bash ubuntu.sh
```

* install puppet modules

```
linux# puppet module install shoekstra-owncloud
```

```
linux# puppet module install dhoppe-fail2ban
```

```
linux# puppet module install puppetlabs-ntp
```

```
linux# puppet module install example42-timezone
```

```
linux# puppet module install example42-sendmail
```

* install owncloud-stack

```
linux# cd /etc/puppet/modules; git clone https://github.com/czhujer/puppet-owncloud-stack.git; mv puppet-owncloud-stack/ owncloud-stack/;
```

** on CentOS - install next module(s)

```
linux# puppet module install --ignore-dependencies ckhall-remi
linux# puppet module install puppetlabs-inifile
```

### Using

* set hiera data

* run manifest

```
linux# puppet apply /etc/puppet/modules/owncloud-stack/manifests/init.pp
```

* enjoy it >]
