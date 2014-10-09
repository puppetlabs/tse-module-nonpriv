class nonpriv ($password='puppetlabs', $server='puppet') {
  if $is_admin {
    $k            = downcase($kernel)
    # first three chars of kernel fact
    $kern         = inline_template('<%= @k[0..2] %>')
    # first portion of dotted certname
    $cert         = values_at(split($clientcert, '[.]'), 0)
    $uniqish      = "np_${kern}_${cert}"
    # first 20 chars of name. Seems windows has 20 char limit & linux 32 char.
    $uniqish_name = inline_template('<%= @uniqish[0..19] %>')

    nonpriv::user_created_by_admin { $uniqish_name:
      ensure   => present,
      password => $password,
      server   => $server,
    }

    @@file_line { $uniqish_name:
      path => '/etc/puppetlabs/puppet/autosign.conf',
      line => $uniqish_name,
      tag  => ['np_fl'],
    }
    if $server == $clientcert {
      File_line <<| tag == 'np_fl' |>>
    } 
    exec { "/bin/su - ${uniqish_name} -c '/opt/puppet/bin/puppet agent -t'": }
  } 
}
