Facter.add(:is_admin) do
  require 'tempfile'
  confine :kernel => 'windows'
  setcode do
    ps1 = Tempfile.new(['is_admin_fact_powershell_script', '.ps1'])
    script = <<END
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent([Security.Principal.TokenAccessLevels]'Query,Duplicate'));
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator);
Write-Host $isAdmin
END
    ps1.write(script)
    ps1.close
    value = 'false'
    value = `powershell -executionpolicy remotesigned -file #{ps1.path}`.chomp.downcase
    ps1.unlink
    (value == 'true').to_s
  end
end

Facter.add(:is_admin) do
  setcode do
    (Facter.value(:id) == 'root').to_s
  end
end
