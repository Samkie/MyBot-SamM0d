; #FUNCTION# ====================================================================================================================
; Name ..........: getMyArmyHeroCount
; Description ...: Obtains count of heroes available from Training - Army Overview window
; Syntax ........: getMyArmyHeroCount()
; Parameters ....: $bOpenArmyWindow  = Bool value true if train overview window needs to be opened
;				 : $bCloseArmyWindow = Bool value, true if train overview window needs to be closed
; Return values .: None
; Author ........:
; Modified ......: MonkeyHunter (06-2016), MR.ViPER (10-2016), Fliegerfaust (03-2017)， Samkie (28 Jun, 2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func getMyArmyHeroCount($bSetLog = True)
	If $g_iSamM0dDebug = 1 Or $g_bDebugSetlog Then SetLog("Begin getMyArmyHeroCount:", $COLOR_DEBUG)

	$g_iHeroAvailable = $eHeroNone ; Reset hero available data
	Local $iDebugArmyHeroCount = 0 ; local debug flag

	; Detection by OCR
	Local $sResult
	Local Const $iHeroes = 3
	Local $sMessage = ""
	Local $tmpUpgradingHeroes[3] = [ $eHeroNone, $eHeroNone, $eHeroNone ]

	For $i = 0 To $iHeroes - 1
		$sResult = myArmyHeroStatus($i)
		If $sResult <> "" Then ; we found something, figure out what?
			Select
				Case StringInStr($sResult, "king", $STR_NOCASESENSEBASIC)
					If $bSetLog Then Setlog("Hero slot: " & $i + 1 & " - Barbarian King available", $COLOR_SUCCESS)
					myHeroStatus("King","Green")
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
				Case StringInStr($sResult, "queen", $STR_NOCASESENSEBASIC)
					If $bSetLog Then Setlog("Hero slot: " & $i + 1 & " - Archer Queen available", $COLOR_SUCCESS)
					myHeroStatus("Queen","Green")
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroQueen)
				Case StringInStr($sResult, "warden", $STR_NOCASESENSEBASIC)
					If $bSetLog Then Setlog("Hero slot: " & $i + 1 & " - Grand Warden available", $COLOR_SUCCESS)
					myHeroStatus("Warden","Green")
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
				Case StringInStr($sResult, "heal", $STR_NOCASESENSEBASIC)
					;If $g_iSamM0dDebug = 1 Or $iDebugArmyHeroCount = 1 Then
						Switch $i
							Case 0
								$sMessage = " - Barbarian King"
								myHeroStatus("King","Blue")
							Case 1
								$sMessage = " - Archer Queen"
								myHeroStatus("Queen","Blue")
							Case 2
								$sMessage = " - Grand Warden"
								myHeroStatus("Warden","Blue")
							Case Else
								$sMessage = " - Very Bad Monkey Needs"
						EndSwitch
						SetLog("Hero slot: " & $i + 1 & $sMessage & " Healing", $COLOR_DEBUG)
					;EndIf
				Case StringInStr($sResult, "upgrade", $STR_NOCASESENSEBASIC)
					Switch $i
						Case 0
							$sMessage = " - Barbarian King"
							myHeroStatus("King","Red")
							$tmpUpgradingHeroes[$i] = $eHeroKing
							; safety code to warn user when wait for hero found while being upgraded to reduce stupid user posts for not attacking
							If BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroKing) = $eHeroKing Or BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroKing) = $eHeroKing Then ; check wait for hero status
								If $g_iSearchNotWaitHeroesEnable Then
									$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
								Else
									SetLog("Warning: King Upgrading & Wait enabled, Disable Wait for King or may never attack!", $COLOR_ERROR)
								EndIf
								_GUI_Value_STATE("SHOW", $groupKingSleeping) ; Show king sleeping icon
							EndIf
						Case 1
							$sMessage = " - Archer Queen"
							myHeroStatus("Queen","Red")
							$tmpUpgradingHeroes[$i] = $eHeroQueen
							; safety code
							If BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroQueen) = $eHeroQueen Or BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroQueen) = $eHeroQueen Then
								If $g_iSearchNotWaitHeroesEnable Then
									$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroQueen)
								Else
									SetLog("Warning: Queen Upgrading & Wait enabled, Disable Wait for Queen or may never attack!", $COLOR_ERROR)
								EndIf
								_GUI_Value_STATE("SHOW", $groupQueenSleeping)
							EndIf
						Case 2
							$sMessage = " - Grand Warden"
							myHeroStatus("Warden","Red")
							$tmpUpgradingHeroes[$i] = $eHeroWarden
							; safety code
							If BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroWarden) = $eHeroWarden Or BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroWarden) = $eHeroWarden Then
								If $g_iSearchNotWaitHeroesEnable Then
									$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
								Else
									SetLog("Warning: Warden Upgrading & Wait enabled, Disable Wait for Warden or may never attack!", $COLOR_ERROR)
								EndIf
								_GUI_Value_STATE("SHOW", $groupWardenSleeping)
							EndIf
						Case Else
							$sMessage = " - Need to Get Monkey"
					EndSwitch
					If $bSetLog Then SetLog("Hero slot: " & $i + 1 & $sMessage & " Upgrade in Process", $COLOR_DEBUG)
				Case StringInStr($sResult, "none", $STR_NOCASESENSEBASIC)
					Switch $i
						Case 0
							myHeroStatus("King","Gray")
						Case 1
							myHeroStatus("Queen","Gray")
						Case 2
							myHeroStatus("Warden","Gray")
					EndSwitch

					If $g_iSamM0dDebug = 1 Or $iDebugArmyHeroCount = 1 Then SetLog("Hero slot: " & $i + 1 & " Empty.", $COLOR_DEBUG)
					ExitLoop ; when we find empty slots, done looking for heroes
				Case Else
					If $bSetLog Then SetLog("Hero slot: " & $i + 1 & " bad OCR string returned!", $COLOR_ERROR)
			EndSelect
		Else
			If $bSetLog Then SetLog("Hero slot: " & $i + 1 & " status read problem!", $COLOR_ERROR)
		EndIf
	Next

	$g_iHeroUpgradingBit = BitOR($tmpUpgradingHeroes[0], $tmpUpgradingHeroes[1], $tmpUpgradingHeroes[2])

	$g_bFullArmyHero = True
	For $i = $DB To $LB
		If $g_abAttackTypeEnable[$i] Then
			If $g_aiSearchHeroWaitEnable[$i] > 0 Then
				If BitAND($g_aiSearchHeroWaitEnable[$i], $eHeroKing) = $eHeroKing And BitAND($g_iHeroAvailable, $eHeroKing) <> $eHeroKing Then
					SETLOG(" " & $g_asModeText[$i] & " Setting - Waiting Barbarian King to recover before start attack.", $COLOR_ACTION)
					$g_bFullArmyHero = False
				EndIf
				If BitAND($g_aiSearchHeroWaitEnable[$i], $eHeroQueen) = $eHeroQueen And BitAND($g_iHeroAvailable, $eHeroQueen) <> $eHeroQueen Then
					SETLOG(" " & $g_asModeText[$i] & " Setting - Waiting Archer Queen to recover before start attack.", $COLOR_ACTION)
					$g_bFullArmyHero = False
				EndIf
				If BitAND($g_aiSearchHeroWaitEnable[$i], $eHeroWarden) = $eHeroWarden And BitAND($g_iHeroAvailable, $eHeroWarden) <> $eHeroWarden Then
					SETLOG(" " & $g_asModeText[$i] & " Setting - Waiting Grand Warden to recover before start attack.", $COLOR_ACTION)
					$g_bFullArmyHero = False
				EndIf
			EndIf
		EndIf
	Next

	If $g_iSamM0dDebug = 1 Then SetLog("$g_bFullArmyHero: " & $g_bFullArmyHero)
	If $g_iSamM0dDebug = 1 Or $iDebugArmyHeroCount = 1 Then SetLog("Hero Status K|Q|W : " & BitAND($g_iHeroAvailable, $eHeroKing) & "|" & BitAND($g_iHeroAvailable, $eHeroQueen) & "|" & BitAND($g_iHeroAvailable, $eHeroWarden), $COLOR_DEBUG)
EndFunc   ;==>getMyArmyHeroCount

Func myArmyHeroStatus($iHeroSlot)
	Local $sDirectory = $g_sSamM0dImageLocation & "\HeroStatus\"
	Local $returnProps="objectname"
	Local $aPropsValues
	Local Const $aHeroesRect[3][4] = [[656, 344, 677, 364], [730, 344, 751, 364], [804, 344, 825, 364]]

	If _Sleep(100) Then Return
	_CaptureRegion2($aHeroesRect[$iHeroSlot][0], $aHeroesRect[$iHeroSlot][1], $aHeroesRect[$iHeroSlot][2], $aHeroesRect[$iHeroSlot][3])

	Local $result = findMultiple($sDirectory ,"FV" ,"FV", 0, 0, 1 , $returnProps, False )
	If IsArray($result) then
		For $i = 0 To UBound($result) -1
			$aPropsValues = $result[$i] ; should be return objectname,objectpoints
			If UBound($aPropsValues) = 1 then
				Return $aPropsValues[0] ; objectname
			EndIf
		Next
	EndIf

	Switch $iHeroSlot
		Case 0
			Return "king"
		Case 1
			Return "queen"
		Case 2
			Return "warden"
	EndSwitch
EndFunc

Func myHeroStatus($sHero, $sColor)
	GUICtrlSetState(Eval("g_hPic" & $sHero & "Green"), ($sColor = "Green" ?  $GUI_SHOW : $GUI_HIDE))
	GUICtrlSetState(Eval("g_hPic" & $sHero & "Red"), ($sColor = "Red" ?  $GUI_SHOW : $GUI_HIDE))
	GUICtrlSetState(Eval("g_hPic" & $sHero & "Blue"), ($sColor = "Blue" ?  $GUI_SHOW : $GUI_HIDE))
	GUICtrlSetState(Eval("g_hPic" & $sHero & "Gray"), ($sColor = "Gray" ?  $GUI_SHOW : $GUI_HIDE))
EndFunc