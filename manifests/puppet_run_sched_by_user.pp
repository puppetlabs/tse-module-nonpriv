# could make this a defined type as well, but want to have only one of these per user for now
class nonpriv::puppet_run_sched_by_user (
  $nonpriv_user,
  $password,
  $ensure='present', # 'present' or 'absent'
  $certname=$nonpriv_user,
  $server='puppet', # puppet master
  $run_interval_mins='30', # in minutes, one of 5, 10, 15, 30, 60
  ) {

  validate_re($ensure, ['present', 'absent'], '$ensure must be \'absent\' or \'present\'')
  validate_re($run_interval_mins, ['5', '10', '15', '30', '60'], '$run_interval_mins must be one of 5, 10, 15, 30, 60')

  if $run_interval_mins == '60' {
    $run_interval_xml = 'PT1H' # 1 Hour
  } else {
    $run_interval_xml = "PT${$run_interval_mins}M" # Minutes
  }

  $nonpriv_user_xml = "WINDOWS\\${nonpriv_user}"

  $xml_dir  = "C:/Users/${nonpriv_user}/.puppet/xml"
  $xml_file = "${xml_dir}/${nonpriv_user}_pe_agent_run.xml"

  $sched_task_command = 'C:\Windows\System32\schtasks.exe'
  $sched_task_create  = "/Create /XML ${xml_file}"
  $sched_task_delete  = '/Delete'
  $sched_task_query   = '/Query'
  $sched_task_creds   = "/RU ${nonpriv_user_xml} /RP ${password}"
  $sched_task_name    = "/TN ${nonpriv_user}_pe_agent_run"

  $create_sched_task = "${sched_task_command} ${sched_task_create} ${sched_task_creds} ${sched_task_name}"
  $delete_sched_task = "${sched_task_command} ${sched_task_delete} ${sched_task_creds} ${sched_task_name} /F"
  $exists_sched_task = "${sched_task_command} ${sched_task_query} ${sched_task_name}"

  if $ensure == 'present' {
    $exec_to_notify = 'delete_then_create_sched_task'
  } else {
    $exec_to_notify = 'delete_sched_task'
  }

  user { $nonpriv_user:
    ensure => present,
  }
  
  file { $xml_dir:
    ensure => directory,
  }

  file { $xml_file:
    ensure  => $ensure,
    owner   => $nonpriv_user,
    content => template('nonpriv/nonpriv_pe_agent_run_xml.erb'),
    require => [ User[ $nonpriv_user ], File[ $xml_dir ] ],
    notify  => Exec[ $exec_to_notify ],
  }

  exec { 'create_sched_task':
    command     => $create_sched_task,
    unless      => $exists_sched_task,
    #tries       => 3,
    #timeout     => 15,
    refreshonly => true,
  }

  exec { 'delete_then_create_sched_task':
    command     => $delete_sched_task,
    returns     => [1,0], # don't care if delete fails or succeeds
    refreshonly => true,
    notify      => Exec[ 'create_sched_task' ],
  }
  
  exec { 'delete_sched_task':
    command     => $delete_sched_task,
    onlyif     => $exists_sched_task,
    refreshonly => true,
  }

}
