#cs FUNCTION ====================================================================================================================
	; Name ..........: AreCollectorsOutside
	; Description ...: dark drills are ignored since they can be zapped
	; Syntax ........:
	; Parameters ....: $percent				minimum % of collectors outside of walls to all
	; Return values .: True					more collectors outside than specified
	;				 : False				less collectors outside than specified
	; Author ........: McSlither (Jan-2016)
	; Modified ......: TheRevenor (Jul 2016), Samkie (19 Feb 2018)
	; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
	;                  MyBot is distributed under the terms of the GNU GPL
	; Related .......:
	; Link ..........: https://github.com/MyBotRun/MyBot/wiki
	; Example .......: None
#ce ===============================================================================================================================

Func AreCollectorsOutside($percent)
	If $ichkDBCollectorsNearRedline = 1 Then Return AreCollectorsNearRedline($percent)

	SetLog("Locating Mines & Collectors", $COLOR_BLUE)
	; reset variables
	Global $g_aiPixelMine[0]
	Global $g_aiPixelElixir[0]
	Global $g_aiPixelNearCollector[0]
	Global $colOutside = 0
	Global $hTimer = TimerInit()
	_WinAPI_DeleteObject($hBitmapFirst)
	$hBitmapFirst = _CaptureRegion2()

	SuspendAndroid()
	$g_aiPixelMine = GetLocationMine()
	If (IsArray($g_aiPixelMine)) Then
		_ArrayAdd($g_aiPixelNearCollector, $g_aiPixelMine, 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING)
	EndIf
	$g_aiPixelElixir = GetLocationElixir()
	If (IsArray($g_aiPixelElixir)) Then
		_ArrayAdd($g_aiPixelNearCollector, $g_aiPixelElixir, 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING)
	EndIf
	ResumeAndroid()

	$bIDoScanMineAndElixir = True

	Global $colNbr = UBound($g_aiPixelNearCollector)
	SetLog("Located collectors in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds:")
	SetLog("[" & UBound($g_aiPixelMine) & "] Gold Mines")
	SetLog("[" & UBound($g_aiPixelElixir) & "] Elixir Collectors")
	;$iNbrOfDetectedMines[$DB] += UBound($g_aiPixelMine)
	;$iNbrOfDetectedCollectors[$DB] += UBound($g_aiPixelElixir)
	;UpdateStats()

	Global $minColOutside = Round($colNbr * $percent / 100)
	Global $radiusAdjustment = 1

	If $g_iSearchTH = "-" Or $g_iSearchTH = "" Then FindTownhall(True)
	If $g_iSearchTH <> "-" Then
		$radiusAdjustment *= Number($g_iSearchTH) / 10
	Else
		If $g_iTownHallLevel > 0 Then
			$radiusAdjustment *= Number($g_iTownHallLevel) / 10
		EndIf
	EndIf
	If $g_bDebugSetlog Then SetLog("$g_iSearchTH: " & $g_iSearchTH)

	For $i = 0 To $colNbr - 1
		Global $arrPixel = $g_aiPixelNearCollector[$i]
		If UBound($arrPixel) > 0 Then
			If isOutsideEllipse($arrPixel[0], $arrPixel[1], $CollectorsEllipseWidth * $radiusAdjustment, $CollectorsEllipseHeigth * $radiusAdjustment) Then
				If $g_bDebugSetlog Then SetLog("Collector (" & $arrPixel[0] & ", " & $arrPixel[1] & ") is outside", $COLOR_PURPLE)
				$colOutside += 1
			EndIf
		EndIf
		If $colOutside >= $minColOutside Then
			If $g_bDebugSetlog Then SetLog("More than " & $percent & "% of the collectors are outside", $COLOR_PURPLE)
			Return True
		EndIf
	Next
	If $g_bDebugSetlog Then SetLog($colOutside & " collectors found outside (out of " & $colNbr & ")", $COLOR_PURPLE)
	Return False
EndFunc   ;==>AreCollectorsOutside

#cs FUNCTION ====================================================================================================================
	; Name ..........: isOutsideEllipse
	; Description ...: This function can test if a given coordinate is inside (True) or outside (False) the village grass borders (a diamond shape).
	;                  It will also exclude some special area's like the CHAT tab, BUILDER button and GEM shop button.
	; Syntax ........: isInsideDiamondXY($Coordx, $Coordy), isInsideDiamond($aCoords)
	; Parameters ....: ($coordx, $coordY) as coordinates or ($aCoords), an array of (x,y) to test
	; Return values .: True or False
	; Author ........: McSlither (Jan-2016)
	; Modified ......: TheRevenor (Jul-2016)
	; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
	;                  MyBot is distributed under the terms of the GNU GPL
	; Related .......: isInsideDiamond($aCoords)
	; Link ..........: https://github.com/MyBotRun/MyBot/wiki
	; Example .......: None
#ce ===============================================================================================================================

Func isOutsideEllipse($coordX, $coordY, $ellipseWidth = 200, $ellipseHeigth = 150, $centerX = $centerX, $centerY = $centerY)

	Global $normalizedX = $coordX - $centerX
	Global $normalizedY = $coordY - $centerY
	Local $result = ($normalizedX * $normalizedX) / ($ellipseWidth * $ellipseWidth) + ($normalizedY * $normalizedY) / ($ellipseHeigth * $ellipseHeigth) > 1

	If $g_bDebugSetlog Then
		If $result Then
			Setlog("Coordinate Outside Ellipse (" & $ellipseWidth & ", " & $ellipseHeigth & ")", $COLOR_PURPLE)
		Else
			Setlog("Coordinate Inside Ellipse (" & $ellipseWidth & ", " & $ellipseHeigth & ")", $COLOR_PURPLE)
		EndIf
	EndIf

	Return $result

EndFunc   ;==>isOutsideEllipse

; Check Collectors Outside
Func chkDBMeetCollOutside()
	If GUICtrlRead($chkDBMeetCollOutside) = $GUI_CHECKED Then
		GUICtrlSetState($txtDBMinCollOutsidePercent, $GUI_ENABLE)
		GUICtrlSetState($chkSkipCollectorCheckIF, $GUI_ENABLE)
		GUICtrlSetState($txtSkipCollectorGold, $GUI_ENABLE)
		GUICtrlSetState($txtSkipCollectorElixir, $GUI_ENABLE)
		GUICtrlSetState($txtSkipCollectorDark, $GUI_ENABLE)
		GUICtrlSetState($chkSkipCollectorCheckIFTHLevel, $GUI_ENABLE)
		GUICtrlSetState($txtIFTHLevel, $GUI_ENABLE)

		GUICtrlSetState($chkDBCollectorsNearRedline, $GUI_ENABLE)
		GUICtrlSetState($cmbRedlineTiles, $GUI_ENABLE)
	Else
		GUICtrlSetState($txtDBMinCollOutsidePercent, $GUI_DISABLE)
		GUICtrlSetState($chkSkipCollectorCheckIF, $GUI_DISABLE)
		GUICtrlSetState($txtSkipCollectorGold, $GUI_DISABLE)
		GUICtrlSetState($txtSkipCollectorElixir, $GUI_DISABLE)
		GUICtrlSetState($txtSkipCollectorDark, $GUI_DISABLE)
		GUICtrlSetState($chkSkipCollectorCheckIFTHLevel, $GUI_DISABLE)
		GUICtrlSetState($txtIFTHLevel, $GUI_DISABLE)
		GUICtrlSetState($chkDBCollectorsNearRedline, $GUI_DISABLE)
		GUICtrlSetState($cmbRedlineTiles, $GUI_DISABLE)

	EndIf
EndFunc   ;==>chkDBMeetCollOutside
