define nonpriv::user_created_by_admin (
  $nonpriv_user = $name,
  $password,    # required
  $ensure       = 'present', # 'present' or 'absent'
  $certname     = $name,
  $server       = 'puppet', # puppet master
  ) {

  validate_re($ensure, ['present', 'absent'], '$ensure must be \'absent\' or \'present\'')

  $win_nonpriv_groups = ['Users', 'Remote Desktop Users']
  $groups = $kernel ? {
    'windows' => $win_nonpriv_groups,
    default   => [],
  }

  user { $nonpriv_user:
    ensure     => $ensure,
    managehome => true,
    password   => $password,
    groups     => $groups,
  }
  
  # windows 7,8,vista,2008
  $win_puppet_dir = "C:/Users/${nonpriv_user}/.puppet"
  $linux_puppet_dir = "/home/${nonpriv_user}/.puppet"
  $puppet_dir = $kernel ? {
    'windows' => $win_puppet_dir,
    default   => $linux_puppet_dir,
  }
  
  file { $puppet_dir:
    ensure  => directory,
    owner   => $nonpriv_user,
    require => User[$nonpriv_user],
  }
  
  $win_content = "[main]\r\nserver=${server}\r\ncertname=${certname}"
  $nix_content = "[main]\nserver=${server}\ncertname=${certname}"
  $content = $kernel ? {
    'windows' => $win_content,
    default   => $nix_content,
  }
  
  file { "${puppet_dir}/puppet.conf":
    ensure  => file,
    content => $content,
    require => File[$puppet_dir],
  }

}
