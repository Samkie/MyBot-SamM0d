; #FUNCTION# ====================================================================================================================
; Name ..........: CheckAvailableUnit
; Description ...: Reads current quanitites/type of troops from Training window, updates $CurXXXXX (Current available unit)
;                  and also update $g_avDTtroopsToBeUsed for drop trophy
;                  remove excess unit will be done by here if enable by user at GUI
; Syntax ........: CheckAvailableUnit
; Parameters ....: $hHBitmap
;
; Return values .: None
; Author ........: Samkie (27 Jun 2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func CheckAvailableUnit($hHBitmap)
	If $g_iSamM0dDebug = 1 Then SetLog("============Start CheckAvailableUnit ============")
	SetLog("Start check available unit...", $COLOR_INFO)

	; reset variable
	For $i = 0 To UBound($MyTroops) - 1
		Assign("cur" & $MyTroops[$i][0], 0)
	Next
	For $i = 0 To 6
		Assign("RemSlot" & $i + 1, 0)
	Next

	; 重建构_captureregion()里的?量$g_hHBitmap，$g_hBitmap，?_GetPixelColor()使用
	If $g_hHBitmap <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap)
	EndIf
	$g_hHBitmap = GetHHBitmapArea($hHBitmap)
	If $g_hBitmap <> 0 Then
		GdiDeleteBitmap($g_hBitmap)
	EndIf
	$g_hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap)

	Local $aiTroopsInfo[7][3]
	Local $AvailableCamp = 0
	Local $sDirectory = $g_sSamM0dImageLocation & "\Troops\"
	Local $sOriDirectory = @ScriptDir & "\COCBot\SamM0d\Images\Troops\"
	Local $returnProps="objectname"
	Local $aPropsValues
	Local $iTroopIndex = -1
	Local $sTroopName = ""
	Local $bDeletedExcess = False

	For $i = 0 To 6
		If _ColorCheck(_GetPixelColor(Int(30 + ($g_iArmy_Av_Troop_Slot_Width * $i)),205,False), Hex(0X4689C8, 6), 20) Then
		;If Not _ColorCheck(_GetPixelColor(Int(30 + ($g_iArmy_Av_Troop_Slot_Width * $i)),205,False), Hex(0XCDCCC6, 6), 20) Then
			Local $iPixelDivider = ($g_iArmy_RegionSizeForScan - ($g_aiArmyAvailableSlot[3] - $g_aiArmyAvailableSlot[1])) / 2
			Assign("g_hHBitmap_Av_Slot" & $i + 1, GetHHBitmapArea($hHBitmap, Int($g_aiArmyAvailableSlot[0] + ($g_iArmy_Av_Troop_Slot_Width* $i) + (($g_iArmy_Av_Troop_Slot_Width - $g_iArmy_RegionSizeForScan) / 2)), $g_aiArmyAvailableSlot[1] - $iPixelDivider, Int($g_aiArmyAvailableSlot[0] + ($g_iArmy_Av_Troop_Slot_Width* $i) + (($g_iArmy_Av_Troop_Slot_Width- $g_iArmy_RegionSizeForScan) / 2) + $g_iArmy_RegionSizeForScan), $g_aiArmyAvailableSlot[3] + $iPixelDivider))
			Assign("g_hHBitmap_Capture_Av_Slot" & $i + 1, GetHHBitmapArea($hHBitmap, Int($g_aiArmyAvailableSlot[0] + ($g_iArmy_Av_Troop_Slot_Width* $i) + (($g_iArmy_Av_Troop_Slot_Width - $g_iArmy_ImageSizeForScan) / 2)), $g_aiArmyAvailableSlot[1], Int($g_aiArmyAvailableSlot[0] + ($g_iArmy_Av_Troop_Slot_Width* $i) + (($g_iArmy_Av_Troop_Slot_Width- $g_iArmy_ImageSizeForScan) / 2) + $g_iArmy_ImageSizeForScan), $g_aiArmyAvailableSlot[3]))

			Local $result = findMultiImage(Eval("g_hHBitmap_Av_Slot" & $i + 1), $sDirectory ,"FV" ,"FV", 0, 1000, 1 , $returnProps)
			Local $bExitLoopFlag = False
			Local $bContinueNextLoop = False

			If IsArray($result) then
				For $j = 0 To UBound($result) -1
					If $j = 0 Then
						$aPropsValues = $result[$j] ; should be return objectname
						If UBound($aPropsValues) = 1 then
							$aiTroopsInfo[$i][0] = $aPropsValues[0] ; objectname
							;SetLog("objectname: " & $aiTroopsInfo[$i][0], $COLOR_DEBUG)
							$aiTroopsInfo[$i][2] = $i + 1
						EndIf
					ElseIf $j = 1 Then
						$aPropsValues = $result[$j]
						SetLog("Error: Multiple detect troops on slot: " & $i + 1 , $COLOR_ERROR)
						SetLog("Troop: " & $aiTroopsInfo[$i][0], $COLOR_ERROR)
						SetLog("Troop: " & $aPropsValues[0], $COLOR_ERROR)
					Else
						$aPropsValues = $result[$j]
						SetLog("Troop: " & $aPropsValues[0], $COLOR_ERROR)
					EndIf
				Next
				If $aPropsValues[0]  = "0" Then $bExitLoopFlag = True
			Else
				Local $iPixelDivider = ($g_iArmy_EnlargeRegionSizeForScan - ($g_aiArmyAvailableSlot[3] - $g_aiArmyAvailableSlot[1])) / 2
				Local $temphHBitmap = GetHHBitmapArea($hHBitmap, Int($g_aiArmyAvailableSlot[0] + ($g_iArmy_Av_Troop_Slot_Width* $i) + (($g_iArmy_Av_Troop_Slot_Width - $g_iArmy_EnlargeRegionSizeForScan) / 2)), $g_aiArmyAvailableSlot[1] - $iPixelDivider, Int($g_aiArmyAvailableSlot[0] + ($g_iArmy_Av_Troop_Slot_Width* $i) + (($g_iArmy_Av_Troop_Slot_Width - $g_iArmy_EnlargeRegionSizeForScan) / 2) + $g_iArmy_EnlargeRegionSizeForScan), $g_aiArmyAvailableSlot[3] + $iPixelDivider)
				_debugSaveHBitmapToImage($temphHBitmap, "Troop_Av_Slot_" & $i + 1, True)
				_debugSaveHBitmapToImage(Eval("g_hHBitmap_Capture_Av_Slot" & $i + 1), "Troop_Slot_" & $i + 1 & "_Unknown_RenameThis_92", True)
				If $temphHBitmap <> 0 Then
					GdiDeleteHBitmap($temphHBitmap)
				EndIf
				SetLog("Error: Cannot detect what troops on slot: " & $i + 1 , $COLOR_ERROR)
				SetLog("Please check the filename: Troop_Slot_" & $i + 1 & "_Unknown_RenameThis_92.png", $COLOR_ERROR)
				SetLog("Locate at:" & @ScriptDir & "\profiles\" & $g_sProfileCurrentName & "\SamM0d Debug\Images\", $COLOR_ERROR)
				SetLog("Rename the correct filename and replace back to file location: " & $sOriDirectory, $COLOR_ERROR)
				SetLog("And then restart the bot.", $COLOR_ERROR)
				$bContinueNextLoop = True
			EndIf

			If $bExitLoopFlag = True Then ExitLoop
			If $bContinueNextLoop Then
				ContinueLoop
			EndIf

			Assign("g_hHBitmap_Av_SlotQty" & $i + 1, GetHHBitmapArea($hHBitmap, Int($g_aiArmyAvailableSlotQty[0] + ($g_iArmy_Av_Troop_Slot_Width* $i) + (($g_iArmy_Av_Troop_Slot_Width- 60) / 2)), $g_aiArmyAvailableSlotQty[1], Int($g_aiArmyAvailableSlotQty[0] + ($g_iArmy_Av_Troop_Slot_Width* $i) + (($g_iArmy_Av_Troop_Slot_Width- 60) / 2) + 60), $g_aiArmyAvailableSlotQty[3]))

			$aiTroopsInfo[$i][1] = getMyOcr(Eval("g_hHBitmap_Av_SlotQty" & $i + 1),0,0,0,0,"ArmyQTY", True)

			If $aiTroopsInfo[$i][1] <> 0 Then
				$iTroopIndex = TroopIndexLookup($aiTroopsInfo[$i][0])
				$sTroopName = MyNameOfTroop($iTroopIndex, $aiTroopsInfo[$i][1])

				SetLog(" - No. of Available " & $sTroopName & ": " & $aiTroopsInfo[$i][1], ($iTroopIndex > 11 ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))
				Assign("cur" & $aiTroopsInfo[$i][0], $aiTroopsInfo[$i][1])

				; assign variable for drop trophy troops type
				For $j = 0 To UBound($g_avDTtroopsToBeUsed) - 1
					If $g_avDTtroopsToBeUsed[$j][0] = $aiTroopsInfo[$i][0] Then
						$g_avDTtroopsToBeUsed[$j][1] = $aiTroopsInfo[$i][1]
						ExitLoop
					EndIf
				Next

				$AvailableCamp += ($aiTroopsInfo[$i][1] * $MyTroops[Eval("e" & $aiTroopsInfo[$i][0])][2])

				If $ichkEnableDeleteExcessTroops = 1 Then
					If $aiTroopsInfo[$i][1] > $MyTroops[Eval("e" & $aiTroopsInfo[$i][0])][3] Then
						$bDeletedExcess = True
						SetLog(" >>> excess: " & $aiTroopsInfo[$i][1] - $MyTroops[Eval("e" & $aiTroopsInfo[$i][0])][3],$COLOR_RED)
						Assign("RemSlot" & $aiTroopsInfo[$i][2],$aiTroopsInfo[$i][1] - $MyTroops[Eval("e" & $aiTroopsInfo[$i][0])][3])
						If $g_iSamM0dDebug = 1 Then SetLog("Set Remove Slot: " & $aiTroopsInfo[$i][2])
					EndIf
				EndIf

				; assign variable for drop trophy troops type
				For $j = 0 To UBound($g_avDTtroopsToBeUsed) - 1
					If $g_avDTtroopsToBeUsed[$j][0] = $aiTroopsInfo[$i][0] Then
						$g_avDTtroopsToBeUsed[$j][1] = $aiTroopsInfo[$i][1]
						ExitLoop
					EndIf
				Next
			Else
				SetLog("Error detect quantity no. On Troop: " & MyNameOfTroop(Eval("e" & $aiTroopsInfo[$i][0]), $aiTroopsInfo[$i][1]),$COLOR_RED)
				ExitLoop
			EndIf
		EndIf
	Next

	If $AvailableCamp <> $g_CurrentCampUtilization Then
		If $ichkEnableDeleteExcessTroops = 1 Then
			SetLog("Error: Troops size for all available Unit: " & $AvailableCamp & "  -  Camp: " & $g_CurrentCampUtilization, $COLOR_RED)
			$g_bRestartCheckTroop = True
			Return False
		EndIf
	EndIf

		If $bDeletedExcess Then
			$bDeletedExcess = False
			If gotoTrainTroops() = False Then Return
			If Not _ColorCheck(_GetPixelColor(823, 175 + $g_iMidOffsetY, True), Hex(0xCFCFC8, 6), 20) Then
				SetLog(" >>> stop train troops.", $COLOR_RED)
				RemoveAllTroopAlreadyTrain()
				Return False
			EndIf

			If gotoArmy() = False Then Return
			SetLog(" >>> remove excess troops.", $COLOR_RED)
			If WaitforPixel($aButtonEditArmy[4],$aButtonEditArmy[5],$aButtonEditArmy[4]+1,$aButtonEditArmy[5]+1,Hex($aButtonEditArmy[6], 6), $aButtonEditArmy[7],20) Then
				Click($aButtonEditArmy[0],$aButtonEditArmy[1],1,0,"#EditArmy")
			Else
				Return False
			EndIf

			If WaitforPixel($aButtonEditCancel[4],$aButtonEditCancel[5],$aButtonEditCancel[4]+1,$aButtonEditCancel[5]+1,Hex($aButtonEditCancel[6], 6), $aButtonEditCancel[7],20) Then
				For $i = 10 To 0 Step -1
					Local $RemoveSlotQty = Eval("RemSlot" & $i + 1)
					If $g_iSamM0dDebug = 1 Then SetLog($i & " $RemoveSlotQty: " & $RemoveSlotQty)
					If $RemoveSlotQty > 0 Then
						Local $iRx = (80 + ($g_iArmy_Av_Troop_Slot_Width * $i))
						Local $iRy = 240 + $g_iMidOffsetY
						For $j = 1 To $RemoveSlotQty
							Click(Random($iRx-2,$iRx+2,1),Random($iRy-2,$iRy+2,1))
							If _Sleep($g_iTrainClickDelay) Then Return
						Next
						Assign("RemSlot" & $i + 1, 0)
					EndIf
				Next
			Else
				Return False
			EndIf

			If WaitforPixel($aButtonEditOkay[4],$aButtonEditOkay[5],$aButtonEditOkay[4]+1,$aButtonEditOkay[5]+1,Hex($aButtonEditOkay[6], 6), $aButtonEditOkay[7],20) Then
				Click($aButtonEditOkay[0],$aButtonEditOkay[1],1,0,"#EditArmyOkay")
			Else
				Return False
			EndIf

			ClickOkay()
			$g_bRestartCheckTroop = True
			If WaitforPixel($aButtonEditArmy[4],$aButtonEditArmy[5],$aButtonEditArmy[4]+1,$aButtonEditArmy[5]+1,Hex($aButtonEditArmy[6], 6), $aButtonEditArmy[7],20) Then
				Return False
			Else
				If _Sleep(1000) Then Return False
			EndIf
			Return False
		EndIf
		If $g_hHBitmap <> 0 Then
			GdiDeleteHBitmap($g_hHBitmap)
		EndIf
		If $g_hBitmap <> 0 Then
			GdiDeleteBitmap($g_hBitmap)
		EndIf
		Return True

	Return False
EndFunc
