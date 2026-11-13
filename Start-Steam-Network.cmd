@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Steam-Network.ps1"
if errorlevel 1 pause
