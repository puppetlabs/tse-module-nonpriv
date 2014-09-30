Facter.add(:isadmin) do
  require 'tempfile'
  confine :kernel => 'windows'

  setcode do
    ps1 = Tempfile.new(['isadmin_fact_powershell_script', '.ps1'])
    script = <<END
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent([Security.Principal.TokenAccessLevels]'Query,Duplicate'));
    $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator);
    Write-Host $isAdmin
END
    ps1.write(script)
    ps1.close
    exec_policy = `powershell -command Get-ExecutionPolicy`.chomp
    `powershell -command Set-ExecutionPolicy RemoteSigned`
    value = `powershell #{ps1.path}`.chomp
    `powershell -command Set-ExecutionPolicy #{exec_policy}`
    value
  end
end
