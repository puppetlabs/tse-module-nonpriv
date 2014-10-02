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
    value = `powershell -executionpolicy remotesigned -file #{ps1.path}`.chomp.downcase
    ps1.unlink
    Facter.debug("windows")
    (value == 'true').to_s
  end
end

Facter.add(:is_admin) do
  confine do
    Facter::Core::Execution.which('id') && Facter.value(:kernel) != "SunOS"
  end
    setcode do
      Facter.debug("main: #{`id -u`}.chomp")
      (Facter::Core::Execution.exec('id -u').chomp == 0).to_s
    end
end

Facter.add(:is_admin) do
  confine :kernel => :SunOS
  setcode do
    Facter.debug("solaris")
    if File.exist? '/usr/xpg4/bin/id'
      (Facter::Core::Execution.exec('/usr/xpg4/bin/id -u').chomp == 0).to_s
    end
  end
end

Facter.add(:is_admin) do
  setcode do
    Facter.debug("root")
    (Facter.value(:id) == 'root').to_s
  end
end
