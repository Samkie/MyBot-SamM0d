Func SetModDebugLog($sLogMessage, $sColor = $COLOR_DEBUG, $Font = Default, $FontSize = Default, $statusbar = 0)
	Local $sLogPrefix = ""

	If $iCurActiveAcc >= 0 Then
		If StringLen($icmbWithProfile[$iCurActiveAcc]) Then
			$sLogPrefix = $icmbWithProfile[$iCurActiveAcc] & " - "
		EndIf
	EndIf

	Local $sLog = $sLogPrefix & TimeDebug() & $sLogMessage

	SetLog($sLogMessage, $sColor, $Font, $FontSize, $statusbar)
	Local $g_hDebugLogFile
	$g_hDebugLogFile = FileOpen($g_sProfilePath & "\ModDebug.log", $FO_APPEND)

	If $g_hDebugLogFile Then
		FileWriteLine($g_hDebugLogFile, $sLog)
	EndIf

	If $g_hDebugLogFile <> 0 Then
	   FileClose($g_hDebugLogFile)
	   $g_hDebugLogFile = 0
	EndIf
EndFunc   ;==>SetModDebugLog