# Dotfiles PowerShell profile.

$global:DOTFILES = Join-Path $HOME "dotfiles"
$env:DOTFILES = $global:DOTFILES

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

if (Get-Command starship -ErrorAction SilentlyContinue) {
	Invoke-Expression (& starship init powershell)
} else {
	function prompt {
		$current = (Get-Location).Path
		return "PS $current`n> "
	}
}
