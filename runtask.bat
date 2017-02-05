@echo off & setlocal EnableDelayedExpansion

::Comprobamos si había tasks antiguas, las borramos

for /f %%x in ('schtasks /query ^| findstr Ikillnukes') do schtasks /Delete /TN %%x /F

::Obtenemos los archivos en cuestión & Obtenemos la fecha de creación de cada archivo en cuestión

FOR /F "usebackq tokens=*" %%a in (
 "folders.txt"
) do (

 	set "creationDate=%%~ta"
 	set "fileline=%%a"
 	set "folderpath=%%a"
 	set "day=!creationDate:~0,2!"
 	set "month=!creationDate:~3,2!"
 	set "year=!creationDate:~6,4!"

 	if "%fileline:~-1%" == "\" ( set "fileline=%fileline:~0,-1%" )

	for %%f in (%fileline%) do set filename=%%~nxf

 	::Establecemos de nuevo la nueva task

	schtasks /CREATE /D (%day% - 1) /M (%month% + 1) /TN "Ikillnukes StarReset for %filename%" /TR "runas.exe /env /user:administrator %ProgramFiles%\Lerp2Dev\Ikillnukes\StarReset\runtask.bat"

	::Ejecutamos la guinda del pastel (borrar los archivos)

	del /f /q "%folderpath%\License.sig"
	del /f /q "%folderpath%\Cache.dat"

	:: Mostramos una alerta diciendo que todo ha ido bien

	if not exist alert.vbs 
	(
		echo "WScript.Echo WScript.Arguments(0)" > alert.vbs
	)

	set msg="""The following program have autorenew it license:"" & vbCrLf & vbCrLf & ""%folderpath%"" & vbCrLf & vbCrLf & ""Now, you can execute it, and resend your mail."""

	wscript alert.vbs "%msg%"

)