class nonpriv ($suffix='nonadmin', $password='puppetlabs', $server='puppet') {
  if $is_admin {
    $kern = downcase($kernel) 
    $host = regsubst($hostname, '[.]', '_', 'G')

    nonpriv::user_created_by_admin { "${kern}_${suffix}_${host}":
      ensure   => present,
      password => $password,
      server   => $server,
    }
  }
}
