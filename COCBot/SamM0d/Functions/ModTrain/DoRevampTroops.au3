; #FUNCTION# ====================================================================================================================
; Name ..........: DoRevampTroops
; Description ...: Training full troops or revamp missing troops with what information get from CheckOnTrainUnit() And CheckAvailableUnit()
;
; Syntax ........: DoRevampTroops()
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
Func DoRevampTroops($bDoPreTrain = False)
	If _Sleep(500) Then Return
	Local $bReVampFlag = False
	Local $tempTroops[20][5]
	$tempTroops	= $MyTroops

	If $ichkMyTroopsOrder Then
		_ArraySort($tempTroops,0,0,0,1)
	EndIf

	For $i = 0 To UBound($tempTroops) - 1
		If $g_iSamM0dDebug = 1 Then SetLog("$tempTroops[" & $i & "]: " & $tempTroops[$i][0] & " - " & $tempTroops[$i][1])
		; reset variable
		Assign("Dif" & $tempTroops[$i][0],0)
		Assign("Add" & $tempTroops[$i][0],0)
	Next

	If $bDoPreTrain = False Then
		For $i = 0 To UBound($tempTroops) - 1
			Local $tempCurComp = $tempTroops[$i][3]
			Local $tempCur = Eval("Cur" & $tempTroops[$i][0]) + Eval("OnT" & $tempTroops[$i][0])
			If $g_iSamM0dDebug = 1 Then SetLog("$tempMyTroops: " & $tempCurComp)
			If $g_iSamM0dDebug = 1 Then SetLog("$tempCur: " & $tempCur)
			If $tempCurComp <> $tempCur Then
				Assign("Dif" & $tempTroops[$i][0], $tempCurComp - $tempCur)
			EndIf
		Next
	Else
		For $i = 0 To UBound($tempTroops) - 1
			If $tempTroops[$i][3] <> Eval("OnQ" & $tempTroops[$i][0]) Then
				Assign("Dif" & $tempTroops[$i][0], $tempTroops[$i][3] - Eval("OnQ" & $tempTroops[$i][0]))
			EndIf
		Next
	EndIf

	For $i = 0 To UBound($tempTroops) - 1
		If Eval("Dif" & $tempTroops[$i][0]) > 0 Then
			If $g_iSamM0dDebug = 1 Then SetLog("Some troops haven't train: " & $tempTroops[$i][0])
			If $g_iSamM0dDebug = 1 Then SetLog("Setting Qty Of " & $tempTroops[$i][0] & " troops: " & $tempTroops[$i][3])
			;SetLog("Prepare for train number Of " & MyNameOfTroop(Eval("e" & $tempTroops[$i][0]), Eval("Dif" & $tempTroops[$i][0])) & " x" & Eval("Dif" & $tempTroops[$i][0]),$COLOR_ACTION)
			Assign("Add" & $tempTroops[$i][0], Eval("Dif" & $tempTroops[$i][0]))
			$bReVampFlag = True
		ElseIf Eval("Dif" & $tempTroops[$i][0]) < 0 Then
			If $g_iSamM0dDebug = 1 Then SetLog("Some troops over train: " & $tempTroops[$i][0])
			If $g_iSamM0dDebug = 1 Then SetLog("Setting Qty Of " & $tempTroops[$i][0] & " troops: " & $tempTroops[$i][3])
			If $g_iSamM0dDebug = 1 Then SetLog("Current Qty Of " & $tempTroops[$i][0] & " troops: " & $tempTroops[$i][3]- Eval("Dif" & $tempTroops[$i][0]))
		EndIf
	Next

	If $bReVampFlag Then
		If gotoTrainTroops() = False Then Return
			If _sleep(100) Then Return
			; starttrain
			Local $iRemainTroopsCapacity = 0
			Local $iCreatedTroopsCapacity = 0
			Local $bFlagOutOfResource = False
			If $bDoPreTrain Then
				$iDonatedUnit = 0
				If Not IsArray($g_aiTroopsMaxCamp) Then $g_aiTroopsMaxCamp = getTrainArmyCapacity()
				$iRemainTroopsCapacity = $g_aiTroopsMaxCamp[1] - $g_aiTroopsMaxCamp[0]
				If $iRemainTroopsCapacity <= 0 Then
					SetLog("Troops full with pre-train.", $COLOR_INFO)
					Return
				EndIf
			Else
				$iRemainTroopsCapacity = $g_iTotalCampSpace - $g_aiTroopsMaxCamp[0]
				If $iRemainTroopsCapacity <= 0 Then
					SetLog("Troops full.", $COLOR_ERROR)
					Return
				EndIf
			EndIf


			For $i = 0 To UBound($tempTroops) - 1
				Local $iOnQQty = Eval("Add" & $tempTroops[$i][0])
				If $iOnQQty > 0 Then
					SetLog($CustomTrain_MSG_5 & " " & MyNameOfTroop(Eval("e" & $tempTroops[$i][0]), $iOnQQty) & " x" & $iOnQQty,$COLOR_ACTION)
				EndIf
			Next

			Local $iCurElixir = $g_aiCurrentLoot[$eLootElixir]
			Local $iCurDarkElixir = $g_aiCurrentLoot[$eLootDarkElixir]
			Local $iCurGemAmount = $g_iGemAmount

			SetLog("Elixir: " & $iCurElixir & "   Dark Elixir: " & $iCurDarkElixir & "   Gem: " & $iCurGemAmount, $COLOR_INFO)

			For $i = 0 To UBound($tempTroops) - 1
				Local $Troop4Add = Eval("Add" & $tempTroops[$i][0])
				If $Troop4Add > 0 And $iRemainTroopsCapacity > 0 Then
					; locate troop button
					If LocateTroopButton($tempTroops[$i][0]) Then
					Local $fixRemain = 0
					Local $iCost
					; check train cost before click, incase use gem

					If $ichkEnableMySwitch = 0 Then
						If $tempTroops[$i][4] = 0 Then
							$iCost = getMyOcr(0,$g_iTroopButtonX - 55,$g_iTroopButtonY + 26, 68, 18,"troopcost",True,False,True)
							If $iCost = 0 Or $iCost >= $MyTroopsCost[Eval("e" & $tempTroops[$i][0])][0] Then
								; cannot read train cost, use max level train cost
								$iCost = $MyTroopsCost[Eval("e" & $tempTroops[$i][0])][0]
							EndIf
							$MyTroops[Eval("e" & $tempTroops[$i][0])][4] = $iCost
						Else
							$iCost = $tempTroops[$i][4]
						EndIf
					Else
						$iCost = getMyOcr(0,$g_iTroopButtonX - 55,$g_iTroopButtonY + 26, 68, 18,"troopcost",True,False,True)
						If $iCost = 0 Or $iCost >= $MyTroopsCost[Eval("e" & $tempTroops[$i][0])][0] Then
							; cannot read train cost, use max level train cost
							$iCost = $MyTroopsCost[Eval("e" & $tempTroops[$i][0])][0]
						EndIf
					EndIf

					If $g_iSamM0dDebug = 1 Then SetLog("$iCost: " & $iCost)
					;Local $iBuildCost = (Eval("e" & $tempTroops[$i][0]) > 11 ? getMyOcrCurDEFromTrain() : getMyOcrCurElixirFromTrain())
					Local $iBuildCost = (Eval("e" & $tempTroops[$i][0]) > 11 ? $iCurDarkElixir : $iCurElixir)
					;SetLog($CustomTrain_MSG_11 & " " & (Eval("e" & $tempTroops[$i][0]) > 11 ? $CustomTrain_MSG_DarkElixir : $CustomTrain_MSG_Elixir)  & ": " & $iBuildCost, (Eval("e" & $tempTroops[$i][0]) > 11 ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))
					;SetLog($CustomTrain_MSG_12 & ": " & $iCost, (Eval("e" & $tempTroops[$i][0]) > 11 ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))

					If $g_iSamM0dDebug = 1 Then SetLog("$iBuildCost: " & $iBuildCost)
					If $g_iSamM0dDebug = 1 Then SetLog("Total need: " & ($Troop4Add * $iCost))
					If ($Troop4Add * $iCost) > $iBuildCost Then
						$bFlagOutOfResource = True
						; use eval and not $i to compare because of maybe after array sort $tempTroops
						Setlog($CustomTrain_MSG_8 & " " & (Eval("e" & $tempTroops[$i][0]) > 11 ? $CustomTrain_MSG_DarkElixir : $CustomTrain_MSG_Elixir) & " " & $CustomTrain_MSG_9 & " " & MyNameOfTroop(Eval("e" & $tempTroops[$i][0]),0), $COLOR_ERROR)
						SetLog("Current " & (Eval("e" & $tempTroops[$i][0]) > 11 ? $CustomTrain_MSG_DarkElixir : $CustomTrain_MSG_Elixir)  & ": " & $iBuildCost, $COLOR_ERROR)
						SetLog("Total need: " & $Troop4Add * $iCost, $COLOR_ERROR)
					EndIf

					If $bFlagOutOfResource Then
						$g_bOutOfElixir = 1
						Setlog("Switching to Halt Attack, Stay Online Mode...", $COLOR_ERROR)
						$g_bChkBotStop = True ; set halt attack variable
						$g_iCmbBotCond = 18; set stay online
						If Not ($g_bFullArmy = True) Then $g_bRestart = True ;If the army camp is full, If yes then use it to refill storages
						Return ; We are out of Elixir stop training.
					EndIf
					; use eval and not $i to compare because of maybe after array sort $tempTroops
					SetLog($CustomTrain_MSG_6 & " " & MyNameOfTroop(Eval("e" & $tempTroops[$i][0]),$Troop4Add) & " x" & $Troop4Add & " " & $CustomTrain_MSG_7 & " " & (Eval("e" & $tempTroops[$i][0]) > 11 ? $CustomTrain_MSG_DarkElixir : $CustomTrain_MSG_Elixir) & " : " & ($Troop4Add * $iCost),(Eval("e" & $tempTroops[$i][0]) > 11 ? $COLOR_DARKELIXIR : $COLOR_ELIXIR))

					If ($tempTroops[$i][2] * $Troop4Add) <= $iRemainTroopsCapacity Then
						If MyTrainClick($g_iTroopButtonX, $g_iTroopButtonY, $Troop4Add,$g_iTrainClickDelay, "#TT01") Then
							If Eval("e" & $tempTroops[$i][0]) > 11 Then
								$iCurDarkElixir -= ($Troop4Add * $iCost)
							Else
								$iCurElixir -= ($Troop4Add * $iCost)
							EndIf
							$iRemainTroopsCapacity -= ($tempTroops[$i][2] * $Troop4Add)
						EndIf
					Else
						Local $iReduceCap = Int($iRemainTroopsCapacity / $tempTroops[$i][2])
						SetLog("troops above cannot fit to max capicity, reduce to train " & MyNameOfTroop(Eval("e" & $tempTroops[$i][0]),$iReduceCap) & " x" & $iReduceCap,$COLOR_ERROR)
						If MyTrainClick($g_iTroopButtonX, $g_iTroopButtonY,$iReduceCap ,$g_iTrainClickDelay, "#TT01") Then
							If Eval("e" & $tempTroops[$i][0]) > 11 Then
								$iCurDarkElixir -= ($iReduceCap * $iCost)
							Else
								$iCurElixir -= ($iReduceCap * $iCost)
							EndIf
							$fixRemain = $iRemainTroopsCapacity - ($iReduceCap * $tempTroops[$i][2])
							$iRemainTroopsCapacity -= ($iRemainTroopsCapacity - ($iReduceCap * $tempTroops[$i][2]))
						EndIf
					EndIf
					If $fixRemain > 0 Then
;~ 						CheckNeedSwipe($eArch)
						SetLog("still got remain capacity, so train " & MyNameOfTroop(Eval("eArch"),$fixRemain) & " x" & $fixRemain & " to fit it.",$COLOR_ERROR)
						If LocateTroopButton("Arch") Then
							If MyTrainClick($g_iTroopButtonX, $g_iTroopButtonY,$fixRemain,$g_iTrainClickDelay, "#TT01") Then
								If Eval("e" & $tempTroops[$i][0]) > 11 Then
									$iCurDarkElixir -= ($fixRemain * $MyTroopsCost[$eArch][0])
								Else
									$iCurElixir -= ($fixRemain * $MyTroopsCost[$eArch][0])
								EndIf
								$iRemainTroopsCapacity -= $fixRemain
							EndIf
						Else
							SetLog("Cannot find button (1): " & $tempTroops[$i][0] & " for click", $COLOR_ERROR)
						EndIf
					EndIf

					Else
						SetLog("Cannot find button (2): " & $tempTroops[$i][0] & " for click", $COLOR_ERROR)
					EndIf

					; reduce some speed
					If _Sleep(500) Then Return
				EndIf
			Next
	EndIf
	If $bDoPreTrain Then
		; all troops and pre-train troops already made, temparary disable check the troops until the donate make.
		$tempDisableTrain = True
	EndIf
EndFunc

Func DoMyQuickTrain($MyTrainArmy)
	;If gotoTrainTroops() Then
	If _Sleep(200) Then Return
	If gotoQuickTrain() = True Then
		Local $aButtonTemp[9]
		Switch $MyTrainArmy
			Case 1
				$aButtonTemp = $aButtonTrainArmy1
			Case 2
				$aButtonTemp = $aButtonTrainArmy2
			case 3
				$aButtonTemp = $aButtonTrainArmy3
		EndSwitch
		If _Sleep(200) Then Return
		ForceCaptureRegion()
		_CaptureRegion()
		If _ColorCheck(_GetPixelColor($aButtonTemp[4], $aButtonTemp[5], False), Hex($aButtonTemp[6], 6), $aButtonTemp[7]) Then
			Local $x, $y
			HMLClickPR($aButtonTemp, $x, $y)
			HMLClick($x, $y)
			SetLog("Train army using quick train army " & $MyTrainArmy & " button.", $COLOR_SUCCESS)
			If $g_CurrentCampUtilization <> 0 Then
				$tempDisableTrain = True
			EndIf
			If _Sleep(200) Then Return
		Else
			If _ColorCheck(_GetPixelColor(50, $aButtonTemp[5], False), Hex(0XD3D3CB, 6), 6) Then
				Return
			Else
				SetLog("Failed to locate quick train army " & $MyTrainArmy & " button.", $COLOR_ERROR)
				SetLog("Try using custom train for train troops.", $COLOR_ERROR)
				If $g_CurrentCampUtilization <> 0 And $g_CurrentCampUtilization < $g_iTotalCampSpace Then
					DoRevampTroops()
				ElseIf $g_aiTroopsMaxCamp[0] > Int((($g_aiTroopsMaxCamp[1] / 2) * $g_iTrainArmyFullTroopPct) / 100) And $g_iTrainArmyFullTroopPct = 100 Then
					DoRevampTroops(True)
				EndIf
			EndIf
		EndIf
	Else
		SetLog("Cannot open quick train tab page.",$COLOR_ERROR)
	EndIf
EndFunc

Func CheckNeedSwipe($TrainTroop)
	; check need swipe
	Local $iSwipeNum = 15

	Local $iCount = 0
	If $TrainTroop > $iSwipeNum Then
		$iCount = 0
		While Not _ColorCheck(_GetPixelColor(838, 370 + $g_iMidOffsetY, True), Hex(0XD3D3CB, 6), 10)
			;ClickDrag(830,476,25,476,250)
			ClickDrag(617,476,418,476,250)
			If _sleep(500) Then Return False
			$iCount += 1
			If $iCount > 3 Then Return False
		WEnd
	Else
		$iCount = 0
		While Not _ColorCheck(_GetPixelColor(24, 370 + $g_iMidOffsetY, True), Hex(0XD3D3CB, 6), 10)
			;ClickDrag(25,476,830,476,250)
			ClickDrag(436,476,636,476,250)
			If _sleep(500) Then Return False
			$iCount += 1
			If $iCount > 3 Then Return False
		WEnd
	EndIf
	Return True
EndFunc

;~ Func getTroopCost($trooptype)
;~ 	Local $iResult = 0
;~ 	Switch $trooptype
;~ 		Case "Barb"
;~ 			$iResult = getMyOcr(0,35,450,60,16,"troopcost",True,False,True)
;~ 		Case "Pumpkin"
;~ 			$iResult = getMyOcr(0,35,552,60,16,"troopcost",True,False,True)
;~ 		Case "Arch"
;~ 			$iResult = getMyOcr(0,134,450,60,16,"troopcost",True,False,True)
;~ 		Case "Giant"
;~ 			$iResult = getMyOcr(0,134,552,60,16,"troopcost",True,False,True)
;~ 		Case "GiantSkeleton"
;~ 			$iResult = getMyOcr(0,233,450,60,16,"troopcost",True,False,True)
;~ 		Case "Golb"
;~ 			$iResult = getMyOcr(0,233,552,60,16,"troopcost",True,False,True)
;~ 		Case "Wall"
;~ 			$iResult = getMyOcr(0,332,450,60,16,"troopcost",True,False,True)
;~ 		Case "Ball"
;~ 			$iResult = getMyOcr(0,332,552,60,16,"troopcost",True,False,True)
;~ 		Case "Wiza"
;~ 			$iResult = getMyOcr(0,431,450,60,16,"troopcost",True,False,True)
;~ 		Case "Heal"
;~ 			$iResult = getMyOcr(0,431,552,60,16,"troopcost",True,False,True)
;~ 		Case "Drag"
;~ 			$iResult = getMyOcr(0,530,450,60,16,"troopcost",True,False,True)
;~ 		Case "Pekk"
;~ 			$iResult = getMyOcr(0,530,552,60,16,"troopcost",True,False,True)

;~ 		Case "BabyD"
;~ 			$iResult = getMyOcr(0,622,450,60,16,"troopcost",True,False,True)
;~ 		Case "Mine"
;~ 			$iResult = getMyOcr(0,622,552,60,16,"troopcost",True,False,True)

;~ 		Case "Mini"
;~ 			$iResult = getMyOcr(0,731,450,60,16,"troopcost",True,False,True)
;~ 		Case "Hogs"
;~ 			$iResult = getMyOcr(0,731,552,60,16,"troopcost",True,False,True)

;~ 		Case "Valk"
;~ 			$iResult = getMyOcr(0,551,450,60,16,"troopcost",True,False,True)
;~ 		Case "Gole"
;~ 			$iResult = getMyOcr(0,551,552,60,16,"troopcost",True,False,True)
;~ 		Case "Witc"
;~ 			$iResult = getMyOcr(0,648,450,60,16,"troopcost",True,False,True)
;~ 		Case "Lava"
;~ 			$iResult = getMyOcr(0,648,552,60,16,"troopcost",True,False,True)
;~ 		Case "Bowl"
;~ 			$iResult = getMyOcr(0,747,450,60,16,"troopcost",True,False,True)

;~ 	EndSwitch

;~ 	Switch $trooptype
;~ 		Case "Barb"
;~ 			$iResult = getMyOcr(0,35,450,60,16,"troopcost",True,False,True)
;~ 		Case "Arch"
;~ 			$iResult = getMyOcr(0,35,552,60,16,"troopcost",True,False,True)
;~ 		Case "Giant"
;~ 			$iResult = getMyOcr(0,134,450,60,16,"troopcost",True,False,True)
;~ 		Case "Gobl"
;~ 			$iResult = getMyOcr(0,134,552,60,16,"troopcost",True,False,True)
;~ 		Case "Wall"
;~ 			$iResult = getMyOcr(0,233,450,60,16,"troopcost",True,False,True)
;~ 		Case "Ball"
;~ 			$iResult = getMyOcr(0,233,552,60,16,"troopcost",True,False,True)
;~ 		Case "Wiza"
;~ 			$iResult = getMyOcr(0,332,450,60,16,"troopcost",True,False,True)
;~ 		Case "Heal"
;~ 			$iResult = getMyOcr(0,332,552,60,16,"troopcost",True,False,True)
;~ 		Case "Drag"
;~ 			$iResult = getMyOcr(0,431,450,60,16,"troopcost",True,False,True)
;~ 		Case "Pekk"
;~ 			$iResult = getMyOcr(0,431,552,60,16,"troopcost",True,False,True)
;~ 		Case "BabyD"
;~ 			$iResult = getMyOcr(0,530,450,60,16,"troopcost",True,False,True)
;~ 		Case "Mine"
;~ 			$iResult = getMyOcr(0,530,552,60,16,"troopcost",True,False,True)

;~ 		Case "Mini"
;~ 			$iResult = getMyOcr(0,632,450,60,16,"troopcost",True,False,True)
;~ 		Case "Hogs"
;~ 			$iResult = getMyOcr(0,632,552,60,16,"troopcost",True,False,True)
;~ 		Case "Valk"
;~ 			$iResult = getMyOcr(0,731,450,60,16,"troopcost",True,False,True)
;~ 		Case "Gole"
;~ 			$iResult = getMyOcr(0,731,552,60,16,"troopcost",True,False,True)
;~ 		Case "Witc"
;~ 			$iResult = getMyOcr(0,648,450,60,16,"troopcost",True,False,True)
;~ 		Case "Lava"
;~ 			$iResult = getMyOcr(0,648,552,60,16,"troopcost",True,False,True)
;~ 		Case "Bowl"
;~ 			$iResult = getMyOcr(0,747,450,60,16,"troopcost",True,False,True)

;~ 	EndSwitch

;~ 	If $g_iSamM0dDebug = 1 Then SetLog("$iResult: " & $iResult)
;~ 	If $iResult = "" Then $iResult = 0
;~ 	Return $iResult
;~ EndFunc
