class nginx {
  $worker_processes = $processorcount
  $worker_connections = 2048

  service { 'nginx':
    ensure => running,
    enable => true
  }

  File { owner => 'www-data', group => 'www-data', mode => 0600, notify => Service['nginx'] }

  file { '/etc/nginx':
    ensure => directory,
    mode => 0700,
    recurse => true,
    purge => true,
    force => true
  }

  # nginx stock files that we want to use
  file { '/etc/nginx/mime.types': source => 'puppet:///modules/nginx/mime.types' }
  file { '/etc/nginx/fastcgi_params': source => 'puppet:///modules/nginx/fastcgi_params' }

  file { '/etc/nginx/nginx.conf': content => template('nginx/nginx.conf.erb') }

  # This gets included from the vhost files
  file { '/etc/nginx/restrictions.conf': source => 'puppet:///modules/nginx/restrictions.conf' }

  file { '/etc/nginx/vhosts.d': ensure => directory }
}
