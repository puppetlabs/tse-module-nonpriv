define nonpriv::user_created_by_admin (
  $password,
  $nonpriv_user=$name,
  $ensure='present', # 'present' or 'absent'
  $certname=$nonpriv_user,
  $server='puppet', # puppet master
  $enable_sched_task=true, # true or false
  ) {

  validate_re($ensure, ['present', 'absent'], '$ensure must be \'absent\' or \'present\'')
  validate_re($enable_sched_task, [true, false], '$enable_sched_task must be \'true\' or \'false\'')

  $nonpriv_groups = undef
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

}
