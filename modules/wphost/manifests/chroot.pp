define wphost::chroot ($hostname=$title, $username) {
  File { owner => $username, group => 'www-data' }

  file { ["/home/${username}/tmp", "/home/${username}/bin", "/home/${username}/usr",
          "/home/${username}/usr/share"]:
    ensure => directory,
    mode => 2770,
    before => Exec["rsync /home/${username}/usr/share/zoneinfo"]
  }

  # Is there a better way to handle this?
  exec { "rsync /home/${username}/usr/share/zoneinfo":
    command => "/usr/bin/rsync -a --delete /usr/share/zoneinfo/ /home/${username}/usr/share/zoneinfo/",
    creates => "/home/${username}/usr/share/zoneinfo/zone.tab"
  }

}
