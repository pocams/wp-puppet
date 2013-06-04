define wphost::wpconfig ($hostname=$title, $username, $password) {

  File { owner => $username, group => 'www-data', mode => 0640 }

  file { "/home/${username}/www/wp-config-sample.php":
    ensure => absent
  }

  file { "/home/${username}/www/wp-config.php":
    content => template('wphost/wp-config.php.erb')
  }

  file { "/home/${username}/www/wp-keys.php":
    content => template('wphost/wp-keys.php.erb'),
    replace => false
  }

  file { "/home/${username}/www/wp-content": ensure => directory, mode => 0750 }
  file { "/home/${username}/www/wp-content/mu-plugins": ensure => directory, mode => 0750 }
  file { "/home/${username}/www/wp-content/mu-plugins/enable_fancy_permalinks.php":
    source => 'puppet:///modules/wphost/enable_fancy_permalinks.php'
  }
}
