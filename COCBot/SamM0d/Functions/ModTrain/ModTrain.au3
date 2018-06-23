; #FUNCTION# ====================================================================================================================
; Name ..........: ModTrain
; Description ...: SamM0d - Train Troops and Spells System
; Syntax ........: ModTrain()
; Parameters ....: $bDoPreTrain = False
; Return values .: None
; Author ........: Samkie (21 Jun, 2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the term
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func ModTrain($ForcePreTrain = False)
	Local $bJustMakeDonateFlag = $bJustMakeDonate
	$bJustMakeDonate = False

	If $g_iSamM0dDebug = 1 Then SetLog("Func Train ", $COLOR_DEBUG)
	If $g_bTrainEnabled = False Then Return
	If $g_iMyTroopsSize = 0 Then
		SetLog($CustomTrain_MSG_15, $COLOR_ERROR)
		Return
	EndIf

	Local $bNotStuckJustOnBoost = False
	Local $iCount = 0

	StartGainCost()

	SetLog($CustomTrain_MSG_1, $COLOR_INFO)
	If _Sleep(100) Then Return
	ClickP($aAway, 1, 0, "#0268") ;Click Away to clear open windows in case user interupted
	If _Sleep(200) Then Return

	If _Sleep(50) Then Return
	checkAttackDisable($g_iTaBChkIdle)
	If $g_bRestart = True Then Return

	If _Wait4Pixel($aButtonOpenTrainArmy[4], $aButtonOpenTrainArmy[5], $aButtonOpenTrainArmy[6], $aButtonOpenTrainArmy[7]) Then
		If $g_iSamM0dDebug = 1 Then SetLog("Click $aArmyTrainButton", $COLOR_SUCCESS)
		If IsMainPage() Then
			If $g_bUseRandomClick = False Then
				Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#1293") ; Button Army Overview
			Else
				ClickR($aArmyTrainButtonRND, $aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0)
			EndIf
		EndIf
	EndIf

	If _Sleep(250) Then Return

	; 紧贴着造兵视窗
	$iCount = 0
	While 1
		; 读取造兵剩余时间
		getArmyTroopTime()
		;getArmySpellTime()
		If _Sleep(50) Then Return
		; getArmyTroopTime() 读取后会保存造兵时间在变量 $g_aiTimeTrain[0]
		If $ForcePreTrain = False Then
			If $g_aiTimeTrain[0] > $itxtStickToTrainWindow Or $g_aiTimeTrain[0] <= 0 Then
				ExitLoop
			Else
				Local $iStickDelay
				If $g_aiTimeTrain[0] < 1 Then
					$iStickDelay = Int($g_aiTimeTrain[0] * 60000)
				ElseIf $g_aiTimeTrain[0] >= 2 Then
					$iStickDelay = 60000
				Else
					$iStickDelay = 30000
				EndIf
				SetLog($CustomTrain_MSG_2, $COLOR_INFO)
				If _Sleep($iStickDelay) Then Return
			EndIf
		Else
			ExitLoop
		EndIf
		$iCount += 1
		If $iCount > (10 + $itxtStickToTrainWindow) Then ExitLoop
	WEnd
	If $g_iSamM0dDebug = 1 Then SetLog("Before $tempDisableTrain: " & $tempDisableTrain)
 	If $g_iSamM0dDebug = 1 Then SetLog("Before $tempDisableBrewSpell: " & $tempDisableBrewSpell)

	TroopsAndSpellsChecker($tempDisableTrain, $tempDisableBrewSpell, $ForcePreTrain)

 	If $g_iSamM0dDebug = 1 Then SetLog("After $tempDisableTrain: " & $tempDisableTrain)
 	If $g_iSamM0dDebug = 1 Then SetLog("After $tempDisableBrewSpell: " & $tempDisableBrewSpell)

	If gotoArmy() = False Then Return

	getMyArmyHeroCount()
	If _Sleep(50) Then Return ; 50ms improve pause button response
	CheckAvailableCCUnit()
	If _Sleep(50) Then Return ; 50ms improve pause button response
	getMyArmyCCCapacity()
	If _Sleep(50) Then Return ; 50ms improve pause button response
	CheckAvailableCCSpellUnit()
	If _Sleep(50) Then Return ; 50ms improve pause button response
	getMyArmyCCSpellCapacity()
	If _Sleep(50) Then Return ; 50ms improve pause button response
	getMyArmyCCSeigeMachineCapacity()
	If _Sleep(50) Then Return ; 50ms improve pause button response

	If $ichkEnableMySwitch = 1 Then
		Local $iKTime[5] = [0,0,0,0,0]
		getArmyTroopTime(False,False)
		$iKTime[4] = $g_aiTimeTrain[0]
		If BitAND($g_aiSearchHeroWaitEnable[$DB], $eHeroKing) = $eHeroKing Or BitAND($g_aiSearchHeroWaitEnable[$LB], $eHeroKing) = $eHeroKing Then
			$iKTime[0] = getArmyHeroTime($eHeroKing)
		EndIf
		If BitAND($g_aiSearchHeroWaitEnable[$DB], $eHeroQueen) = $eHeroQueen Or BitAND($g_aiSearchHeroWaitEnable[$LB], $eHeroQueen) = $eHeroQueen Then
			$iKTime[1] = getArmyHeroTime($eHeroQueen)
		EndIf
		If BitAND($g_aiSearchHeroWaitEnable[$DB], $eHeroWarden) = $eHeroWarden Or BitAND($g_aiSearchHeroWaitEnable[$LB], $eHeroWarden) = $eHeroWarden Then
			$iKTime[2] = getArmyHeroTime($eHeroWarden)
		EndIf
		If $g_abSearchSpellsWaitEnable[$DB] Or $g_abSearchSpellsWaitEnable[$LB] Then
			getArmySpellTime()
			$iKTime[3] = $g_aiTimeTrain[1]
		EndIf

		;_ArraySort($iKTime,1)
		Local $iMaxV =  _ArrayMax($iKTime, 1)

		If $g_iSamM0dDebug = 1 Then SetLog("$iMaxV: " & $iMaxV)

		Local $bIsAttackType = False
		If $iCurActiveAcc <> -1 Then
			For $i = 0 To UBound($aSwitchList) - 1
				If $aSwitchList[$i][4] = $iCurActiveAcc Then
					;$aSwitchList[$i][0] = _DateAdd('n', $iKTime[0], _NowCalc())
					$aSwitchList[$i][0] = _DateAdd('n', $iMaxV, _NowCalc())
					If $iMaxV Then
						SetLog("Army Ready Time: " & $aSwitchList[$i][0], $COLOR_INFO)
					EndIf
					If $aSwitchList[$i][2] <> 1 Then
						$bIsAttackType = True
					EndIf
					ExitLoop
				EndIf
			Next
		EndIf

		If $ichkEnableContinueStay = 1 Then
			If $bIsAttackType Then
				If $g_iSamM0dDebug = 1 Then SetLog("$itxtTrainTimeLeft: " & $itxtTrainTimeLeft)
				;If $g_iSamM0dDebug = 1 Then SetLog("$iKTime[0]: " & $iKTime[0])
				If $g_iSamM0dDebug = 1 Then SetLog("$iMaxV: " & $iMaxV)
				If $g_iSamM0dDebug = 1 Then SetLog("Before $bAvoidSwitch: " & $bAvoidSwitch)
				$bAvoidSwitch = False
				If $iMaxV <= 0 Then
					$bAvoidSwitch = True
				Else
					If $itxtTrainTimeLeft >= $iMaxV Then
						$bAvoidSwitch = True
					EndIf
				EndIf
				If $g_iSamM0dDebug = 1 Then SetLog("After $bAvoidSwitch: " & $bAvoidSwitch)
			EndIf
		EndIf
	EndIf

	getArmyCCStatus()
	If _Sleep(50) Then Return ; 50ms improve pause button response

	If $g_iSamM0dDebug = 1 Then Setlog("Fullarmy = " & $g_bFullArmy & " CurCamp = " & $g_CurrentCampUtilization & " TotalCamp = " & $g_iTotalCampSpace & " - result = " & ($g_bFullArmy = True And $g_CurrentCampUtilization = $g_iTotalCampSpace), $COLOR_DEBUG)
	If $g_bFullArmy = True Then
		SetLog($CustomTrain_MSG_4, $COLOR_SUCCESS, "Times New Roman", 10)
		If (($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyAlertCampFull = True) Then PushMsg("CampFull")
	EndIf

	If _Sleep(200) Then Return
	ClickP($aAway, 1, 250, "#0504")
	If _Sleep(250) Then Return

	$g_bFirstStart = False

	;;;;;; Protect Army cost stats from being missed up by DC and other errors ;;;;;;;
	If _Sleep(200) Then Return

	EndGainCost("Train")
	UpdateStats()

	If $g_iSamM0dDebug = 1 Then SetLog("$g_bfullArmy: " & $g_bfullArmy)
	If $g_iSamM0dDebug = 1 Then SetLog("$g_bFullArmyHero: " & $g_bFullArmyHero)
	If $g_iSamM0dDebug = 1 Then SetLog("$g_bFullArmySpells: " & $g_bFullArmySpells)
	If $g_iSamM0dDebug = 1 Then SetLog("$g_bFullCCSpells: " & $g_bFullCCSpells)
	If $g_iSamM0dDebug = 1 Then SetLog("$g_FullCCTroops: " & $g_FullCCTroops)

	If $g_FullCCTroops = False Or $g_bFullCCSpells = False Then
		If $ichkEnableMySwitch = 1 Then
			; If waiting for cc or cc spell, ignore stay to the account, cause you don't know when the cc or spell will be ready.
			If $g_iSamM0dDebug = 1 Then SetLog("Disable Avoid Switch cause of waiting cc or cc spell enable.")
			$bAvoidSwitch = False
		EndIf
	EndIf

	If $g_bFullArmy = True And $g_bFullArmyHero = True And $g_bFullArmySpells = True And $g_bFullCCSpells = True And $g_FullCCTroops = True Then
		$g_bIsFullArmywithHeroesAndSpells = True
	Else
		$g_bIsFullArmywithHeroesAndSpells = False
	EndIf

	If $g_iSamM0dDebug = 1 Then SetLog("$g_bIsFullArmywithHeroesAndSpells: " & $g_bIsFullArmywithHeroesAndSpells)

EndFunc   ;==>CustomTrain

Func TroopsAndSpellsChecker($bDisableTrain = True, $bDisableBrewSpell = True, $bForcePreTrain = False)
	If $g_iSamM0dDebug = 1 Then SETLOG("Begin TroopsAndSpellsChecker:", $COLOR_DEBUG1)

	Local $hTimer = __TimerInit()
	Local $iCount = 0

	While 1
		Local $iCount2 = 0
		Local $bTroopCheckOK = False
		Local $bSpellCheckOK = False

		$g_bRestartCheckTroop = False

		; 预防进入死循环
		$iCount += 1
		If $iCount > 8 Then
			ExitLoop
		EndIf

		; 首先截获列队中的图像，然后去造兵界面截获排队中的图像
		;---------------------------------------------------
		DeleteTrainHBitmap()
		If gotoArmy() = False Then ExitLoop
		If _Sleep(250) Then ExitLoop
		$iCount2 = 0
		While IsQueueBlockByMsg($iCount2) ; 检查游戏上的讯息，是否有挡着训练界面， 最多30秒
			If _Sleep(1000) Then ExitLoop
			$iCount2 += 1
			If $iCount2 >= 30 Then
				ExitLoop
			EndIf
		WEnd
		_CaptureRegion2()
		$g_hHBitmapArmyTab = GetHHBitmapArea($g_hHBitmap2)
		;--------------------------------------------------

		$g_hHBitmapSpellCap = GetHHBitmapArea($g_hHBitmapArmyTab,$g_aiSpellCap[0],$g_aiSpellCap[1],$g_aiSpellCap[2],$g_aiSpellCap[3])
		getMySpellCapacityMini($g_hHBitmapSpellCap)
		If $bDisableBrewSpell = False Then
			; reset Global variables
			For $i = $enumLightning To $enumSkeleton
				Assign("Cur" & $MySpells[$i][0] & "Spell", 0)
				Assign("OnQ" & $MySpells[$i][0] & "Spell", 0)
				Assign("OnT" & $MySpells[$i][0] & "Spell", 0)
				Assign("Ready" & $MySpells[$i][0] & "Spell", 0)
			Next

			If gotoBrewSpells() = False Then ExitLoop
			If _Sleep(100) Then ExitLoop
			$iCount2 = 0
			While IsQueueBlockByMsg($iCount2) ; 检查游戏上的讯息，是否有挡着训练界面， 最多30秒
				If _Sleep(1000) Then ExitLoop
				$iCount2 += 1
				If $iCount2 >= 30 Then
					ExitLoop
				EndIf
			WEnd
			_CaptureRegion2()
			$g_hHBitmapBrewTab = GetHHBitmapArea($g_hHBitmap2)
			$g_hHBitmapBrewCap = GetHHBitmapArea($g_hHBitmapBrewTab,$g_aiBrewCap[0],$g_aiBrewCap[1],$g_aiBrewCap[2],$g_aiBrewCap[3])
			getBrewSpellCapacityMini($g_hHBitmapBrewCap)

			If $g_aiSpellsMaxCamp[0] = 0 Then
				DoRevampSpells()
				If $bForcePreTrain Then
					ContinueLoop
				EndIf
			Else
				If CheckAvailableSpellUnit($g_hHBitmapArmyTab) Then
					If CheckOnBrewUnit($g_hHBitmapBrewTab) Then
						Select
							Case $g_iCurrentSpells >= $g_iMySpellsSize And $g_aiSpellsMaxCamp[0] >= $g_iMySpellsSize
								If $g_bDoPrebrewspell = 0 Then
									SetLog("Pre-brew spell disable by user.",$COLOR_INFO)
									$tempDisableBrewSpell = True
								Else
									DoRevampSpells(True)
								EndIf
							Case $g_iCurrentSpells < $g_iMySpellsSize And $g_aiSpellsMaxCamp[0] >= $g_iMySpellsSize
								If $bForcePreTrain Or $ichkForcePreBrewSpell Then
									If $g_bDoPrebrewspell = 0 Then
										SetLog("Pre-brew spell disable by user.",$COLOR_INFO)
										$tempDisableBrewSpell = True
									Else
										DoRevampSpells(True)
									EndIf
								EndIf
							Case $g_iCurrentSpells < $g_iMySpellsSize And $g_aiSpellsMaxCamp[0] < $g_iMySpellsSize
								DoRevampSpells()
								If $bForcePreTrain Or $ichkForcePreBrewSpell Then
									ContinueLoop
								EndIf
							Case Else
								SetLog("Error: cannot meet any condition to Do Revamp Spells.", $COLOR_RED)
								If $g_iSamM0dDebug = 1 Then
									SetLog("$g_iCurrentSpells: " & $g_iCurrentSpells, $COLOR_RED)
									SetLog("$g_iMySpellsSize: " & $g_iMySpellsSize, $COLOR_RED)
									SetLog("$g_aiSpellsMaxCamp[0]: " & $g_aiTroopsMaxCamp[0], $COLOR_RED)
									SetLog("$g_aiSpellsMaxCamp[1]: " & $g_aiTroopsMaxCamp[1], $COLOR_RED)
								EndIf
						EndSelect
						$bSpellCheckOK = True
					EndIf
				EndIf
			EndIf
			If $g_bRestartCheckTroop Then ContinueLoop
		Else
			$bSpellCheckOK = True
		EndIf


		$g_hHBitmapArmyCap = GetHHBitmapArea($g_hHBitmapArmyTab,$g_aiArmyCap[0],$g_aiArmyCap[1],$g_aiArmyCap[2],$g_aiArmyCap[3])
		getMyArmyCapacityMini($g_hHBitmapArmyCap)
		If $bDisableTrain = False Then
			;====Reset the variable======
			For $i = 0 To UBound($g_avDTtroopsToBeUsed, 1) - 1
				$g_avDTtroopsToBeUsed[$i][1] = 0
			Next
			For $i = 0 To UBound($MyTroops) - 1
				Assign("cur" & $MyTroops[$i][0], 0)
				Assign("OnQ" & $MyTroops[$i][0], 0)
				Assign("OnT" & $MyTroops[$i][0], 0)
				Assign("Ready" & $MyTroops[$i][0], 0)
			Next
			;============================

			If gotoTrainTroops() = False Then ExitLoop
			If _Sleep(100) Then ExitLoop
			$iCount2 = 0
			While IsQueueBlockByMsg($iCount2) ; 检查游戏上的讯息，是否有挡着训练界面， 最多30秒
				If _Sleep(1000) Then ExitLoop
				$iCount2 += 1
				If $iCount2 >= 30 Then
					ExitLoop
				EndIf
			WEnd
			_CaptureRegion2()
			$g_hHBitmapTrainTab = GetHHBitmapArea($g_hHBitmap2)
			$g_hHBitmapTrainCap = GetHHBitmapArea($g_hHBitmapTrainTab,$g_aiTrainCap[0],$g_aiTrainCap[1],$g_aiTrainCap[2],$g_aiTrainCap[3])
			getTrainArmyCapacityMini($g_hHBitmapTrainCap)

			If $g_aiTroopsMaxCamp[0] = 0 Then
				DoRevampTroops()
				If $bForcePreTrain Then
					ContinueLoop
				EndIf
			Else
				If CheckAvailableUnit($g_hHBitmapArmyTab) Then
					If CheckOnTrainUnit($g_hHBitmapTrainTab) Then
						Local $bPreTrainFlag = $bForcePreTrain
						If $ichkForcePreTrainTroops Then
							If $g_iArmyCapacity >= $itxtForcePreTrainStrength Then
								$bPreTrainFlag = True
							EndIf
						EndIf

						Local $iFullArmyCamp = Int(($g_iMyTroopsSize * $g_iTrainArmyFullTroopPct) / 100)
						Select
							Case $g_CurrentCampUtilization = $iFullArmyCamp And $g_aiTroopsMaxCamp[0] = $iFullArmyCamp
								If $icmbMyQuickTrain = 0 Then
									If $ichkDisablePretrainTroops = 1 Then
										SetLog("Pre-train troops disable by user.",$COLOR_INFO)
										$tempDisableTrain = True
									Else
										DoRevampTroops(True)
									EndIf
								ElseIf $icmbMyQuickTrain = 4 Then
									DoMyQuickTrain(1)
									DoMyQuickTrain(2)
									DoMyQuickTrain(3)
								Else
									DoMyQuickTrain($icmbMyQuickTrain)
								EndIf
							Case $g_CurrentCampUtilization >= $iFullArmyCamp And $g_aiTroopsMaxCamp[0] > $iFullArmyCamp
								If $ichkDisablePretrainTroops = 1 Then
									SetLog("Pre-train troops disable by user.",$COLOR_INFO)
									$tempDisableTrain = True
								Else
									DoRevampTroops(True)
								EndIf
							Case $g_CurrentCampUtilization < $iFullArmyCamp And $g_aiTroopsMaxCamp[0] > $iFullArmyCamp
								If $bPreTrainFlag Then
									If $ichkDisablePretrainTroops = 1 Then
										SetLog("Pre-train troops disable by user.",$COLOR_INFO)
										$tempDisableTrain = True
									Else
										DoRevampTroops(True)
									EndIf
								EndIf
							Case $g_CurrentCampUtilization < $iFullArmyCamp And $g_aiTroopsMaxCamp[0] = $iFullArmyCamp
								If $bPreTrainFlag Then
									If $icmbMyQuickTrain = 0 Then
										If $ichkDisablePretrainTroops = 1 Then
											SetLog("Pre-train troops disable by user.",$COLOR_INFO)
											$tempDisableTrain = True
										Else
											DoRevampTroops(True)
										EndIf
									ElseIf $icmbMyQuickTrain = 4 Then
										DoMyQuickTrain(1)
										DoMyQuickTrain(2)
										DoMyQuickTrain(3)
									Else
										DoMyQuickTrain($icmbMyQuickTrain)
									EndIf
								EndIf
							Case $g_CurrentCampUtilization < $iFullArmyCamp And $g_aiTroopsMaxCamp[0] < $iFullArmyCamp
								DoRevampTroops()
								If $bPreTrainFlag Then
									ContinueLoop
								EndIf
							Case Else
								SetLog("Error: cannot meet any condition to Do Revamp Troops.", $COLOR_RED)
								If $g_iSamM0dDebug = 1 Then
									SetLog("$g_CurrentCampUtilization: " & $g_CurrentCampUtilization, $COLOR_RED)
									SetLog("$iFullArmyCamp: " & $iFullArmyCamp, $COLOR_RED)
									SetLog("$g_aiTroopsMaxCamp[0]: " & $g_aiTroopsMaxCamp[0], $COLOR_RED)
									SetLog("$g_aiTroopsMaxCamp[1]: " & $g_aiTroopsMaxCamp[1], $COLOR_RED)
								EndIf
						EndSelect
						$bTroopCheckOK = True
					EndIf
				EndIf
			EndIf
			If $g_bRestartCheckTroop Then ContinueLoop
		Else
			$bTroopCheckOK = True
		EndIf

		If $bTroopCheckOK And $bSpellCheckOK Then ExitLoop
	WEnd

	If $g_iSamM0dDebugImage = 1 Then SaveAndDebugTrainImage()

	DeleteTrainHBitmap()

	If $g_iSamM0dDebug = 1 Then SetLog("$hTimer: " & Round(__TimerDiff($hTimer) / 1000, 2))
EndFunc

Func IsQueueBlockByMsg($iCount)
	ForceCaptureRegion()
	_CaptureRegion()
	Select
		; Msg: Troops removed
		Case _ColorCheck(_GetPixelColor(391, 215, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6) And _ColorCheck(_GetPixelColor(487, 215, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6)
			Return SetLogAndReturn(1)
		; Msg: Spells removed
		Case _ColorCheck(_GetPixelColor(392, 215, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6) And _ColorCheck(_GetPixelColor(458, 209, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6)
			Return SetLogAndReturn(2)

		; Msg: Gold storages full (red text)
		Case _ColorCheck(_GetPixelColor(242, 209, $g_bNoCapturePixel), Hex(0xFF1919, 6), 6) And _ColorCheck(_GetPixelColor(317, 215, $g_bNoCapturePixel), Hex(0xFF1919, 6), 6)
			Return SetLogAndReturn(3)
		; Msg: Elixir storages full (red text)
		Case _ColorCheck(_GetPixelColor(318, 213, $g_bNoCapturePixel), Hex(0xFF1919, 6), 6) And _ColorCheck(_GetPixelColor(391, 215, $g_bNoCapturePixel), Hex(0xFF1919, 6), 6)
			Return SetLogAndReturn(4)
		; Msg: Dark Elixir storages full (red text)
		Case _ColorCheck(_GetPixelColor(168, 214, $g_bNoCapturePixel), Hex(0xFF1919, 6), 6) And _ColorCheck(_GetPixelColor(242, 214, $g_bNoCapturePixel), Hex(0xFF1919, 6), 6)
			Return SetLogAndReturn(5)

		; Msg: The request was sent!
		Case _ColorCheck(_GetPixelColor(316, 215, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6) And _ColorCheck(_GetPixelColor(462, 209, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6)
			Return SetLogAndReturn(6)

		; Msg: Army added to training queues!
		Case _ColorCheck(_GetPixelColor(324, 215, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6) And _ColorCheck(_GetPixelColor(460, 209, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6)
			Return SetLogAndReturn(7)

		; Msg: Not enough space in training queues (red text)
		Case _ColorCheck(_GetPixelColor(258, 215, $g_bNoCapturePixel), Hex(0xFF1919, 6), 6) And _ColorCheck(_GetPixelColor(485, 215, $g_bNoCapturePixel), Hex(0xFF1919, 6), 6)
			Return SetLogAndReturn(8)

		; Msg: Not enough storage space (red text)
		Case _ColorCheck(_GetPixelColor(319, 215, $g_bNoCapturePixel), Hex(0xFF1919, 6), 6) And _ColorCheck(_GetPixelColor(537, 215, $g_bNoCapturePixel), Hex(0xFF1919, 6), 6)
			Return SetLogAndReturn(9)

		; donate message
;~ 		Case _ColorCheck(_GetPixelColor(245, 215, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6) And _ColorCheck(_GetPixelColor(301, 215, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6) And _ColorCheck(_GetPixelColor(360, 215, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6)
;~ 			Return SetLogAndReturn(99)
		Case Else
			For $i = 130 To 330 Step + 2
				If _ColorCheck(_GetPixelColor($i, 215, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6) And _ColorCheck(_GetPixelColor($i + 42, 215, $g_bNoCapturePixel), Hex(0xFEFEFE, 6), 6) Then
					If $iCount = 0 And ($g_iChkWait4CC Or $g_iChkWait4CCSpell) Then
						Local $hClone = _GDIPlus_BitmapCloneArea($g_hBitmap, 20, 198, 820, 24, $GDIP_PXF24RGB)
						Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
						Local $Time = @HOUR & "." & @MIN & "." & @SEC
						Local $filename = String(@ScriptDir & "\profiles\" & $g_sProfileCurrentName & "\SamM0d Debug\Images\Msg Block_" & $Date & "_" & $Time & ".png")
						_GDIPlus_ImageSaveToFile($hClone, $filename)
						_GDIPlus_BitmapDispose($hClone)
					EndIf
					Return SetLogAndReturn(99)
				EndIf
			Next
	EndSelect
	If _Sleep(1000) Then Return	False
	Return False
EndFunc

Func SetLogAndReturn($iMsg)
	Local $sMsg
	Switch $iMsg
		Case 1
			$sMsg = "Troops removed"
		Case 2
			$sMsg = "Spells removed"
		Case 3
			$sMsg = "Gold Storages Full"
		Case 4
			$sMsg = "Elixir Storages Full"
		Case 5
			$sMsg = "Dark Elixir Storages Full"
		Case 6
			$sMsg = "The request was sent!"
		Case 7
			$sMsg = "Army added to training queues!"
		Case 8
			$sMsg = "Not enough space in training queues"
		Case 9
			$sMsg = "Not enough storage space"
		Case Else
			$sMsg = "Donate or other message"
	EndSwitch
	If $g_iSamM0dDebug = 1 Then SetLog("[" & $sMsg & "] - block for detection troops or spells.",$COLOR_RED)
	Return True
EndFunc