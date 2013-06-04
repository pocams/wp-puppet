define wphost::vhost ($hostname=$title, $username, $password, $wp_lang='', $ensure=present) {

  $ensure_dir = $ensure ? {
    absent => absent,
    default => directory
  }

  group { $username:
    ensure => $ensure
  }

  # The www-data user needs to be present in the user's group so it can get access
  # to the home directory, which has to be owned by root for sftp chroot to work
  if ($ensure == present) {
    exec { "/usr/sbin/usermod -G ${username} -a www-data":
      unless => "/usr/bin/groups www-data | /bin/egrep -q '\\b${username}\\b'"
    }
  }

  user { $username:
    comment => $hostname,
    home => "/home/${username}",
    ensure => $ensure,
    shell => "/usr/sbin/nologin",
    gid => $username,
    groups => [ 'sftp-users' ]
  }

  file { "/home/${username}":
    ensure => $ensure_dir,
    mode => 0750,
    owner => 'root',
    group => $username,
  }

  file { [ "/home/${username}/www" ]:
    ensure => $ensure_dir,
    mode => 2750,
    owner => $username,
    group => 'www-data'
  }

  file { "/home/${username}/logs":
    ensure => $ensure_dir,
    mode => 2770,
    owner => $username,
    group => 'www-data'
  }

  wphost::wpconfig { $hostname:
    username => $username,
    password => $password
  }

  wphost::chroot { $hostname:
    username => $username,
  }

  fpm::vhost { $hostname:
    username => $username
  }

  nginx::vhost { $hostname:
    username => $username
  }

  mysql::db { $username:
    user => $username,
    password => $password
  }

  vsftpd::user { $username: }

}
