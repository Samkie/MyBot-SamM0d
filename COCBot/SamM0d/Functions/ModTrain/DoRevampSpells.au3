; #FUNCTION# ====================================================================================================================
; Name ..........: DoRevampSpells
; Description ...: Brewing full spells or revamp missing spells with what information get from CheckOnBrewUnit() And CheckAvailableSpellUnit()
;
; Syntax ........: DoRevampSpells()
; Parameters ....: $bDoPreTrain
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
Func DoRevampSpells($bDoPreTrain = False)
	If _Sleep(500) Then Return
	Local $bReVampFlag = False
	; start brew
	Local $tempSpells[10][5]
	$tempSpells	= $MySpells

	If $ichkMySpellsOrder Then
		_ArraySort($tempSpells,0,0,0,1)
	EndIf

	For $i = 0 To UBound($tempSpells) - 1
		If $g_iSamM0dDebug = 1 Then SetLog("$tempSpells[" & $i & "]: " & $tempSpells[$i][0] & " - " & $tempSpells[$i][1])
		; reset variable
		Assign("Dif" & $tempSpells[$i][0] & "Spell",0)
		Assign("Add" & $tempSpells[$i][0] & "Spell",0)
	Next

	If $bDoPreTrain = False Then
		For $i = 0 To UBound($tempSpells) - 1
			Local $tempCurComp = $tempSpells[$i][3]
			Local $tempCur = Eval("Cur" & $tempSpells[$i][0] & "Spell") + Eval("OnT" & $tempSpells[$i][0] & "Spell")
			If $g_iSamM0dDebug = 1 Then SetLog("$tempMySpells: " & $tempCurComp)
			If $g_iSamM0dDebug = 1 Then SetLog("$tempCur: " & $tempCur)
			If $tempCurComp <> $tempCur Then
				Assign("Dif" & $tempSpells[$i][0] & "Spell", $tempCurComp - $tempCur)
			EndIf
		Next
	Else
		For $i = 0 To UBound($tempSpells) - 1
			If Eval("ichkPre" & $tempSpells[$i][0]) = 1 Then
				If $tempSpells[$i][3] <> Eval("OnQ" & $tempSpells[$i][0] & "Spell") Then
					Assign("Dif" & $tempSpells[$i][0] & "Spell", $tempSpells[$i][3] - Eval("OnQ" & $tempSpells[$i][0] & "Spell"))
				EndIf
			EndIf
		Next
	EndIf

	For $i = 0 To UBound($tempSpells) - 1
		If Eval("Dif" & $tempSpells[$i][0] & "Spell") > 0 Then
			If $g_iSamM0dDebug = 1 Then SetLog("Some spells haven't train: " & $tempSpells[$i][0])
			If $g_iSamM0dDebug = 1 Then SetLog("Setting Qty Of " & $tempSpells[$i][0] & " spells: " & $tempSpells[$i][3])
			;SetLog("Prepare for train number Of " & MyNameOfTroop(Eval("enum" & $tempSpells[$i][0]), Eval("Dif" & $tempSpells[$i][0])) & " x" & Eval("Dif" & $tempSpells[$i][0]),$COLOR_ACTION)
			Assign("Add" & $tempSpells[$i][0] & "Spell", Eval("Dif" & $tempSpells[$i][0] & "Spell"))
			$bReVampFlag = True
		ElseIf Eval("Dif" & $tempSpells[$i][0] & "Spell") < 0 Then
			If $g_iSamM0dDebug = 1 Then SetLog("Some spells over train: " & $tempSpells[$i][0])
			If $g_iSamM0dDebug = 1 Then SetLog("Setting Qty Of " & $tempSpells[$i][0] & " spells: " & $tempSpells[$i][3])
			If $g_iSamM0dDebug = 1 Then SetLog("Current Qty Of " & $tempSpells[$i][0] & " spells: " & $tempSpells[$i][3]- Eval("Dif" & $tempSpells[$i][0] & "Spell"))
		EndIf
	Next

	If $bReVampFlag Then
		If gotoBrewSpells() = False Then Return

			If _sleep(100) Then Return
			; starttrain
			Local $iRemainSpellsCapacity = 0
			Local $iCreatedSpellsCapacity = 0
			Local $bFlagOutOfResource = False
			If $bDoPreTrain Then
				If Not IsArray($g_aiSpellsMaxCamp) Then $g_aiSpellsMaxCamp = getTrainArmyCapacity(True)
				$iRemainSpellsCapacity = $g_aiSpellsMaxCamp[1] - $g_aiSpellsMaxCamp[0]
				If $iRemainSpellsCapacity <= 0 Then
					SetLog("Spells full with pre-train.", $COLOR_INFO)
					Return
				EndIf
			Else
				$iRemainSpellsCapacity = $g_iTotalSpellValue - $g_aiSpellsMaxCamp[0]
				If $iRemainSpellsCapacity <= 0 Then
					SetLog("Spells full.", $COLOR_ERROR)
					Return
				EndIf
			EndIf

			For $i = 0 To UBound($tempSpells) - 1
				Local $iOnQQty = Eval("Add" & $tempSpells[$i][0] & "Spell")
				If $iOnQQty > 0 Then
					SetLog($CustomTrain_MSG_10 & " " & MyNameOfTroop(Eval("enum" & $tempSpells[$i][0]) + 23, $iOnQQty) & " x" & $iOnQQty,$COLOR_ACTION)
				EndIf
			Next

			Local $iCurElixir = $g_aiCurrentLoot[$eLootElixir]
			Local $iCurDarkElixir = $g_aiCurrentLoot[$eLootDarkElixir]
			Local $iCurGemAmount = $g_iGemAmount

			SetLog("Elixir: " & $iCurElixir & "   Dark Elixir: " & $iCurDarkElixir & "   Gem: " & $iCurGemAmount, $COLOR_INFO)

			For $i = 0 To UBound($tempSpells) - 1
				Local $tempSpell = Eval("Add" & $tempSpells[$i][0] & "Spell")
				If $tempSpell > 0 And $iRemainSpellsCapacity > 0 Then

					If LocateTroopButton($tempSpells[$i][0], True) Then
					Local $iCost
					; check train cost before click, incase use gem

					If $ichkEnableMySwitch = 0 Then
						If $tempSpells[$i][4] = 0 Then
							$iCost = getMyOcr(0,$g_iTroopButtonX - 55,$g_iTroopButtonY + 26, 68, 18,"troopcost",True,False,True)
							If $iCost = 0 Or $iCost >= $MySpellsCost[Eval("enum" & $tempSpells[$i][0])][0] Then
								; cannot read train cost, use max level train cost
								$iCost = $MySpellsCost[Eval("enum" & $tempSpells[$i][0])][0]
							EndIf
							$MySpells[Eval("enum" & $tempSpells[$i][0])][4] = $iCost
						Else
							$iCost = $tempSpells[$i][4]
						EndIf
					Else
						$iCost = getMyOcr(0,$g_iTroopButtonX - 55,$g_iTroopButtonY + 26, 68, 18,"troopcost",True,False,True)
						If $iCost = 0 Or $iCost >= $MySpellsCost[Eval("enum" & $tempSpells[$i][0])][0] Then
							; cannot read train cost, use max level train cost
							$iCost = $MySpellsCost[Eval("enum" & $tempSpells[$i][0])][0]
						EndIf
					EndIf

;~ 					If $tempSpells[$i][4] = 0 Then
;~ 						$iCost = getSpellCost($tempSpells[$i][0])
;~ 						If $iCost = 0 Or $iCost > $MySpellsCost[Eval("enum" & $tempSpells[$i][0])][0] Then
;~ 							; cannot read train cost, use max level train cost
;~ 							;$iCost = $MySpellsCost[$i][0]
;~ 							$iCost = $MySpellsCost[Eval("enum" & $tempSpells[$i][0])][0]
;~ 						EndIf
;~ 						$tempSpells[$i][4] = $iCost
;~ 						$MySpells[Eval("enum" & $tempSpells[$i][0])][4] = $iCost
;~ 					EndIf
;~ 					$iCost = $tempSpells[$i][4]

					If $g_iSamM0dDebug = 1 Then SetLog("$iCost: " & $iCost)
					;Local $iBuildCost = (Eval("enum" & $tempSpells[$i][0]) > 5 ? getMyOcrCurDEFromTrain() : getMyOcrCurElixirFromTrain())
					Local $iBuildCost = (Eval("enum" & $tempSpells[$i][0]) > 5 ? $iCurDarkElixir : $iCurElixir)

					If $g_iSamM0dDebug = 1 Then SetLog("$BuildCost: " & $iBuildCost)
					If $g_iSamM0dDebug = 1 Then SetLog("Total need: " & ($tempSpell * $iCost))

					;SetLog($CustomTrain_MSG_11 & " " & (Eval("enum" & $tempSpells[$i][0]) > 5 ? $CustomTrain_MSG_DarkElixir : $CustomTrain_MSG_Elixir) & ": " & $iBuildCost, (Eval("enum" & $tempSpells[$i][0]) > 5 ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))
					;SetLog($CustomTrain_MSG_13 & ": " & $iCost, (Eval("enum" & $tempSpells[$i][0]) > 5 ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))

					If ($tempSpell * $iCost) > $iBuildCost Then
						$bFlagOutOfResource = True
						; use eval and not $i to compare because of maybe after array sort $tempTroops
						Setlog("Not enough " & (Eval("enum" & $tempSpells[$i][0]) > 5 ? "Dark" : "") & " Elixir to brew " & MyNameOfTroop(Eval("enum" & $tempSpells[$i][0])+23,0), $COLOR_ERROR)
						SetLog("Current " & (Eval("enum" & $tempSpells[$i][0]) > 5 ? "Dark" : "") & " Elixir: " & $iBuildCost, $COLOR_ERROR)
						SetLog("Total need: " & $tempSpell * $iCost, $COLOR_ERROR)
					EndIf
					If $bFlagOutOfResource Then
						$g_bOutOfElixir = 1
						Setlog("Switching to Halt Attack, Stay Online Mode...", $COLOR_ERROR)
						$g_bChkBotStop = True ; set halt attack variable
						$g_icmbBotCond = 18; set stay online
						If Not ($g_bfullarmy = True) Then $g_bRestart = True ;If the army camp is full, If yes then use it to refill storages
						Return ; We are out of Elixir stop training.
					EndIf

					SetLog($CustomTrain_MSG_14 & " " & MyNameOfTroop(Eval("enum" & $tempSpells[$i][0])+23,$tempSpell) & " x" & $tempSpell & " with total " & (Eval("enum" & $tempSpells[$i][0]) > 5 ? $CustomTrain_MSG_DarkElixir : $CustomTrain_MSG_Elixir) & ": " & ($tempSpell * $iCost),(Eval("enum" & $tempSpells[$i][0]) > 5 ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))

					If ($tempSpells[$i][2] * $tempSpell) <= $iRemainSpellsCapacity Then
						If MyTrainClick($g_iTroopButtonX, $g_iTroopButtonY, $tempSpell, $g_iTrainClickDelay, "#BS01", True) Then
							If Eval("enum" & $tempSpells[$i][0]) > 5 Then
								$iCurDarkElixir -= ($tempSpell * $iCost)
							Else
								$iCurElixir -= ($tempSpell * $iCost)
							EndIf
							$iRemainSpellsCapacity -= ($tempSpells[$i][2] * $tempSpell)
						EndIf
					Else
						SetLog("Error: remaining space cannot fit to brew " & MyNameOfTroop(Eval("enum" & $tempSpells[$i][0])+23,0), $COLOR_ERROR)
					EndIf

					Else
						SetLog("Cannot find button: " & $tempSpells[$i][0] & " for click", $COLOR_ERROR)
					EndIf
				EndIf
			Next
	EndIf
	If $bDoPreTrain Then
		; all spells and pre-brew spells already made, temparary disable check the spells until the spell donate make.
		$tempDisableBrewSpell = True
	EndIf
EndFunc

Func getSpellCost($trooptype)
;~ 	If $isSantaSpellAvailable <> 1 Then ; Check if santa spell variable is not set YET
;~ 		ForceCaptureRegion()
;~ 		Local $_IsSantaSpellPixel[4] = [65, 540, 0x7C0427, 20]

;~ 		Local $rPixelCheck = _CheckPixel($_IsSantaSpellPixel, True)

;~ 		If $rPixelCheck = True Then
;~ 			$isSantaSpellAvailable = 1
;~ 		Else
;~ 			$isSantaSpellAvailable = 0
;~ 		EndIf
;~ 	EndIf

	Local $iResult = 0
;~ 	If $isSantaSpellAvailable = 1 Then
;~ 		Switch $trooptype
;~ 			Case "Lightning"
;~ 				$iResult = getMyOcr(35,450,60,16,"troopcost",True)
;~ 			Case "Heal"
;~ 				$iResult = getMyOcr(132,450,60,16,"troopcost",True)
;~ 			Case "Jump"
;~ 				$iResult = getMyOcr(230,450,60,16,"troopcost",True)

;~ 			Case "Clone"
;~ 				$iResult = getMyOcr(328,450,60,16,"troopcost",True)

;~ 			Case "Rage"
;~ 				$iResult = getMyOcr(132,550,60,16,"troopcost",True)
;~ 			Case "Freeze"
;~ 				$iResult = getMyOcr(230,550,60,16,"troopcost",True)

;~ 			Case "Poison"
;~ 				$iResult = getMyOcr(336+98,450,60,16,"troopcost",True)
;~ 			Case "Earth"
;~ 				$iResult = getMyOcr(336+98,550,60,16,"troopcost",True)
;~ 			Case "Haste"
;~ 				$iResult = getMyOcr(434+98,450,60,16,"troopcost",True)
;~ 			Case "Skeleton"
;~ 				$iResult = getMyOcr(434+98,550,60,16,"troopcost",True)
;~ 		EndSwitch
;~ 	Else

;~ 		Switch $trooptype
;~ 			Case "Lightning"
;~ 				$iResult = getMyOcr(0,35,451,60,14,"troopcost",True,False,True)
;~ 			Case "Rage"
;~ 				$iResult = getMyOcr(0,132,451,60,14,"troopcost",True,False,True)
;~ 			Case "Freeze"
;~ 				$iResult = getMyOcr(0,230,451,60,14,"troopcost",True,False,True)

;~ 			Case "Heal"
;~ 				$iResult = getMyOcr(0,35,551,60,14,"troopcost",True,False,True)
;~ 			Case "Jump"
;~ 				$iResult = getMyOcr(0,132,551,60,14,"troopcost",True,False,True)
;~ 			Case "Clone"
;~ 				$iResult = getMyOcr(0,230,551,60,14,"troopcost",True,False,True)

;~ 			Case "Poison"
;~ 				$iResult = getMyOcr(0,336,451,60,14,"troopcost",True,False,True)
;~ 			Case "Earth"
;~ 				$iResult = getMyOcr(0,336,551,60,14,"troopcost",True,False,True)
;~ 			Case "Haste"
;~ 				$iResult = getMyOcr(0,434,451,60,14,"troopcost",True,False,True)
;~ 			Case "Skeleton"
;~ 				$iResult = getMyOcr(0,434,551,60,14,"troopcost",True,False,True)
;~ 		EndSwitch

		Switch $trooptype
			Case "Lightning"
				$iResult = getMyOcr(0,35,451,60,14,"troopcost",True,False,True)
			Case "Rage"
				$iResult = getMyOcr(0,132,451,60,14,"troopcost",True,False,True)
			Case "Freeze"
				$iResult = getMyOcr(0,230,451,60,14,"troopcost",True,False,True)

			Case "Heal"
				$iResult = getMyOcr(0,35,551,60,14,"troopcost",True,False,True)
			Case "Jump"
				$iResult = getMyOcr(0,132,551,60,14,"troopcost",True,False,True)
			Case "Clone"
				$iResult = getMyOcr(0,230,551,60,14,"troopcost",True,False,True)

			Case "Poison"
				$iResult = getMyOcr(0,336,451,60,14,"troopcost",True,False,True)
			Case "Earth"
				$iResult = getMyOcr(0,336,551,60,14,"troopcost",True,False,True)
			Case "Haste"
				$iResult = getMyOcr(0,434,451,60,14,"troopcost",True,False,True)
			Case "Skeleton"
				$iResult = getMyOcr(0,434,551,60,14,"troopcost",True,False,True)
		EndSwitch

;~ 	EndIf
	If $g_iSamM0dDebug = 1 Then SetLog("$iResult: " & $iResult)
	If $iResult = "" Then $iResult = 0
	Return $iResult
EndFunc