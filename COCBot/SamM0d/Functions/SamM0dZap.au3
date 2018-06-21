; #FUNCTION# ====================================================================================================================
; Name ..........: SamM0dZap v0.3
; Description ...: This file Includes all functions to current GUI
; Syntax ........: SamM0dZap()
; Parameters ....: None
; Return values .: None
; Author ........: LunaEclipse(March, 2016)
; Modified ......: Samkie(2 FEB 2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SamM0dZap()
	Local $searchDark
	Local $oldSearchDark = 0
	Local $numSpells
	Local $bDoZap = False
	Local $performedZap = False
	Local $strikeOffsets = [0, 15]
	Local $strikeGain
	Local $Sort4DrillDEExpect = 0
	Local $LastZapXY = [-1,-1]
	Local $bZapFlag = True
	Local $result
	Local $aDrill[1][5] ; col: 0 = x, 1 = y, 2 = level, 3 = $strikeGain, 4 = Zap Count
	Local $iCounter = 0 ; prevent endless loop
	Local $iCount = 0
	Local $coor
	Local $coorxy
	Local $dLevel
	Local $x
	Local $y
	Local $aSpells [2][5] = [["Own", $eLSpell, -1, -1, 0 ] _		; Own/Donated, SpellType, AttackbarPosition, Level, Count
							, ["Donated", $eLSpell, -1, -1, 0]]

	; If smartZap is not checked, exit.
	If $ichkUseSamM0dZap <> 1 Then Return $performedZap
	SetLog("====== You Are Activated SamM0dZap Mode ======", $COLOR_FUCHSIA)
	; Get Dark Elixir value, if no DE value exists, exit.
	$searchDark = getDarkElixirVillageSearch(48, 126)

	If Number($searchDark) = 0 Then
		SetLog("No Dark Elixir so lets just exit!", $COLOR_FUCHSIA)
		Return $performedZap
	; Check to see if the DE Storage is already full
	ElseIf getDarkElixirStorageFull() Then
		SetLog("Your Dark Elixir Storage is full, no need to zap!", $COLOR_FUCHSIA)
		Return $performedZap
	; Check to make sure the account is high enough level to store DE.
	ElseIf (Number($searchDark) < Number($itxtMinDE)) Then
		SetLog("Dark Elixir is below minimum value, exiting now!", $COLOR_FUCHSIA)
		Return $performedZap
	EndIf

	; Check match mode
	If $ichkSmartZapDB = 1 And $g_iMatchMode <> $DB Then
		SetLog("Not a dead base so lets just go home!", $COLOR_FUCHSIA)
		Return $performedZap
	EndIf

	; Get the number of lightning spells

	;Local $iTroops = PrepareAttack($g_iMatchMode, True) ; Check remaining troops/spells
	;If $iTroops > 0 Then
		For $i = 0 To UBound($g_avAttackTroops) - 1
			If $g_avAttackTroops[$i][0] = $eLSpell Then
				If $aSpells[0][4] = 0 Then
					If $g_bDebugSmartZap = 1 Then SetLog(NameOfTroop($g_avAttackTroops[$i][0], 0) & ": " & $g_avAttackTroops[$i][1], $COLOR_DEBUG)
					$aSpells[0][2] = $i
					$aSpells[0][3] = Number($g_iLSpellLevel)		; Get the Level on Attack bar
					$aSpells[0][4] = $g_avAttackTroops[$i][1]
				Else
					If $g_bDebugSmartZap = 1 Then SetLog("Donated " & NameOfTroop($g_avAttackTroops[$i][0], 0) & ": " & $g_avAttackTroops[$i][1], $COLOR_DEBUG)
					$aSpells[1][2] = $i
					$aSpells[1][3] = Number($g_iLSpellLevel)		; Get the Level on Attack bar
					$aSpells[1][4] = $g_avAttackTroops[$i][1]
				EndIf
			EndIf
		Next
	;EndIf

	If $aSpells[0][4] + $aSpells[1][4] = 0 Then
		SetLog("No lightning spells trained, time to go home!", $COLOR_ERROR)
		Return $performedZap
	Else
		If $aSpells[0][4] > 0 Then
			SetLog(" - Number of " & NameOfTroop($aSpells[0][1], 1) & ": " & Number($aSpells[0][4]), $COLOR_INFO)
		EndIf
		If $aSpells[1][4] > 0 Then
			SetLog(" - Number of Donated " & NameOfTroop($aSpells[1][1], 1) & ": " & Number($aSpells[1][4]), $COLOR_INFO)
		EndIf
		$numSpells = $aSpells[0][4] + $aSpells[1][4]
	EndIf

	_CaptureRegion2()

	;$result = DllCall($hFuncLib, "str", "getLocationDarkElixirExtractorWithLevel", "ptr", $hHBitmap2)
	$result = GetLocationDarkElixirWithLevel()
	If $debugZapSetLog Then SetLog("$result: " & $result)
	If $result <> "" Then
		$coor = StringSplit($result,"~",$STR_NOCOUNT)
		For $i = 0 To UBound($coor) - 1
			$dLevel = StringSplit($coor[$i],"#",$STR_NOCOUNT)
			If UBound($dLevel) = 2 Then
				$coorxy = StringSplit($dLevel[1],"-",$STR_NOCOUNT)
				Local $bCheckCloneDrill = False
				For $j = 0 To UBound($aDrill) - 1
					If $aDrill[$j][0] <= $coorxy[0] + 5 And $aDrill[$j][0] >= $coorxy[0] - 5 Then
						If $aDrill[$j][1] <= $coorxy[1] + 5 And $aDrill[$j][1] >= $coorxy[1] - 5 Then
							SetLog("Detect 2 drills at the same coordinate: ", $COLOR_RED)
							SetLog("Level: " & $aDrill[$j][2] & " - x,y: " & $aDrill[$j][0] & "," & $aDrill[$j][1], $COLOR_RED)
							SetLog("Level: " & $dLevel[0] & " - x,y: " & $coorxy[0] & "," & $coorxy[1], $COLOR_RED)
							$bCheckCloneDrill = True
							ExitLoop
						EndIf
					EndIf
				Next
				If $bCheckCloneDrill = False Then
					ReDim $aDrill[$iCount+1][5]
					If UBound($coorxy) = 2 Then
						$aDrill[$iCount][0] = $coorxy[0] ;x
						$aDrill[$iCount][1] = $coorxy[1] ;y
						$aDrill[$iCount][2] = $dLevel[0] ; Level
						$aDrill[$iCount][3] = 0 ; DE get from Last Zap
						$aDrill[$iCount][4] = 0 ; No. of Lightning Spell Used
						$iCount += 1
					EndIf
				EndIf
			EndIf
		Next
		SetLog("Number of Dark Elixir Drills: " &  UBound($aDrill), $COLOR_FUCHSIA)
	Else
		SetLog("No drills found, time to go home!", $COLOR_FUCHSIA)
		Return $performedZap
	EndIf

	_ArraySort($aDrill, 1, 0, 0, 2) ; sort level as descending order for zap higher level drill

	While IsAttackPage() And $numSpells > 0
		CheckHeroesHealth()

		If $debugZapSetLog Then
			For $i = 0 To UBound($aDrill) - 1
				SetLog("Drill[" & $i & "]: " & $aDrill[$i][0] & "," & $aDrill[$i][1] & "," & $aDrill[$i][2] & "," & $aDrill[$i][3] & "," & $aDrill[$i][4])
			Next
		EndIf
		; Dark Elixir below minimum
		If Number($searchDark) < Number($itxtMinDEGetFromDrill) Then
			SetLog("Exit: Dark Elixir is lower than the Min. DE Get From Drill. DE:" & $searchDark & "<" & $itxtMinDEGetFromDrill, $COLOR_FUCHSIA)
			Return $performedZap
		EndIf

		; Store the DE value before any Zaps are done.
		$oldSearchDark = $searchDark

		; let start checking drill

		$x = $aDrill[0][0] + $strikeOffsets[0]
		$y = $aDrill[0][1] + $strikeOffsets[1]

		$bDoZap = False ; reset for check is that doing any zap perform
		$bZapFlag = True

		If $aDrill[0][3] = 0 And $aDrill[0][4] = 0 Then
			; perform first zap
			$LastZapXY[0] = $x
			$LastZapXY[1] = $y
			If $ichkSmartZapRnd = 1 Then
				Local $PrevCoor = $x & "," & $y
				$x = Random($x-4,$x+4,1)
				$y = Random($y-4,$y+4,1)
				SetLog("Random Click =-= Change " & $PrevCoor & " To " & $x & "," & $y & "=-= Zap Drill", $COLOR_HMLClick_LOG)
			EndIf
			$bDoZap = myzapDrill($eLSpell,$x,$y)
			SleepAndCheckHeroesHealth(3500, 500)
			;If _Sleep(3500) Then Return
		Else
			If $Sort4DrillDEExpect <> $aDrill[0][4] Then
				$Sort4DrillDEExpect = $aDrill[0][4]
				If $ichkPreventTripleZap Then
					If $Sort4DrillDEExpect >= 2 Then
						SetLog("Exit: Prevent triple zap on same drill.", $COLOR_FUCHSIA)
						Return $performedZap
					EndIf
				EndIf
				; reorder better result
				_ArraySort($aDrill, 1, 0, 0, 3) ; sort level as descending order for get higher value DE get from last strike
				$x = $aDrill[0][0] + $strikeOffsets[0]
				$y = $aDrill[0][1] + $strikeOffsets[1]
			EndIf
			If $ichkDrillExistBeforeZap Then
				If $LastZapXY[0] = $x And $LastZapXY[1] = $y Then
					if $debugZapSetLog Then SetLog("Make delay longer before checking drill cause of last zap animation." & $bZapFlag)
					SleepAndCheckHeroesHealth(5000, 500)
					;If _Sleep(5000) Then Return
				EndIf
				;$bZapFlag = checkAnyDrillExist($x,$y)
				$bZapFlag = ReCheckDrillExist($x,$y)
				if $debugZapSetLog Then SetLog("checkAnyDrillExist():$bZapFlag=" & $bZapFlag)
			EndIf
			If $bZapFlag Then
				$LastZapXY[0] = $x
				$LastZapXY[1] = $y
				If $ichkSmartZapRnd = 1 Then
					Local $PrevCoor = $x & "," & $y
					$x = Random($x-4,$x+4,1)
					$y = Random($y-4,$y+4,1)
					SetLog("Random Click =-= Change " & $PrevCoor & " To " & $x & "," & $y & "=-= Zap Drill", $COLOR_HMLClick_LOG)
				EndIf
				$bDoZap = myzapDrill($eLSpell,$x,$y)
				SleepAndCheckHeroesHealth(3500, 500)
				;If _Sleep(3500) Then Return
			EndIf
		EndIf

		; Check to make sure we actually zapped
		If $bDoZap = True Then
			$performedZap = True
			$g_iNumLSpellsUsed += 1
			$numSpells -= 1

			; Get the DE Value after SmartZap has performed its actions.
			$searchDark = getDarkElixirStable($oldSearchDark)

			If $searchDark = -1 Then
				SetLog("Exit: Cannot get Dark Elixir value from village.", $COLOR_FUCHSIA)
				Return $performedZap
			EndIf

			If $oldSearchDark > $searchDark Then
				$strikeGain = $oldSearchDark - $searchDark
				$g_iSmartZapGain += $strikeGain
				SetLog("DE get from last strike: " & $strikeGain & ", Total DE from Zap: " & $g_iSmartZapGain, $COLOR_FUCHSIA)

				If $searchDark = 0 Then
					SetLog("Exit: No more Dark Elixir detected.", $COLOR_FUCHSIA)
					Return $performedZap
				EndIf
			EndIf

			If $strikeGain > $itxtMinDEGetFromDrill Then ; nice DE gain
				$aDrill[0][3] = $strikeGain
				$aDrill[0][4] += 1 ; LightnigSpell + 1 for check if drill still exist with second zap if needed

				If UBound($aDrill) > 1 Then
					; if got few drill found, move this to last row for zap later
					Local $aTemp[5] ; save this drill to temp
					For $i = 0 To 4
						$aTemp[$i] = $aDrill[0][$i]
					Next
					_ArrayDelete($aDrill,0) ; delete this drill, and add to last row
					Local $iMax = UBound($aDrill)

					ReDim $aDrill[$iMax+1][5]
					For $i = 0 To 4
						$aDrill[$iMax][$i] = $aTemp[$i]
					Next
				EndIf
			Else
				;check array before deleye
				If UBound($aDrill) = 1 Then
					; this is last drill, exit zap
					SetLog("Exit: No drill getting more DE then expected. DE:" & $strikeGain & "<" & $itxtMinDEGetFromDrill, $COLOR_FUCHSIA)
					ExitLoop
				Else
					_ArrayDelete($aDrill,0) ; delete this drill
					SetLog("Ingore this drill since get less DE then expected. DE:" & $strikeGain & "<" & $itxtMinDEGetFromDrill, $COLOR_FUCHSIA)
				EndIf
			EndIf
		Else
			If $bZapFlag = False Then
				If UBound($aDrill) = 1 Then
					; this is last drill, exit zap
					SetLog("Exit: No more drill exist.", $COLOR_FUCHSIA)
					ExitLoop
				Else
					_ArrayDelete($aDrill,0) ; delete this drill
					SetLog("Ingore this drill since no more exist.", $COLOR_FUCHSIA)
				EndIf
			Else
				SetLog("Error: Cannot select Lightning Spell!", $COLOR_FUCHSIA)
				ExitLoop
			EndIf
		EndIf

		$iCounter += 1
		If $iCounter > 5 Then
			SetLog("Exit: Error occur when perform zap, enter endless loop.", $COLOR_RED)
			ExitLoop
		EndIf
	WEnd
	Return $performedZap
EndFunc   ;==>SamM0dZap

Func myzapDrill($THSpell, $x, $y)
	Local $Spell = -1
	Local $name = ""
	; If _Sleep(10) Then Return
	; If $g_bRestart = True Then Return
	For $i = 0 To UBound($g_avAttackTroops) - 1
		If $g_avAttackTroops[$i][0] = $THSpell Then
			$Spell = $i
			$name = NameOfTroop($THSpell, 0)
		EndIf
	Next
	If $Spell > -1 Then
		SelectDropTroop($Spell)
		If _Sleep(10) Then Return False
		If IsAttackPage() Then Click($x, $y, 1, 0, "#0029")
		SetLog("Dropping " & $name & " at x,y: " & $x & "," & $y, $COLOR_FUCHSIA)
		$numLSpellDrop += 1
		Return True
	Else
		If $g_bDebugSetlog Then SetLog("No " & $name & " Found")
	EndIf
	Return False
EndFunc   ;==>myzapDrill

Func getDarkElixirStorageFull()
	Local $return = False
	Local $aDarkElixirStorageFull[4] = [743, 94, 0x1A0026, 10] ; DE Resource Bar when in combat
	If _CheckPixel($aDarkElixirStorageFull, $g_bCapturePixel) Then $return = True
	Return $return
EndFunc   ;==>getDarkElixirStorageFull

Func getDarkElixirStable($oldSearchDark)
	Local $searchDark = -1, $iCount = 0, $iSucessCount = 0
	If _Sleep(100) Then Return
	If _ColorCheck(_GetPixelColor(30, 143, True), Hex(0x282020, 6), 10) Or _ColorCheck(_GetPixelColor(36, 140, True), Hex(0x302430, 6), 10) Then ; Check if the village have a Dark Elixir Storage
		;$oldSearchDark = getDarkElixirVillageSearch(45, 125) ; Get updated Dark Elixir value
		;If _Sleep(500) Then Return
		While $iCount <= 15
			$searchDark = getDarkElixirVillageSearch(48, 126) ; Get updated Dark Elixir value
			If $debugZapSetLog Then Setlog("$iCount: " & $iCount & " $searchDark = " & $searchDark & ", $oldSearchDark = " & $oldSearchDark, $COLOR_PURPLE)
			If $oldSearchDark = $searchDark Then
				$iSucessCount += 1
				If $iSucessCount >= 3 Then ExitLoop
			Else
				If Number($searchDark) < Number($oldSearchDark) Then
					$oldSearchDark = Number($searchDark)
				EndIf
				$iSucessCount = 0
			EndIf
			$iCount += 1
			If _Sleep(500) Then Return
		WEnd
		$searchDark = $oldSearchDark
	Else
		$searchDark = -1
		If $debugZapSetLog Then SetLog("No DE Detected.", $COLOR_PURPLE)
	EndIf
	If $debugZapSetLog Then SetLog("$searchDark： " & $searchDark, $COLOR_PURPLE)
	Return $searchDark
EndFunc   ;==>getDarkElixir

Func SleepAndCheckHeroesHealth($delay, $delayFactor)
	Local $iCount = 0
	While $iCount < $delay
		CheckHeroesHealth()
		If $iCount + $delayFactor < $delay Then
			$iCount += $delayFactor
			If _Sleep($delayFactor) Then Return False
		Else
			$iCount += ($delay - $iCount)
			If _Sleep($delay - $iCount) Then Return False
		EndIf
	WEnd
	Return True
EndFunc
;~ Func checkAnyDrillExist($x,$y)
;~ 	Local $result
;~ 	_CaptureRegion2($x-40,$y-40,$x+30,$y+30)
;~ 	$result = GetLocationDarkElixir()
;~ 	If IsArray($result) Then
;~ 		Return True
;~ 	Else
;~ 		Return False
;~ 	EndIf
;~ EndFunc

Func txtMinDEGetFromDrill()
	$itxtMinDEGetFromDrill = GUICtrlRead($txtMinDEGetFromDrill)
EndFunc

Func chkSmartZapRnd()
    If GUICtrlRead($chkSmartZapRnd) = $GUI_CHECKED Then
        $ichkSmartZapRnd = 1
    Else
        $ichkSmartZapRnd = 0
    EndIf
EndFunc

Func chkDrillExistBeforeZap()
    If GUICtrlRead($chkDrillExistBeforeZap) = $GUI_CHECKED Then
        $ichkDrillExistBeforeZap = 1
    Else
        $ichkDrillExistBeforeZap = 0
    EndIf
EndFunc

Func chkPreventTripleZap()
    If GUICtrlRead(chkPreventTripleZap) = $GUI_CHECKED Then
        $ichkPreventTripleZap = 1
    Else
        $ichkPreventTripleZap = 0
    EndIf
EndFunc

Func txtMinDark2()
	$itxtMinDE = GUICtrlRead($txtMinDark2)
	GUICtrlSetData($g_hTxtSmartMinDark,$itxtMinDE)
EndFunc

Func chkSmartZapSaveHeroes2()
    If GUICtrlRead($chkSmartZapSaveHeroes2) = $GUI_CHECKED Then
        $ichkSmartZapSaveHeroes = 1
		GUICtrlSetState($g_hChkSmartZapSaveHeroes, $GUI_CHECKED)
    Else
        $ichkSmartZapSaveHeroes = 0
		GUICtrlSetState($g_hChkSmartZapSaveHeroes, $GUI_UNCHECKED)
    EndIf

EndFunc   ;==>chkSmartZapSaveHeroes

Func chkSmartZapDB2()
    If GUICtrlRead($chkSmartZapDB2) = $GUI_CHECKED Then
        $ichkSmartZapDB = 1
		GUICtrlSetState($g_hChkSmartZapDB, $GUI_CHECKED)
    Else
        $ichkSmartZapDB = 0
		GUICtrlSetState($g_hChkSmartZapDB, $GUI_UNCHECKED)
    EndIf
EndFunc   ;==>chkSmartZapDB
