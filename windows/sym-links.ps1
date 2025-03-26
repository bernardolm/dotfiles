Remove-Item "$Env:USERPROFILE\.ssh\config" ; New-Item -ItemType SymbolicLink -Target "$Env:USERPROFILE\Dropbox\shared\home\.ssh\config" -Path "$Env:USERPROFILE\.ssh\config"

Remove-Item "$Env:USERPROFILE\.wakatime.cfg" ; New-Item -ItemType SymbolicLink -Target "$Env:USERPROFILE\Dropbox\shared\home\.wakatime.cfg" -Path "$Env:USERPROFILE\.wakatime.cfg"

Remove-Item "$Env:USERPROFILE\.gitconfig" ; New-Item -ItemType SymbolicLink -Target "$Env:USERPROFILE\Dropbox\windows\home\.gitconfig" -Path "$Env:USERPROFILE\.gitconfig"

Remove-Item "$Env:USERPROFILE\.wslconfig" ; New-Item -ItemType SymbolicLink -Target "$Env:USERPROFILE\Dropbox\windows\home\.wslconfig" -Path "$Env:USERPROFILE\.wslconfig"

Remove-Item "$Env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState" ; New-Item -ItemType SymbolicLink -Target "$Env:USERPROFILE\Dropbox\windows\windows-terminal" -Path "$Env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

Remove-Item "$Env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" : New-Item -ItemType SymbolicLink -Target "$Env:USERPROFILE\Dropbox\windows\pws\Microsoft.PowerShell_profile.ps1" -Path "$Env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
