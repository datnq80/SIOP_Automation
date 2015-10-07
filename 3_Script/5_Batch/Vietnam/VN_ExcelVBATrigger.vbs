Option Explicit

On Error Resume Next

ExcelMacroExample

Sub ExcelMacroExample() 

Dim xlApp 
Dim xlBook 
Dim args

On Error Resume Next

Set xlApp = CreateObject("Excel.Application") 

If Err.Number <> 0 Then
WScript.Echo "Error in DoStep1: " & Err.Description
Err.Clear
End If

dim fso: set fso = CreateObject("Scripting.FileSystemObject") 
dim CurrentDirectory
CurrentDirectory = fso.GetAbsolutePathName(".")
WScript.Echo CurrentDirectory

Set xlBook = xlApp.Workbooks.Open(CurrentDirectory + "\VN_Bottom Up_SI&OP MWH.xlsm", 0, True)

If Err.Number <> 0 Then
WScript.Echo "Error in DoStep1: " & Err.Description
Err.Clear
End If

xlApp.Run "UpdateDataMacro"


If Err.Number <> 0 Then
WScript.Echo "Error in DoStep1: " & Err.Description
Err.Clear
End If

xlApp.DisplayAlerts = False

If Err.Number <> 0 Then
WScript.Echo "Error in DoStep1: " & Err.Description
Err.Clear
End If

xlBook.SaveAs CurrentDirectory + "\VN_Bottom Up_SI&OP MWH_Final.xlsm"
xlApp.Quit 


If Err.Number <> 0 Then
WScript.Echo "Error in DoStep1: " & Err.Description
Err.Clear
End If

xlBook.Close
Set xlBook = Nothing 
Set xlApp = Nothing 

WScript.Echo "Done"

End Sub 