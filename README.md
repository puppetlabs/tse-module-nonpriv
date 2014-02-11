nonpriv
=======

Set up a non-privileged user for Puppet Enterprise 3.2 on Windows Server 2008r2.

This module contains three classes:

 * **nonpriv**: for use by an Administrator to setup a non-priv user to use PE; complete with a simple puppet.conf and a scheduled task for a puppet agent run every 30 minutes.
 * **nonpriv::user_created_by_admin**: for use by an Administrator to setup a non-priv user with a puppet.conf.
 * **nonpriv::puppet_run_sched_by_user**: for use by an Administrator or non-priv user to setup a scheduled task to run the puppet agent.

```puppet 
class { 'nonpriv':
  user     => 'foobar',
  password => 'Pupp3t!',
  server   => 'puppet',
  certname => $user,
}
```
