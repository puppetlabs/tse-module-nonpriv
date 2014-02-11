class nonpriv ($user, $password, $server) {

  class { 'nonpriv::user_created_by_admin':
    nonpriv_user      => $user,
    password          => $password,
    ensure            => present,
    certname          => $user,
    server            => $server,
    enable_sched_task => true,
  }

  class { 'nonpriv::puppet_run_sched_by_user':
    nonpriv_user      => $user,
    password          => $password,
    ensure            =>'present',
    certname          =>$user,
    server            =>$server,
    run_interval_mins =>'30',
  }

  Class[ 'nonpriv::user_created_by_admin' ] ->
  Class[ 'nonpriv::puppet_run_sched_by_user' ]

}
