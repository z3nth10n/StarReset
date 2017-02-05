::@echo off
::for /f "usebackq tokens=*" %%A in ("folders.txt") do call :modf "%%A"
@Echo Off & SetLocal EnableDelayedExpansion

FOR /F "usebackq tokens=*" %%# in (
 "folders.txt"
) Do (
 Set "creationDate=%%~t#"
 set "day=!creationDate:~0,2!"
 set "month=!creationDate:~3,2!"
 set "year=!creationDate:~6,4!"

    Echo Date: "!year!!month!!day!"
)
pause
goto:EOF

:modf
set "target_dir=%~1"
set dir=%target_dir:\=\\%\\
set "data_path=%dir:~0,-2%"
::for /f %%f in ('wmic Datafile where "name='%data_path%'" get CreationDate') do if "%%f" NEQ "CreationDate" call :OUTPUT "%%f" "%target_dir%"

::wmic /OUTPUT:result.txt Datafile where "name='%data_path%'" get CreationDate ^| FIND "." /FORMAT:VALUE
::|more > hola.txt

goto:EOF

:OUTPUT
set "result=%~1"
set "date=%result:~0,8%"

::Aquí hay un error, por alguna razón se ejecuta 2 veces esto, ya he intentado arregarlo con condiciones sin suerte

echo File: %~2
echo.

IF "%result%" NEQ "" (

echo Creation Date: %date%
echo.

set "year=%date:~0,4%"
set "month=%date:~4,2%"
set "day=%date:~6,2%"

echo Year: %year%
echo Month: %month%
echo Day: %day%
echo.
pause

)

goto:EOF