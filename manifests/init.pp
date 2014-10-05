class nonpriv ($suffix='nonadmin', $password='puppetlabs', $server='puppet') {
  if $is_admin {
    $kern = downcase($kernel) 
    $cert = values_at(split($clientcert, '[.]'), 0)

    nonpriv::user_created_by_admin { "${kern}_${suffix}_${cert}":
      ensure   => present,
      password => $password,
      server   => $server,
    }
  }
}
