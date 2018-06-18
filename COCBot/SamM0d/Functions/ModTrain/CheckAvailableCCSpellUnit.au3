; #FUNCTION# ====================================================================================================================
; Name ..........: CheckAvailableCCSpellUnit
; Description ...: Reads current cc spells from Training window
;                  remove it if not needed.
; Syntax ........: CheckAvailableCCSpellUnit()
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
Func CheckAvailableCCSpellUnit()
	If $g_iSamM0dDebug = 1 Then SetLog("============Start CheckAvailableCCSpellUnit ============")
	If $g_iChkWait4CCSpell = 0 Then Return True
	SetLog("Start check available clan castle spell...", $COLOR_INFO)

	Local $iCount = 0

	While 1
		$iCount += 1
		If $iCount > 3 Then ExitLoop

		If $g_hHBitmap2 <> 0 Then
			GdiDeleteHBitmap($g_hHBitmap2)
		EndIf
		If $g_hHBitmap_Av_CC_Spell_Slot1 <> 0 Then
			GdiDeleteHBitmap($g_hHBitmap_Av_CC_Spell_Slot1)
		EndIf
		If $g_hHBitmap_Av_CC_Spell_Slot2 <> 0 Then
			GdiDeleteHBitmap($g_hHBitmap_Av_CC_Spell_Slot2)
		EndIf
		If $g_hHBitmap_Av_CC_Spell_SlotQty1 <> 0 Then
			GdiDeleteHBitmap($g_hHBitmap_Av_CC_Spell_SlotQty1)
		EndIf
		If $g_hHBitmap_Av_CC_Spell_SlotQty2 <> 0 Then
			GdiDeleteHBitmap($g_hHBitmap_Av_CC_Spell_SlotQty2)
		EndIf
		If $g_hHBitmap_Capture_Av_CC_Spell_Slot1 <> 0 Then
			GdiDeleteHBitmap($g_hHBitmap_Capture_Av_CC_Spell_Slot1)
		EndIf
		If $g_hHBitmap_Capture_Av_CC_Spell_Slot2 <> 0 Then
			GdiDeleteHBitmap($g_hHBitmap_Capture_Av_CC_Spell_Slot2)
		EndIf

		If _Sleep(250) Then ExitLoop
		_CaptureRegion2()

		If $g_hHBitmap <> 0 Then
			GdiDeleteHBitmap($g_hHBitmap)
		EndIf
		$g_hHBitmap = GetHHBitmapArea($g_hHBitmap2)
		If $g_hBitmap <> 0 Then
			GdiDeleteBitmap($g_hBitmap)
		EndIf
		$g_hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap)

		Local $aiSpellsInfo[2][3]
		Local $AvailableCamp = 0
		Local $sDirectory = $g_sSamM0dImageLocation & "\Spells\CC\"
		Local $sOriDirectory = @ScriptDir & "\COCBot\SamM0d\Images\Spells\CC\"
		Local $returnProps="objectname"
		Local $aPropsValues
		Local $bDeletedExcess = False
		Local $iOffsetSlot = 0
		Local $iSpellsCount = 0

		; reset variable
		For $i = 0 To UBound($MySpells) - 1
			Assign("curCCSpell" & $MySpells[$i][0], 0)
			Assign("RemoveUnitOfcurCCSpell" & $MySpells[$i][0], 0)
		Next

		Local $iSlotCount = 0
		If _ColorCheck(_GetPixelColor(481,510,False), Hex(0XCECDC5, 6), 10) And _ColorCheck(_GetPixelColor(551,510,False), Hex(0XCDCDC5, 6), 10) = False Then
			$iOffsetSlot = $g_aiArmyAvailableCCSpellSlot[0] + 39
			$iSlotCount = 0
		Else
			$iOffsetSlot = $g_aiArmyAvailableCCSpellSlot[0]
			$iSlotCount = 1
		EndIf

		For $i = 0 To $iSlotCount
			Local $iPixelDivider = ($g_iArmy_RegionSizeForScan - ($g_aiArmyAvailableCCSpellSlot[3] - $g_aiArmyAvailableCCSpellSlot[1])) / 2
			Assign("g_hHBitmap_Av_CC_Spell_Slot" & $i + 1, GetHHBitmapArea($g_hHBitmap2, Int($iOffsetSlot + ($g_iArmy_Av_CC_Spell_Slot_Width* $i) + (($g_iArmy_Av_CC_Spell_Slot_Width - $g_iArmy_RegionSizeForScan) / 2)), $g_aiArmyAvailableCCSpellSlot[1] - $iPixelDivider, Int($iOffsetSlot + ($g_iArmy_Av_CC_Spell_Slot_Width* $i) + (($g_iArmy_Av_CC_Spell_Slot_Width - $g_iArmy_RegionSizeForScan) / 2) + $g_iArmy_RegionSizeForScan), $g_aiArmyAvailableCCSpellSlot[3] + $iPixelDivider))
			Assign("g_hHBitmap_Capture_Av_CC_Spell_Slot" & $i + 1, GetHHBitmapArea($g_hHBitmap2, Int($iOffsetSlot + ($g_iArmy_Av_CC_Spell_Slot_Width* $i) + (($g_iArmy_Av_CC_Spell_Slot_Width - $g_iArmy_ImageSizeForScan) / 2)), $g_aiArmyAvailableCCSpellSlot[1], Int($iOffsetSlot + ($g_iArmy_Av_CC_Spell_Slot_Width* $i) + (($g_iArmy_Av_CC_Spell_Slot_Width - $g_iArmy_ImageSizeForScan) / 2) + $g_iArmy_ImageSizeForScan), $g_aiArmyAvailableCCSpellSlot[3]))

			Local $result = findMultiImage(Eval("g_hHBitmap_Av_CC_Spell_Slot" & $i + 1), $sDirectory ,"FV" ,"FV", 0, 1000, 1 , $returnProps)
			Local $bExitLoopFlag = False
			Local $bContinueNextLoop = False

			If IsArray($result) then
				For $j = 0 To UBound($result) -1
					If $j = 0 Then
						$aPropsValues = $result[$j] ; should be return objectname
						If UBound($aPropsValues) = 1 then
							If $aPropsValues[0] <> "0" Then
								$aiSpellsInfo[$i][0] = $aPropsValues[0] ; objectname
								$aiSpellsInfo[$i][2] = $i + 1
								$iSpellsCount += 1
							EndIf
						EndIf
					ElseIf $j = 1 Then
						$aPropsValues = $result[$j]
						SetLog("Error: Multiple detect spells on slot: " & $i + 1 , $COLOR_ERROR)
						SetLog("Spell: " & $aiSpellsInfo[$i][0], $COLOR_ERROR)
						SetLog("Spell: " & $aPropsValues[0], $COLOR_ERROR)
					Else
						$aPropsValues = $result[$j]
						SetLog("Spell: " & $aPropsValues[0], $COLOR_ERROR)
					EndIf
				Next
				If $aPropsValues[0]  = "0" Then $bExitLoopFlag = True
			Else
				Local $iPixelDivider = ($g_iArmy_EnlargeRegionSizeForScan - ($g_aiArmyAvailableCCSpellSlot[3] - $g_aiArmyAvailableCCSpellSlot[1])) / 2
				Local $temphHBitmap = GetHHBitmapArea($g_hHBitmap2, Int($iOffsetSlot + ($g_iArmy_Av_CC_Spell_Slot_Width* $i) + (($g_iArmy_Av_CC_Spell_Slot_Width - $g_iArmy_EnlargeRegionSizeForScan) / 2)), $g_aiArmyAvailableCCSpellSlot[1] - $iPixelDivider, Int($iOffsetSlot + ($g_iArmy_Av_CC_Spell_Slot_Width* $i) + (($g_iArmy_Av_CC_Spell_Slot_Width - $g_iArmy_EnlargeRegionSizeForScan) / 2) + $g_iArmy_EnlargeRegionSizeForScan), $g_aiArmyAvailableCCSpellSlot[3] + $iPixelDivider)
				_debugSaveHBitmapToImage($temphHBitmap, "Spell_Av_CC_Slot_" & $i + 1, True)
				_debugSaveHBitmapToImage(Eval("g_hHBitmap_Capture_Av_CC_Spell_Slot" & $i + 1), "Spell_CC_Slot_" & $i + 1 & "_Unknown_RenameThis_92", True)
				If $temphHBitmap <> 0 Then
					GdiDeleteHBitmap($temphHBitmap)
				EndIf
				SetLog("Error: Cannot detect what cc spells on slot: " & $i + 1 , $COLOR_ERROR)
				SetLog("Please check the filename: Spell_CC_Slot_" & $i + 1 & "_Unknown_RenameThis_92.png", $COLOR_ERROR)
				SetLog("Locate at:" & @ScriptDir & "\profiles\" & $g_sProfileCurrentName & "\SamM0d Debug\Images\", $COLOR_ERROR)
				SetLog("Rename the correct filename and replace back to file location: " & $sOriDirectory, $COLOR_ERROR)
				SetLog("And then restart the bot.", $COLOR_ERROR)
				$bContinueNextLoop = True
			EndIf

			If $bExitLoopFlag = True Then ExitLoop
			If $bContinueNextLoop Then
				ContinueLoop
			EndIf

			Assign("g_hHBitmap_Av_CC_Spell_SlotQty" & $i + 1, GetHHBitmapArea($g_hHBitmap2, Int($iOffsetSlot + ($g_iArmy_Av_CC_Spell_Slot_Width* $i) + (($g_iArmy_Av_CC_Spell_Slot_Width- $g_iArmy_QtyWidthForScan) / 2)), $g_aiArmyAvailableCCSpellSlotQty[1], Int($iOffsetSlot + ($g_iArmy_Av_CC_Spell_Slot_Width* $i) + (($g_iArmy_Av_CC_Spell_Slot_Width- $g_iArmy_QtyWidthForScan) / 2) + $g_iArmy_QtyWidthForScan), $g_aiArmyAvailableCCSpellSlotQty[3]))

			$aiSpellsInfo[$i][1] = getMyOcr(Eval("g_hHBitmap_Av_CC_Spell_SlotQty" & $i + 1),0,0,0,0,"ArmyQTY", True)

			If $aiSpellsInfo[$i][1] <> 0 Then
				Assign("curCCSpell" & $aiSpellsInfo[$i][0], Eval("curCCSpell" & $aiSpellsInfo[$i][0]) + $aiSpellsInfo[$i][1])
			Else
				SetLog("Error detect quantity no. On CC Spell: " & MyNameOfTroop(Eval("enum" & $aiSpellsInfo[$i][0]) + 23, $aiSpellsInfo[$i][1]),$COLOR_RED)
				ExitLoop
			EndIf
		Next

		If $iSpellsCount = 0 Then
			SetLog("No Spell On Clan Castle.",$COLOR_ERROR)
			ExitLoop
		EndIf

		For $i = 0 To UBound($MySpells) - 1
			Local $itempTotal = Eval("curCCSpell" & $MySpells[$i][0])
			If $itempTotal > 0 Then
				SetLog(" - No. of Available CC Spells - " & MyNameOfTroop(Eval("enum" & $MySpells[$i][0]) + 23,  Eval("curCCSpell" & $MySpells[$i][0])) & ": " &  Eval("curCCSpell" & $MySpells[$i][0]), (Eval("enum" & $MySpells[$i][0]) > 5 ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))
				Local $bIsSpellInKeepList = False
				If $iCCSpellSlot1 Or $iCCSpellSlot2 Then
					For $j = 1 To 2
						If Eval("enum" & $MySpells[$i][0]) + 1 = Eval("iCCSpellSlot" & $j) Then
							$bIsSpellInKeepList = True
							If $itempTotal > Eval("iCCSpellSlotQty" & $j) Then
								Assign("RemoveUnitOfcurCCSpell" & $MySpells[$i][0], $itempTotal - Eval("iCCSpellSlotQty" & $j))
								$bDeletedExcess = True
							EndIf
							ExitLoop
						EndIf
					Next
					If $bIsSpellInKeepList = False Then
						Assign("RemoveUnitOfcurCCSpell" & $MySpells[$i][0], $itempTotal)
						$bDeletedExcess = True
					EndIf
				EndIf
			EndIf
		Next

		If $bDeletedExcess Then
			$bDeletedExcess = False
			SetLog(" >>> remove excess cc spells.", $COLOR_RED)
			If WaitforPixel($aButtonEditArmy[4],$aButtonEditArmy[5],$aButtonEditArmy[4]+1,$aButtonEditArmy[5]+1,Hex($aButtonEditArmy[6], 6), $aButtonEditArmy[7],20) Then
				Click($aButtonEditArmy[0],$aButtonEditArmy[1],1,0,"#EditArmy")
			Else
				ExitLoop
			EndIf
			If WaitforPixel($aButtonEditCancel[4],$aButtonEditCancel[5],$aButtonEditCancel[4]+1,$aButtonEditCancel[5]+1,Hex($aButtonEditCancel[6], 6), $aButtonEditCancel[7],20) Then
				For $i = 0 To $iSlotCount
					If $aiSpellsInfo[$i][1] <> 0 Then
						; 檢查這個兵種是否要刪除
						Local $iUnitToRemove = Eval("RemoveUnitOfcurCCSpell" & $aiSpellsInfo[$i][0])
						If $iUnitToRemove > 0 Then
							If $aiSpellsInfo[$i][1] > $iUnitToRemove Then
								SetLog("Remove " & MyNameOfTroop(Eval("enum" & $aiSpellsInfo[$i][0]) + 23,  $aiSpellsInfo[$i][1]) & " at slot: " & $aiSpellsInfo[$i][2] & ", unit to remove: " & $iUnitToRemove, $COLOR_ACTION)
								RemoveCCSpells($aiSpellsInfo[$i][2]-1, $iUnitToRemove, $iOffsetSlot)
								$iUnitToRemove = 0
								Assign("RemoveUnitOfcurCCSpell" & $aiSpellsInfo[$i][0], $iUnitToRemove)
							Else
								SetLog("Remove " & MyNameOfTroop(Eval("enum" & $aiSpellsInfo[$i][0]) + 23,  $aiSpellsInfo[$i][1]) & " at slot: " & $aiSpellsInfo[$i][2] & ", unit to remove: " & $aiSpellsInfo[$i][1], $COLOR_ACTION)
								RemoveCCSpells($aiSpellsInfo[$i][2]-1, $aiSpellsInfo[$i][1], $iOffsetSlot)
								$iUnitToRemove -= $aiSpellsInfo[$i][1]
								Assign("RemoveUnitOfcurCCSpell" & $aiSpellsInfo[$i][0], $iUnitToRemove)
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
		_debugSaveHBitmapToImage($g_hHBitmap_Av_CC_Spell_Slot1, "ArmyTab_CCSpell_Slot1")
		_debugSaveHBitmapToImage($g_hHBitmap_Av_CC_Spell_Slot2, "ArmyTab_CCSpell_Slot2")
		_debugSaveHBitmapToImage($g_hHBitmap_Av_CC_Spell_SlotQty1, "ArmyTab_CCSpell_NoUnit_Slot1")
		_debugSaveHBitmapToImage($g_hHBitmap_Av_CC_Spell_SlotQty2, "ArmyTab_CCSpell_NoUnit_Slot2")
		_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_CC_Spell_Slot1, "RenameIt2ImgLocFormat_ArmyTab_CCSpell_Slot1")
		_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_CC_Spell_Slot2, "RenameIt2ImgLocFormat_ArmyTab_CCSpell_Slot2")
	EndIf
	If $g_hBitmap <> 0 Then
		GdiDeleteBitmap($g_hBitmap)
	EndIf
	If $g_hHBitmap2 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap2)
	EndIf
	If $g_hHBitmap_Av_CC_Spell_Slot1 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_CC_Spell_Slot1)
	EndIf
	If $g_hHBitmap_Av_CC_Spell_Slot2 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_CC_Spell_Slot2)
	EndIf
	If $g_hHBitmap_Av_CC_Spell_SlotQty1 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_CC_Spell_SlotQty1)
	EndIf
	If $g_hHBitmap_Av_CC_Spell_SlotQty2 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_CC_Spell_SlotQty2)
	EndIf
	If $g_hHBitmap_Capture_Av_CC_Spell_Slot1 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_CC_Spell_Slot1)
	EndIf
	If $g_hHBitmap_Capture_Av_CC_Spell_Slot2 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_CC_Spell_Slot2)
	EndIf
EndFunc
