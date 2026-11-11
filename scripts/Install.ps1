param([Parameter(Mandatory=$true)][string]$WindhawkDir)
$ErrorActionPreference='Stop'
$app=(Resolve-Path -LiteralPath $WindhawkDir).Path
$root=Split-Path $PSScriptRoot -Parent
$exe=Join-Path $app 'windhawk.exe'
$storage=Join-Path $app 'windhawk.ini'
if (!(Test-Path $exe) -or !(Test-Path $storage)) {throw 'Select a Windhawk portable directory.'}
$storageText=Get-Content $storage -Raw
if ($storageText -notmatch '(?m)^Portable=1\s*$' -or $storageText -notmatch '(?m)^AppDataPath=AppData\s*$') {throw 'Only the standard Windhawk portable layout is supported.'}
$file='macos-style-dock_1.0-local.4.dll'
$dll=Join-Path $root "bin\$file"
$expected=(Get-Content (Join-Path $root 'SHA256SUMS.txt')|Where-Object {$_ -match "  bin/$([regex]::Escape($file))$"}) -replace '  .*',''
if (!$expected -or (Get-FileHash $dll -Algorithm SHA256).Hash -ne $expected) {throw 'DLL checksum mismatch.'}
$mods=Join-Path $app 'AppData\Engine\Mods'
$sourceDir=Join-Path $app 'AppData\ModsSource'
$backup=Join-Path $app 'AppData\MacDockFixesBackup'
$config=Join-Path $mods 'macos-style-dock.ini'
$source=Join-Path $sourceDir 'macos-style-dock.wh.cpp'
New-Item -ItemType Directory -Path $mods,$sourceDir,(Join-Path $mods '64') -Force|Out-Null
if (!(Test-Path $backup)) {
 New-Item -ItemType Directory -Path $backup|Out-Null
 @{HadConfig=(Test-Path $config);HadSource=(Test-Path $source)}|ConvertTo-Json|Set-Content (Join-Path $backup 'state.json') -Encoding utf8
 if(Test-Path $config){Copy-Item $config (Join-Path $backup 'module.ini')}
 if(Test-Path $source){Copy-Item $source (Join-Path $backup 'module.wh.cpp')}
}
Start-Process $exe -ArgumentList @('-exit','-wait') -WindowStyle Hidden -Wait
try {
 Copy-Item $dll (Join-Path $mods "64\$file") -Force
 foreach($pair in @(@('libc++.dll','libc++.whl'),@('libunwind.dll','libunwind.whl'),@('windhawk-mod-shim.dll','windhawk-mod-shim.dll'))){
  Copy-Item (Join-Path $app "Compiler\x86_64-w64-mingw32\bin\$($pair[0])") (Join-Path $mods "64\$($pair[1])") -Force
 }
 $text=Get-Content (Join-Path $root 'presets\macos-style-dock.ini') -Raw
 $text=$text -replace 'SettingsChangeTime=\d+',('SettingsChangeTime='+[DateTimeOffset]::UtcNow.ToUnixTimeSeconds())
 Set-Content $config $text -Encoding unicode
 Copy-Item (Join-Path $root 'src\macos-style-dock.wh.cpp') $source -Force
} finally {Start-Process $exe -ArgumentList '-tray-only' -WindowStyle Hidden}
Write-Output 'Installed 1.0-local.4. Restore.ps1 restores the previous module state.'
