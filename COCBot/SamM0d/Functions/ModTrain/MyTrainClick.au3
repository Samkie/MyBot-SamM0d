
; #FUNCTION# ====================================================================================================================
; Name ..........: MyTrainClick
; Description ...: Clicks in troop training window
; Syntax ........: MyTrainClick($TroopButton, $iTimes, $iSpeed, $sdebugtxt="")
; Parameters ....: $TroopButton         - base on HLFClick button type
;                  $iTimes              - Number fo times to cliok
;                  $iSpeed              - Wait time after click
;				   $sdebugtxt		    - String with click debug text
; Return values .: None
; Author ........: Samkie (23 Feb 2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func LocateTroopButton($TroopButton, $bIsBrewSpell = False)
	If IsTrainPage() Then
		Local $aRegionForScan[4] = [26,411,840,536]
		Local $aButtonXY

		If $bIsBrewSpell Then $TroopButton = "Spell" & $TroopButton

		_CaptureRegion2($aRegionForScan[0],$aRegionForScan[1],$aRegionForScan[2],$aRegionForScan[3])
		Local $aFileToScan = _FileListToArrayRec($g_sSamM0dImageLocation & "\TrainButtons", $TroopButton & "*.png", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		If UBound($aFileToScan) > 1 Then
			For $i = 1 To UBound($aFileToScan) - 1
				If $g_iSamM0dDebug = 1 Then SetLog("$aFileToScan[" & $i & "]: " & $aFileToScan[$i])
				If StringInStr($aFileToScan[$i],$TroopButton) Then
					Local $result = FindImageInPlace($TroopButton, $g_sSamM0dImageLocation & "\TrainButtons\" & $aFileToScan[$i], "0,0," & $aRegionForScan[2] - $aRegionForScan[0] & "," & $aRegionForScan[3] - $aRegionForScan[1], False)
					If StringInStr($result, ",") > 0 Then
						$aButtonXY = StringSplit($result, ",", $STR_NOCOUNT)
						ExitLoop
					EndIf
				EndIf
			Next
		Else
			SetLog("Cannot find image file " & $TroopButton & " for scan", $COLOR_ERROR)
			Return False
		EndIf

		_debugSaveHBitmapToImage($g_hHBitmap2, "RegionForScan")
		If $g_hHBitmap2 <> 0 Then
			GdiDeleteHBitmap($g_hHBitmap2)
		EndIf

		If IsArray($aButtonXY) Then
			$g_iTroopButtonX = $aRegionForScan[0] + $aButtonXY[0]
			$g_iTroopButtonY = $aRegionForScan[1] + $aButtonXY[1]
			Return True
		Else
			Local $iCount = 0
			If _ColorCheck(_GetPixelColor(24, 370 + $g_iMidOffsetY, True), Hex(0XD3D3CB, 6), 10) Then
				While Not _ColorCheck(_GetPixelColor(838, 370 + $g_iMidOffsetY, True), Hex(0XD3D3CB, 6), 10)
					;ClickDrag(830,476,25,476,250)
					ClickDrag(617,476,318,476,250)
					If _sleep(500) Then Return False
					$iCount += 1
					If $iCount > 3 Then Return False
				WEnd
			ElseIf _ColorCheck(_GetPixelColor(838, 370 + $g_iMidOffsetY, True), Hex(0XD3D3CB, 6), 10) Then
				While Not _ColorCheck(_GetPixelColor(24, 370 + $g_iMidOffsetY, True), Hex(0XD3D3CB, 6), 10)
					;ClickDrag(25,476,830,476,250)
					ClickDrag(236,476,538,476,250)
					If _sleep(500) Then Return False
					$iCount += 1
					If $iCount > 3 Then Return False
				WEnd
			EndIf

			_CaptureRegion2($aRegionForScan[0],$aRegionForScan[1],$aRegionForScan[2],$aRegionForScan[3])
			Local $aFileToScan = _FileListToArrayRec($g_sSamM0dImageLocation & "\TrainButtons", $TroopButton & "*.png", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
			If UBound($aFileToScan) > 1 Then
				For $i = 1 To UBound($aFileToScan) - 1
					If $g_iSamM0dDebug = 1 Then SetLog("$aFileToScan[" & $i & "]: " & $aFileToScan[$i])
					If StringInStr($aFileToScan[$i],$TroopButton) Then
						Local $result = FindImageInPlace($TroopButton, $g_sSamM0dImageLocation & "\TrainButtons\" & $aFileToScan[$i], "0,0," & $aRegionForScan[2] - $aRegionForScan[0] & "," & $aRegionForScan[3] - $aRegionForScan[1], False)
						If StringInStr($result, ",") > 0 Then
							$aButtonXY = StringSplit($result, ",", $STR_NOCOUNT)
							ExitLoop
						EndIf
					EndIf
				Next
			Else
				SetLog("Cannot find image file " & $TroopButton & " for scan", $COLOR_ERROR)
			EndIf

			_debugSaveHBitmapToImage($g_hHBitmap2, "RegionForScan")
			If $g_hHBitmap2 <> 0 Then
				GdiDeleteHBitmap($g_hHBitmap2)
			EndIf

			If IsArray($aButtonXY) Then
				$g_iTroopButtonX = $aRegionForScan[0] + $aButtonXY[0]
				$g_iTroopButtonY = $aRegionForScan[1] + $aButtonXY[1]
				Return True
			EndIf
		EndIf
	EndIf
	Return False
EndFunc

Func MyTrainClick($x, $y, $iTimes = 1, $iSpeed = 0, $sdebugtxt="", $bIsBrewSpell = False)
	If IsTrainPage() Then
			Local $iRandNum = Random($iHLFClickMin-1,$iHLFClickMax-1,1) ;Initialize value (delay awhile after $iRandNum times click)
			Local $iRandX = Random($x - 5,$x + 5,1)
			Local $iRandY = Random($y - 5,$y + 5,1)
			If isProblemAffect(True) Then Return
			For $i = 0 To ($iTimes - 1)
				HMLPureClick(Random($iRandX-2,$iRandX+2,1), Random($iRandY-2,$iRandY+2,1))
				If $i >= $iRandNum Then
					$iRandNum = $iRandNum + Random($iHLFClickMin,$iHLFClickMax,1)
					$iRandX = Random($x - 5, $x + 5,1)
					$iRandY = Random($y - 5, $y + 5,1)
					If _Sleep(Random(($isldHLFClickDelayTime*90)/100, ($isldHLFClickDelayTime*110)/100, 1), False) Then ExitLoop
				Else
					If _Sleep(Random(($iSpeed*90)/100, ($iSpeed*110)/100, 1), False) Then ExitLoop
				EndIf
			Next
	EndIf
EndFunc   ;==>MyTrainClick

Func MakeTroopsAndSpellsTrainImage()

	Local $currentRunState = $g_bRunState
	$g_bRunState = True
	; capture region left upper

	ClickP($aAway, 1, 0, "#0268") ;Click Away to clear open windows in case user interupted
	If _Sleep(200) Then Return

	If _Wait4Pixel($aButtonOpenTrainArmy[4], $aButtonOpenTrainArmy[5], $aButtonOpenTrainArmy[6], $aButtonOpenTrainArmy[7]) Then
		If $g_iSamM0dDebug = 1 Then SetLog("Click $aArmyTrainButton", $COLOR_SUCCESS)
		If IsMainPage() Then
			If $g_bUseRandomClick = False Then
				Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#1293") ; Button Army Overview
			Else
				ClickR($aArmyTrainButtonRND, $aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0)
			EndIf
		EndIf
	EndIf

	If _Sleep(250) Then Return

	If gotoTrainTroops() = False Then Return
	RemoveAllPreTrainTroops()

	Local $iCount = 0
	Local $iSlotWidth = 98.5
	Local $iStartingOffset = 45
	Local $iUpperLeftTroopElixirStartOffset = 26
	Local $iUpperLeftTroopDarkElixirStartOffset = 624
	Local $iUpperRightTroopDarkElixirStartOffset = 640
	Local $iUpperRowY1 = 413
	Local $iUpperRowY2 = 433
	Local $iLowerRowY1 = 514
	Local $iLowerRowY2 = 534

	_CaptureRegion2()
	Local $aTemp[1][3]
	$iCount = 0
	For $i = 0 To UBound($MyTroopsButton) - 1
		If $MyTroopsButton[$i][1] = 0 Then
			ReDim $aTemp[$iCount + 1][3]
			$aTemp[$iCount][0] = $MyTroopsButton[$i][0]
			$aTemp[$iCount][1] = $MyTroopsButton[$i][1]
			$aTemp[$iCount][2] = $MyTroopsButton[$i][2]
			$iCount += 1
		EndIf
	Next
	_ArraySort($aTemp,0,0,0,2)
	For $i = 0 to 5
		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftTroopElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iUpperRowY1,$iUpperLeftTroopElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iUpperRowY2)
		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[$i][0] & "_92", True)
		If $hHBitmapTest <> 0 Then
			GdiDeleteHBitmap($hHBitmapTest)
		EndIf
	Next
	For $i = 0 to 1
		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iUpperRowY1,$iUpperLeftTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iUpperRowY2)
		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[$i + 6][0] & "_92", True)
		If $hHBitmapTest <> 0 Then
			GdiDeleteHBitmap($hHBitmapTest)
		EndIf
	Next

	Local $aTemp[1][3]
	$iCount = 0
	For $i = 0 To UBound($MyTroopsButton) - 1
		If $MyTroopsButton[$i][1] = 1 Then
			ReDim $aTemp[$iCount + 1][3]
			$aTemp[$iCount][0] = $MyTroopsButton[$i][0]
			$aTemp[$iCount][1] = $MyTroopsButton[$i][1]
			$aTemp[$iCount][2] = $MyTroopsButton[$i][2]
			$iCount += 1
		EndIf
	Next
	_ArraySort($aTemp,0,0,0,2)
	For $i = 0 to 5
		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftTroopElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iLowerRowY1,$iUpperLeftTroopElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iLowerRowY2)
		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[$i][0] & "_92", True)
		If $hHBitmapTest <> 0 Then
			GdiDeleteHBitmap($hHBitmapTest)
		EndIf
	Next
	For $i = 0 to 1
		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iLowerRowY1,$iUpperLeftTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iLowerRowY2)
		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[$i + 6][0] & "_92", True)
		If $hHBitmapTest <> 0 Then
			GdiDeleteHBitmap($hHBitmapTest)
		EndIf
	Next

	If CheckNeedSwipe(19) = False Then
		SetLog("Cannot click drag to select troop" , $COLOR_ERROR)
		Return
	EndIf

	Sleep(1000)

	_CaptureRegion2()

	Local $aTemp[1][3]
	$iCount = 0
	For $i = 0 To UBound($MyTroopsButton) - 1
		If $MyTroopsButton[$i][1] = 2 Then
			ReDim $aTemp[$iCount + 1][3]
			$aTemp[$iCount][0] = $MyTroopsButton[$i][0]
			$aTemp[$iCount][1] = $MyTroopsButton[$i][1]
			$aTemp[$iCount][2] = $MyTroopsButton[$i][2]
			$iCount += 1
		EndIf
	Next
	_ArraySort($aTemp,0,0,0,2)
	For $i = 0 to $iCount - 1
		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperRightTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iUpperRowY1,$iUpperRightTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iUpperRowY2)
		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[$i][0] & "_92", True)
		If $hHBitmapTest <> 0 Then
			GdiDeleteHBitmap($hHBitmapTest)
		EndIf
	Next

	Local $aTemp[1][3]
	$iCount = 0
	For $i = 0 To UBound($MyTroopsButton) - 1
		If $MyTroopsButton[$i][1] = 3 Then
			ReDim $aTemp[$iCount + 1][3]
			$aTemp[$iCount][0] = $MyTroopsButton[$i][0]
			$aTemp[$iCount][1] = $MyTroopsButton[$i][1]
			$aTemp[$iCount][2] = $MyTroopsButton[$i][2]
			$iCount += 1
		EndIf
	Next
	_ArraySort($aTemp,0,0,0,2)
	For $i = 0 to $iCount - 1
		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperRightTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iLowerRowY1,$iUpperRightTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iLowerRowY2)
		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[$i][0] & "_92", True)
		If $hHBitmapTest <> 0 Then
			GdiDeleteHBitmap($hHBitmapTest)
		EndIf
	Next

	If gotoBrewSpells() = False Then Return
	RemoveAllPreTrainTroops()

	Local $iUpperLeftSpellStartOffset = 26
	Local $iUpperLeftDarkSpellStartOffset = 329

	_CaptureRegion2()
	Local $aTemp[1][3]
	$iCount = 0
	For $i = 0 To UBound($MySpellsButton) - 1
		If $MySpellsButton[$i][1] = 0 Then
			ReDim $aTemp[$iCount + 1][3]
			$aTemp[$iCount][0] = $MySpellsButton[$i][0]
			$aTemp[$iCount][1] = $MySpellsButton[$i][1]
			$aTemp[$iCount][2] = $MySpellsButton[$i][2]
			$iCount += 1
		EndIf
	Next
	_ArraySort($aTemp,0,0,0,2)
	For $i = 0 to 2
		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iUpperRowY1,$iUpperLeftSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iUpperRowY2)
		_debugSaveHBitmapToImage($hHBitmapTest, "Spell" & $aTemp[$i][0] & "_93", True)
		If $hHBitmapTest <> 0 Then
			GdiDeleteHBitmap($hHBitmapTest)
		EndIf
	Next
	For $i = 0 to 1
		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftDarkSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iUpperRowY1,$iUpperLeftDarkSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iUpperRowY2)
		_debugSaveHBitmapToImage($hHBitmapTest, "Spell" & $aTemp[$i + 3][0] & "_93", True)
		If $hHBitmapTest <> 0 Then
			GdiDeleteHBitmap($hHBitmapTest)
		EndIf
	Next

	Local $aTemp[1][3]
	$iCount = 0
	For $i = 0 To UBound($MySpellsButton) - 1
		If $MySpellsButton[$i][1] = 1 Then
			ReDim $aTemp[$iCount + 1][3]
			$aTemp[$iCount][0] = $MySpellsButton[$i][0]
			$aTemp[$iCount][1] = $MySpellsButton[$i][1]
			$aTemp[$iCount][2] = $MySpellsButton[$i][2]
			$iCount += 1
		EndIf
	Next
	_ArraySort($aTemp,0,0,0,2)
	For $i = 0 to 2
		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iLowerRowY1,$iUpperLeftSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iLowerRowY2)
		_debugSaveHBitmapToImage($hHBitmapTest, "Spell" & $aTemp[$i][0] & "_93", True)
		If $hHBitmapTest <> 0 Then
			GdiDeleteHBitmap($hHBitmapTest)
		EndIf
	Next
	For $i = 0 to 1
		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftDarkSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iLowerRowY1,$iUpperLeftDarkSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iLowerRowY2)
		_debugSaveHBitmapToImage($hHBitmapTest, "Spell" & $aTemp[$i + 3][0] & "_93", True)
		If $hHBitmapTest <> 0 Then
			GdiDeleteHBitmap($hHBitmapTest)
		EndIf
	Next
	$g_bRunState = $currentRunState
EndFunc

; Event
;~ Func MakeTroopsAndSpellsTrainImage()
;~ 	Local $currentRunState = $g_bRunState
;~ 	$g_bRunState = True
;~ 	; capture region left upper
;~ 	SetLog("MakeTroopsAndSpellsTrainImage Start")

;~ 	ClickP($aAway, 1, 0, "#0268") ;Click Away to clear open windows in case user interupted
;~ 	If _Sleep(200) Then Return

;~ 	If _Wait4Pixel($aButtonOpenTrainArmy[4], $aButtonOpenTrainArmy[5], $aButtonOpenTrainArmy[6], $aButtonOpenTrainArmy[7]) Then
;~ 		If $g_iSamM0dDebug = 1 Then SetLog("Click $aArmyTrainButton", $COLOR_SUCCESS)
;~ 		If IsMainPage() Then
;~ 			If $g_bUseRandomClick = False Then
;~ 				Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#1293") ; Button Army Overview
;~ 			Else
;~ 				ClickR($aArmyTrainButtonRND, $aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0)
;~ 			EndIf
;~ 		EndIf
;~ 	EndIf

;~ 	If _Sleep(250) Then Return

;~ 	If gotoTrainTroops() = False Then Return
;~ 	RemoveAllPreTrainTroops()

;~ 	Local $iCount = 0
;~ 	Local $iSlotWidth = 98.5
;~ 	Local $iStartingOffset = 45
;~ 	Local $iUpperLeftTroopElixirStartOffset = 26
;~ 	Local $iUpperLeftTroopDarkElixirStartOffset = 722
;~ 	Local $iUpperRightTroopDarkElixirStartOffset = 542
;~ 	Local $iUpperRowY1 = 413
;~ 	Local $iUpperRowY2 = 433
;~ 	Local $iLowerRowY1 = 514
;~ 	Local $iLowerRowY2 = 534

;~ 	_CaptureRegion2()
;~ 	Local $aTemp[1][3]
;~ 	$iCount = 0
;~ 	For $i = 0 To UBound($MyTroopsButton) - 1
;~ 		If $MyTroopsButton[$i][1] = 0 Then
;~ 			ReDim $aTemp[$iCount + 1][3]
;~ 			$aTemp[$iCount][0] = $MyTroopsButton[$i][0]
;~ 			$aTemp[$iCount][1] = $MyTroopsButton[$i][1]
;~ 			$aTemp[$iCount][2] = $MyTroopsButton[$i][2]
;~ 			$iCount += 1
;~ 		EndIf
;~ 	Next

;~ 	_ArraySort($aTemp,0,0,0,2)
;~ 	For $i = 0 to 6
;~ 		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftTroopElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iUpperRowY1,$iUpperLeftTroopElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iUpperRowY2)
;~ 		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[$i][0] & "_92", True)
;~ 		If $hHBitmapTest <> 0 Then
;~ 			GdiDeleteHBitmap($hHBitmapTest)
;~ 		EndIf
;~ 	Next
;~ 	For $i = 0 to 0
;~ 		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iUpperRowY1,$iUpperLeftTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iUpperRowY2)
;~ 		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[7][0] & "_92", True)
;~ 		If $hHBitmapTest <> 0 Then
;~ 			GdiDeleteHBitmap($hHBitmapTest)
;~ 		EndIf
;~ 	Next

;~ 	Local $aTemp[1][3]
;~ 	$iCount = 0
;~ 	For $i = 0 To UBound($MyTroopsButton) - 1
;~ 		If $MyTroopsButton[$i][1] = 1 Then
;~ 			ReDim $aTemp[$iCount + 1][3]
;~ 			$aTemp[$iCount][0] = $MyTroopsButton[$i][0]
;~ 			$aTemp[$iCount][1] = $MyTroopsButton[$i][1]
;~ 			$aTemp[$iCount][2] = $MyTroopsButton[$i][2]
;~ 			$iCount += 1
;~ 		EndIf
;~ 	Next
;~ 	_ArraySort($aTemp,0,0,0,2)
;~ 	For $i = 0 to 6
;~ 		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftTroopElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iLowerRowY1,$iUpperLeftTroopElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iLowerRowY2)
;~ 		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[$i][0] & "_92", True)
;~ 		If $hHBitmapTest <> 0 Then
;~ 			GdiDeleteHBitmap($hHBitmapTest)
;~ 		EndIf
;~ 	Next

;~ 	For $i = 0 to 0
;~ 		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iLowerRowY1,$iUpperLeftTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iLowerRowY2)
;~ 		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[7][0] & "_92", True)
;~ 		If $hHBitmapTest <> 0 Then
;~ 			GdiDeleteHBitmap($hHBitmapTest)
;~ 		EndIf
;~ 	Next

;~ 	If CheckNeedSwipe(19) = False Then
;~ 		SetLog("Cannot click drag to select troop" , $COLOR_ERROR)
;~ 		Return
;~ 	EndIf

;~ 	Sleep(1000)

;~ 	_CaptureRegion2()

;~ 	Local $aTemp[1][3]
;~ 	$iCount = 0
;~ 	For $i = 0 To UBound($MyTroopsButton) - 1
;~ 		If $MyTroopsButton[$i][1] = 2 Then
;~ 			ReDim $aTemp[$iCount + 1][3]
;~ 			$aTemp[$iCount][0] = $MyTroopsButton[$i][0]
;~ 			$aTemp[$iCount][1] = $MyTroopsButton[$i][1]
;~ 			$aTemp[$iCount][2] = $MyTroopsButton[$i][2]
;~ 			$iCount += 1
;~ 		EndIf
;~ 	Next
;~ 	_ArraySort($aTemp,0,0,0,2)
;~ 	For $i = 0 to $iCount - 1
;~ 		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperRightTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iUpperRowY1,$iUpperRightTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iUpperRowY2)
;~ 		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[$i][0] & "_92", True)
;~ 		If $hHBitmapTest <> 0 Then
;~ 			GdiDeleteHBitmap($hHBitmapTest)
;~ 		EndIf
;~ 	Next

;~ 	Local $aTemp[1][3]
;~ 	$iCount = 0
;~ 	For $i = 0 To UBound($MyTroopsButton) - 1
;~ 		If $MyTroopsButton[$i][1] = 3 Then
;~ 			ReDim $aTemp[$iCount + 1][3]
;~ 			$aTemp[$iCount][0] = $MyTroopsButton[$i][0]
;~ 			$aTemp[$iCount][1] = $MyTroopsButton[$i][1]
;~ 			$aTemp[$iCount][2] = $MyTroopsButton[$i][2]
;~ 			$iCount += 1
;~ 		EndIf
;~ 	Next
;~ 	_ArraySort($aTemp,0,0,0,2)
;~ 	For $i = 0 to $iCount - 1
;~ 		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperRightTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iLowerRowY1,$iUpperRightTroopDarkElixirStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iLowerRowY2)
;~ 		_debugSaveHBitmapToImage($hHBitmapTest, $aTemp[$i][0] & "_92", True)
;~ 		If $hHBitmapTest <> 0 Then
;~ 			GdiDeleteHBitmap($hHBitmapTest)
;~ 		EndIf
;~ 	Next

;~ 	If gotoBrewSpells() = False Then Return
;~ 	RemoveAllPreTrainTroops()

;~ 	Local $iUpperLeftSpellStartOffset = 26
;~ 	Local $iUpperLeftDarkSpellStartOffset = 329
	Local $iUpperLeftDarkSpellStartOffset = 423 ; event 25-08

;~ 	_CaptureRegion2()
;~ 	Local $aTemp[1][3]
;~ 	$iCount = 0
;~ 	For $i = 0 To UBound($MySpellsButton) - 1
;~ 		If $MySpellsButton[$i][1] = 0 Then
;~ 			ReDim $aTemp[$iCount + 1][3]
;~ 			$aTemp[$iCount][0] = $MySpellsButton[$i][0]
;~ 			$aTemp[$iCount][1] = $MySpellsButton[$i][1]
;~ 			$aTemp[$iCount][2] = $MySpellsButton[$i][2]
;~ 			$iCount += 1
;~ 		EndIf
;~ 	Next
;~ 	_ArraySort($aTemp,0,0,0,2)
;~ 	For $i = 0 to 2
;~ 		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iUpperRowY1,$iUpperLeftSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iUpperRowY2)
;~ 		_debugSaveHBitmapToImage($hHBitmapTest, "Spell" & $aTemp[$i][0] & "_93", True)
;~ 		If $hHBitmapTest <> 0 Then
;~ 			GdiDeleteHBitmap($hHBitmapTest)
;~ 		EndIf
;~ 	Next
;~ 	For $i = 0 to 1
;~ 		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftDarkSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iUpperRowY1,$iUpperLeftDarkSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iUpperRowY2)
;~ 		_debugSaveHBitmapToImage($hHBitmapTest, "Spell" & $aTemp[$i + 3][0] & "_93", True)
;~ 		If $hHBitmapTest <> 0 Then
;~ 			GdiDeleteHBitmap($hHBitmapTest)
;~ 		EndIf
;~ 	Next

;~ 	Local $aTemp[1][3]
;~ 	$iCount = 0
;~ 	For $i = 0 To UBound($MySpellsButton) - 1
;~ 		If $MySpellsButton[$i][1] = 1 Then
;~ 			ReDim $aTemp[$iCount + 1][3]
;~ 			$aTemp[$iCount][0] = $MySpellsButton[$i][0]
;~ 			$aTemp[$iCount][1] = $MySpellsButton[$i][1]
;~ 			$aTemp[$iCount][2] = $MySpellsButton[$i][2]
;~ 			$iCount += 1
;~ 		EndIf
;~ 	Next
;~ 	_ArraySort($aTemp,0,0,0,2)
;~ 	For $i = 0 to 2
;~ 		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iLowerRowY1,$iUpperLeftSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iLowerRowY2)
;~ 		_debugSaveHBitmapToImage($hHBitmapTest, "Spell" & $aTemp[$i][0] & "_93", True)
;~ 		If $hHBitmapTest <> 0 Then
;~ 			GdiDeleteHBitmap($hHBitmapTest)
;~ 		EndIf
;~ 	Next
;~ 	For $i = 0 to 1
;~ 		Local $hHBitmapTest = GetHHBitmapArea($g_hHBitmap2, $iUpperLeftDarkSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset ,$iLowerRowY1,$iUpperLeftDarkSpellStartOffset + ($iSlotWidth * $i) + $iStartingOffset + 20, $iLowerRowY2)
;~ 		_debugSaveHBitmapToImage($hHBitmapTest, "Spell" & $aTemp[$i + 3][0] & "_93", True)
;~ 		If $hHBitmapTest <> 0 Then
;~ 			GdiDeleteHBitmap($hHBitmapTest)
;~ 		EndIf
;~ 	Next
;~ 	SetLog("MakeTroopsAndSpellsTrainImage END")
;~ 	$g_bRunState = $currentRunState
;~ EndFunc
