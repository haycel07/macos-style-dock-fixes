param([Parameter(Mandatory=$true)][string]$WindhawkDir)
$ErrorActionPreference='Stop'
$app=(Resolve-Path -LiteralPath $WindhawkDir).Path
$exe=Join-Path $app 'windhawk.exe'
$backup=Join-Path $app 'AppData\MacDockFixesBackup'
$state=Get-Content (Join-Path $backup 'state.json') -Raw|ConvertFrom-Json
$config=Join-Path $app 'AppData\Engine\Mods\macos-style-dock.ini'
$source=Join-Path $app 'AppData\ModsSource\macos-style-dock.wh.cpp'
Start-Process $exe -ArgumentList @('-exit','-wait') -WindowStyle Hidden -Wait
try {
 if($state.HadConfig){Copy-Item (Join-Path $backup 'module.ini') $config -Force}
 elseif(Test-Path $config){(Get-Content $config -Raw) -replace '(?m)^Disabled=0\r?$','Disabled=1'|Set-Content $config -Encoding unicode}
 if($state.HadSource){Copy-Item (Join-Path $backup 'module.wh.cpp') $source -Force}
} finally {Start-Process $exe -ArgumentList '-tray-only' -WindowStyle Hidden}
Write-Output 'Previous module state restored. Backups and DLL files were retained.'
