' Declaramos las variables

Dim folderName, folderSelected, stardockPath, installPath, appendFolders, originalPath ' Strings
Dim folderIndex, iter ' Ints

' Asignamos los objetos

Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")
Set oShell = CreateObject("Shell.Application")
Set folderDict = CreateObject("Scripting.Dictionary")
'Set req = CreateObject("Msxml2.XMLHttp.6.0")

' Asignamos las variables

stardockPath = EnvironmentCombine("%ALLUSERSPROFILE%", "Stardock")
installPath = EnvironmentCombine("%ProgramFiles%", "Lerp2Dev\Ikillnukes\StarReset")

originalPath = fso.GetParentFolderName(WScript.ScriptFullName)
folderIndex = 0
folderSelected = ""
appendFolders = ""

' Forzamos a que el script se ejecute como administrador

If Not CheckforElevation Then
	oShell.ShellExecute "cscript.exe", _
        Chr(34) & WScript.ScriptFullName & Chr(34), "", "runas", 1
	WScript.Quit
End If

' Forzamos a la ejecucción de cscript.exe

Sub forceCScriptExecution
    Dim Arg, Str
    If Not LCase( Right( WScript.FullName, 12 ) ) = "\cscript.exe" Then
        For Each Arg In WScript.Arguments
            If InStr( Arg, " " ) Then Arg = """" & Arg & """"
            Str = Str & " " & Arg
        Next
        CreateObject( "WScript.Shell" ).Run _
            "cscript //nologo """ & _
            WScript.ScriptFullName & _
            """ " & Str
        WScript.Quit
    End If
End Sub

forceCScriptExecution

' Comenzamos a mostrar el programa

echo "Welcome to the StarReset wizard, with this tool you can have FOREVER Stardock services, like Deskcapes."
echo "First we have to make some checks..."
echo ""

If (fso.FolderExists(stardockPath)) Then ' Comprobamos que el script exista
   	echo "Great! You have installed at least one service from Stardocks, now you have to select which of them do you want to have forever:"
   	Break

   	' Obtenemos todos los subdirectorios que hay en C:/ProgramData/Stardock
   	For Each objFolder In fso.GetFolder(stardockPath).SubFolders
   		folderName = Replace(objFolder.Path, stardockPath, "")
    	If (folderName <> "Registrations") Then
    		folderDict.Add folderIndex, objFolder.Path
    		folderIndex = folderIndex + 1
    		echo folderIndex & ".- " & folderName
    	End If
	Next
	Break
	echo "Now select which of this folder/s must be checked (ex: 1 3 6 8): "
	folderSelected = WScript.StdIn.Read(1)

	' Una vez que el usuario selecciona las carpetas para rastrear...
	If InStr(folderSelected, " ") > 0 Then
		For Each folderInd In Split(folderSelected)
			Dim i : i = CInt(folderSelected)
			If IsNumeric(folderInd) AND folderDict.Item(i - 1) Then
				appendFolders = appendFolders & vbCrLf & folderDict.Item(i - 1)
			End If
		Next
	Else
		Dim i : i = CInt(folderSelected)
		If IsNumeric(folderSelected) AND folderDict.Item(i - 1) <> "" Then
			appendFolders = folderDict.Item(i - 1)
		End If
	End If

	' ... se procesarán y se guardaran en un txt
	WriteAllText installPath & "\folders.txt", appendFolders

	' Copiamos los archivos a donde nos interesan, que será a %ProgramFiles%/Lerp2Dev/Ikillnukes/StarReset
	fso.CopyFile originalPath & "\folders.txt", installPath, True
	fso.CopyFile originalPath & "\runtask.bat", installPath, True

	' Ejecutamos el .bat que tiene la utilidad del schtasks
	oShell.ShellExecute "cmd.exe", "/c " & originalPath & "\runtask.bat", "", "runas", 1

   	'req.open "GET", "https://raw.githubusercontent.com/Ikillnukes/StarReset/master/starreset.bat", False
	'req.send

	'If req.Status = 200 Then
	'	WriteAllText testPath, req.responseText
	'End If

	'Set req = Nothing
Else
   	echo "You don't have any Stardock apps installed... You must have it installed to continue!"
End If

Pause

' Declaramos las demás funciones

Sub echo(str)
	WScript.Echo (str)
End Sub

Sub Break
	echo ""
End Sub

Sub Pause
	' Dim z
    WScript.Echo ("Presione una tecla para continuar . . .")
    z = WScript.StdIn.Read(1)
End Sub

' Opens a text file, reads all lines of the file, and then closes the file.
' @param {String} path The file to open for reading.
' @return {String} A string containing all lines of the file.
Function ReadAllText(path)
  Dim fso, stream

  Set fso = CreateObject("Scripting.FileSystemObject")
  Set stream = fso.OpenTextFile(CStr(path))
  ReadAllText = stream.ReadAll()
  stream.Close

  Set stream = Nothing
  Set fso = Nothing
End Function

' Creates a new file, writes the specified string to the file, and then closes the file.
' If the target file already exists, it is overwritten.
' @param {String} path The file to write to.
' @param {String} contents The string to write to the file.
Sub WriteAllText(path, contents)
  Dim fso, stream

  Set fso = CreateObject("Scripting.FileSystemObject")
  Set stream = fso.CreateTextFile(CStr(path))
  stream.Write CStr(contents)
  stream.Close

  Set stream = Nothing
  Set fso = Nothing
End Sub

Function EnvironmentCombine(env, comb)
	Set shell = CreateObject("WScript.Shell")
	EnvironmentCombine = shell.ExpandEnvironmentStrings(env) & "\" & comb & "\"
End Function

Function CheckforElevation 'test whether user has elevated token 
	Dim oShell, oExecWhoami, oWhoamiOutput, strWhoamiOutput, boolHasElevatedToken
	Set oShell = CreateObject("WScript.Shell")
	Set oExecWhoami = oShell.Exec("whoami /groups")
	Set oWhoamiOutput = oExecWhoami.StdOut
	strWhoamiOutput = oWhoamiOutput.ReadAll
	If InStr(1, strWhoamiOutput, "S-1-16-12288", vbTextCompare) Then boolHasElevatedToken = True
	CheckforElevation = boolHasElevatedToken
End Function