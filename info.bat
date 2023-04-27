@echo off
setlocal EnableDelayedExpansion

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


:: Información sobre el disco
:: Modelo, Memoria y Letra asignada
@echo RAM (GB)
powershell.exe -command "$totalMemory = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb; '{0:N2}' -f $totalMemory"
echo.


:: Información sobre el disco
:: Modelo, Memoria y Letra asignada
@echo|set /p="DISCO (GB)"
echo.

for /f "tokens=2 delims='='" %%a in ('wmic path win32_diskdrive get model /value') do set "name=%%a"
for /f "tokens=2 delims='='" %%b in ('wmic path win32_diskdrive get size /value') do set "size=%%b"
for /f "tokens=2 delims='='" %%c in ('powershell -command "Get-WmiObject Win32_DiskDrive | select -ExpandProperty DeviceID"') do set "letter=%%c"

for /f "usebackq tokens=1,2 delims=: " %%a in (`powershell -command "& {[int64]$a = %size%; if ($a -ge 1TB) { '{0:N2} TB' -f ($a/1TB) } elseif ($a -ge 1GB) { '{0:N2} GB' -f ($a/1GB) } else { '{0:N2} MB' -f ($a/1MB) } } "`) do set "cap=%%a" & set "unit=%%b"

echo %name%    %cap%%unit%    %letter%


echo.

:: Información sobre la GPU
:: Modelo y Memoria
@echo|set /p="GPU"
echo.

for /f "tokens=2 delims='='" %%a in ('wmic path win32_videocontroller get name /value') do set "name=%%a"
for /f "tokens=2 delims='='" %%b in ('wmic path win32_videocontroller get AdapterRAM /value') do set "ram=%%b"
for /f "usebackq tokens=1,2 delims=: " %%a in (`powershell -command "& {[int64]$a = %ram%; if ($a -ge 1GB) { '{0:N2} GB' -f ($a/1GB) } else { '{0:N2} MB' -f ($a/1MB) } } "`) do set "mem=%%a" & set "unit=%%b"
echo %name% %mem%%unit%
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
