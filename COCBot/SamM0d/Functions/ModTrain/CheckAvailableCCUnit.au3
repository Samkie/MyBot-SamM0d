; #FUNCTION# ====================================================================================================================
; Name ..........: CheckAvailableCCUnit
; Description ...: Reads current cc troops from Training window
;                  remove it if not needed.
; Syntax ........: CheckAvailableCCUnit()
; Parameters ....:
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
Func CheckAvailableCCUnit()
	If $g_iSamM0dDebug = 1 Then SetLog("============Start CheckAvailableCCUnit ============")
	If $g_iChkWait4CC = 0 Then Return True
	SetLog("Start check available clan castle unit...", $COLOR_INFO)
	Local $iCount = 0

	While 1
		$iCount += 1
		If $iCount > 3 then ExitLoop

		Local $aiTroopsInfo[6][3]
		Local $sDirectory = $g_sSamM0dImageLocation & "\Troops\CC\"
		Local $sOriDirectory = @ScriptDir & "\COCBot\SamM0d\Images\Troops\CC\"
		Local $returnProps="objectname"
		Local $aPropsValues
		Local $bDeletedExcess = False
		Local $iTroopsCount = 0

		DeleteHBitmap4CheckAvailableCCUnit()
		If _Sleep(250) Then ExitLoop
		_CaptureRegion2()

		; reset variable
		For $i = 0 To UBound($MyTroops) - 1
			Assign("curCC" & $MyTroops[$i][0], 0)
			Assign("RemoveUnitOfcurCC" & $MyTroops[$i][0], 0)
		Next

		For $i = 0 To 5
			Local $iPixelDivider = ($g_iArmy_RegionSizeForScan - ($g_aiArmyAvailableCCSlot[3] - $g_aiArmyAvailableCCSlot[1])) / 2
			Assign("g_hHBitmap_Av_CC_Slot" & $i + 1, GetHHBitmapArea($g_hHBitmap2, Int($g_aiArmyAvailableCCSlot[0] + ($g_iArmy_Av_CC_Slot_Width * $i) + (($g_iArmy_Av_CC_Slot_Width - $g_iArmy_RegionSizeForScan) / 2)), $g_aiArmyAvailableCCSlot[1] - $iPixelDivider, Int($g_aiArmyAvailableCCSlot[0] + ($g_iArmy_Av_CC_Slot_Width * $i) + (($g_iArmy_Av_CC_Slot_Width - $g_iArmy_RegionSizeForScan) / 2) + $g_iArmy_RegionSizeForScan), $g_aiArmyAvailableCCSlot[3] + $iPixelDivider))
			Assign("g_hHBitmap_Capture_Av_CC_Slot" & $i + 1, GetHHBitmapArea($g_hHBitmap2, Int($g_aiArmyAvailableCCSlot[0] + ($g_iArmy_Av_CC_Slot_Width* $i) + (($g_iArmy_Av_CC_Slot_Width - $g_iArmy_ImageSizeForScan) / 2)), $g_aiArmyAvailableCCSlot[1], Int($g_aiArmyAvailableCCSlot[0] + ($g_iArmy_Av_CC_Slot_Width* $i) + (($g_iArmy_Av_CC_Slot_Width- $g_iArmy_ImageSizeForScan) / 2) + $g_iArmy_ImageSizeForScan), $g_aiArmyAvailableCCSlot[3]))

			Local $result = findMultiImage(Eval("g_hHBitmap_Av_CC_Slot" & $i + 1), $sDirectory ,"FV" ,"FV", 0, 1000, 1 , $returnProps)
			Local $bExitLoopFlag = False
			Local $bContinueNextLoop = False

			If IsArray($result) then
				For $j = 0 To UBound($result) -1
					If $j = 0 Then
						$aPropsValues = $result[$j] ; should be return objectname
						If UBound($aPropsValues) = 1 then
							If  $aPropsValues[0] <> "0" Then
								$aiTroopsInfo[$i][0] = $aPropsValues[0] ; objectname
								$aiTroopsInfo[$i][2] = $i + 1
								$iTroopsCount += 1
							EndIf
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
				Local $iPixelDivider = ($g_iArmy_EnlargeRegionSizeForScan - ($g_aiArmyAvailableCCSlot[3] - $g_aiArmyAvailableCCSlot[1])) / 2
				Local $temphHBitmap = GetHHBitmapArea($g_hHBitmap2, Int($g_aiArmyAvailableCCSlot[0] + ($g_iArmy_Av_CC_Slot_Width * $i) + (($g_iArmy_Av_CC_Slot_Width - $g_iArmy_EnlargeRegionSizeForScan) / 2)), $g_aiArmyAvailableCCSlot[1] - $iPixelDivider, Int($g_aiArmyAvailableCCSlot[0] + ($g_iArmy_Av_CC_Slot_Width* $i) + (($g_iArmy_Av_CC_Slot_Width - $g_iArmy_EnlargeRegionSizeForScan) / 2) + $g_iArmy_EnlargeRegionSizeForScan), $g_aiArmyAvailableCCSlot[3] + $iPixelDivider)
				_debugSaveHBitmapToImage($temphHBitmap, "Troop_Av_CC_Slot_" & $i + 1, True)
				_debugSaveHBitmapToImage(Eval("g_hHBitmap_Capture_Av_CC_Slot" & $i + 1), "Troop_CC_Slot_" & $i + 1 & "_Unknown_RenameThis_92", True)
				If $temphHBitmap <> 0 Then
					GdiDeleteHBitmap($temphHBitmap)
				EndIf
				SetLog("Error: Cannot detect what cc troops on slot: " & $i + 1 , $COLOR_ERROR)
				SetLog("Please check the filename: Troop_CC_Slot_" & $i + 1 & "_Unknown_RenameThis_92.png", $COLOR_ERROR)
				SetLog("Locate at:" & @ScriptDir & "\profiles\" & $g_sProfileCurrentName & "\SamM0d Debug\Images\", $COLOR_ERROR)
				SetLog("Rename the correct filename and replace back to file location: " & $sOriDirectory, $COLOR_ERROR)
				SetLog("And then restart the bot.", $COLOR_ERROR)
				$bContinueNextLoop = True
			EndIf

			If $bExitLoopFlag = True Then ExitLoop
			If $bContinueNextLoop Then
				ContinueLoop
			EndIf

			Assign("g_hHBitmap_Av_CC_SlotQty" & $i + 1, GetHHBitmapArea($g_hHBitmap2, Int($g_aiArmyAvailableCCSlotQty[0] + ($g_iArmy_Av_CC_Slot_Width* $i) + (($g_iArmy_Av_CC_Slot_Width - $g_iArmy_QtyWidthForScan) / 2)), $g_aiArmyAvailableCCSlotQty[1], Int($g_aiArmyAvailableCCSlotQty[0] + ($g_iArmy_Av_CC_Slot_Width* $i) + (($g_iArmy_Av_CC_Slot_Width- $g_iArmy_QtyWidthForScan) / 2) + $g_iArmy_QtyWidthForScan), $g_aiArmyAvailableCCSlotQty[3]))

			$aiTroopsInfo[$i][1] = getMyOcr(Eval("g_hHBitmap_Av_CC_SlotQty" & $i + 1),0,0,0,0,"ArmyQTY", True)

			If $aiTroopsInfo[$i][1] <> 0 Then
				Assign("curCC" & $aiTroopsInfo[$i][0], Eval("curCC" & $aiTroopsInfo[$i][0]) + $aiTroopsInfo[$i][1])
			Else
				SetLog("Error detect quantity no. On CC Troop: " & MyNameOfTroop(Eval("e" & $aiTroopsInfo[$i][0]), $aiTroopsInfo[$i][1]),$COLOR_RED)
				ExitLoop
			EndIf
		Next

		If $iTroopsCount = 0 Then
			SetLog("No Army On Clan Castle.",$COLOR_ERROR)
			ExitLoop
		EndIf

		For $i = 0 To UBound($MyTroops) - 1
			Local $itempTotal = Eval("curCC" & $MyTroops[$i][0])
			If $itempTotal > 0 Then
				SetLog(" - No. of Available CC Troops - " & MyNameOfTroop(Eval("e" & $MyTroops[$i][0]),  Eval("curCC" & $MyTroops[$i][0])) & ": " &  Eval("curCC" & $MyTroops[$i][0]), (Eval("enum" & $MyTroops[$i][0]) > 5 ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))
				Local $bIsTroopInKeepList = False
				If $iCCTroopSlot1 Or $iCCTroopSlot2 Or $iCCTroopSlot3 Then
					For $j = 1 To 3
						If Eval("e" & $MyTroops[$i][0]) + 1 = Eval("iCCTroopSlot" & $j) Then
							$bIsTroopInKeepList = True
							If $itempTotal > Eval("iCCTroopSlotQty" & $j) Then
								Assign("RemoveUnitOfcurCC" & $MyTroops[$i][0], $itempTotal - Eval("iCCTroopSlotQty" & $j))
								$bDeletedExcess = True
							EndIf
							ExitLoop
						EndIf
					Next
					If $bIsTroopInKeepList = False Then
						Assign("RemoveUnitOfcurCC" & $MyTroops[$i][0], $itempTotal)
						$bDeletedExcess = True
					EndIf
				EndIf
			EndIf
		Next

		If $bDeletedExcess Then
			$bDeletedExcess = False
			SetLog(" >>> remove excess cc troops.", $COLOR_RED)
			If WaitforPixel($aButtonEditArmy[4],$aButtonEditArmy[5],$aButtonEditArmy[4]+1,$aButtonEditArmy[5]+1,Hex($aButtonEditArmy[6], 6), $aButtonEditArmy[7],20) Then
				Click($aButtonEditArmy[0],$aButtonEditArmy[1],1,0,"#EditArmy")
			Else
				ExitLoop
			EndIf

			If WaitforPixel($aButtonEditCancel[4],$aButtonEditCancel[5],$aButtonEditCancel[4]+1,$aButtonEditCancel[5]+1,Hex($aButtonEditCancel[6], 6), $aButtonEditCancel[7],20) Then
				For $i = 0 To 5
					If $aiTroopsInfo[$i][1] <> 0 Then
						; 檢查這個兵種是否要刪除
						Local $iUnitToRemove = Eval("RemoveUnitOfcurCC" & $aiTroopsInfo[$i][0])
						If $iUnitToRemove > 0 Then
							If $aiTroopsInfo[$i][1] > $iUnitToRemove Then
								SetLog("Remove " & MyNameOfTroop(Eval("e" & $aiTroopsInfo[$i][0]),  $aiTroopsInfo[$i][1]) & " at slot: " & $aiTroopsInfo[$i][2] & ", unit to remove: " & $iUnitToRemove, $COLOR_ACTION)
								RemoveCCTroops($aiTroopsInfo[$i][2]-1, $iUnitToRemove)
								$iUnitToRemove = 0
								Assign("RemoveUnitOfcurCC" & $aiTroopsInfo[$i][0], $iUnitToRemove)
							Else
								SetLog("Remove " & MyNameOfTroop(Eval("e" & $aiTroopsInfo[$i][0]),  $aiTroopsInfo[$i][1]) & " at slot: " & $aiTroopsInfo[$i][2] & ", unit to remove: " & $aiTroopsInfo[$i][1], $COLOR_ACTION)
								RemoveCCTroops($aiTroopsInfo[$i][2]-1, $aiTroopsInfo[$i][1])
								$iUnitToRemove -= $aiTroopsInfo[$i][1]
								Assign("RemoveUnitOfcurCC" & $aiTroopsInfo[$i][0], $iUnitToRemove)
							EndIf
						EndIf
					EndIf
				Next
			Else
				ExitLoop
			EndIf

			If WaitforPixel($aButtonEditOkay[4],$aButtonEditOkay[5],$aButtonEditOkay[4]+1,$aButtonEditOkay[5]+1,Hex($aButtonEditOkay[6], 6), $aButtonEditOkay[7],20) Then
				Click($aButtonEditOkay[0],$aButtonEditOkay[1],1,0,"#EditArmyOkay")
			Else
				ExitLoop
			EndIf

			ClickOkay()
			If WaitforPixel($aButtonEditArmy[4],$aButtonEditArmy[5],$aButtonEditArmy[4]+1,$aButtonEditArmy[5]+1,Hex($aButtonEditArmy[6], 6), $aButtonEditArmy[7],20) Then
				ContinueLoop
			Else
				If _Sleep(1000) Then ExitLoop
			EndIf
			ContinueLoop
		EndIf

		ExitLoop
	WEnd
	If $g_iSamM0dDebugImage = 1 Then
		_debugSaveHBitmapToImage($g_hHBitmap_Av_CC_Slot1, "ArmyTab_CCTroop_Slot1")
		_debugSaveHBitmapToImage($g_hHBitmap_Av_CC_Slot2, "ArmyTab_CCTroop_Slot2")
		_debugSaveHBitmapToImage($g_hHBitmap_Av_CC_Slot3, "ArmyTab_CCTroop_Slot3")
		_debugSaveHBitmapToImage($g_hHBitmap_Av_CC_Slot4, "ArmyTab_CCTroop_Slot4")
		_debugSaveHBitmapToImage($g_hHBitmap_Av_CC_Slot5, "ArmyTab_CCTroop_Slot5")
		_debugSaveHBitmapToImage($g_hHBitmap_Av_CC_Slot6, "ArmyTab_CCTroop_Slot6")
		_debugSaveHBitmapToImage($g_hHBitmap_Av_CC_SlotQty1, "ArmyTab_CCTroop_NoUnit_Slot1")
		_debugSaveHBitmapToImage($g_hHBitmap_Av_CC_SlotQty2, "ArmyTab_CCTroop_NoUnit_Slot2")
		_debugSaveHBitmapToImage($g_hHBitmap_Av_CC_SlotQty3, "ArmyTab_CCTroop_NoUnit_Slot3")
		_debugSaveHBitmapToImage($g_hHBitmap_Av_CC_SlotQty4, "ArmyTab_CCTroop_NoUnit_Slot4")
		_debugSaveHBitmapToImage($g_hHBitmap_Av_CC_SlotQty5, "ArmyTab_CCTroop_NoUnit_Slot5")
		_debugSaveHBitmapToImage($g_hHBitmap_Av_CC_SlotQty6, "ArmyTab_CCTroop_NoUnit_Slot6")
		_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_CC_Slot1, "RenameIt2ImgLocFormat_ArmyTab_CCTroop_Slot1")
		_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_CC_Slot2, "RenameIt2ImgLocFormat_ArmyTab_CCTroop_Slot2")
		_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_CC_Slot3, "RenameIt2ImgLocFormat_ArmyTab_CCTroop_Slot3")
		_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_CC_Slot4, "RenameIt2ImgLocFormat_ArmyTab_CCTroop_Slot4")
		_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_CC_Slot5, "RenameIt2ImgLocFormat_ArmyTab_CCTroop_Slot5")
		_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_CC_Slot6, "RenameIt2ImgLocFormat_ArmyTab_CCTroop_Slot6")
	EndIf
	DeleteHBitmap4CheckAvailableCCUnit()
EndFunc

Func DeleteHBitmap4CheckAvailableCCUnit()
	If $g_hHBitmap2 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap2)
	EndIf
	If $g_hHBitmap_Av_CC_Slot1 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_CC_Slot1)
	EndIf
	If $g_hHBitmap_Av_CC_Slot2 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_CC_Slot2)
	EndIf
	If $g_hHBitmap_Av_CC_Slot3 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_CC_Slot3)
	EndIf
	If $g_hHBitmap_Av_CC_Slot4 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_CC_Slot4)
	EndIf
	If $g_hHBitmap_Av_CC_Slot5 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_CC_Slot5)
	EndIf
	If $g_hHBitmap_Av_CC_Slot6 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_CC_Slot6)
	EndIf
	If $g_hHBitmap_Av_CC_SlotQty1 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_CC_SlotQty1)
	EndIf
	If $g_hHBitmap_Av_CC_SlotQty2 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_CC_SlotQty2)
	EndIf
	If $g_hHBitmap_Av_CC_SlotQty3 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_CC_SlotQty3)
	EndIf
	If $g_hHBitmap_Av_CC_SlotQty4 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_CC_SlotQty4)
	EndIf
	If $g_hHBitmap_Av_CC_SlotQty5 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_CC_SlotQty5)
	EndIf
	If $g_hHBitmap_Av_CC_SlotQty6 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_CC_SlotQty6)
	EndIf

	If $g_hHBitmap_Capture_Av_CC_Slot1 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_CC_Slot1)
	EndIf
	If $g_hHBitmap_Capture_Av_CC_Slot2 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_CC_Slot2)
	EndIf
	If $g_hHBitmap_Capture_Av_CC_Slot3 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_CC_Slot3)
	EndIf
	If $g_hHBitmap_Capture_Av_CC_Slot4 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_CC_Slot4)
	EndIf
	If $g_hHBitmap_Capture_Av_CC_Slot5 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_CC_Slot5)
	EndIf
	If $g_hHBitmap_Capture_Av_CC_Slot6 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_CC_Slot6)
	EndIf
EndFunc