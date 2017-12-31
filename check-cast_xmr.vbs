' Check-Cast_XMR.vbs
' 	- Version 1
'	- Date: December 30, 2017
'	- Author: Tarv

On Error Resume Next

Dim objHTTP, objShell, objFSO, objLog
Dim strCastXMR_HTTP, strCastXMR_Output, strCastXMR_EXE, strCastXMR_BAT, strDevCon_BAT
Dim intLoop, intFindStart, intFindEnd, intFindLength, intHash
Dim boolEnd
Dim arrHash

' ----- EDIT BELOW HERE -------------------------------------------

' Set this to the web address you are using to monitor Cast_XMR
' The default setting should be fine in most cases
strCastXMR_HTTP = "http://127.0.0.1:7777/"

' Enter your Hash Rate limits for each GPU here
' Seperate each GPU limit by commas, this example shows two GPU
arrHash = Array(1760000,1760000)

' Enter the exact file name for Cast_XMR here
strCastXMR_EXE = "cast_xmr-vega.exe"

' Enter the FULL PATH to the bat file that launches Cast_XMR here
strCastXMR_BAT = "C:\Miners\Cast_XMR\run.bat"

' Enter the FULL PATH to the bat file that disables/enables the cards
' This is optional and can be left blank ""
strDevCon_BAT = ""

' ----- EDIT ABOVE HERE -------------------------------------------

Set objHTTP = CreateObject("MSXML2.XMLHTTP")
Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objLog = objFSO.OpenTextFile("check-cast_xmr-log.txt",8,True)

objLog.WriteLine "---- Runtime: " & FormatDateTime(Now, vbGeneralDate)

objHTTP.open "GET", strCastXMR_HTTP, False
objHTTP.send
strCastXMR_Output = objHTTP.responseText
strCastXMR_Output = Replace(strCastXMR_Output, Chr(13), "")
strCastXMR_Output = Replace(strCastXMR_Output, Chr(10), "")

If strCastXMR_Output = "" Then
	objShell.Popup "There was no response from " & strCastXMR_HTTP & Chr(13) & Chr(13) & "Exiting...", 5
	objLog.WriteLine "ERROR: There was no response from " & strCastXMR_HTTP 
End If

boolEnd = 0
intLoop = 0
intFindEnd = 1
intFindStart = InStr(intFindEnd, strCastXMR_Output, """hash_rate""") + 13

Do While intFindStart > 13 And boolEnd = 0

	intFindEnd = Instr(intFindStart, strCastXMR_Output, ",")
	intFindLength = intFindEnd - intFindStart
	intHash = Int(Mid(strCastXMR_Output, intFindStart, intFindLength))
	
	If intHash < arrHash(intLoop) Then

		objShell.Popup "Low Hashrate Found on GPU" & intLoop+1 & Chr(13) & "Hashrate: " & intHash & " - Expected: " & arrHash(intLoop) & Chr(13) & Chr(13) & "Cast_XMR will be restarted...", 5
		objLog.WriteLine "Low Hashrate Found on GPU" & intLoop+1 & " - Hashrate: " & intHash & " - Expected: " & arrHash(intLoop)
		objShell.Run "taskkill /f /im " & strCastXMR_EXE & " /t"
		WScript.Sleep 5000  '-- Script will pause for 5 seconds after killing the miner

		If Len(Trim(strDevCon_BAT)) > 0 Then
			objShell.Run strDevCon_BAT
			objLog.WriteLine "Cards were disabled/enabled at " & FormatDateTime(Now, vbGeneralDate)
			WScript.Sleep 10000  '-- Script will pause for 10 seconds after disable/enable the cards
		End If
		
		objShell.Run strCastXMR_BAT
		objLog.WriteLine "Cast_XMR was restarted at " & FormatDateTime(Now, vbGeneralDate)
		boolEnd = 1

	End If
		
	intFindStart = InStr(intFindEnd, strCastXMR_Output, """hash_rate""") + 13
	intLoop = intLoop + 1

Loop

objLog.Close
