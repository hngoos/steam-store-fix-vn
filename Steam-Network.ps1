param([switch]$Stop)

$ErrorActionPreference = 'Stop'
try {
    $upstream = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'upstream.json') -Raw | ConvertFrom-Json
    $executable = Join-Path $PSScriptRoot ('.runtime\' + $upstream.directory + '\x86_64\goodbyedpi.exe')
    if (-not $Stop) {
        $executable = & (Join-Path $PSScriptRoot 'Install-GoodbyeDPI.ps1')
    }

    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]$identity
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        $arguments = '-NoProfile -ExecutionPolicy Bypass -File "' + $PSCommandPath + '"'
        if ($Stop) { $arguments += ' -Stop' }
        $administrator = Start-Process -FilePath "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" -ArgumentList $arguments -Verb RunAs -WindowStyle Hidden -Wait -PassThru
        if ($administrator.ExitCode -ne 0) { throw 'Administrator helper failed. See logs, or run Steam-Network.ps1 from an Administrator PowerShell window to see the error.' }
        if ($Stop) { Write-Host 'This copy of the Steam network helper is stopped.' }
        else { Write-Host 'Steam network helper is ready. Refresh the Store with Ctrl+R.' }
        exit 0
    }

    $allInstances = @(Get-CimInstance Win32_Process -Filter "Name='goodbyedpi.exe'")
    $ownInstances = @($allInstances | Where-Object { $_.ExecutablePath -eq $executable })
    if ($Stop) {
        foreach ($instance in $ownInstances) { Stop-Process -Id $instance.ProcessId -ErrorAction Stop }
        exit 0
    }
    if ($ownInstances.Count -gt 0) { exit 0 }
    if ($allInstances.Count -gt 0) { throw 'Another copy of GoodbyeDPI is running. Stop that copy before starting this one.' }

    $logDirectory = Join-Path $PSScriptRoot 'logs'
    New-Item -ItemType Directory -Path $logDirectory -Force | Out-Null
    $domains = Join-Path $PSScriptRoot 'steam-domains.txt'
    $arguments = '-5 --blacklist "' + $domains + '" --max-payload 0'
    $process = Start-Process -FilePath $executable -ArgumentList $arguments -WorkingDirectory (Split-Path $executable) -WindowStyle Hidden -RedirectStandardOutput (Join-Path $logDirectory 'goodbyedpi.log') -RedirectStandardError (Join-Path $logDirectory 'goodbyedpi-error.log') -PassThru
    Start-Sleep -Milliseconds 700
    $process.Refresh()
    if ($process.HasExited) { throw ('GoodbyeDPI exited during startup with code ' + $process.ExitCode + '. See logs.') }
}
catch {
    Write-Error -Message $_.Exception.Message -ErrorAction Continue
    exit 1
}
