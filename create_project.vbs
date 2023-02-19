Option Explicit
Const DontShowWindow = 0
Const DoShowWindow = 1
Const WaitUntilFinished = True
Const ForReading = 1
Const TristateFalse = 0
Const WshRunning = 0
Dim S, szBaseFolder
Dim nErr

szBaseFolder = Left(WScript.ScriptFullName, Len(WScript.ScriptFullName) - Len(WScript.ScriptName))

'-------------------------------------------------------------------------------

Call RunDosCommand("RD /Q /S build", szBaseFolder)
Call RunDosCommand("MD build", szBaseFolder)
Call RunDosCommand("MD build\Win32", szBaseFolder)
Call RunDosCommand("MD build\x64", szBaseFolder)

S = "..\..\CMake\bin\cmake.exe -G" & Chr(34) & "Visual Studio 17 2022" & Chr(34) & _
    " -DCMAKE_CONFIGURATION_TYPES=Debug;Release -DBUILD_TESTING=OFF -DUSE_OPENMP=OFF" & _
    " -DBUILD_STATIC_LIB=ON -S ..\..\Source"

nErr = RunApp(S & " -A Win32", szBaseFolder & "build\Win32\", False)
If nErr = 0 Then
	nErr = RunApp(S & " -A x64", szBaseFolder & "build\x64\", False)
End If
If nErr <> 0 Then
	WScript.Echo "Error: Unable to generate Visual Studio solutions."
	WScript.Quit 1
End If

'-------------------------------------------------------------------------------
'Done

WScript.Echo "Visual Studio solutions successfully generated!"
WScript.Quit 0


'-------------------------------------------------------------------------------

Function RunDosCommand(szCommand, szCurrFolder)
	RunDosCommand = RunApp("CMD.EXE /C " & szCommand, szCurrFolder, False)
End Function

Function RunApp(szCommand, szCurrFolder, bHide)
Dim oShell
Dim S

	Set oShell = CreateObject("WScript.Shell")
	If Len(szCurrFolder) > 0 Then
		oShell.CurrentDirectory = szCurrFolder
	Else
		oShell.CurrentDirectory = szBaseFolder
	End If
	If bHide = False Then
		WScript.Echo "Executing: " & szCommand
	End If
	RunApp = oShell.Run(szCommand, DontShowWindow, WaitUntilFinished)
End Function
