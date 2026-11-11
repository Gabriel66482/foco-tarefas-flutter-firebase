param([Parameter(ValueFromRemainingArguments = $true)][string[]]$FirebaseArgs)
$ErrorActionPreference = 'Stop'
$projectPath = Split-Path $PSScriptRoot -Parent
$localCli = Join-Path $projectPath 'node_modules\firebase-tools\lib\bin\firebase.js'
if (!(Test-Path -LiteralPath $localCli)) { throw 'Execute npm install ou pnpm install primeiro.' }
Push-Location $projectPath
try { node $localCli @FirebaseArgs; if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE } }
finally { Pop-Location }
