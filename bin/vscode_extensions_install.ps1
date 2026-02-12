#!/usr/bin/env pwsh
[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$ScriptArgs
)

$scriptPath = Join-Path $PSScriptRoot "vscode_extensions_install.py"

$py = Get-Command py -ErrorAction SilentlyContinue
if ($py) {
    & py -3 $scriptPath @ScriptArgs
    exit $LASTEXITCODE
}

$python = Get-Command python -ErrorAction SilentlyContinue
if ($python) {
    & python $scriptPath @ScriptArgs
    exit $LASTEXITCODE
}

Write-Error "Python nao encontrado. Instale Python 3 e tente novamente."
exit 1
