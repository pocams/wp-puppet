class varnish (
  $nfiles = 131072,
  $memlock = 82000,
  $backend_host = '127.0.0.1',
  $backend_port = '8080',
  $max_threads = '1500',
  $thread_timeout = '120') {

  package { 'varnish': }

  file { '/etc/default/varnish':
    content => template('varnish/default_varnish.erb'),
    notify => Service['varnish']
  }

  file { '/etc/varnish/default.vcl':
    content => template('varnish/default.vcl.erb'),
    notify => Service['varnish']
  }

  service { 'varnish':
    ensure => running,
    enable => true
  }
}
