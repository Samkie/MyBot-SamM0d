Func _Wait4Pixel($x, $y, $sColor, $iColorVariation, $iWait = 1000, $iDelay = 100, $sMsglog = Default)
	Local $hTimer = __TimerInit()
	Local $iMaxCount = Int($iWait / $iDelay)
	For $i = 1 To $iMaxCount
		ForceCaptureRegion()
		If _CheckColorPixel($x, $y, $sColor, $iColorVariation, True, $sMsglog) Then Return True
		;If _ColorCheck(_GetPixelColor($x, $y, True, "Ori Color: " & Hex($sColor,6)), Hex($sColor,6), Int($iColorVariation)) Then Return True
		If _Sleep($iDelay) Then Return False
		If __TimerDiff($hTimer) >= $iWait Then ExitLoop
	Next
	Return False
EndFunc

Func _Wait4PixelGone($x, $y, $sColor, $iColorVariation, $iWait = 1000, $iDelay = 100, $sMsglog = Default)
	Local $hTimer = __TimerInit()
	Local $iMaxCount = Int($iWait / $iDelay)
	For $i = 1 To $iMaxCount
		ForceCaptureRegion()
		If Not _CheckColorPixel($x, $y, $sColor, $iColorVariation, True, $sMsglog) Then Return True
		If _Sleep($iDelay) Then Return False
		If __TimerDiff($hTimer) >= $iWait Then ExitLoop
	Next
	Return False
EndFunc

Func _CheckColorPixel($x, $y, $sColor, $iColorVariation, $bFCapture = True, $sMsglog = Default)
	Local $hPixelColor = _GetPixelColor2($x, $y, $bFCapture)
	Local $bFound = _ColorCheck($hPixelColor, Hex($sColor,6), Int($iColorVariation))
	Local $COLORMSG = ($bFound = True ? $COLOR_BLUE : $COLOR_RED)
	If $sMsglog <> Default And IsString($sMsglog) And $g_iSamM0dDebug = 1 Then
		Local $String = $sMsglog & " - Ori Color: " & Hex($sColor,6) & " at X,Y: " & $x & "," & $y & " Found: " & $hPixelColor
		SetLog($String, $COLORMSG)
	EndIf
	Return $bFound
EndFunc

Func _GetPixelColor2($iX, $iY, $bNeedCapture = False)
	Local $aPixelColor = 0
	If $bNeedCapture = False Or $g_bRunState = False Then
		$aPixelColor = _GDIPlus_BitmapGetPixel($g_hBitmap, $iX, $iY)
	Else
		_CaptureRegion($iX - 1, $iY - 1, $iX + 1, $iY + 1)
		$aPixelColor = _GDIPlus_BitmapGetPixel($g_hBitmap, 1, 1)
	EndIf
	Return Hex($aPixelColor, 6)
EndFunc   ;==>_GetPixelColor
