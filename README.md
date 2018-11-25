# puppet-owncloudstack
puppet module for OwnCloud Stack

tested on Centos 6.x x86_64, CentOS 7.x x86_64

### Authors

* Patrik Majer (@czhujer) <patrik.majer.pisek@gmail.com>

### Instalation - Manual

* install packages: git, puppet (puppet module)

* install main module

```
linux# cd /etc/puppet/modules && git clone https://github.com/czhujer/puppet-owncloud-stack.git owncloudstack;
```

* install other modules

```
linux# cd owncloudstack && r10k puppetfile install -v
```

### Usage

Put the classes, types, and resources for customizing, configuring, and doing the fancy stuff with your module here.
