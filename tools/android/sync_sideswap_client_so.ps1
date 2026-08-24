# Workspace root = parent of tools/
$ErrorActionPreference = 'Stop'
$workspaceRoot = $PSScriptRoot | Split-Path -Parent | Split-Path -Parent
$rustRoot = Resolve-Path (Join-Path $workspaceRoot '..\sideswap_rust')

# Find Android SDK path from local.properties
$localProps = Get-Content (Join-Path $workspaceRoot 'android\local.properties') | Where-Object { $_ -match '^sdk\.dir=' }
$sdkDir = ($localProps -replace '^sdk\.dir=', '').Trim().Replace('\\', '\')

# Find latest installed NDK
$ndkBase = Join-Path $sdkDir 'ndk'
$ndkVersion = Get-ChildItem $ndkBase | Sort-Object Name -Descending | Select-Object -First 1 -ExpandProperty Name
$llvmBin = "$ndkBase\$ndkVersion\toolchains\llvm\prebuilt\windows-x86_64\bin"
Write-Host "Using NDK $ndkVersion"

$env:ANDROID_NDK_HOME = "$ndkBase\$ndkVersion"

$targets = @(
    @{ Rust = 'aarch64-linux-android';   Clang = 'aarch64-linux-android21-clang.cmd';   JniDir = 'arm64-v8a'   },
    @{ Rust = 'armv7-linux-androideabi'; Clang = 'armv7a-linux-androideabi21-clang.cmd'; JniDir = 'armeabi-v7a' },
    @{ Rust = 'i686-linux-android';      Clang = 'i686-linux-android21-clang.cmd';       JniDir = 'x86'         },
    @{ Rust = 'x86_64-linux-android';   Clang = 'x86_64-linux-android21-clang.cmd';     JniDir = 'x86_64'      }
)

Set-Location $rustRoot

# Ensure all Android targets are installed for the project toolchain
foreach ($t in $targets) {
    rustup target add $t.Rust
}

foreach ($t in $targets) {
    Write-Host "`nBuilding $($t.Rust)..."
    $rustUpper = $t.Rust.ToUpper().Replace('-', '_')
    $ccKey     = $t.Rust.Replace('-', '_')
    Set-Item -Path "env:CARGO_TARGET_${rustUpper}_LINKER" -Value "$llvmBin\$($t.Clang)"
    Set-Item -Path "env:CC_$ccKey"                        -Value "$llvmBin\$($t.Clang)"
    Set-Item -Path "env:AR_$ccKey"                        -Value "$llvmBin\llvm-ar.exe"

    cargo build -p sideswap_client --target $t.Rust
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    $dst = Join-Path $workspaceRoot "android\app\src\main\jniLibs\$($t.JniDir)"
    New-Item -ItemType Directory -Force -Path $dst | Out-Null
    $src = Join-Path (Get-Location) "target\$($t.Rust)\debug\libsideswap_client.so"
    Copy-Item -Force -LiteralPath $src -Destination (Join-Path $dst 'libsideswap_client.so')
    Write-Host "Copied .so to $dst"
}
