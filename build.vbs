Option Explicit
Const DontShowWindow = 0
Const DoShowWindow = 1
Const WaitUntilFinished = True
Const ForReading = 1
Const TristateFalse = 0
Const WshRunning = 0
Dim szBaseFolder, szBaseCmdLine, szBuildTarget
Dim nErr, nIdx

szBaseFolder = Left(WScript.ScriptFullName, Len(WScript.ScriptFullName) - Len(WScript.ScriptName))

'-------------------------------------------------------------------------------

szBaseCmdLine = "..\..\CMake\bin\cmake.exe --build . --config"
'szBuildTarget = "--target dmlc-core\dmlc --target dmlc-core\dmlc_lint --target src\objxgboost"
szBuildTarget = "--target dmlc-core\dmlc --target src\objxgboost"

nErr = RunApp(szBaseCmdLine + " Debug " + szBuildTarget, szBaseFolder & "build\Win32\", False)
If nErr = 0 Then
	nErr = RunApp(szBaseCmdLine + " Release " + szBuildTarget, szBaseFolder & "build\Win32\", False)
End If
If nErr = 0 Then
	nErr = RunApp(szBaseCmdLine + " Debug " + szBuildTarget, szBaseFolder & "build\x64\", False)
End If
If nErr = 0 Then
	nErr = RunApp(szBaseCmdLine + " Release " + szBuildTarget, szBaseFolder & "build\x64\", False)
End If
If nErr <> 0 Then
	WScript.Echo "Error: Unable to complete code compilation"
	WScript.Quit 1
End If

'-------------------------------------------------------------------------------
'Done

WScript.Echo "Compilation succeeded!"
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
