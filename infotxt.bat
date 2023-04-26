@echo off

SET output=sysInfo.txt

@echo HOSTNAME >> %output%
for /f "tokens=2 delims==" %%G in ('wmic computersystem get name /value ^| findstr /c:"=" ^| findstr /v /c:"Caption"') do set "hostname=%%G"
echo %hostname% >> %output%
echo. >> %output%

@echo MODELO >> %output%
for /f "tokens=2 delims==" %%G in ('wmic computersystem get model /value ^| findstr /c:"=" ^| findstr /v /c:"Caption"') do set "model=%%G"
echo %model% >> %output%
echo. >> %output%

@echo NUMERO DE SERIE >> %output%
for /f "tokens=2 delims==" %%G in ('wmic bios get serialnumber /value ^| findstr /c:"=" ^| findstr /v /c:"Caption"') do set "serial=%%G"
echo %serial% >> %output%
echo. >> %output%

@echo CPU >> %output%
for /f "tokens=2 delims==" %%G in ('wmic cpu get name /value ^| findstr /c:"=" ^| findstr /v /c:"Caption"') do set "CPUName=%%G"
echo %CPUName% >> %output%
echo. >> %output%

@echo RAM (GB) >> %output%
powershell.exe -command "$totalMemory = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb; '{0:N2}' -f $totalMemory" >> %output%
echo. >> %output%

@echo|set /p="DISCO (GB)" >> %output%
echo. >> %output%
powershell.exe -command "Get-WmiObject -Class Win32_LogicalDisk -ComputerName LOCALHOST | ? {$_.DriveType -eq 3} | ForEach-Object { '{0}{1}{2}' -f $_.DeviceID, ' ', ([math]::Round($_.Size/1GB, 2)).ToString() } | Out-String -Stream | ForEach-Object { $_ -replace '\r\n', '`n' }" >> %output%
echo. >> %output%

@echo|set /p="GPU" >> %output%
echo. >> %output%
powershell.exe -command "Get-WmiObject -Class Win32_VideoController | ForEach-Object { '{0}{1}' -f $_.Name, ' ' + [math]::Round($_.AdapterRAM / 1GB, 2),'GB' } | Out-String -Stream | ForEach-Object { $_ -replace '\r\n', '' }" >> %output%
echo. >> %output%

@echo S.O. >> %output%
powershell.exe -command "Get-CimInstance Win32_OperatingSystem | select -ExpandProperty Caption" >> %output%
echo. >> %output%

@echo EDAD DEL EQUIPO >> %output%
powershell.exe -command "(Get-WmiObject -Class Win32_BIOS).ReleaseDate.Substring(0, 4)" >> %output%
echo. >> %output%

@echo ANYDESK ID >> %output%
for /f "delims=" %%i in ('"C:\Program Files (x86)\AnyDesk\AnyDesk.exe" --get-id') do set ID=%%i 
echo %ID% >> %output%