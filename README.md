<p align="center">
  <img src="docs/assets/steam-store-fix-wordmark.svg" width="740" alt="Steam Store Fix VN">
</p>

**Steam Store Fix VN** is a Windows launcher for GoodbyeDPI that helps resolve Steam Store connection resets and incomplete page loading. It applies a configuration scoped to Steam domains without requiring a VPN.

<p align="center">
  <a href="https://github.com/hngoos/steam-store-fix-vn/releases/latest"><img src="docs/assets/install-windows.svg" width="260" alt="Download Steam Store Fix VN for Windows"></a>
</p>

## Features

- **Steam domain filtering:** HTTP/TLS adjustments apply to the listed Steam domains and their subdomains.
- **Start and stop controls:** included launchers handle the required Administrator prompt and run the helper in the background.
- **Verified dependencies:** downloads a pinned official GoodbyeDPI release and verifies archive and binary SHA256 hashes, along with the WinDivert driver signature.
- **On-demand operation:** runs when started, with local logs for troubleshooting and no automatic startup.
- **Preserved settings:** Windows DNS and proxy settings, Steam configuration, and game files remain unchanged.

## Requirements

- Windows 10 or Windows 11, x64.
- Windows PowerShell 5.1.
- Administrator privileges to run the WinDivert driver.
- Access to GitHub for the initial dependency download.

Windows ARM64, 32-bit Windows, macOS, and Linux are not supported.

## Getting started

1. Download the ZIP package from the [latest release](https://github.com/hngoos/steam-store-fix-vn/releases/latest).
2. Extract the archive and run **`Start-Steam-Network.cmd`**.
3. Approve the Windows Administrator prompt. Dependencies are downloaded and verified automatically on first launch.
4. Open the Steam Store and press **Ctrl + R** to reload the page.

Keep the extracted files together. Stop any other GoodbyeDPI instance before starting the helper. Run the Start launcher again after restarting Windows.

### Stopping and removing

- **Stop:** run **`Stop-Steam-Network.cmd`** and approve the Administrator prompt. The launcher stops the helper associated with that installation.
- **Remove:** stop the helper, then delete the extracted files.

## Supported use cases

- Steam reports **Error Code: -101** or **Unable to connect to server**.
- Store pages load partially, with missing navigation or search controls.
- Steam stylesheets, scripts, images, or API requests fail to load.
- Steam works on another network but fails on the current connection.

These symptoms can have several causes. This utility targets connection interference on the network path; it does not resolve Steam outages, account issues, or a loss of internet connectivity. Results depend on the network and its filtering behavior.

## How it works

The launcher runs [GoodbyeDPI](https://github.com/ValdikSS/GoodbyeDPI) with the following configuration:

```text
-5 --blacklist steam-domains.txt --max-payload 0
```

WinDivert processes packets locally while the helper is running. Filtering is scoped by domain rather than process, so other applications connecting to the same Steam domains are also within scope.

Dependencies are downloaded from the official upstream release into `.runtime/`. The pinned GoodbyeDPI build is an upstream release candidate. Its version, download URL, and expected hashes are recorded in [upstream.json](upstream.json).

## Troubleshooting

If the Store still loads incorrectly, confirm that `goodbyedpi.exe` is running, reload the page, and review the files in `logs/`. A successful launch alone does not confirm that all Steam connections are working.

For additional guidance, see the [troubleshooting guide](docs/TROUBLESHOOTING.md). When [reporting an issue](https://github.com/hngoos/steam-store-fix-vn/issues/new), include the Windows version, network provider, and relevant error messages. Remove account details and authentication data before sharing logs or screenshots.

## Development

Package verification runs on Windows through GitHub Actions. To run the checks locally:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tests\Verify-Package.ps1
```

The checks verify package integrity and installation behavior without loading the network driver. See the [development guide](docs/DEVELOPMENT.md) and [changelog](CHANGELOG.md) for further details.

The troubleshooting and development guides are currently available in Vietnamese.

## Acknowledgments and license

Connection handling is provided by [GoodbyeDPI by ValdikSS](https://github.com/ValdikSS/GoodbyeDPI) and [WinDivert by basil00](https://github.com/basil00/WinDivert). Their licenses are documented in [Third-party notices](THIRD_PARTY_NOTICES.md).

The scripts in this repository are distributed under the [MIT License](LICENSE). This is an independent community project and is not affiliated with or endorsed by Valve.

## Contact

<p align="left">
  <a href="https://www.facebook.com/hngoos"><img src="docs/assets/contact-facebook.svg" width="40" height="40" alt="Facebook"></a>
  <a href="https://www.instagram.com/hngoos/"><img src="docs/assets/contact-instagram.svg" width="40" height="40" alt="Instagram"></a>
  <a href="mailto:1hngoos@gmail.com"><img src="docs/assets/contact-gmail.svg" width="40" height="40" alt="Email 1hngoos@gmail.com"></a>
  <a href="https://github.com/hngoos"><img src="docs/assets/contact-github.svg" width="40" height="40" alt="GitHub hngoos"></a>
</p>

[Report an issue](https://github.com/hngoos/steam-store-fix-vn/issues/new) · [License](LICENSE)
