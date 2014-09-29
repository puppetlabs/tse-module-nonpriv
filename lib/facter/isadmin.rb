Facter.add(:isadmin) do
  require 'tempfile'
  confine :kernel => 'windows'

  setcode do
    ps = Tempfile.new('isadmin_fact_powershell_script')
    script = <<END
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent([Security.Principal.TokenAccessLevels]'Query,Duplicate'))
    $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    return $isAdmin
END
    ps.write(script)
    command = "powershell -command #{ps.path}"
    Facter::Core::Execution.exec(command)
    ps.close
  end
end
