# Dotfiles PowerShell profile.

$global:DotfilesHome = Join-Path $HOME "dotfiles"
$env:STARSHIP_CONFIG = Join-Path $global:DotfilesHome "terminal/starship/theme/starship.toml"

try {
	[Console]::InputEncoding = [System.Text.UTF8Encoding]::new()
	[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
} catch {
}

if (Get-Module -ListAvailable -Name PSReadLine) {
	Import-Module PSReadLine -ErrorAction SilentlyContinue
	Set-PSReadLineOption -EditMode Windows -ErrorAction SilentlyContinue
	Set-PSReadLineOption -PredictionSource History -ErrorAction SilentlyContinue
}

Set-Alias ll Get-ChildItem -Option AllScope
Set-Alias la Get-ChildItem -Option AllScope

function Go-Dotfiles {
	Set-Location $global:DotfilesHome
}

function Use-WslZsh {
	if (Get-Command wsl.exe -ErrorAction SilentlyContinue) {
		wsl.exe -e zsh -l
		return
	}
	Write-Warning "WSL executable not found."
}

Set-Alias dfd Go-Dotfiles -Option AllScope
Set-Alias wslz Use-WslZsh -Option AllScope

if (Get-Command starship -ErrorAction SilentlyContinue) {
	Invoke-Expression (& starship init powershell)
} else {
	function prompt {
		$current = (Get-Location).Path
		return "PS $current`n> "
	}
}
