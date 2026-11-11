$ErrorActionPreference = 'Stop'
$projectPath = Split-Path $PSScriptRoot -Parent
$localJava = Join-Path $projectPath '..\..\work\java\jdk-21.0.13+9-jre'
if (Test-Path -LiteralPath $localJava) {
  $env:JAVA_HOME = (Resolve-Path $localJava).Path
  $env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
}
$localCli = Join-Path $projectPath 'node_modules\firebase-tools\lib\bin\firebase.js'
$workCli = Join-Path $projectPath '..\..\work\node_modules\firebase-tools\lib\bin\firebase.js'
if (Test-Path $localCli) { $cli = $localCli }
elseif (Test-Path $workCli) { $cli = $workCli }
else { throw 'Execute npm install para instalar a CLI Firebase.' }
Push-Location $projectPath
try {
  node $cli emulators:start --project demo-foco-tarefas --import=.firebase-data --export-on-exit=.firebase-data
} finally { Pop-Location }
