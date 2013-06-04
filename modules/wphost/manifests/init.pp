class wphost ($mysql_root_password) {
  file { '/etc/sysctl.conf': content => template('wphost/sysctl.conf.erb') }
  file { '/etc/security/limits.conf': content => template('wphost/limits.conf.erb') }

  include apt
  include fpm
  include vsftpd
  include varnish

  # SSH config
  group { 'sftp-users':
    gid => 300
  }

  service { 'ssh': }

  file { '/etc/ssh/sshd_config':
    source => 'puppet:///modules/wphost/sshd_config',
    owner => root,
    group => root,
    mode => 0644,
    notify => Service['ssh']
  }


  package { 'php5-gd': }
  package { 'php-apc': }

  file { '/etc/php5/fpm/php.ini':
    content => template('wphost/php.ini.erb')
  }

#  apt::source { 'nginx':
#    location => 'http://nginx.org/packages/ubuntu/',
#    repos => 'nginx',
#    key => '7BD9BF62',
#    key_source => 'http://nginx.org/keys/nginx_signing.key'
#  }

  class { 'nginx': }

  apt::source { 'mariadb':
    location          => "http://ftp.osuosl.org/pub/mariadb/repo/5.5/ubuntu/",
    repos             => 'main',
    key               => '1BB943DB',
    key_server        => 'keyserver.ubuntu.com'
  }

  class { 'mysql':
    client_package_name => 'mariadb-client',
    server_package_name => 'mariadb-server',
    root_password => $mysql_root_password
  }

  class { 'mysql::server': }
  class { 'mysql::php': }

}
