define wphost::adminuser ($username=$title, $authorized_key, $comment) {
  $home = "/home/${username}"

  group { $username:
    ensure => present
  }

  user { $username:
    ensure => present,
    password => '!',
    home => $home,
    comment => $comment,
    shell => '/bin/bash',
    gid => $username,
    groups => [ 'admin' ],
  }

  file { $home:
    ensure => directory,
    owner => $username,
    group => $username,
    notify => Exec["${username}-skel"]
  }

  file { "${home}/.ssh":
    ensure => directory,
    owner => $username,
    group => $username,
    mode => 0700
  }

  file { "${home}/.ssh/authorized_keys":
    ensure => present,
    owner => $username,
    group => $username,
    mode => 0600,
    content => "${authorized_key}\n"
  }

  file { "/etc/sudoers.d/${username}":
    ensure => present,
    mode => 0440,
    content => "${username} ALL=(ALL) NOPASSWD:ALL\n"
  }

  exec { "${username}-skel":
    # cp -r ends up copying the skel directory itself, not its contents
    #command => "/bin/cp -r /etc/skel \"$home\"; /bin/chown -R \"$username:$username\" \"$home\"",
    command => "/usr/bin/rsync -a /etc/skel/ \"$home/\"; /bin/chown -R \"$username:$username\" \"$home\"",
    refreshonly => true
  }

}
