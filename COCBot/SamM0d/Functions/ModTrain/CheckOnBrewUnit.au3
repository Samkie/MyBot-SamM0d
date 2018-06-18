; #FUNCTION# ====================================================================================================================
; Name ..........: CheckOnBrewUnit
; Description ...: Reads current quanitites/type of spells from brew spell window, updates $OnTXXXXSpell (On Train unit and quantity), $OnQXXXXXSpell (On Queue unit and quantity)
;                  Check spells brew correctly, will remove what un need.
; Syntax ........: CheckOnBrewUnit
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
Func CheckOnBrewUnit($hHBitmap)
	If $hHBitmap = 0 Then
		SetLog("Error: $hHBitmap = 0",$COLOR_ERROR)
		Return False
	EndIf
	If $g_iSamM0dDebug = 1 Then SetLog("============Start CheckOnBrewUnit ============")
	SetLog("Start check on brew unit...", $COLOR_INFO)
	; reset variable
	For $i = 0 To UBound($MySpells) - 1
		Assign("OnT" & $MySpells[$i][0] & "Spell", 0)
		Assign("OnQ" & $MySpells[$i][0] & "Spell", 0)
		Assign("Ready" & $MySpells[$i][0] & "Spell", 0)
		Assign("RemoveSpellUnitOfOnT" & $MySpells[$i][0], 0)
		Assign("RemoveSpellUnitOfOnQ" & $MySpells[$i][0], 0)
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

	Local $aiSpellInfo[11][4]
	Local $iAvailableCamp = 0
	Local $iMySpellsCampSize = 0

	Local $iOnQueueCamp = 0
	Local $iMyPreBrewSpellSize = 0

	Local $sDirectory
	Local $sOriDirectory
	Local $returnProps="objectname"
	Local $aPropsValues
	Local $bDeletedExcess = False
	Local $bGotOnBrewFlag = False
	Local $bGotOnQueueFlag = False
	Local $iCount = 0
	For $i = 10 To 0 Step -1
		If _ColorCheck(_GetPixelColor(Int($g_aiArmyOnBrewSlot[0] + ($g_iArmy_OnT_Troop_Slot_Width * $i) + ($g_iArmy_OnT_Troop_Slot_Width / 2)),196,False), Hex(0XCFCFC8, 6), 10) And _ColorCheck(_GetPixelColor(Int($g_aiArmyOnBrewSlot[0] + ($g_iArmy_OnT_Troop_Slot_Width * $i) + ($g_iArmy_OnT_Troop_Slot_Width / 2)),186,False), Hex(0XCFCFC8, 6), 10) Then
			; Is Empty Slot
			$aiSpellInfo[$i][0] = ""
			$aiSpellInfo[$i][1] = 0
			$aiSpellInfo[$i][2] = $i + 1
			$aiSpellInfo[$i][3] = False
			$iCount += 1
		Else
			Local $bIsQueueSpell = False
			Local $bContinueNextLoop = False

			If _ColorCheck(_GetPixelColor(Int($g_aiArmyOnBrewSlot[0] + ($g_iArmy_OnT_Troop_Slot_Width * $i) + ($g_iArmy_OnT_Troop_Slot_Width / 2)),186,False), Hex(0XD7AFA9, 6), 10) Then
				$sDirectory = $g_sSamM0dImageLocation & "\Spells\Queue\"
				$sOriDirectory = @ScriptDir & "\COCBot\SamM0d\Images\Spells\Queue\"
				$bIsQueueSpell = True
			Else
				$sDirectory = $g_sSamM0dImageLocation & "\Spells\Brew\"
				$sOriDirectory = @ScriptDir & "\COCBot\SamM0d\Images\Spells\Brew\"
			EndIf
			Local $iPixelDivider = ($g_iArmy_RegionSizeForScan - ($g_aiArmyOnBrewSlot[3] - $g_aiArmyOnBrewSlot[1])) / 2
			Assign("g_hHBitmap_OB_Slot" & $i + 1, GetHHBitmapArea($hHBitmap, Int($g_aiArmyOnBrewSlot[0] + ($g_iArmy_OnT_Troop_Slot_Width * $i) + (($g_iArmy_OnT_Troop_Slot_Width - $g_iArmy_RegionSizeForScan) / 2)), $g_aiArmyOnBrewSlot[1] - $iPixelDivider, Int($g_aiArmyOnBrewSlot[0] + ($g_iArmy_OnT_Troop_Slot_Width* $i) + (($g_iArmy_OnT_Troop_Slot_Width - $g_iArmy_RegionSizeForScan) / 2) + $g_iArmy_RegionSizeForScan), $g_aiArmyOnBrewSlot[3] + $iPixelDivider))
			Assign("g_hHBitmap_Capture_OB_Slot" & $i + 1, GetHHBitmapArea($hHBitmap, Int($g_aiArmyOnBrewSlot[0] + ($g_iArmy_OnT_Troop_Slot_Width* $i) + (($g_iArmy_OnT_Troop_Slot_Width - $g_iArmy_ImageSizeForScan) / 2)), $g_aiArmyOnBrewSlot[1], Int($g_aiArmyOnBrewSlot[0] + ($g_iArmy_OnT_Troop_Slot_Width* $i) + (($g_iArmy_OnT_Troop_Slot_Width- $g_iArmy_ImageSizeForScan) / 2) + $g_iArmy_ImageSizeForScan), $g_aiArmyOnBrewSlot[3]))
			Local $result = findMultiImage(Eval("g_hHBitmap_OB_Slot" & $i + 1), $sDirectory ,"FV" ,"FV", 0, 1000, 1 , $returnProps)

			Local $sObjectname = ""
			Local $iQty = 0
			If IsArray($result) then
				For $j = 0 To UBound($result) -1
					If $j = 0 Then
						$aPropsValues = $result[$j] ; should be return objectname
						If UBound($aPropsValues) = 1 then
							$sObjectname = $aPropsValues[0] ; objectname
						EndIf
					ElseIf $j = 1 Then
						$aPropsValues = $result[$j]
						SetLog("Error: Multiple detect spells on slot: " & $i + 1 , $COLOR_ERROR)
						SetLog("Spell: " & $sObjectname, $COLOR_ERROR)
						SetLog("Spell: " & $aPropsValues[0], $COLOR_ERROR)
					Else
						$aPropsValues = $result[$j]
						SetLog("Spell: " & $aPropsValues[0], $COLOR_ERROR)
					EndIf
				Next

			Else
				Local $iPixelDivider = ($g_iArmy_EnlargeRegionSizeForScan - ($g_aiArmyOnBrewSlot[3] - $g_aiArmyOnBrewSlot[1])) / 2
				Local $temphHBitmap = GetHHBitmapArea($hHBitmap, Int($g_aiArmyOnBrewSlot[0] + ($g_iArmy_OnT_Troop_Slot_Width* $i) + (($g_iArmy_OnT_Troop_Slot_Width - $g_iArmy_EnlargeRegionSizeForScan) / 2)), $g_aiArmyOnBrewSlot[1] - $iPixelDivider, Int($g_aiArmyOnBrewSlot[0] + ($g_iArmy_OnT_Troop_Slot_Width* $i) + (($g_iArmy_OnT_Troop_Slot_Width - $g_iArmy_EnlargeRegionSizeForScan) / 2) + $g_iArmy_EnlargeRegionSizeForScan), $g_aiArmyOnBrewSlot[3] + $iPixelDivider)
				_debugSaveHBitmapToImage($temphHBitmap, ($bIsQueueSpell = True ? "Spell_Queue_Slot_" : "Spell_Brew_Slot_") & $i + 1, True)
				_debugSaveHBitmapToImage(Eval("g_hHBitmap_Capture_OB_Slot" & $i + 1), ($bIsQueueSpell = True ? "Spell_Queue_Slot_" : "Spell_Brew_Slot_") & $i + 1 & "_Unknown_RenameThis_92", True)
				If $temphHBitmap <> 0 Then
					GdiDeleteHBitmap($temphHBitmap)
				EndIf
				SetLog("Error: Cannot detect what spells on slot: " & $i + 1 , $COLOR_ERROR)
				SetLog("Please check the filename: " & ($bIsQueueSpell = True ? "Spell_Queue_Slot_" : "Spell_Brew_Slot_") & $i + 1 & "_Unknown_RenameThis_92.png", $COLOR_ERROR)
				SetLog("Locate at:" & @ScriptDir & "\profiles\" & $g_sProfileCurrentName & "\SamM0d Debug\Images\", $COLOR_ERROR)
				SetLog("Rename the correct filename and replace back to file location: " & $sOriDirectory, $COLOR_ERROR)
				SetLog("And then restart the bot.", $COLOR_ERROR)
				$bContinueNextLoop = True
			EndIf

			If $bContinueNextLoop Then
				ContinueLoop
			EndIf

			Assign("g_hHBitmap_OB_SlotQty" & $i + 1, GetHHBitmapArea($hHBitmap, Int($g_aiArmyOnBrewSlotQty[0] + ($g_iArmy_OnT_Troop_Slot_Width * $i)), $g_aiArmyOnBrewSlotQty[1], Int($g_aiArmyOnBrewSlotQty[0] + ($g_iArmy_OnT_Troop_Slot_Width* $i) + 40), $g_aiArmyOnBrewSlotQty[3]))

			If $bIsQueueSpell Then
				$iQty = getMyOcr(Eval("g_hHBitmap_OB_SlotQty" & $i + 1),0,0,0,0,"spellqtypre", True)
			Else
				$iQty = getMyOcr(Eval("g_hHBitmap_OB_SlotQty" & $i + 1),0,0,0,0,"spellqtybrew", True)
			EndIf

			If $iQty <> 0 And $sObjectname <> "" Then
				$aiSpellInfo[$i][0] = $sObjectname
				$aiSpellInfo[$i][1] = $iQty
				$aiSpellInfo[$i][2] = $i + 1
				$aiSpellInfo[$i][3] = $bIsQueueSpell
				If $bIsQueueSpell Then
					Assign("OnQ" & $sObjectname & "Spell", Eval("OnQ" & $sObjectname & "Spell") + $iQty)

					Local $hHbitmap_ready = GetHHBitmapArea($hHBitmap, Int(112 + ($g_iArmy_OnT_Troop_Slot_Width * $i)), 240, Int(112 + ($g_iArmy_OnT_Troop_Slot_Width* $i) + 12), 248)
					_debugSaveHBitmapToImage($hHbitmap_ready, "hHbitmap_ready" & $i + 1, True)

					$sDirectory = $g_sSamM0dImageLocation & "\Troops\Ready\"

					$result = findMultiImage($hHbitmap_ready, $sDirectory ,"FV" ,"FV", 0, 1000, 1 , $returnProps)

					If IsArray($result) then
						Assign("Ready" & $sObjectname & "Spell", Eval("Ready" & $sObjectname & "Spell") + $iQty)
					EndIf

				Else
					Assign("OnT" & $sObjectname & "Spell", Eval("OnT" & $sObjectname & "Spell") + $iQty)
				EndIf
			Else
				SetLog("Error detect quantity no. On Spell: " & MyNameOfTroop(Eval("enum" & $sObjectname) + $eLSpell , $iQty),$COLOR_RED)
				ExitLoop
			EndIf
		EndIf
	Next

	If $g_hHBitmap <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap)
	EndIf
	If $g_hBitmap <> 0 Then
		GdiDeleteBitmap($g_hBitmap)
	EndIf

	If $iCount = 11 Then
		SetLog("No Spell On Brew.",$COLOR_ERROR)
		Return True
	EndIf

	$bGotOnBrewFlag = False
	For $i = 0 To UBound($MySpells) - 1
		Local $itempTotal = Eval("cur" & $MySpells[$i][0] & "Spell") + Eval("OnT" & $MySpells[$i][0] & "Spell")
		If Eval("OnT" & $MySpells[$i][0] & "Spell") > 0 Then
			SetLog(" - No. of On Brew " & MyNameOfTroop(Eval("enum" & $MySpells[$i][0]) + $eLSpell,  Eval("OnT" & $MySpells[$i][0] & "Spell")) & ": " &  Eval("OnT" & $MySpells[$i][0] & "Spell"), (Eval("enum" & $MySpells[$i][0]) > 5 ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))
			$bGotOnBrewFlag = True
		EndIf
		If $MySpells[$i][3] < $itempTotal Then
			If $ichkEnableDeleteExcessSpells = 1 Then
				SetLog("Error: " & MyNameOfTroop(Eval("enum" & $MySpells[$i][0] + $eLSpell),  Eval("OnT" & $MySpells[$i][0] & "Spell")) & " need " & $MySpells[$i][3] & " only, and i made " & $itempTotal)
				Assign("RemoveSpellUnitOfOnT" & $MySpells[$i][0], $itempTotal - $MySpells[$i][3])
				$bDeletedExcess = True
			EndIf
		EndIf
		If $itempTotal > 0 Then
			$iAvailableCamp += $itempTotal * $MySpells[$i][2]
		EndIf
		If $MySpells[$i][3] > 0 Then
			$iMySpellsCampSize += $MySpells[$i][3] * $MySpells[$i][2]
		EndIf
	Next

	If $bDeletedExcess Then
		$bDeletedExcess = False
		If gotoBrewSpells() = False Then Return
		SetLog(" >>> Some Spells over train, stop and remove Spells.", $COLOR_RED)
		RemoveAllPreTrainTroops()
		_ArraySort($aiSpellInfo, 0, 0, 0, 2) ; sort to make remove start from left to right
		For $i = 0 To 10
			If $aiSpellInfo[$i][1] <> 0 And $aiSpellInfo[$i][3] = False Then
				; 檢查這個兵種是否要刪除
				Local $iUnitToRemove = Eval("RemoveSpellUnitOfOnT" & $aiSpellInfo[$i][0])
				If $iUnitToRemove > 0 Then
					If $aiSpellInfo[$i][1] > $iUnitToRemove Then
						SetLog("Remove " & MyNameOfTroop(Eval("enum" & $aiSpellInfo[$i][0]) + $eLSpell,  $aiSpellInfo[$i][1]) & " at slot: " & $aiSpellInfo[$i][2] & ", unit to remove: " & $iUnitToRemove, $COLOR_ACTION)
						RemoveTrainTroops($aiSpellInfo[$i][2]-1, $iUnitToRemove)
						$iUnitToRemove = 0
						Assign("RemoveSpellUnitOfOnT" & $aiSpellInfo[$i][0], $iUnitToRemove)
					Else
						SetLog("Remove " & MyNameOfTroop(Eval("enum" & $aiSpellInfo[$i][0]) + $eLSpell,  $aiSpellInfo[$i][1]) & " at slot: " & $aiSpellInfo[$i][2] & ", unit to remove: " & $aiSpellInfo[$i][1], $COLOR_ACTION)
						RemoveTrainTroops($aiSpellInfo[$i][2]-1, $aiSpellInfo[$i][1])
						$iUnitToRemove -= $aiSpellInfo[$i][1]
						Assign("RemoveSpellUnitOfOnT" & $aiSpellInfo[$i][0], $iUnitToRemove)
					EndIf
				EndIf
			EndIf
		Next
		$g_bRestartCheckTroop = True
		Return False
	Else
		$bDeletedExcess = False
		$bGotOnQueueFlag = False
		For $i = 0 To UBound($MySpells) - 1
			Local $itempTotal = Eval("OnQ" & $MySpells[$i][0] & "Spell")
			If $itempTotal > 0 Then
				SetLog(" - No. of On Queue " & MyNameOfTroop(Eval("enum" & $MySpells[$i][0]) + $eLSpell,  Eval("OnQ" & $MySpells[$i][0] & "Spell")) & ": " &  Eval("OnQ" & $MySpells[$i][0] & "Spell"), (Eval("enum" & $MySpells[$i][0]) > 5 ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))
				$bGotOnQueueFlag = True
				If Eval("ichkPre" & $MySpells[$i][0]) = 1 Then
					If $MySpells[$i][3] < $itempTotal Then
						If $ichkEnableDeleteExcessSpells = 1 Then
							SetLog("Error: " & MyNameOfTroop(Eval("enum" & $MySpells[$i][0]) + $eLSpell,  Eval("OnQ" & $MySpells[$i][0] & "Spell")) & " need " & $MySpells[$i][3] & " only, and i made " & $itempTotal)
							Assign("RemoveSpellUnitOfOnQ" & $MySpells[$i][0], $itempTotal - $MySpells[$i][3])
							$bDeletedExcess = True
						EndIf
					EndIf
					$iMyPreBrewSpellSize += $itempTotal * $MySpells[$i][2]
				Else
					SetLog("Error: " & MyNameOfTroop(Eval("enum" & $MySpells[$i][0]) + $eLSpell,  Eval("OnQ" & $MySpells[$i][0] & "Spell")) & " not needed to pre brew, remove all.")
					Assign("RemoveSpellUnitOfOnQ" & $MySpells[$i][0], $itempTotal)
					$bDeletedExcess = True
				EndIf
				$iOnQueueCamp += $itempTotal * $MySpells[$i][2]
			EndIf
		Next

		If $bGotOnQueueFlag And Not $bGotOnBrewFlag Then
			If $iAvailableCamp < $iMySpellsCampSize Or $g_bDoPrebrewspell = 0 Then
				If $g_bDoPrebrewspell = 0 Then
					SetLog("Pre-Brew spells disable by user, remove all pre-train spells.", $COLOR_ERROR)
				Else
					SetLog("Error: Spells size not correct but pretrain already.", $COLOR_ERROR)
					SetLog("Error: Detected Spells size = " & $iAvailableCamp & ", My Spells size = " & $iMySpellsCampSize, $COLOR_ERROR)
				EndIf
				If gotoBrewSpells() = False Then Return
				RemoveAllPreTrainTroops()
				$g_bRestartCheckTroop = True
				Return False
			EndIf
		EndIf

		If $bDeletedExcess Then
			$bDeletedExcess = False
			If gotoBrewSpells() = False Then Return
			SetLog(" >>> Some spells over train, stop and remove pre-train Spells.", $COLOR_RED)
			_ArraySort($aiSpellInfo, 0, 0, 0, 2) ; sort to make remove start from left to right
			For $i = 0 To 10
				If $aiSpellInfo[$i][1] <> 0 And $aiSpellInfo[$i][3] = True Then
					Local $iUnitToRemove = Eval("RemoveSpellUnitOfOnQ" & $aiSpellInfo[$i][0])
					If $iUnitToRemove > 0 Then
						If $aiSpellInfo[$i][1] > $iUnitToRemove Then
							SetLog("Remove " & MyNameOfTroop(Eval("enum" & $aiSpellInfo[$i][0]) + $eLSpell,  $aiSpellInfo[$i][1]) & " at slot: " & $aiSpellInfo[$i][2] & ", unit to remove: " & $iUnitToRemove, $COLOR_ACTION)
							RemoveTrainTroops($aiSpellInfo[$i][2]-1, $iUnitToRemove)
							$iUnitToRemove = 0
							Assign("RemoveSpellUnitOfOnQ" & $aiSpellInfo[$i][0], $iUnitToRemove)
						Else
							SetLog("Remove " & MyNameOfTroop(Eval("enum" & $aiSpellInfo[$i][0]) + $eLSpell,  $aiSpellInfo[$i][1]) & " at slot: " & $aiSpellInfo[$i][2] & ", unit to remove: " & $aiSpellInfo[$i][1], $COLOR_ACTION)
							RemoveTrainTroops($aiSpellInfo[$i][2]-1, $aiSpellInfo[$i][1])
							$iUnitToRemove -= $aiSpellInfo[$i][1]
							Assign("RemoveSpellUnitOfOnQ" & $aiSpellInfo[$i][0], $iUnitToRemove)
						EndIf
					EndIf
				EndIf
			Next
			$g_bRestartCheckTroop = True
			Return False
		EndIf

		; if don't have on brew spell then i check the pre brew spell size
		If $bGotOnQueueFlag And Not $bGotOnBrewFlag Then
			If $aiSpellInfo[0][1] > 0 Then
				If $iOnQueueCamp <> $iMyPreBrewSpellSize Then
					SetLog("Error: Pre-Brew Spells size not correct.", $COLOR_ERROR)
					SetLog("Error: Detected Pre-Brew Spells size = " & $iOnQueueCamp & ", My Spells size = " & $iMyPreBrewSpellSize, $COLOR_ERROR)
					If gotoBrewSpells() = False Then Return
					RemoveAllPreTrainTroops()
					$g_bRestartCheckTroop = True
					Return False
				EndIf
			EndIf

			If $g_bDoPrebrewspell = 0 Then
				SetLog("Pre-brew spell disable by user, remove all pre-brew spell.",$COLOR_INFO)
				If gotoBrewSpells() = False Then Return
				RemoveAllPreTrainTroops()
			EndIf
		Else
			If $ichkMySpellsOrder Then
				Local $tempSpells[10][5]
				$tempSpells	= $MySpells
				_ArraySort($tempSpells,0,0,0,1)
				For $i = 0 To UBound($tempSpells) - 1
					If $tempSpells[$i][3] > 0 Then
						$tempSpells[0][0] = $tempSpells[$i][0]
						$tempSpells[0][3] = $tempSpells[$i][3]
						ExitLoop
					EndIf
				Next
				_ArraySort($aiSpellInfo, 1, 0, 0, 2)
				For $i = 0 To UBound($aiSpellInfo) - 1
					If $aiSpellInfo[$i][3] = True Then
						If $aiSpellInfo[$i][0] <> $tempSpells[0][0] Then
							SetLog("Pre-Brew Spell first slot: " & MyNameOfTroop(Eval("enum" & $aiSpellInfo[$i][0])+ $eLSpell, $aiSpellInfo[$i][1]), $COLOR_ERROR)
							SetLog("My first order spells: " & MyNameOfTroop(Eval("enum" & $tempSpells[0][0])+ $eLSpell, $tempSpells[0][3]), $COLOR_ERROR)
							SetLog("Remove and re-brew by order.", $COLOR_ERROR)
							RemoveAllPreTrainTroops()
							$g_bRestartCheckTroop = True
							Return False
						Else
							If $aiSpellInfo[$i][1] < $tempSpells[0][3] Then
								SetLog("Pre-Brew Spell first slot: " & MyNameOfTroop(Eval("enum" & $aiSpellInfo[$i][0])+ $eLSpell, $aiSpellInfo[$i][1]) & " - Units: " & $aiSpellInfo[$i][1], $COLOR_ERROR)
								SetLog("My first order spells: " & MyNameOfTroop(Eval("enum" & $tempSpells[0][0])+ $eLSpell, $tempSpells[0][3]) & " - Units: " & $tempSpells[0][3], $COLOR_ERROR)
								SetLog("Not enough quantity, remove and re-brew again.", $COLOR_ERROR)
								RemoveAllPreTrainTroops()
								$g_bRestartCheckTroop = True
								Return False
							EndIf
						EndIf
						ExitLoop
					EndIf
				Next
			EndIf
		EndIf
	EndIf

	If $g_abAttackTypeEnable[$DB] = True And $g_abSearchSpellsWaitEnable[$DB] = True Then
		For $i = $enumLightning To $enumSkeleton
			If Eval("Cur" & $MySpells[$i][0] & "Spell") < $MySpells[$i][3] Then
				SETLOG(" Dead Base - Waiting " & MyNameOfTroop($i+ $eLSpell, $MySpells[$i][3] - Eval("Cur" & $MySpells[$i][0] & "Spell")) & _
				" to brew finish before start next attack.", $COLOR_ACTION)
			EndIf
		Next
	EndIf

	If $g_abAttackTypeEnable[$LB] = True And $g_abSearchSpellsWaitEnable[$LB] = True Then
		For $i = $enumLightning To $enumSkeleton
			If Eval("Cur" & $MySpells[$i][0] & "Spell") < $MySpells[$i][3] Then
				SETLOG(" Live Base - Waiting " & MyNameOfTroop($i+ $eLSpell+ $eLSpell, $MySpells[$i][3] - Eval("Cur" & $MySpells[$i][0] & "Spell")) & _
				" to brew finish before start next attack.", $COLOR_ACTION)
			EndIf
		Next
	EndIf

	If $g_iSamM0dDebug = 1 Then SETLOG("$bFullArmySpells: " & $g_bFullArmySpells & ", $iTotalSpellSpace:$iMyTotalTrainSpaceSpell " & $iAvailableCamp & "|" & $g_iMySpellsSize, $COLOR_DEBUG)

	Return True
EndFunc
