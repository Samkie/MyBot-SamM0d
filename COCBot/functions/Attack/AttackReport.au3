; #FUNCTION# ====================================================================================================================
; Name ..........: AttackReport
; Description ...: This function will report the loot from the last Attack: gold, elixir, dark elixir and trophies.
;                  It will also update the statistics to the GUI (Last Attack).
; Syntax ........: AttackReport()
; Parameters ....: None
; Return values .: None
; Author ........: Hervidero (02-2015), Sardo (05-2015), Hervidero (12-2015)
; Modified ......: Sardo (05-2015), Hervidero (05-2015), Knowjack (07-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func AttackReport()
	Static $iBonusLast = 0 ; last attack Bonus percentage
	Local $g_asLeagueDetailsShort = ""
	Local $iCount

;~ 	$iCount = 0 ; Reset loop counter
;~ 	While _CheckPixel($aEndFightSceneAvl, True) = False ; check for light gold pixle in the Gold ribbon in End of Attack Scene before reading values
;~ 		$iCount += 1
;~ 		If _Sleep($DELAYATTACKREPORT1) Then Return
;~ 		If $g_bDebugSetlog Then SetDebugLog("Waiting Attack Report Ready, " & ($iCount / 2) & " Seconds.", $COLOR_DEBUG)
;~ 		If $iCount > 20 Then ExitLoop ; wait 20*500ms = 10 seconds max before we have call the OCR read an error
;~ 	WEnd
;~ 	If $iCount > 20 Then SetLog("End of Attack scene slow to appear, attack values my not be correct", $COLOR_INFO)

	Local $iTempStatsLastAttack[UBound($g_iStatsLastAttack)]
	Local $iTempOldStatsLastAttack[UBound($g_iStatsLastAttack)]
	Local $iTempStatsBonusLast[UBound($g_iStatsBonusLast)]
	Local $iTempOldStatsBonusLast[UBound($g_iStatsBonusLast)]
	Local $iTempBonusLast, $iTempOldBonusLast
	Local $iTempstarsearned, $iTempOldstarsearned
	Local $starsearned
	Local $bRedo = True

	$iCount = 0
	While $bRedo
		$bRedo = False
		; samm0d - set ocr farce capture to false
		Local $wasForce = OcrForceCaptureRegion(False)
		_CaptureRegions()

		$iTempStatsLastAttack[$eLootGold] = getResourcesLoot(333, 289 + $g_iMidOffsetY)
		If $iTempStatsLastAttack[$eLootGold] <> $iTempOldStatsLastAttack[$eLootGold] Then
			$iTempOldStatsLastAttack[$eLootGold] = $iTempStatsLastAttack[$eLootGold]
			$bRedo = True
		EndIf
		$iTempStatsLastAttack[$eLootElixir] = getResourcesLoot(333, 328 + $g_iMidOffsetY)
		If $iTempStatsLastAttack[$eLootElixir] <> $iTempOldStatsLastAttack[$eLootElixir] Then
			$iTempOldStatsLastAttack[$eLootElixir] = $iTempStatsLastAttack[$eLootElixir]
			$bRedo = True
		EndIf
		If _ColorCheck(_GetPixelColor($aAtkRprtDECheck[0], $aAtkRprtDECheck[1], $g_bNoCapturePixel), Hex($aAtkRprtDECheck[2], 6), $aAtkRprtDECheck[3]) Then ; if the color of the DE drop detected
			$iTempStatsLastAttack[$eLootDarkElixir] = getResourcesLootDE(365, 365 + $g_iMidOffsetY)
			If $iTempStatsLastAttack[$eLootDarkElixir] <> $iTempOldStatsLastAttack[$eLootDarkElixir] Then
				$iTempOldStatsLastAttack[$eLootDarkElixir] = $iTempStatsLastAttack[$eLootDarkElixir]
				$bRedo = True
			EndIf
			$iTempStatsLastAttack[$eLootTrophy] = getResourcesLootT(403, 402 + $g_iMidOffsetY)
		Else
			$iTempStatsLastAttack[$eLootTrophy] = getResourcesLootT(403, 365 + $g_iMidOffsetY)
		EndIf
		If $iTempStatsLastAttack[$eLootTrophy] <> $iTempOldStatsLastAttack[$eLootTrophy] Then
			$iTempOldStatsLastAttack[$eLootTrophy] = $iTempStatsLastAttack[$eLootTrophy]
			$bRedo = True
		EndIf

		If $iTempStatsLastAttack[$eLootTrophy] >= 0 Then
			$iTempBonusLast = Number(getResourcesBonusPerc(570, 309 + $g_iMidOffsetY))
			If ($iTempBonusLast <> $iTempOldBonusLast) Or ($iTempBonusLast = 0) Then
				$iTempOldBonusLast = $iTempBonusLast
				$bRedo = True
			Else
				If $iTempBonusLast > 0 Then
					$iTempStatsBonusLast[$eLootGold] = getResourcesBonus(590, 340 + $g_iMidOffsetY)
					$iTempStatsBonusLast[$eLootGold] = StringReplace($iTempStatsBonusLast[$eLootGold], "+", "")
					If $iTempStatsBonusLast[$eLootGold] <> $iTempOldStatsBonusLast[$eLootGold] Then
						$iTempOldStatsBonusLast[$eLootGold] = $iTempStatsBonusLast[$eLootGold]
						$bRedo = True
					EndIf
					$iTempStatsBonusLast[$eLootElixir] = getResourcesBonus(590, 371 + $g_iMidOffsetY)
					$iTempStatsBonusLast[$eLootElixir] = StringReplace($iTempStatsBonusLast[$eLootElixir], "+", "")
					If $iTempStatsBonusLast[$eLootElixir] <> $iTempOldStatsBonusLast[$eLootElixir] Then
						$iTempOldStatsBonusLast[$eLootElixir] = $iTempStatsBonusLast[$eLootElixir]
						$bRedo = True
					EndIf
					If _ColorCheck(_GetPixelColor($aAtkRprtDECheck2[0], $aAtkRprtDECheck2[1], $g_bNoCapturePixel), Hex($aAtkRprtDECheck2[2], 6), $aAtkRprtDECheck2[3]) Then
						$iTempStatsBonusLast[$eLootDarkElixir] = getResourcesBonus(621, 402 + $g_iMidOffsetY)
						$iTempStatsBonusLast[$eLootDarkElixir] = StringReplace($iTempStatsBonusLast[$eLootDarkElixir], "+", "")
					Else
						$iTempStatsBonusLast[$eLootDarkElixir] = 0
					EndIf
					If $iTempStatsBonusLast[$eLootDarkElixir] <> $iTempOldStatsBonusLast[$eLootDarkElixir] Then
						$iTempOldStatsBonusLast[$eLootDarkElixir] = $iTempStatsBonusLast[$eLootDarkElixir]
						$bRedo = True
					EndIf
				EndIf
			EndIf
		EndIf
		; check stars earned
		$starsearned = 0
		If _ColorCheck(_GetPixelColor($aWonOneStarAtkRprt[0], $aWonOneStarAtkRprt[1], $g_bNoCapturePixel), Hex($aWonOneStarAtkRprt[2], 6), $aWonOneStarAtkRprt[3]) Then $starsearned += 1
		If _ColorCheck(_GetPixelColor($aWonTwoStarAtkRprt[0], $aWonTwoStarAtkRprt[1], $g_bNoCapturePixel), Hex($aWonTwoStarAtkRprt[2], 6), $aWonTwoStarAtkRprt[3]) Then $starsearned += 1
		If _ColorCheck(_GetPixelColor($aWonThreeStarAtkRprt[0], $aWonThreeStarAtkRprt[1], $g_bNoCapturePixel), Hex($aWonThreeStarAtkRprt[2], 6), $aWonThreeStarAtkRprt[3]) Then $starsearned += 1

		$iTempstarsearned = $starsearned
		If $iTempstarsearned <> $iTempOldstarsearned Then
			$iTempOldstarsearned = $iTempstarsearned
			$bRedo = True
		EndIf
		; samm0d
		OcrForceCaptureRegion($wasForce)
		If _Sleep($DELAYATTACKREPORT1) Then Return ; delay 500ms

		$iCount += 1
		If $iCount > 30 Then
			Setlog("Return Home scene read loot value error, attack values may not be correct", $COLOR_INFO)
			ExitLoop
		EndIf
	WEnd

	$g_iStatsLastAttack[$eLootGold] = $iTempStatsLastAttack[$eLootGold]
	$g_iStatsLastAttack[$eLootElixir] = $iTempStatsLastAttack[$eLootElixir]
	$g_iStatsLastAttack[$eLootDarkElixir] = $iTempStatsLastAttack[$eLootDarkElixir]
	$g_iStatsLastAttack[$eLootTrophy] = $iTempStatsLastAttack[$eLootTrophy]
	If _ColorCheck(_GetPixelColor($aAtkRprtTrophyCheck[0], $aAtkRprtTrophyCheck[1], $g_bNoCapturePixel), Hex($aAtkRprtTrophyCheck[2], 6), $aAtkRprtTrophyCheck[3]) Then
		$g_iStatsLastAttack[$eLootTrophy] = -$g_iStatsLastAttack[$eLootTrophy]
	EndIf

	If _ColorCheck(_GetPixelColor($aAtkRprtDECheck[0], $aAtkRprtDECheck[1], $g_bNoCapturePixel), Hex($aAtkRprtDECheck[2], 6), $aAtkRprtDECheck[3]) Then ; if the color of the DE drop detected
		SetLog("Loot: [G]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [E]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [DE]: " & _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]) & " [T]: " & $g_iStatsLastAttack[$eLootTrophy], $COLOR_SUCCESS)
	Else
		SetLog("Loot: [G]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [E]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [T]: " & $g_iStatsLastAttack[$eLootTrophy], $COLOR_SUCCESS)
	EndIf

	If $g_iStatsLastAttack[$eLootTrophy] >= 0 Then
		$iBonusLast = $iTempBonusLast
		If $iBonusLast > 0 Then
			$g_iStatsBonusLast[$eLootGold] = $iTempStatsBonusLast[$eLootGold]
			$g_iStatsBonusLast[$eLootElixir] = $iTempStatsBonusLast[$eLootElixir]
			$g_iStatsBonusLast[$eLootDarkElixir] = $iTempStatsBonusLast[$eLootDarkElixir]

			SetLog("Bonus Percentage: " & $iBonusLast & "%")
			Local $iCalcMaxBonus = 0, $iCalcMaxBonusDark = 0

			If _ColorCheck(_GetPixelColor($aAtkRprtDECheck2[0], $aAtkRprtDECheck2[1], $g_bNoCapturePixel), Hex($aAtkRprtDECheck2[2], 6), $aAtkRprtDECheck2[3]) Then
				If $iBonusLast = 100 Then
					$iCalcMaxBonus = $g_iStatsBonusLast[$eLootGold]
					SetLog("Bonus [G]: " & _NumberFormat($g_iStatsBonusLast[$eLootGold]) & " [E]: " & _NumberFormat($g_iStatsBonusLast[$eLootElixir]) & " [DE]: " & _NumberFormat($g_iStatsBonusLast[$eLootDarkElixir]), $COLOR_SUCCESS)
				Else
					$iCalcMaxBonus = Number($g_iStatsBonusLast[$eLootGold] / ($iBonusLast / 100))
					$iCalcMaxBonusDark = Number($g_iStatsBonusLast[$eLootDarkElixir] / ($iBonusLast / 100))

					SetLog("Bonus [G]: " & _NumberFormat($g_iStatsBonusLast[$eLootGold]) & " out of " & _NumberFormat($iCalcMaxBonus) & " [E]: " & _NumberFormat($g_iStatsBonusLast[$eLootElixir]) & " out of " & _NumberFormat($iCalcMaxBonus) & " [DE]: " & _NumberFormat($g_iStatsBonusLast[$eLootDarkElixir]) & " out of " & _NumberFormat($iCalcMaxBonusDark), $COLOR_SUCCESS)
				EndIf
			Else
				If $iBonusLast = 100 Then
					$iCalcMaxBonus = $g_iStatsBonusLast[$eLootGold]
					SetLog("Bonus [G]: " & _NumberFormat($g_iStatsBonusLast[$eLootGold]) & " [E]: " & _NumberFormat($g_iStatsBonusLast[$eLootElixir]), $COLOR_SUCCESS)
				Else
					$iCalcMaxBonus = Number($g_iStatsBonusLast[$eLootGold] / ($iBonusLast / 100))
					SetLog("Bonus [G]: " & _NumberFormat($g_iStatsBonusLast[$eLootGold]) & " out of " & _NumberFormat($iCalcMaxBonus) & " [E]: " & _NumberFormat($g_iStatsBonusLast[$eLootElixir]) & " out of " & _NumberFormat($iCalcMaxBonus), $COLOR_SUCCESS)
				EndIf
			EndIf
			$g_asLeagueDetailsShort = "--"
			For $i = 1 To 21 ; skip 0 = Bronze III, see "No Bonus" else section below
				If $g_asLeagueDetails[$i][0] = $iCalcMaxBonus Then
					SetLog("Your league level is: " & $g_asLeagueDetails[$i][1])
					$g_asLeagueDetailsShort = $g_asLeagueDetails[$i][3]
					ExitLoop
				EndIf
			Next
		Else
			SetLog("No Bonus")
			$g_iStatsBonusLast[$eLootGold] = 0
			$g_iStatsBonusLast[$eLootElixir] = 0
			$g_iStatsBonusLast[$eLootDarkElixir] = 0
			$g_asLeagueDetailsShort = "--"
			If $g_aiCurrentLoot[$eLootTrophy] + $g_iStatsLastAttack[$eLootTrophy] >= 400 And $g_aiCurrentLoot[$eLootTrophy] + $g_iStatsLastAttack[$eLootTrophy] < 500 Then ; Bronze III has no League bonus
				SetLog("Your league level is: " & $g_asLeagueDetails[0][1])
				$g_asLeagueDetailsShort = $g_asLeagueDetails[0][3]
			EndIf
		EndIf
		;Display League in Stats ==>
		GUICtrlSetData($g_hLblLeague, "")

		;samm0d
		If StringInStr($g_asLeagueDetailsShort, "1") > 1 Then
			GUICtrlSetData($g_hLblLeague, "1")
			$aProfileStats[27][$iCurActiveAcc+1] = 1
		ElseIf StringInStr($g_asLeagueDetailsShort, "2") > 1 Then
			GUICtrlSetData($g_hLblLeague, "2")
			$aProfileStats[27][$iCurActiveAcc+1] = 2
		ElseIf StringInStr($g_asLeagueDetailsShort, "3") > 1 Then
			GUICtrlSetData($g_hLblLeague, "3")
			$aProfileStats[27][$iCurActiveAcc+1] = 3
		EndIf
		_GUI_Value_STATE("HIDE", $g_aGroupLeague)
		If StringInStr($g_asLeagueDetailsShort, "B") > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueBronze], $GUI_SHOW)
			$aProfileStats[26][$iCurActiveAcc+1] = "B"
		ElseIf StringInStr($g_asLeagueDetailsShort, "S") > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueSilver], $GUI_SHOW)
			$aProfileStats[26][$iCurActiveAcc+1] = "S"
		ElseIf StringInStr($g_asLeagueDetailsShort, "G") > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueGold], $GUI_SHOW)
			$aProfileStats[26][$iCurActiveAcc+1] = "G"
		ElseIf StringInStr($g_asLeagueDetailsShort, "c", $STR_CASESENSE) > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueCrystal], $GUI_SHOW)
			$aProfileStats[26][$iCurActiveAcc+1] = "c"
		ElseIf StringInStr($g_asLeagueDetailsShort, "M") > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueMaster], $GUI_SHOW)
			$aProfileStats[26][$iCurActiveAcc+1] = "M"
		ElseIf StringInStr($g_asLeagueDetailsShort, "C", $STR_CASESENSE) > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueChampion], $GUI_SHOW)
			$aProfileStats[26][$iCurActiveAcc+1] = "C"
		ElseIf StringInStr($g_asLeagueDetailsShort, "T") > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueTitan], $GUI_SHOW)
			$aProfileStats[26][$iCurActiveAcc+1] = "T"
		ElseIf StringInStr($g_asLeagueDetailsShort, "LE") > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueLegend], $GUI_SHOW)
			$aProfileStats[26][$iCurActiveAcc+1] = "LE"
		Else
			GUICtrlSetState($g_ahPicLeague[$eLeagueUnranked], $GUI_SHOW)
			$aProfileStats[26][$iCurActiveAcc+1] = 0
		EndIf
		;==> Display League in Stats
	Else
		$g_iStatsBonusLast[$eLootGold] = 0
		$g_iStatsBonusLast[$eLootElixir] = 0
		$g_iStatsBonusLast[$eLootDarkElixir] = 0
		$g_asLeagueDetailsShort = "--"
	EndIf

	Local $AtkLogTxt
	; samm0d
	If $ichkEnableMySwitch Then
		If $iCurActiveAcc <> - 1 Then
			$AtkLogTxt = $iCurActiveAcc + 1 & "#"
		Else
			$AtkLogTxt = "  "
		EndIf
	Else
		$AtkLogTxt = "  "
	EndIf
	$AtkLogTxt &= "|" & _NowTime(4) & "|"
	$AtkLogTxt &= StringFormat("%5d", $g_aiCurrentLoot[$eLootTrophy]) & "|"
	$AtkLogTxt &= StringFormat("%6d", $g_iSearchCount) & "|"
	$AtkLogTxt &= StringFormat("%7d", $g_iStatsLastAttack[$eLootGold]) & "|"
	$AtkLogTxt &= StringFormat("%7d", $g_iStatsLastAttack[$eLootElixir]) & "|"
	If $numLSpellDrop > 0 Then ;samm0d
		$AtkLogTxt &=  "z" & $numLSpellDrop & StringFormat("%5d",$g_iStatsLastAttack[$eLootDarkElixir]) & "|"
		$numLSpellDrop = 0
	Else
		$AtkLogTxt &= StringFormat("%7d", $g_iStatsLastAttack[$eLootDarkElixir]) & "|"
	EndIf
	$AtkLogTxt &= StringFormat("%3d", $g_iStatsLastAttack[$eLootTrophy]) & "|"
	$AtkLogTxt &= StringFormat("%2d", $starsearned) & "|"
	$AtkLogTxt &= StringFormat("%6d", $g_iStatsBonusLast[$eLootGold]) & "|"
	$AtkLogTxt &= StringFormat("%6d", $g_iStatsBonusLast[$eLootElixir]) & "|"
	$AtkLogTxt &= StringFormat("%4d", $g_iStatsBonusLast[$eLootDarkElixir]) & "|"
	$AtkLogTxt &= $g_asLeagueDetailsShort & "  |"

	; samm0d
	If $ichkEnableMySwitch Then
		If $iCurActiveAcc <> - 1 Then
			$AtkLogTxt &= " " & $icmbWithProfile[$iCurActiveAcc]
		EndIf
	EndIf

	Local $AtkLogTxtExtend
	$AtkLogTxtExtend = "|"
	$AtkLogTxtExtend &= $g_CurrentCampUtilization & "/" & $g_iTotalCampSpace & "|"
	If Int($g_iStatsLastAttack[$eLootTrophy]) >= 0 Then
		SetAtkLog($AtkLogTxt, $AtkLogTxtExtend, $COLOR_BLACK)
	Else
		SetAtkLog($AtkLogTxt, $AtkLogTxtExtend, $COLOR_ERROR)
	EndIf

	; rename or delete zombie
	If $g_bDebugDeadBaseImage Then
		setZombie($g_iStatsLastAttack[$eLootElixir])
	EndIf

	; Share Replay
	If $g_bShareAttackEnable Then
		If (Number($g_iStatsLastAttack[$eLootGold]) >= Number($g_iShareMinGold)) And (Number($g_iStatsLastAttack[$eLootElixir]) >= Number($g_iShareMinElixir)) And (Number($g_iStatsLastAttack[$eLootDarkElixir]) >= Number($g_iShareMinDark)) Then
			SetLog("Reached miminum Loot values... Share Replay")
			$g_bShareAttackEnableNow = True
		Else
			SetLog("Below miminum Loot values... No Share Replay")
			$g_bShareAttackEnableNow = False
		EndIf
	EndIf

	If $g_iFirstAttack = 0 Then $g_iFirstAttack = 1
	$g_iStatsTotalGain[$eLootGold] += $g_iStatsLastAttack[$eLootGold] + $g_iStatsBonusLast[$eLootGold]
	$g_aiTotalGoldGain[$g_iMatchMode] += $g_iStatsLastAttack[$eLootGold] + $g_iStatsBonusLast[$eLootGold]
	$g_iStatsTotalGain[$eLootElixir] += $g_iStatsLastAttack[$eLootElixir] + $g_iStatsBonusLast[$eLootElixir]
	$g_aiTotalElixirGain[$g_iMatchMode] += $g_iStatsLastAttack[$eLootElixir] + $g_iStatsBonusLast[$eLootElixir]
	If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
		$g_iStatsTotalGain[$eLootDarkElixir] += $g_iStatsLastAttack[$eLootDarkElixir] + $g_iStatsBonusLast[$eLootDarkElixir]
		$g_aiTotalDarkGain[$g_iMatchMode] += $g_iStatsLastAttack[$eLootDarkElixir] + $g_iStatsBonusLast[$eLootDarkElixir]
	EndIf
	$g_iStatsTotalGain[$eLootTrophy] += $g_iStatsLastAttack[$eLootTrophy]
	$g_aiTotalTrophyGain[$g_iMatchMode] += $g_iStatsLastAttack[$eLootTrophy]
	If $g_iMatchMode = $TS Then
		If $starsearned > 0 Then
			$g_iNbrOfTHSnipeSuccess += 1
		Else
			$g_iNbrOfTHSnipeFails += 1
		EndIf
	EndIf
	$g_aiAttackedVillageCount[$g_iMatchMode] += 1
	If ProfileSwitchAccountEnabled() Then
		$g_aiGoldTotalAcc[$g_iCurAccount] += $g_iStatsLastAttack[$eLootGold] + $g_iStatsBonusLast[$eLootGold]
		$g_aiElixirTotalAcc[$g_iCurAccount] += $g_iStatsLastAttack[$eLootElixir] + $g_iStatsBonusLast[$eLootElixir]
		If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
			$g_aiDarkTotalAcc[$g_iCurAccount] += $g_iStatsLastAttack[$eLootDarkElixir] + $g_iStatsBonusLast[$eLootDarkElixir]
		EndIf
		$g_aiTrophyLootAcc[$g_iCurAccount] += $g_iStatsLastAttack[$eLootTrophy]
		$g_aiAttackedCountAcc[$g_iCurAccount] += 1
		SetSwitchAccLog(" - Acc. " & $g_iCurAccount + 1 & ", Attack: " & $g_aiAttackedCountAcc[$g_iCurAccount])
	EndIf
	UpdateStats()
	$g_iActualTrainSkip = 0

EndFunc   ;==>AttackReport
