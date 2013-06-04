define vsftpd::user ($username=$title) {
  concat::fragment { "vsftpd_user_$username":
    target => $vsftpd::allowed_users_file,
    content => "$username\n",
    order => 10
  }
}
