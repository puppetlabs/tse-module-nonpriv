class nonpriv::user_created_by_admin (
  $password,
  $nonpriv_user=$name,
  $ensure='present', # 'present' or 'absent'
  $certname=$nonpriv_user,
  $server='puppet', # puppet master
  $enable_sched_task=true, # true or false
  ) {

  validate_re($ensure, ['present', 'absent'], '$ensure must be \'absent\' or \'present\'')
  validate_re(bool2num($enable_sched_task), [1, 0], '$enable_sched_task must be \'true\' or \'false\'')

  if $enable_sched_task {
    $nonpriv_groups = ['Users', 'Remote Desktop Users', 'Performance Log Users']
  } else {
    $nonpriv_groups = ['Users', 'Remote Desktop Users']
  }

  user { $nonpriv_user:
    ensure     => $ensure,
    managehome => true,
    password   => $password,
    groups     => $nonpriv_groups,
  }

  $puppet_dir = "C:/Users/${nonpriv_user}/.puppet"

  file { "$puppet_dir/puppet.conf": {
    ensure  => file,
    content => "server=${server}\r\ncertname=${certname}",
    require => User [ $nonpriv_user ],
  }

}
