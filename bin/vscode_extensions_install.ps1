#!/usr/bin/env pwsh
[CmdletBinding()]
param(
	[Parameter(ValueFromRemainingArguments = $true)]
	[string[]]$ScriptArgs
)

$scriptPath = Join-Path $PSScriptRoot "vscode_extensions_install.py"

$pyenv = Get-Command pyenv -ErrorAction SilentlyContinue
if ($pyenv) {
	& pyenv exec python $scriptPath @ScriptArgs
	exit $LASTEXITCODE
}

Write-Error "pyenv nao encontrado. Configure o pyenv para executar os scripts Python deste repositorio."
exit 1
