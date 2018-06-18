; #FUNCTION# ====================================================================================================================
; Name ..........: Functions(AltuFaltu_Mod)
; Description ...: This function will do various image search operation.
; Syntax ........: None
; Parameters ....: None
; Return values .: None
; Author ........: AltuFaltu(06-04-18)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func RndClick_AF($Area)

	Local $x = Random($Area[0],$Area[2],1)
	Local $y = Random($Area[1],$Area[3],1)
	PureClick($x,$y)
	If $g_bDebugSetlog = 1 Then Setlog("Click On Position - (" & $x & "," & $y & ").")

EndFunc

Func WaitforVariousImages($terget,$try=1,$intval=1000)

	Local $Result = False
	Local $try1 = 0
	While 1
		If $try1 < $try Then
			If CheckVariousImages($terget,True) = True Then
				If $g_DebugLogAF = 1 Then Setlog("Wait for " & $terget & " - Success.")
				$Result = True
				ExitLoop
			Else
				If _Sleep($intval) Then Return
			EndIf
		Else
			If $g_DebugLogAF = 1 Then Setlog("Wait for " & $terget & " - Fails.")
			ExitLoop
		EndIf
		$try1 = $try1+1
	WEnd
	Return $Result

EndFunc

Func CheckVariousImages($terget = "", $forceCapture = False,$Retry = 1)

	Local $x, $y, $h, $w
	Local $img
	Local $Ret = False

	Switch $terget
		Case "SCIDDisconnectBtn"
			$x = 365
			$y = 210
			$h = 25
			$w = 140
			$img = @ScriptDir & "\COCBot\AltuFaltu_Mod\Images\ImgCheck\Disconnect_92.png"
		Case "SCIDLogOutBtn"
			$x = 595
			$y = 275
			$h = 45
			$w = 125
			$img = @ScriptDir & "\COCBot\AltuFaltu_Mod\Images\ImgCheck\Logout_92.png"
		Case "SCIDLogOutConfirmBtn"
			$x = 445
			$y = 425
			$h = 35
			$w = 180
			$img = @ScriptDir & "\COCBot\AltuFaltu_Mod\Images\ImgCheck\LogoutCnf_92.png"
		Case "SCIDLoginBtn"
			$x = 295
			$y = 615
			$h = 30
			$w = 265
			$img = @ScriptDir & "\COCBot\AltuFaltu_Mod\Images\ImgCheck\Login_92.png"
		Case "SCIDAccSelectPage"
			$x = 485
			$y = 200
			$h = 30
			$w = 40
			$img = @ScriptDir & "\COCBot\AltuFaltu_Mod\Images\ImgCheck\IDMulti_92.png"
		Case "SCIDAccSelectPageSingleAcc"
			$x = 485
			$y = 235
			$h = 30
			$w = 40
			$img = @ScriptDir & "\COCBot\AltuFaltu_Mod\Images\ImgCheck\IDSingle_92.png"
	EndSwitch

	Local $iImageNotMatchCount = 0

		While 1
			If $iImageNotMatchCount > 0 Or $forceCapture = true Then
				_CaptureRegion()
			EndIf
			If _Sleep(1000) Then Return
			Local $SearchArea = GetHHBitmapArea($g_hHBitmap,$x,$y,$x+$w,$y+$h)
			If $g_DebugImageAF = 1 Then _debugSaveHBitmapToImageAF($SearchArea,$terget,True)
			Local $result = DllCall($g_hLibMyBot, "str", "FindTile", "handle", $SearchArea, "str", $img, "str", "FV", "int", 1)
			If IsArray($result) Then
				If $g_DebugLogAF = 1 Then SetLog("DLL Call succeeded " & $result[0], $COLOR_ERROR)
				If $result[0] = "0" Or $result[0] = "" Then
					If $g_DebugLogAF = 1 Then SetLog("Image not found", $COLOR_ERROR)
					$iImageNotMatchCount += 1
					If $iImageNotMatchCount = $Retry Then
						$Ret = False
						ExitLoop
					EndIf
				ElseIf StringLeft($result[0], 2) = "-1" Then
					If $g_DebugLogAF = 1 Then SetLog("DLL Error: " & $result[0], $COLOR_ERROR)
				Else
					If $g_DebugLogAF = 1 Then SetLog("$result[0]: " & $result[0])
					Local $aCoor = StringSplit($result[0],"|",$STR_NOCOUNT)
					If IsArray($aCoor) Then
						If StringLeft($aCoor[1], 2) <> "-1" Then
							$Ret = True
							ExitLoop
						EndIf
					EndIf
				EndIf
			Else
				$Ret = False
			EndIf
		WEnd
	Return $Ret

EndFunc

Func findMultiImageAF($hBitmap4Find, $directory, $sCocDiamond, $redLines, $minLevel = 0, $maxLevel = 1000, $maxReturnPoints = 0, $returnProps = "objectname,objectlevel,objectpoints", $debugImageName = "AF")
	; same has findButton, but allow custom area instead of button area decoding
	; nice for dinamic locations
	If $g_DebugLogAF = 1 Then
		SetLog("******** findMultiImage *** START ***", $COLOR_ORANGE)
		SetLog("findMultiImage : directory : " & $directory, $COLOR_ORANGE)
		SetLog("findMultiImage : sCocDiamond : " & $sCocDiamond, $COLOR_ORANGE)
		SetLog("findMultiImage : redLines : " & $redLines, $COLOR_ORANGE)
		SetLog("findMultiImage : minLevel : " & $minLevel, $COLOR_ORANGE)
		SetLog("findMultiImage : maxLevel : " & $maxLevel, $COLOR_ORANGE)
		SetLog("findMultiImage : maxReturnPoints : " & $maxReturnPoints, $COLOR_ORANGE)
		SetLog("findMultiImage : returnProps : " & $returnProps, $COLOR_ORANGE)
		SetLog("******** findMultiImage *** START ***", $COLOR_ORANGE)
	EndIf

	If $g_DebugImageAF = 1 Then
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC
		_debugSaveHBitmapToImageAF($hBitmap4Find, $debugImageName, False, True)
	EndIf

	Local $error, $extError

	Local $aCoords = "" ; use AutoIt mixed variable type and initialize array of coordinates to null
	Local $returnData = StringSplit($returnProps, ",", $STR_NOCOUNT)
	Local $returnLine[UBound($returnData)]
	Local $returnValues[0]


	; Capture the screen for comparison
	; Perform the search

	Local $result = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $hBitmap4Find, "str", $directory, "str", $sCocDiamond, "Int", $maxReturnPoints, "str", $redLines, "Int", $minLevel, "Int", $maxLevel)
	$error = @error ; Store error values as they reset at next function call
	$extError = @extended
	If $error Then
		;_logErrorDLLCall($g_sLibImgLocPath, $error)
		If $g_DebugLogAF = 1 Then SetLog(" imgloc DLL Error : " & $error & " --- " & $extError)
		SetError(2, $extError, $aCoords) ; Set external error code = 2 for DLL error
		Return ""
	EndIf

	If checkImglocError($result, "findMultiImage") = True Then
		If $g_DebugLogAF = 1 Then SetLog("findMultiImage Returned Error or No values : ", $COLOR_DEBUG)
		If $g_DebugLogAF = 1 Then SetLog("******** findMultiImage *** END ***", $COLOR_ORANGE)
		Return ""
	Else
		If $g_DebugLogAF = 1 Then SetLog("findMultiImage found : " & $result[0])
	EndIf

	If $result[0] <> "" Then ;despite being a string, AutoIt receives a array[0]
		Local $resultArr = StringSplit($result[0], "|", $STR_NOCOUNT)
		ReDim $returnValues[UBound($resultArr)]
		For $rs = 0 To UBound($resultArr) - 1
			For $rD = 0 To UBound($returnData) - 1 ; cycle props
				$returnLine[$rD] = RetrieveImglocProperty($resultArr[$rs], $returnData[$rD])
				If $g_DebugLogAF = 1 Then SetLog("findMultiImage : " & $resultArr[$rs] & "->" & $returnData[$rD] & " -> " & $returnLine[$rD])
			Next
			$returnValues[$rs] = $returnLine
		Next

		;;lets check if we should get redlinedata
		If $redLines = "" Then
			$g_sImglocRedline = RetrieveImglocProperty("redline", "") ;global var set in imglocTHSearch
			If $g_DebugLogAF = 1 Then SetLog("findMultiImage : Redline argument is emty, seting global Redlines")
		EndIf
		If $g_DebugLogAF = 1 Then SetLog("******** findMultiImage *** END ***", $COLOR_ORANGE)
		Return $returnValues

	Else
		If $g_DebugLogAF = 1 Then SetLog(" ***  findMultiImage has no result **** ", $COLOR_ORANGE)
		If $g_DebugLogAF = 1 Then SetLog("******** findMultiImage *** END ***", $COLOR_ORANGE)
		Return ""
	EndIf

EndFunc   ;==>findMultiImageAF

Func _debugSaveHBitmapToImageAF($hHBitmap, $sFilename, $bDateTime = False, $bSaveType = "ImgDebug")

	If $hHBitmap <> 0 Then
		Local $EditedImage = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap)
		If $bDateTime Then
			Local $Date = @MDAY & "." & @MON & "." & @YEAR
			Local $Time = @HOUR & "." & @MIN & "." & @SEC & "." & @MSEC
			$sFilename = $sFilename & "-" & $Date & "-" & $Time
		EndIf
		_GDIPlus_ImageSaveToFile($EditedImage, @ScriptDir & "\COCBot\AltuFaltu_Mod\Images\" & $bSaveType & "\" & $sFilename & ".png")
		_GDIPlus_BitmapDispose($EditedImage)
	EndIf

EndFunc   ;==>_debugSaveHBitmapToImageAF
