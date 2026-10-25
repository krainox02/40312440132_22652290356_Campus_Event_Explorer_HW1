param([string]$Device = 'web-server')
$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot
$flutterPath = Join-Path $env:USERPROFILE '.cache\tooling\flutter-3.47.6\flutter\bin\flutter.bat'
if (-not (Test-Path -LiteralPath $flutterPath)) {
    $flutterCommand = Get-Command flutter -ErrorAction SilentlyContinue
    if ($flutterCommand) {
        $flutterPath = $flutterCommand.Source
    } else {
        $flutterPath = Join-Path $env:TEMP 'hw1-tooling\flutter\bin\flutter.bat'
    }
}
if (-not (Test-Path -LiteralPath $flutterPath)) {
    throw 'Install Flutter 3.47.6 Stable and add flutter/bin to PATH. See README.md.'
}
$versionOutput = (& $flutterPath --version --machine) -join "`n"
if ($LASTEXITCODE -ne 0) { throw 'Flutter initialization failed. See the output above.' }
$jsonStart = $versionOutput.IndexOf('{')
if ($jsonStart -lt 0) { throw 'Flutter did not return version information.' }
$version = $versionOutput.Substring($jsonStart) | ConvertFrom-Json
if ($version.frameworkVersion -ne '3.47.6' -or $version.channel -ne 'stable') {
    throw 'This assignment requires Flutter 3.47.6 on the Stable channel.'
}
& $flutterPath --no-version-check pub get
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
if ($Device -eq 'web-server') {
    Write-Host 'After the build finishes, open http://127.0.0.1:8766 in Chrome.'
    Write-Host 'Keep this window open while using the application.'
    & $flutterPath --no-version-check run -d web-server --release --web-hostname 127.0.0.1 --web-port 8766
} else {
    & $flutterPath --no-version-check run -d $Device
}
exit $LASTEXITCODE
