param(
    [string]$ArchivePath,
    [string]$InstallDirectory = (Join-Path $PSScriptRoot '.runtime')
)

$ErrorActionPreference = 'Stop'
if ($env:OS -ne 'Windows_NT' -or -not [Environment]::Is64BitOperatingSystem) {
    throw 'This package requires Windows x64. ARM64 is not supported.'
}
$nativeArchitecture = Get-ItemPropertyValue -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name PROCESSOR_ARCHITECTURE
if ($nativeArchitecture -ne 'AMD64') { throw 'This package requires Windows x64. ARM64 is not supported.' }
$upstream = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'upstream.json') -Raw | ConvertFrom-Json
$binaryDirectory = Join-Path $InstallDirectory ($upstream.directory + '\x86_64')
$executable = Join-Path $binaryDirectory 'goodbyedpi.exe'

if (-not (Test-Path -LiteralPath $executable -PathType Leaf)) {
    $downloadedArchive = $null
    try {
        if (-not $ArchivePath) {
            $downloadedArchive = Join-Path ([IO.Path]::GetTempPath()) ('steam-store-fix-' + [guid]::NewGuid().ToString('N') + '.zip')
            $ArchivePath = $downloadedArchive
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            Write-Host ('Downloading official GoodbyeDPI ' + $upstream.version + '...')
            Invoke-WebRequest -UseBasicParsing -Uri $upstream.archiveUrl -OutFile $ArchivePath
        }
        if ((Get-FileHash -LiteralPath $ArchivePath -Algorithm SHA256).Hash -ne $upstream.archiveSha256) {
            throw 'SHA256 mismatch: the downloaded archive is not the pinned official package. Installation stopped.'
        }
        Expand-Archive -LiteralPath $ArchivePath -DestinationPath $InstallDirectory -Force
    }
    finally {
        if ($downloadedArchive -and (Test-Path -LiteralPath $downloadedArchive)) {
            Remove-Item -LiteralPath $downloadedArchive -Force
        }
    }
}

foreach ($file in $upstream.files.PSObject.Properties) {
    $filePath = Join-Path $binaryDirectory $file.Name
    if (-not (Test-Path -LiteralPath $filePath -PathType Leaf) -or
        (Get-FileHash -LiteralPath $filePath -Algorithm SHA256).Hash -ne $file.Value) {
        throw ('Runtime integrity check failed: ' + $file.Name + '. Stop the helper, remove .runtime, and run setup again.')
    }
}
$driverSignature = Get-AuthenticodeSignature -LiteralPath (Join-Path $binaryDirectory 'WinDivert64.sys')
if ($driverSignature.Status -ne 'Valid') {
    throw ('WinDivert driver signature verification failed: ' + $driverSignature.Status)
}

return $executable
