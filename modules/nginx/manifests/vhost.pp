define nginx::vhost ($hostname=$title, $username, $aliases = [], $listen = '127.0.0.1:8080') {
  File { owner => 'www-data', group => 'www-data', mode => 0600, notify => Service['nginx'] }

  $server_names = concat([$hostname], $aliases)

  file { "/etc/nginx/vhosts.d/${hostname}": content => template('nginx/vhost.conf.erb') }
}
