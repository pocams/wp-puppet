define fpm::vhost ($hostname = $title,
                   $username,
                   $slowlog_timeout = '5s',
                   $max_children = 4,
                   $start_servers = 2,
                   $min_spare_servers = 1,
                   $max_spare_servers = 3) {

  $socket_path = $fpm::socket_path
  $slowlog_path = $fpm::slowlog_path

  file { "/etc/php5/fpm/pool.d/${hostname}":
    ensure => file,
    content => template('fpm/fpm.conf.erb'),
    notify => Service['php5-fpm']
  }
}
