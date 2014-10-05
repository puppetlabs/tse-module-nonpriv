class nonpriv ($suffix='nonadmin', $password='puppetlabs', $server='puppet') {
  if $is_admin {
    $kern = downcase($kernel)

    nonpriv::user_created_by_admin { "${kern}_${suffix}":
      ensure   => present,
      password => ${password},
      server   => ${server},
    }
  }
}
