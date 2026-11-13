param([string]$ArchivePath)

$ErrorActionPreference = 'Stop'
$repository = Split-Path $PSScriptRoot
$installer = Join-Path $repository 'Install-GoodbyeDPI.ps1'
$temporaryRoot = Join-Path ([IO.Path]::GetTempPath()) ('steam-store-fix-tests-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $temporaryRoot | Out-Null
try {
    $invalidArchive = Join-Path $temporaryRoot 'modified.zip'
    Set-Content -LiteralPath $invalidArchive -Value 'This is not the official archive.' -Encoding ASCII
    $rejectedInstall = Join-Path $temporaryRoot 'rejected runtime'
    $failure = ''
    try { & $installer -ArchivePath $invalidArchive -InstallDirectory $rejectedInstall | Out-Null }
    catch { $failure = $_.Exception.Message }
    if ($failure -notmatch 'SHA256 mismatch') { throw "FAIL: a modified archive must fail SHA256 verification; got: $failure" }
    if (Test-Path -LiteralPath $rejectedInstall) { throw 'FAIL: an unverified archive created an installation.' }
    Write-Host 'PASS: modified downloads are rejected before extraction.'

    $upstream = Get-Content -LiteralPath (Join-Path $repository 'upstream.json') -Raw | ConvertFrom-Json
    if (-not $ArchivePath) {
        $ArchivePath = Join-Path $temporaryRoot 'official.zip'
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -UseBasicParsing -Uri $upstream.archiveUrl -OutFile $ArchivePath
    }
    $installDirectory = Join-Path $temporaryRoot 'runtime with spaces'
    $executable = & $installer -ArchivePath $ArchivePath -InstallDirectory $installDirectory
    if (-not (Test-Path -LiteralPath $executable -PathType Leaf)) { throw 'FAIL: official archive did not install an executable.' }
    Write-Host 'PASS: official package installs in a path containing spaces.'

    $originalWriteTime = (Get-Item -LiteralPath $executable).LastWriteTimeUtc
    $secondExecutable = & $installer -InstallDirectory $installDirectory
    if ($secondExecutable -ne $executable -or (Get-Item -LiteralPath $executable).LastWriteTimeUtc -ne $originalWriteTime) {
        throw 'FAIL: repeated setup should reuse the verified installation.'
    }
    Write-Host 'PASS: repeated setup reuses the verified runtime.'

    [IO.File]::AppendAllText($executable, 'tampered')
    $failure = ''
    try { & $installer -InstallDirectory $installDirectory | Out-Null }
    catch { $failure = $_.Exception.Message }
    if ($failure -notmatch 'Runtime integrity check failed') { throw "FAIL: an altered executable must be rejected; got: $failure" }
    Write-Host 'PASS: altered installed executables are rejected.'
}
finally {
    $resolvedRoot = [IO.Path]::GetFullPath($temporaryRoot)
    $expectedPrefix = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\') + '\steam-store-fix-tests-'
    if (-not $resolvedRoot.StartsWith($expectedPrefix, [StringComparison]::OrdinalIgnoreCase)) { throw 'Refusing cleanup outside the test temporary directory.' }
    Remove-Item -LiteralPath $resolvedRoot -Recurse -Force
}
