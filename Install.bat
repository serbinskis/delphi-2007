@echo off
pushd %~dp0

title Downloading - Delphi 2007
md "%TEMP%\Delphi2007"
cd "%TEMP%\Delphi2007"
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/serbinskis/delphi-2007/raw/refs/heads/master/Archive/Delphi2007.7z.001', 'Delphi2007.7z.001')"
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/serbinskis/delphi-2007/raw/refs/heads/master/Archive/Delphi2007.7z.002', 'Delphi2007.7z.002')"
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/serbinskis/delphi-2007/raw/refs/heads/master/Archive/Delphi2007.7z.003', 'Delphi2007.7z.003')"

title Extracting - Delphi 2007
powershell -Command "Invoke-WebRequest -Uri 'https://www.7-zip.org/a/7za920.zip' -OutFile '7za920.zip'"
powershell -Command "Expand-Archive -Path '7za920.zip' -DestinationPath '.'" -ErrorAction SilentlyContinue"
7za x Delphi2007.7z.001 -aoa >nul
del /s /q Delphi2007.7z.* >nul

title Patching - Delphi 2007
md "%USERPROFILE%\.borland"
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/serbinskis/delphi-2007/raw/refs/heads/master/Crack/SETUP.EXE' -OutFile 'ib6.5\SETUP.EXE'"
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/serbinskis/delphi-2007/raw/refs/heads/master/Crack/SETUP.EXE' -OutFile 'Info\Extras\jre1-2-2.exe'"
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/serbinskis/delphi-2007/raw/refs/heads/master/Crack/SETUP.EXE' -OutFile 'Info\Extras\visibroker45\Setup.exe'"
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/serbinskis/delphi-2007/raw/refs/heads/master/Crack/registry.slm' -OutFile \"$env:USERPROFILE\\.borland\\registry.slm\""

title Installing - Delphi 2007
msiexec /i "Install\Borland Delphi 7.msi" /qr PRODUCT_ID=EV8X-73899F-BD3Y8K-ZS8X AUTH_KEY=673-KP8
cd "%TEMP%" & rd /s /q "%TEMP%\Delphi2007"

title Configuring - Delphi 2007
rename "%SystemDrive%\Program Files (x86)\Borland\Delphi7" "Delphi 7"
move /Y "%SystemDrive%\Program Files (x86)\Common Files\Borland Shared" "%SystemDrive%\Program Files (x86)\Borland\Delphi 7" >nul
compact /C /S:"%SystemDrive%\Program Files (x86)\Borland\Delphi 7" /I /Q >nul

title Extending - Delphi 2007
md "%SystemDrive%\Program Files (x86)\Borland\Delphi 7\Addons"
cd "%SystemDrive%\Program Files (x86)\Borland\Delphi 7\Addons"
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/serbinskis/delphi-addons/archive/refs/heads/master.zip', 'Addons.zip')"
powershell -Command "Expand-Archive -Path 'Addons.zip' -DestinationPath '.'" -ErrorAction SilentlyContinue"
powershell -Command "Get-ChildItem -Directory | ForEach-Object { Get-ChildItem -Path $_.Name | Move-Item -Destination '.'; Remove-Item -Path $_.Name -Recurse -Force }"
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/serbinskis/delphi-2007/raw/refs/heads/master/Crack/Bpl.zip', '..\Projects\Bpl.zip')"
powershell -Command "Expand-Archive -Path '..\Projects\Bpl.zip' -DestinationPath '..\Projects\' -ErrorAction SilentlyContinue"
del ..\Projects\Bpl.zip >nul
del Addons.zip >nul

title Ownershiping - Delphi 2007
set "dest=%SystemDrive%\Program Files (x86)\Borland"
takeown.exe /F "%dest%" /R /D Y >nul & icacls.exe "%dest%" /grant Everyone:F /T >nul

title Fixing Shortcuts - Delphi 2007
cd "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\Borland Delphi 7"
powershell -Command "$shell = New-Object -ComObject WScript.Shell; Get-ChildItem -Path '.' -Recurse -Include *.lnk | ForEach-Object { $shortcut = $shell.CreateShortcut($_.FullName); $targetPath = $shortcut.TargetPath; $workingDirectory = $shortcut.WorkingDirectory; if ($targetPath -like '*Delphi7*') { $shortcut.TargetPath = $targetPath -replace 'Delphi7', 'Delphi 7'; $shortcut.Save(); Write-Host 'Updated shortcut: ' $_.FullName }; if ($workingDirectory -like '*Delphi7*') { $shortcut.WorkingDirectory = $workingDirectory -replace 'Delphi7', 'Delphi 7'; $shortcut.Save() } }; [Runtime.InteropServices.Marshal]::ReleaseComObject($shell) | Out-Null"

title Registerying - Delphi 2007
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/serbinskis/delphi-2007/raw/refs/heads/master/Crack/Borland.reg' -OutFile '%temp%\Borland.reg'"
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/serbinskis/delphi-2007/raw/refs/heads/master/Crack/Classes.reg' -OutFile '%temp%\Classes.reg'"
reg import "%temp%\Borland.reg"
reg import "%temp%\Classes.reg"
del "%temp%\Borland.reg"
del "%temp%\Classes.reg"

title Updating Path - Delphi 2007
powershell -Command "$envPath = [Environment]::GetEnvironmentVariable('Path', 'Machine'); $newPath = ($envPath -split ';' | Where-Object { $_ -notmatch 'Borland\\Delphi7' }) -join ';'; [Environment]::SetEnvironmentVariable('Path', $newPath, 'Machine')"
set "dest=%SystemDrive%\Program Files (x86)\Borland\Delphi 7\bin"
powershell -Command "$path = '%dest%'; $envPath = [Environment]::GetEnvironmentVariable('Path', 'Machine'); if ($envPath -notlike '*'+$path+'*') { [Environment]::SetEnvironmentVariable('Path', $envPath+';'+$path, 'Machine') }"
set "dest=%SystemDrive%\Program Files (x86)\Borland\Delphi 7\Projects\Bpl\"
powershell -Command "$path = '%dest%'; $envPath = [Environment]::GetEnvironmentVariable('Path', 'Machine'); if ($envPath -notlike '*'+$path+'*') { [Environment]::SetEnvironmentVariable('Path', $envPath+';'+$path, 'Machine') }"
