class fpm {
  $config_path = '/etc/php5/fpm/pool.d'
  $chroot_path = '/var/chroot'
  $socket_path = '/var/run/fpm'
  $slowlog_path = '/var/log/fpm-slowlog'

  package { "php5-fpm":
    ensure => installed
  }

  service { "php5-fpm":
    enable => true,
    ensure => running
  }

  group { "fpm":
    gid => 200,
  }

  file { $config_path:
    ensure => directory,
    mode => 0700,
    recurse => true,
    purge => true
  }

  file { $chroot_path:
    ensure => directory,
    mode => 0700
  }

  file { $socket_path:
    ensure => directory,
    mode => 0750,
    group => 'www-data'
  }

  file { $slowlog_path:
    ensure => directory,
    owner => 'root',
    group => 'fpm',
    mode => 0775
  }

  file { "/etc/php5/fpm/php-fpm.conf":
    ensure => present,
    source => 'puppet:///modules/fpm/php-fpm.conf',
    notify => Service['php5-fpm']
  }

  file { "/etc/init.d/php5-fpm":
    ensure => present,
    mode => 0755,
    content => template('fpm/php5-fpm.erb'),
    notify => Service['php5-fpm']
  }
}
