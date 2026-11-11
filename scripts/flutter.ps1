param([Parameter(ValueFromRemainingArguments = $true)][string[]]$FlutterArgs)
$ErrorActionPreference = 'Stop'
$projectPath = Split-Path $PSScriptRoot -Parent
$bundledSdk = Join-Path $projectPath '..\..\work\flutter\bin\flutter.bat'
$flutterCommand = Get-Command flutter -ErrorAction SilentlyContinue
if ($flutterCommand) { $executable = $flutterCommand.Source }
elseif (Test-Path -LiteralPath $bundledSdk) { $executable = (Resolve-Path $bundledSdk).Path }
else { throw 'Flutter não encontrado. Instale o SDK e adicione flutter/bin ao PATH.' }
Push-Location $projectPath
try { & $executable @FlutterArgs; if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE } }
finally { Pop-Location }
