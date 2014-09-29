Facter.add(:isadmin) do
  require 'tempfile'
  confine :kernel => 'windows'

  setcode do
    ps = Tempfile.new('isadmin_fact_powershell_script')
    ps.write("$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent([Security.Principal.TokenAccessLevels]'Query,Duplicate'))
              $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
              return $isAdmin")
    command = "powershell -command #{ps.path}"
    Facter::Core::Execution.exec(command)
  end
end
