class vsftpd {
  $allowed_users_file = '/etc/vsftpd.allowed_users'

  package { 'vsftpd': }

  file { '/etc/ftpusers':
    # Not used - delete to avoid confusion
    ensure => absent
  }

  # Unprivileged user for vsftpd
  group { 'ftpnopriv':
    ensure => present,
    system => true
  }

  file { '/var/ftpnopriv':
    ensure => directory,
    mode => 0500,
    owner => 'ftpnopriv',
    group => 'ftpnopriv',
    recurse => true,
    purge => true,
    require => Group['ftpnopriv']
  }

  user { 'ftpnopriv':
    gid => 'ftpnopriv',
    home => '/var/ftpnopriv',
    shell => '/sbin/nologon',
    system => true,
    require => Group['ftpnopriv']
  }

  file { '/etc/vsftpd.conf':
    owner => 'root',
    group => 'root',
    mode => 0600,
    content => template('vsftpd/vsftpd.conf.erb'),
    notify => Service['vsftpd']
  }

  concat { $allowed_users_file:
    owner => 'root',
    group => 'root',
    mode => 0600
  }

  concat::fragment { 'allowed_users_header':
    target => $allowed_users_file,
    content => "# Managed by Puppet - do not edit\n# The following users are allowed to log in via FTP\n",
    order => 00
  }

  file { '/etc/pam.d/vsftpd':
    content => template('vsftpd/pam_d_vsftpd.erb')
  }

  service { 'vsftpd':
    enable => true,
    ensure => running
  }
}
