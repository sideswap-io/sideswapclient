# Workspace root = parent of tools/
$ErrorActionPreference = 'Stop'
$workspaceRoot = $PSScriptRoot | Split-Path -Parent | Split-Path -Parent
$rustRoot = Resolve-Path (Join-Path $workspaceRoot '..\sideswap_rust')

Set-Location $rustRoot
cargo build -p sideswap_client
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$dst = Join-Path $workspaceRoot 'build\windows\x64\runner\Debug'
New-Item -ItemType Directory -Force -Path $dst | Out-Null
$src = Join-Path (Get-Location) 'target\debug\sideswap_client.dll'
Copy-Item -Force -LiteralPath $src -Destination (Join-Path $dst 'sideswap_client.dll')
Write-Host "Copied DLL to $dst"
