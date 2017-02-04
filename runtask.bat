@echo off

::Comprobamos si había tasks antiguas, las borramos



::Borramos los archivos



::Obtenemos los archivos en cuestión



::Obtenemos la fecha de creación de cada archivo en cuestión



::Establecemos de nuevo la nueva task

schtasks /CREATE "" /TN "Ikillnukes StarReset" /TR "runas.exe /env /user:domain\Administrator %ProgramFiles%\Lerp2Dev\Ikillnukes\StarReset\runtask.bat"

::Ejecutamos la guinda del pastel



::Al terminar, deberíamos ejecutar los programas a los que se les ha hecho referencia



pause