; #FUNCTION# ====================================================================================================================
; Name ..........:
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........: Samkie (25 Jun 2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func gotoArmy()
	Local $iCount = 0
	While 1
		ForceCaptureRegion()
		_CaptureRegion()
		If _ColorCheck(_GetPixelColor($aButtonClose1[4],$aButtonClose1[5], False), Hex($aButtonClose1[6], 6), $aButtonClose1[7]) = True Then
			If _ColorCheck(_GetPixelColor($aButtonArmyTab[4],$aButtonArmyTab[5], False), Hex($aButtonArmyTab[6], 6), $aButtonArmyTab[7]) = False Then
				ClickP($aButtonArmyTab,1,0,"ArmyTab")
			Else
				ExitLoop
			EndIf
		EndIf
		$iCount += 1
		If $iCount >= 15 Then
			setlog("Failed to open army page.", $COLOR_ERROR)
			Return False
		EndIf
		If _Sleep(100) Then Return
	WEnd
	If _Sleep(100) Then Return
	Return True
EndFunc

Func gotoTrainTroops()
	Local $iCount = 0
	While 1
		ForceCaptureRegion()
		_CaptureRegion()
		If _ColorCheck(_GetPixelColor($aButtonClose1[4],$aButtonClose1[5], False), Hex($aButtonClose1[6], 6), $aButtonClose1[7]) = True Then
			If _ColorCheck(_GetPixelColor($aButtonTrainTroopsTab[4],$aButtonTrainTroopsTab[5], False), Hex($aButtonTrainTroopsTab[6], 6), $aButtonTrainTroopsTab[7]) = False Then
				ClickP($aButtonTrainTroopsTab,1,0,"TrainTroopsTab")
			Else
				ExitLoop
			EndIf
		EndIf
		$iCount += 1
		If $iCount >= 15 Then
			setlog("Failed to open train troops page.", $COLOR_ERROR)
			Return False
		EndIf
		If _Sleep(100) Then Return
	WEnd
	If _Sleep(100) Then Return
	Return True
EndFunc

Func gotoBrewSpells()
	Local $iCount = 0
	While 1
		ForceCaptureRegion()
		_CaptureRegion()
		If _ColorCheck(_GetPixelColor($aButtonClose1[4],$aButtonClose1[5], False), Hex($aButtonClose1[6], 6), $aButtonClose1[7]) = True Then
			If _ColorCheck(_GetPixelColor($aButtonBrewSpellsTab[4],$aButtonBrewSpellsTab[5], False), Hex($aButtonBrewSpellsTab[6], 6), $aButtonBrewSpellsTab[7]) = False Then
				ClickP($aButtonBrewSpellsTab,1,0,"BrewSpellsTab")
			Else
				ExitLoop
			EndIf
		EndIf
		$iCount += 1
		If $iCount >= 15 Then
			setlog("Failed to open brew spells page.", $COLOR_ERROR)
			Return False
		EndIf
		If _Sleep(100) Then Return
	WEnd
	If _Sleep(100) Then Return
	Return True
EndFunc

Func gotoQuickTrain()
	Local $iCount = 0
	While 1
		ForceCaptureRegion()
		_CaptureRegion()
		If _ColorCheck(_GetPixelColor($aButtonClose1[4],$aButtonClose1[5], False), Hex($aButtonClose1[6], 6), $aButtonClose1[7]) = True Then
			If _ColorCheck(_GetPixelColor($aButtonQuickTrainTab[4],$aButtonQuickTrainTab[5], False), Hex($aButtonQuickTrainTab[6], 6), $aButtonQuickTrainTab[7]) = False Then
				ClickP($aButtonQuickTrainTab,1,0,"QuickTrainTab")
			Else
				ExitLoop
			EndIf
		EndIf
		$iCount += 1
		If $iCount >= 15 Then
			setlog("Failed to open quick train page.", $COLOR_ERROR)
			Return False
		EndIf
		If _Sleep(100) Then Return
	WEnd
	If _Sleep(100) Then Return
	Return True
EndFunc