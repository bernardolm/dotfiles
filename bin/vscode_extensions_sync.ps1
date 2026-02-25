#!/usr/bin/env pwsh
[CmdletBinding()]
param(
	[Parameter(ValueFromRemainingArguments = $true)]
	[string[]]$ScriptArgs
)

$scriptPath = Join-Path $PSScriptRoot "vscode_extensions_sync.py"

$pyenv = Get-Command pyenv -ErrorAction SilentlyContinue
if ($pyenv) {
	& pyenv exec python $scriptPath @ScriptArgs
	exit $LASTEXITCODE
}

Write-Error "pyenv not found. Configure pyenv to run this repository's Python scripts."
exit 1
