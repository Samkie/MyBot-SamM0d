; #FUNCTION# ====================================================================================================================
; Name ..........: applyConfig.au3
; Description ...: Applies all of the  variable to the GUI
; Syntax ........:
; Parameters ....:
; Return values .: NA
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func ApplyConfig_MOD($TypeReadSave)
	; <><><> Team AiO MOD++ (2018) <><><>
	Switch $TypeReadSave
		Case "Read"
			;~ ; Pause tray tip
			;~ GUICtrlSetState($chkDisablePauseTrayTip, ($ichkDisablePauseTrayTip = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			
			; Random _Sleep
			GUICtrlSetState($g_chkUseRandomSleepDbg, $g_ichkUseRandomSleepDbg = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($cmb_SleepMult, $icmb_SleepMult)
			
			; bot log
			GUICtrlSetState($chkBotLogLineLimit, ($ichkBotLogLineLimit = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetData($txtLogLineLimit, $itxtLogLineLimit)
			chkBotLogLineLimit()
			
			; use Event troop
			GUICtrlSetState($chkEnableUseEventTroop, ($ichkEnableUseEventTroop = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			
			; donate only when troop pre train ready
			GUICtrlSetState($chkEnableDonateWhenReady, ($ichkEnableDonateWhenReady = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			
			; stop bot when low battery
			GUICtrlSetState($chkEnableStopBotWhenLowBattery, ($ichkEnableStopBotWhenLowBattery = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			
			; prevent over donate
			GUICtrlSetState($chkEnableLimitDonateUnit, ($ichkEnableLimitDonateUnit = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetData($txtLimitDonateUnit, $itxtLimitDonateUnit)
			chkEnableLimitDonateUnit()
			
			; max logout time
			GUICtrlSetState($chkEnableLogoutLimit, ($ichkEnableLogoutLimit = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetData($txtLogoutLimitTime, $itxtLogoutLimitTime)
			chkEnableLogoutLimit()
			
			; Unit Wave Factor
			GUICtrlSetState($chkUnitFactor, ($ichkUnitFactor = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetData($txtUnitFactor, $itxtUnitFactor)
			GUICtrlSetState($chkWaveFactor, ($ichkWaveFactor = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetData($txtWaveFactor, $itxtWaveFactor)
			chkUnitFactor()
			chkWaveFactor()
			
			; SmartZap from ChaCalGyn (LunaEclipse) - DEMEN
			; ExtremeZap - Added by TheRevenor
			
			GUICtrlSetState($chkUseSamM0dZap, ($ichkUseSamM0dZap = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetState($chkSmartZapDB, ($ichkSmartZapDB = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetState($chkSmartZapSaveHeroes, ($ichkSmartZapSaveHeroes = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			
			If $itxtMinDE <= 0 Then
				$itxtMinDE = 400
			EndIf
			GUICtrlSetData($txtMinDark2, $itxtMinDE)
			
			; samm0d zap
			GUICtrlSetState($chkSmartZapRnd, ($ichkSmartZapRnd = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetState($chkDrillExistBeforeZap, ($ichkDrillExistBeforeZap = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetState($chkPreventTripleZap, ($ichkPreventTripleZap = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetData($txtMinDEGetFromDrill, $itxtMinDEGetFromDrill)
			cmbZapMethod()
			
			; Check Collectors Outside - Added by TheRevenor
			GUICtrlSetState($chkDBMeetCollOutside, ($ichkDBMeetCollOutside = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetState($chkDBCollectorsNearRedline, ($ichkDBCollectorsNearRedline = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			_GUICtrlComboBox_SetCurSel($cmbRedlineTiles,$icmbRedlineTiles)
			GUICtrlSetState($chkSkipCollectorCheckIF, ($ichkSkipCollectorCheckIF = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetData($txtDBMinCollOutsidePercent, $iDBMinCollOutsidePercent)
			GUICtrlSetData($txtSkipCollectorGold, $itxtSkipCollectorGold)
			GUICtrlSetData($txtSkipCollectorElixir, $itxtSkipCollectorElixir)
			GUICtrlSetData($txtSkipCollectorDark, $itxtSkipCollectorDark)
			GUICtrlSetState($chkSkipCollectorCheckIFTHLevel, ($ichkSkipCollectorCheckIFTHLevel = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetData($txtIFTHLevel, $itxtIFTHLevel)
			chkDBMeetCollOutside()
			
			; drop cc first
			GUICtrlSetState($chkDropCCFirst, ($ichkDropCCFirst = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			
			; Check League For DeadBase
			GUICtrlSetState($chkDBNoLeague, ($iChkNoLeague[$DB] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetState($chkABNoLeague, ($iChkNoLeague[$LB] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			
			; HLFClick By Samkie
			GUICtrlSetState($chkEnableHLFClick, ($ichkEnableHLFClick = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetData($sldHLFClickDelayTime, $isldHLFClickDelayTime)
			chkEnableHLFClick()
			sldHLFClickDelayTime()
			GUICtrlSetState($chkEnableHLFClickSetlog, ($EnableHMLSetLog = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			
;-			; advanced update for wall by Samkie
;-			GUICtrlSetState($chkSmartUpdateWall, ($ichkSmartUpdateWall = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
;-			GUICtrlSetData($txtClickWallDelay, $itxtClickWallDelay)
;-			chkSmartUpdateWall()
			
			; samm0d ocr
			GUICtrlSetState($chkEnableCustomOCR4CCRequest, ($ichkEnableCustomOCR4CCRequest = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			
			; auto dock
			GUICtrlSetState($chkAutoDock, ($ichkAutoDock = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetState($chkAutoHideEmulator, ($g_bChkAutoHideEmulator = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetState($chkAutoMinimizeBot, ($g_bChkAutoMinimizeBot = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			
			; CSV Deployment Speed Mod
			GUICtrlSetData($sldSelectedSpeedDB, $isldSelectedCSVSpeed[$DB])
			GUICtrlSetData($sldSelectedSpeedAB, $isldSelectedCSVSpeed[$LB])
			sldSelectedSpeedDB()
			sldSelectedSpeedAB()
			
			; wait 4 cc
			GUICtrlSetState($chkWait4CC, ($g_iChkWait4CC = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetData($txtCCStrength, $CCStrength)
			_GUICtrlComboBox_SetCurSel($cmbCCTroopSlot1,$iCCTroopSlot1)
			_GUICtrlComboBox_SetCurSel($cmbCCTroopSlot2,$iCCTroopSlot2)
			_GUICtrlComboBox_SetCurSel($cmbCCTroopSlot3,$iCCTroopSlot3)
			GUICtrlSetData($txtCCTroopSlotQty1,$iCCTroopSlotQty1)
			GUICtrlSetData($txtCCTroopSlotQty2,$iCCTroopSlotQty2)
			GUICtrlSetData($txtCCTroopSlotQty3,$iCCTroopSlotQty3)
			chkWait4CC()
			; wait for cc spell
			GUICtrlSetState($chkWait4CCSpell, ($g_iChkWait4CCSpell = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			_GUICtrlComboBox_SetCurSel($cmbCCSpellSlot1,$iCCSpellSlot1)
			_GUICtrlComboBox_SetCurSel($cmbCCSpellSlot2,$iCCSpellSlot2)
			GUICtrlSetData($txtCCSpellSlotQty1,$iCCSpellSlotQty1)
			GUICtrlSetData($txtCCSpellSlotQty2,$iCCSpellSlotQty2)
			chkWait4CCSpell()
			
			; check 4 cc
			GUICtrlSetState($chkCheck4CC, ($ichkCheck4CC = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetData($txtCheck4CCWaitTime, $itxtCheck4CCWaitTime)
			chkCheck4CC()
			
			; global delay increse
			GUICtrlSetState($chkIncreaseGlobalDelay, ($ichkIncreaseGlobalDelay = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetData($txtIncreaseGlobalDelay, $itxtIncreaseGlobalDelay)
			chkIncreaseGlobalDelay()
			
			; stick to train page
			GUICtrlSetData($txtStickToTrainWindow, $itxtStickToTrainWindow)
			txtStickToTrainWindow()
			
			GUICtrlSetState($chkModTrain, ($ichkModTrain = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetState($chkForcePreTrainTroops, ($ichkForcePreTrainTroops = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetData($txtForcePreTrainStrength, $itxtForcePreTrainStrength)
			_GUICtrlComboBox_SetCurSel($cmbTroopSetting,$icmbTroopSetting)
			_GUICtrlComboBox_SetCurSel($cmbMyQuickTrain,$icmbMyQuickTrain)
			GUICtrlSetState($chkDisablePretrainTroops, ($ichkDisablePretrainTroops = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			
			; My Troops
			GUICtrlSetState($chkMyTroopsOrder, ($ichkMyTroopsOrder = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetState($chkEnableDeleteExcessTroops, ($ichkEnableDeleteExcessTroops = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			
			$g_iMyTroopsSize = 0
			For $i = 0 To UBound($MyTroops)-1
				GUICtrlSetData(Eval("txtMy" & $MyTroops[$i][0]), $MyTroops[$i][3])
				_GUICtrlComboBox_SetCurSel(Eval("cmbMy" & $MyTroops[$i][0] & "Order"), $MyTroops[$i][1]-1)
				$g_iMyTroopsSize += $MyTroops[$i][3] * $MyTroops[$i][2]
			Next
			
			UpdateTroopSize()
			
			;cmbMyTroopOrder()
			
			GUICtrlSetState($chkMySpellsOrder, ($ichkMySpellsOrder = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetState($chkEnableDeleteExcessSpells, ($ichkEnableDeleteExcessSpells = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			GUICtrlSetState($chkForcePreBrewSpell, ($ichkForcePreBrewSpell = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
			
			For $i = 0 To UBound($MySpells)-1
				GUICtrlSetState(Eval("chkPre" & $MySpells[$i][0]), (Eval("ichkPre" & $MySpells[$i][0]) = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
				GUICtrlSetData(Eval("txtNum" & $MySpells[$i][0] & "Spell"), $MySpells[$i][3])
				_GUICtrlComboBox_SetCurSel(Eval("cmbMy" & $MySpells[$i][0] & "SpellOrder"), $MySpells[$i][1]-1)
			Next
			
			;cmbMySpellOrder()
			
			GUICtrlSetData($txtTotalCountSpell2, $g_iTotalSpellValue)
			
			lblMyTotalCountSpell()
			
			_GUI_Value_STATE("HIDE",$g_aGroupListTHLevels)
			If $g_iTownHallLevel >= 4 And $g_iTownHallLevel <= 11 Then
				GUICtrlSetState($g_ahPicTHLevels[$g_iTownHallLevel], $GUI_SHOW)
			EndIf
			
			GUICtrlSetData($g_hLblTHLevels, $g_iTownHallLevel)
			
			applyFriendlyChallengeSetting()

			; Restart Search Legend league - Team AiO MOD++
			GUICtrlSetState($g_hChkSearchTimeout, $g_bIsSearchTimeout = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtSearchTimeout, $g_iSearchTimeout)
			chkSearchTimeout()
			; ClanHop - Team AiO MOD++
			GUICtrlSetState($g_hChkClanHop, $g_bChkClanHop = True ? $GUI_CHECKED : $GUI_UNCHECKED)

			; Bot Humanization - Team AiO MOD++
			GUICtrlSetState($g_chkUseBotHumanization, $g_ichkUseBotHumanization = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkUseAltRClick, $g_ichkUseAltRClick = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkCollectAchievements, $g_ichkCollectAchievements = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkLookAtRedNotifications, $g_ichkLookAtRedNotifications = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkUseBotHumanization()
			For $i = 0 To 12
				_GUICtrlComboBox_SetCurSel($g_acmbPriority[$i], $g_iacmbPriority[$i])
			Next
			For $i = 0 To 1
				_GUICtrlComboBox_SetCurSel($g_acmbMaxSpeed[$i], $g_iacmbMaxSpeed[$i])
			Next
			For $i = 0 To 1
				_GUICtrlComboBox_SetCurSel($g_acmbPause[$i], $g_iacmbPause[$i])
			Next
			For $i = 0 To 1
				GUICtrlSetData($g_ahumanMessage[$i], $g_iahumanMessage[$i])
			Next
			_GUICtrlComboBox_SetCurSel($g_cmbMaxActionsNumber, $g_icmbMaxActionsNumber)
			GUICtrlSetData($g_challengeMessage, $g_ichallengeMessage)
			cmbStandardReplay()
			cmbWarReplay()

			; Goblin XP - Team AiO MOD++
			GUICtrlSetState($chkEnableSuperXP, $ichkEnableSuperXP = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkEnableSuperXP()
			GUICtrlSetState($chkSkipZoomOutXP, $ichkSkipZoomOutXP = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($chkFastGoblinXP, $ichkFastGoblinXP = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($rbSXTraining, ($irbSXTraining = 1) ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($rbSXIAttacking, ($irbSXTraining = 2) ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($txtMaxXPtoGain, $itxtMaxXPtoGain)
			GUICtrlSetState($chkSXBK, $ichkSXBK = $eHeroKing ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($chkSXAQ, $ichkSXAQ = $eHeroQueen ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($chkSXGW, $ichkSXGW = $eHeroWarden ? $GUI_CHECKED : $GUI_UNCHECKED)

			; GTFO - Team AiO MOD++
			GUICtrlSetState($g_hChkUseGTFO, $g_bChkUseGTFO = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtMinSaveGTFO_Elixir, $g_iTxtMinSaveGTFO_Elixir)
			GUICtrlSetData($g_hTxtMinSaveGTFO_DE, $g_iTxtMinSaveGTFO_DE)
			ApplyGTFO()

			GUICtrlSetState($g_hChkUseKickOut, $g_bChkUseKickOut = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtDonatedCap, $g_iTxtDonatedCap)
			GUICtrlSetData($g_hTxtReceivedCap, $g_iTxtReceivedCap)
			GUICtrlSetState($g_hChkKickOutSpammers, $g_bChkKickOutSpammers = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtKickLimit, $g_iTxtKickLimit)
			ApplyKickOut()

			; Check Grand Warden Mode - Team AiO MOD++
			GUICtrlSetState($g_hChkCheckWardenMode, $g_bCheckWardenMode ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkCheckWardenMode()
			_GUICtrlComboBox_SetCurSel($g_hCmbCheckWardenMode, $g_iCheckWardenMode)

		Case "Save"
			; Random _Sleep
			$g_ichkUseRandomSleepDbg = GUICtrlRead($g_chkUseRandomSleepDbg) = $GUI_CHECKED ? 1 : 0
			$icmb_SleepMult = _GUICtrlComboBox_GetCurSel($cmb_SleepMult)

			; ClanHop - Team AiO MOD++
			$g_bChkClanHop = (GUICtrlRead($g_hChkClanHop) = $GUI_CHECKED)

			; Bot Humanization - Team AiO MOD++
			$g_ichkUseBotHumanization = GUICtrlRead($g_chkUseBotHumanization) = $GUI_CHECKED ? 1 : 0
			$g_ichkUseAltRClick = GUICtrlRead($g_chkUseAltRClick) = $GUI_CHECKED ? 1 : 0
			$g_ichkCollectAchievements = GUICtrlRead($g_chkCollectAchievements) = $GUI_CHECKED ? 1 : 0
			$g_ichkLookAtRedNotifications = GUICtrlRead($g_chkLookAtRedNotifications) = $GUI_CHECKED ? 1 : 0
			For $i = 0 To 12
				$g_iacmbPriority[$i] = _GUICtrlComboBox_GetCurSel($g_acmbPriority[$i])
			Next
			For $i = 0 To 1
				$g_iacmbMaxSpeed[$i] = _GUICtrlComboBox_GetCurSel($g_acmbMaxSpeed[$i])
			Next
			For $i = 0 To 1
				$g_iacmbPause[$i] = _GUICtrlComboBox_GetCurSel($g_acmbPause[$i])
			Next
			For $i = 0 To 1
				$g_iahumanMessage[$i] = GUICtrlRead($g_ahumanMessage[$i])
			Next
			$g_icmbMaxActionsNumber = _GUICtrlComboBox_GetCurSel($g_icmbMaxActionsNumber)
			$g_ichallengeMessage = GUICtrlRead($g_challengeMessage)

			; Goblin XP - Team AiO MOD++
			$ichkEnableSuperXP = GUICtrlRead($chkEnableSuperXP) = $GUI_CHECKED ? 1 : 0
			$ichkSkipZoomOutXP = GUICtrlRead($chkSkipZoomOutXP) = $GUI_CHECKED ? 1 : 0
			$ichkFastGoblinXP = GUICtrlRead($chkFastGoblinXP) = $GUI_CHECKED ? 1 : 0
			$irbSXTraining = GUICtrlRead($rbSXTraining) = $GUI_CHECKED ? 1 : 2
			$ichkSXBK = (GUICtrlRead($chkSXBK) = $GUI_CHECKED) ? $eHeroKing : $eHeroNone
			$ichkSXAQ = (GUICtrlRead($chkSXAQ) = $GUI_CHECKED) ? $eHeroQueen : $eHeroNone
			$ichkSXGW = (GUICtrlRead($chkSXGW) = $GUI_CHECKED) ? $eHeroWarden : $eHeroNone
			$itxtMaxXPtoGain = Int(GUICtrlRead($txtMaxXPtoGain))

			; GTFO - Team AiO MOD++
			$g_bChkUseGTFO = (GUICtrlRead($g_hChkUseGTFO) = $GUI_CHECKED)
			$g_iTxtMinSaveGTFO_Elixir = Number(GUICtrlRead($g_hTxtMinSaveGTFO_Elixir))
			$g_iTxtMinSaveGTFO_DE = Number( GUICtrlRead($g_hTxtMinSaveGTFO_DE))

			$g_bChkUseKickOut = (GUICtrlRead($g_hChkUseKickOut) = $GUI_CHECKED)
			$g_iTxtDonatedCap = Number(GUICtrlRead($g_hTxtDonatedCap))
			$g_iTxtReceivedCap = Number(GUICtrlRead($g_hTxtReceivedCap))
			$g_bChkKickOutSpammers = (GUICtrlRead($g_hChkKickOutSpammers) = $GUI_CHECKED)
			$g_iTxtKickLimit = Number(GUICtrlRead($g_hTxtKickLimit))

			; Check Grand Warden Mode - Team AiO MOD++
			$g_bCheckWardenMode = (GUICtrlRead($g_hChkCheckWardenMode) = $GUI_CHECKED)
			$g_iCheckWardenMode = _GUICtrlComboBox_GetCurSel($g_hCmbCheckWardenMode)

			; Restart Search Legend league - Team AiO MOD++
			$g_bIsSearchTimeout = (GUICtrlRead($g_hChkSearchTimeout) = $GUI_CHECKED)
			$g_iSearchTimeout = GUICtrlRead($g_hTxtSearchTimeout)
	EndSwitch
 EndFunc   ;==>ApplyConfig_MOD
