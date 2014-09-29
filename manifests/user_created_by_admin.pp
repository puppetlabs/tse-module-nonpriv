define nonpriv::user_created_by_admin (
  $nonpriv_user = $name,
  $password,
  $ensure='present', # 'present' or 'absent'
  $certname=$nonpriv_user,
  $server='puppet', # puppet master
  ) {

  validate_re($ensure, ['present', 'absent'], '$ensure must be \'absent\' or \'present\'')

  $nonpriv_groups = ['Users', 'Remote Desktop Users']

  user { $nonpriv_user:
    ensure     => $ensure,
    managehome => true,
    password   => $password,
    groups     => $nonpriv_groups,
  }

  $puppet_dir = "C:/Users/${nonpriv_user}/.puppet"
  
  file { $puppet_dir:
    ensure  => directory,
    owner   => $nonpriv_user,
    require => User [ $nonpriv_user ],
  }

  file { "${puppet_dir}/puppet.conf":
    ensure  => file,
    content => "[main]\r\nserver=${server}\r\ncertname=${certname}",
    require => File [ $puppet_dir ],
  }

}
