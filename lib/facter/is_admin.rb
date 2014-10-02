Facter.add(:is_admin) do
  confine :kernel => 'windows'
  require 'tempfile'
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
    value = `powershell -executionpolicy remotesigned -file #{ps1.path}`.chomp.chomp.downcase
    ps1.unlink
    (value == 'true').to_s
  end
end

Facter.add(:is_admin) do
  confine do
    Facter::Core::Execution.which('id') && Facter.value(:kernel) != "SunOS"
  end
    setcode do
      id = `id -u`
      bool = (id.chomp == 0)
      (Facter::Core::Execution.exec('id -u').strip == "0").to_s
    end
end

Facter.add(:is_admin) do
  confine :kernel => :SunOS
  setcode do
    if File.exist? '/usr/xpg4/bin/id'
      (Facter::Core::Execution.exec('/usr/xpg4/bin/id -u').strip == "0").to_s
    end
  end
end

Facter.add(:is_admin) do
  setcode do
    (Facter.value(:id) == 'root').to_s
  end
end
