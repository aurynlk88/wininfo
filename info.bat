@echo off

@echo HOSTNAME
for /f "tokens=2 delims==" %%G in ('wmic computersystem get name /value ^| findstr /c:"=" ^| findstr /v /c:"Caption"') do set "hostname=%%G"
echo %hostname%
echo.

@echo MODELO
for /f "tokens=2 delims==" %%G in ('wmic computersystem get model /value ^| findstr /c:"=" ^| findstr /v /c:"Caption"') do set "model=%%G"
echo %model%
echo.


@echo NUMERO DE SERIE
for /f "tokens=2 delims==" %%G in ('wmic bios get serialnumber /value ^| findstr /c:"=" ^| findstr /v /c:"Caption"') do set "serial=%%G"
echo %serial%
echo.


@echo CPU
for /f "tokens=2 delims==" %%G in ('wmic cpu get name /value ^| findstr /c:"=" ^| findstr /v /c:"Caption"') do set "CPUName=%%G"
echo %CPUName%
echo.


@echo RAM (GB)
powershell.exe -command "$totalMemory = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb; '{0:N2}' -f $totalMemory"
echo.

@echo|set /p="DISCO (GB)"
echo.
powershell.exe -command "Get-WmiObject -Class Win32_LogicalDisk -ComputerName LOCALHOST | ? {$_.DriveType -eq 3} | ForEach-Object { '{0}{1}{2}' -f $_.DeviceID, ' ', ([math]::Round($_.Size/1GB, 2)).ToString() } | Out-String -Stream | ForEach-Object { $_ -replace '\r\n', '`n' }"
echo.

@echo|set /p="GPU"
echo.
powershell.exe -command "Get-WmiObject -Class Win32_VideoController | ForEach-Object { '{0}{1}' -f $_.Name, ' ' + [math]::Round($_.AdapterRAM / 1GB, 2),'GB' } | Out-String -Stream | ForEach-Object { $_ -replace '\r\n', '' }"
echo.

@echo S.O.
powershell.exe -command "Get-CimInstance Win32_OperatingSystem | select -ExpandProperty Caption"
echo.

@echo EDAD DEL EQUIPO
powershell.exe -command "(Get-WmiObject -Class Win32_BIOS).ReleaseDate.Substring(0, 4)"
echo.

@echo ANYDESK ID
for /f "delims=" %%i in ('"C:\Program Files (x86)\AnyDesk\AnyDesk.exe" --get-id') do set ID=%%i 
echo %ID%


pause>nul