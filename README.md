## Install Delphi 2007

Run the command line as administrator and execute the code below to install Delphi 2007.

```sh
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/serbinskis/delphi-2007/refs/heads/master/Install.bat' -OutFile \"$env:TEMP\Install.bat\""
cmd.exe /c "%TEMP%\Install.bat"
powershell -Command "Remove-Item \"$env:TEMP\Install.bat\""
```