nonpriv
=======

Set up a non-privileged user for Puppet Enterprise on Linux and Windows Server 2008r2.
Tested on CentOS and Server2008r2 so far.

This module contains three classes:

 * **nonpriv**: for use by Linux root or a Windows Administrator to setup a non-priv user to use PE; complete with a simple puppet.conf in the .puppet directory in their home dir.
 * **nonpriv::user_created_by_admin**: defined type to make the users as described above.
 * **nonpriv::puppet_run_sched_by_user**: for use by an Administrator or non-priv user to setup a scheduled task to run the puppet agent. Or at least it used to be. Not using just now.

```puppet 
class { 'nonpriv':
  suffix   => 'foobar',
  password => 'Pupp3t!',
  server   => 'puppet',
}
```

And one fact:

 * **isadmin**: the isadmin fact is true for root or Administrator users on many systems

