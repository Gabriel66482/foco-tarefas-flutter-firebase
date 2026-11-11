param([Parameter(ValueFromRemainingArguments = $true)][string[]]$FlutterArgs)
$ErrorActionPreference = 'Stop'
$projectPath = Split-Path $PSScriptRoot -Parent
$localJava = Join-Path $projectPath '..\..\work\jdk\jdk-21.0.13+9'
$localAndroid = Join-Path $projectPath '..\..\work\android-sdk'
if (Test-Path -LiteralPath $localJava) { $env:JAVA_HOME = (Resolve-Path $localJava).Path }
if (Test-Path -LiteralPath $localAndroid) { $env:ANDROID_HOME = (Resolve-Path $localAndroid).Path }
$bundledSdk = Join-Path $projectPath '..\..\work\flutter\bin\flutter.bat'
$flutterCommand = Get-Command flutter -ErrorAction SilentlyContinue
if ($flutterCommand) { $executable = $flutterCommand.Source }
elseif (Test-Path -LiteralPath $bundledSdk) { $executable = (Resolve-Path $bundledSdk).Path }
else { throw 'Flutter não encontrado. Instale o SDK e adicione flutter/bin ao PATH.' }
Push-Location $projectPath
try { & $executable @FlutterArgs; if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE } }
finally { Pop-Location }
