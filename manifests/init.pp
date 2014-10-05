class nonpriv ($suffix='nonadmin', $password='puppetlabs', $server='puppet') {
  if $is_admin {
    $kern = downcase($kernel) 
    $cert = regsubst($clientcert, '[.]', '_', 'G')

    nonpriv::user_created_by_admin { "${kern}_${suffix}_${cert}":
      ensure   => present,
      password => $password,
      server   => $server,
    }
  }
}
