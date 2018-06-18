; #FUNCTION# ====================================================================================================================
; Name ..........: saveConfig.au3
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SaveConfig_MOD()
	ApplyConfig_MOD(GetApplyConfigSaveAction())

	; Random _Sleep
	_Ini_Add("Pico Bot Humanization", "UseRandomSleepDbg", $g_ichkUseRandomSleepDbg)
	_Ini_Add("Pico Bot Humanization", "cmb_SleepMult", _GUICtrlComboBox_GetCurSel($cmb_SleepMult))
	
	
	; Multi Finger (LunaEclipse)
	_Ini_Add("MultiFinger", "Select", _GUICtrlComboBox_GetCurSel($cmbDBMultiFinger))
	
	; bot log
	_Ini_Add("BotLogLineLimit", "Enable", (GUICtrlRead($chkBotLogLineLimit) = $GUI_CHECKED ? 1 : 0 ))
	_Ini_Add("BotLogLineLimit", "LimitValue", GUICtrlRead($txtLogLineLimit))
	
	; use Event troop
	_Ini_Add("EnableUseEventTroop", "Enable", (GUICtrlRead($chkEnableUseEventTroop) = $GUI_CHECKED ? 1 : 0 ))
	
	; donate only when troop pre train ready
	_Ini_Add("EnableDonateWhenReady", "Enable", (GUICtrlRead($chkEnableDonateWhenReady) = $GUI_CHECKED ? 1 : 0 ))
	
	; stop bot when low battery
	_Ini_Add("EnableStopBotWhenLowBattery", "Enable", (GUICtrlRead($chkEnableStopBotWhenLowBattery) = $GUI_CHECKED ? 1 : 0 ))
	
	;~ ; Pause Tray Tip
	;~ _Ini_Add("DisablePauseTrayTip", "Enable", (GUICtrlRead($chkDisablePauseTrayTip) = $GUI_CHECKED ? 1 : 0 ))
	
	; prevent over donate
	_Ini_Add("PreventOverDonate", "Enable", (GUICtrlRead($chkEnableLimitDonateUnit) = $GUI_CHECKED ? 1 : 0 ))
	_Ini_Add("PreventOverDonate", "LimitValue", GUICtrlRead($txtLimitDonateUnit))
	
	; max logout time
	_Ini_Add("LogoutLimit", "Enable", (GUICtrlRead($chkEnableLogoutLimit) = $GUI_CHECKED ? 1 : 0 ))
	_Ini_Add("LogoutLimit", "LimitValue", GUICtrlRead($txtLogoutLimitTime))
	
	; Unit Wave Factor
	_Ini_Add("SetSleep", "EnableUnitFactor", (GUICtrlRead($chkUnitFactor) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("SetSleep", "UnitFactor", GUICtrlRead($txtUnitFactor))
	_Ini_Add("SetSleep", "EnableWaveFactor", (GUICtrlRead($chkWaveFactor) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("SetSleep", "WaveFactor", GUICtrlRead($txtWaveFactor))
	
	; SmartZap Settings from ChaCalGyn (LunaEclipse) - DEMEN
	_Ini_Add("SamM0dZap", "SamM0dZap", (GUICtrlRead($chkUseSamM0dZap) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("SmartZap", "ZapDBOnly", (GUICtrlRead($chkSmartZapDB) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("SmartZap", "THSnipeSaveHeroes", (GUICtrlRead($chkSmartZapSaveHeroes) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("SmartZap", "MinDE", GUICtrlRead($txtMinDark2))
	
	; samm0d zap
	_Ini_Add("SamM0dZap", "UseSmartZapRnd", (GUICtrlRead($chkSmartZapRnd) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("SamM0dZap", "CheckDrillBeforeZap", (GUICtrlRead($chkDrillExistBeforeZap) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("SamM0dZap", "PreventTripleZap", (GUICtrlRead($chkPreventTripleZap) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("SamM0dZap", "MinDEGetFromDrill", GUICtrlRead($txtMinDEGetFromDrill))
	
	; Check Collectors Outside
	_Ini_Add("search", "DBMeetCollOutside", (GUICtrlRead($chkDBMeetCollOutside) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("search", "DBCollectorsNearRedline", (GUICtrlRead($chkDBCollectorsNearRedline) = $GUI_CHECKED  ? 1 : 0))
	_Ini_Add("search", "RedlineTiles", _GUICtrlComboBox_GetCurSel($cmbRedlineTiles))
	_Ini_Add("search", "SkipCollectorCheckIF", (GUICtrlRead($chkSkipCollectorCheckIF) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("search", "DBMinCollOutsidePercent", GUICtrlRead($txtDBMinCollOutsidePercent))
	_Ini_Add("search", "SkipCollectorGold", GUICtrlRead($txtSkipCollectorGold))
	_Ini_Add("search", "SkipCollectorElixir", GUICtrlRead($txtSkipCollectorElixir))
	_Ini_Add("search", "SkipCollectorDark", GUICtrlRead($txtSkipCollectorDark))
	_Ini_Add("search", "SkipCollectorCheckIFTHLevel", (GUICtrlRead($chkSkipCollectorCheckIFTHLevel) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("search", "IFTHLevel", GUICtrlRead($txtIFTHLevel))
	
	; dropp cc first
	_Ini_Add("CCFirst", "Enable", (GUICtrlRead($chkDropCCFirst) = $GUI_CHECKED ? 1 : 0))
	
	; Check League For DeadBase
	_Ini_Add("search", "DBNoLeague", (GUICtrlRead($chkDBNoLeague) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("search", "ABNoLeague", (GUICtrlRead($chkABNoLeague) = $GUI_CHECKED ? 1 : 0))
	
	; HLFClick By Samkie
	_Ini_Add("HLFClick", "EnableHLFClick", (GUICtrlRead($chkEnableHLFClick) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("HLFClick", "HLFClickDelayTime", GUICtrlRead($sldHLFClickDelayTime))
	_Ini_Add("HLFClick", "EnableHLFClickSetlog", (GUICtrlRead($chkEnableHLFClickSetlog) = $GUI_CHECKED ? 1 : 0))
	
	; samm0d ocr
	_Ini_Add("GetMyOcr", "EnableCustomOCR4CCRequest", (GUICtrlRead($chkEnableCustomOCR4CCRequest) = $GUI_CHECKED ? 1 : 0))
	
	; auto dock
	_Ini_Add("AutoDock", "Enable", (GUICtrlRead($chkAutoDock) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("AutoHideEmulator", "Enable", (GUICtrlRead($chkAutoHideEmulator) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("AutoMinimizeBot", "Enable", (GUICtrlRead($chkAutoMinimizeBot) = $GUI_CHECKED ? 1 : 0))
	
;-	; advanced update for wall by Samkie
;-	_Ini_Add("AU4Wall", "EnableSmartUpdateWall", (GUICtrlRead($chkSmartUpdateWall) = $GUI_CHECKED ? 1 :0))
;-	_Ini_Add("AU4Wall", "ClickWallDelay", GUICtrlRead($txtClickWallDelay))
;-	_Ini_Add("AU4Wall", "BaseNodeX", $aBaseNode[0])
;-	_Ini_Add("AU4Wall", "BaseNodeY", $aBaseNode[1])
;-	_Ini_Add("AU4Wall", "LastWallX", $aLastWall[0])
;-	_Ini_Add("AU4Wall", "LastWallY", $aLastWall[1])
;-	_Ini_Add("AU4Wall", "FaceDirection", $iFaceDirection)
	
	; CSV Deployment Speed Mod
	_Ini_Add("attack", "CSVSpeedDB", $isldSelectedCSVSpeed[$DB])
	_Ini_Add("attack", "CSVSpeedAB", $isldSelectedCSVSpeed[$LB])
	
	; Wait 4 CC
	_Ini_Add("Wait4CC", "Enable", (GUICtrlRead($chkWait4CC) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("Wait4CC", "CCTroopSlot1", _GUICtrlComboBox_GetCurSel($cmbCCTroopSlot1))
	_Ini_Add("Wait4CC", "CCTroopSlot2", _GUICtrlComboBox_GetCurSel($cmbCCTroopSlot2))
	_Ini_Add("Wait4CC", "CCTroopSlot3", _GUICtrlComboBox_GetCurSel($cmbCCTroopSlot3))
	_Ini_Add("Wait4CC", "CCTroopSlotQty1", GUICtrlRead($txtCCTroopSlotQty1))
	_Ini_Add("Wait4CC", "CCTroopSlotQty2", GUICtrlRead($txtCCTroopSlotQty2))
	_Ini_Add("Wait4CC", "CCTroopSlotQty3", GUICtrlRead($txtCCTroopSlotQty3))
	_Ini_Add("Wait4CC", "CCStrength", GUICtrlRead($txtCCStrength))
	
	; wait for cc spell
	_Ini_Add("Wait4CCSpell", "Enable", (GUICtrlRead($chkWait4CCSpell) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("Wait4CCSpell", "CCSpellSlot1", _GUICtrlComboBox_GetCurSel($cmbCCSpellSlot1))
	_Ini_Add("Wait4CCSpell", "CCSpellSlot2", _GUICtrlComboBox_GetCurSel($cmbCCSpellSlot2))
	_Ini_Add("Wait4CCSpell", "CCSpellSlotQty1", GUICtrlRead($txtCCSpellSlotQty1))
	_Ini_Add("Wait4CCSpell", "CCSpellSlotQty2", GUICtrlRead($txtCCSpellSlotQty2))
	
	; check 4 cc
	_Ini_Add("Check4CC", "Enable", (GUICtrlRead($chkCheck4CC) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("Check4CC", "WaitTime", GUICtrlRead($txtCheck4CCWaitTime))
	
	; global delay increse
	_Ini_Add("GlobalDelay", "Enable", (GUICtrlRead($chkIncreaseGlobalDelay) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("GlobalDelay", "DelayPercentage", GUICtrlRead($txtIncreaseGlobalDelay))
	
	; stick to train page
	_Ini_Add("StickToTrainPage", "Minutes", GUICtrlRead($txtStickToTrainWindow))
	
	; My Troops
	_Ini_Add("MyTroops", "ForcePreTrainTroop", (GUICtrlRead($chkForcePreTrainTroops) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("MyTroops", "ForcePreTrainStrength", GUICtrlRead($txtForcePreTrainStrength))
	_Ini_Add("MyTroops", "NoPreTrain", (GUICtrlRead($chkDisablePretrainTroops) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("MyTroops", "DeleteExcess", (GUICtrlRead($chkEnableDeleteExcessTroops) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("MyTroops", "EnableModTrain", (GUICtrlRead($chkModTrain) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("MyTroops", "Order", (GUICtrlRead($chkMyTroopsOrder) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("MyTroops", "TrainCombo", _GUICtrlComboBox_GetCurSel($cmbMyQuickTrain))
	
	Local $itempcmbTroopSetting = _GUICtrlComboBox_GetCurSel($cmbTroopSetting)
	
	_Ini_Add("MyTroops", "Composition", $itempcmbTroopSetting)
	
	cmbTroopSetting()
	
	For $j = 0 To 2
		For $i = 0 To UBound($MyTroops) - 1
			_Ini_Add("MyTroops", $MyTroops[$i][0] & $j, $MyTroopsSetting[$j][$i][0])
			_Ini_Add("MyTroops", $MyTroops[$i][0] & "Order" & $j, $MyTroopsSetting[$j][$i][1])
		Next
	Next
	
	If GUICtrlRead($chkEnableDeleteExcessSpells) = $GUI_CHECKED Then
		_Ini_Add("MySpells", "DeleteExcess", 1)
	Else
		_Ini_Add("MySpells", "DeleteExcess", 0)
	EndIf
	
	If GUICtrlRead($chkForcePreBrewSpell) = $GUI_CHECKED Then
		_Ini_Add("MySpells", "ForcePreBrewSpell", 1)
	Else
		_Ini_Add("MySpells", "ForcePreBrewSpell", 0)
	EndIf
	
	If GUICtrlRead($chkMySpellsOrder) = $GUI_CHECKED Then
		_Ini_Add("MySpells", "Order", 1)
	Else
		_Ini_Add("MySpells", "Order", 0)
	EndIf
	
	For $j = 0 To 2
		For $i = 0 To UBound($MySpells) - 1
			_Ini_Add("MySpells", $MySpells[$i][0] & $j, $MySpellSetting[$j][$i][0])
			_Ini_Add("MySpells", $MySpells[$i][0] & "Order" & $j, $MySpellSetting[$j][$i][1])
			_Ini_Add("MySpells", $MySpells[$i][0] & "Pre" & $j, $MySpellSetting[$j][$i][2])
		Next
	Next
	
	saveFriendlyChallengeSetting()
	
	saveDemenWarSetting()

	; <><><> Team AiO MOD++ (2018) <><><>
	; ClanHop - Team AiO MOD++
	_Ini_Add("donate", "chkClanHop", $g_bChkClanHop)

	; Bot Humanization - Team AiO MOD++
	_Ini_Add("Bot Humanization", "chkUseBotHumanization", $g_ichkUseBotHumanization)
	_Ini_Add("Bot Humanization", "chkUseAltRClick", $g_ichkUseAltRClick)
	_Ini_Add("Bot Humanization", "chkCollectAchievements", $g_ichkCollectAchievements)
	_Ini_Add("Bot Humanization", "chkLookAtRedNotifications", $g_ichkLookAtRedNotifications)
	For $i = 0 To 12
		_Ini_Add("Bot Humanization", "cmbPriority[" & $i & "]", _GUICtrlComboBox_GetCurSel($g_acmbPriority[$i]))
	Next
	For $i = 0 To 1
		_Ini_Add("Bot Humanization", "cmbMaxSpeed[" & $i & "]", _GUICtrlComboBox_GetCurSel($g_acmbMaxSpeed[$i]))
	Next
	For $i = 0 To 1
		_Ini_Add("Bot Humanization", "cmbPause[" & $i & "]", _GUICtrlComboBox_GetCurSel($g_acmbPause[$i]))
	Next
	For $i = 0 To 1
		_Ini_Add("Bot Humanization", "humanMessage[" & $i & "]", GUICtrlRead($g_ahumanMessage[$i]))
	Next
	_Ini_Add("Bot Humanization", "cmbMaxActionsNumber", _GUICtrlComboBox_GetCurSel($g_cmbMaxActionsNumber))
	_Ini_Add("Bot Humanization", "challengeMessage", GUICtrlRead($g_challengeMessage))

	; Goblin XP - Team AiO MOD++
	_Ini_Add("GoblinXP", "EnableSuperXP", $ichkEnableSuperXP)
	_Ini_Add("GoblinXP", "SkipZoomOutXP", $ichkSkipZoomOutXP)
	_Ini_Add("GoblinXP", "FastGoblinXP", $ichkFastGoblinXP)
	_Ini_Add("GoblinXP", "SXTraining",  $irbSXTraining)
	_Ini_Add("GoblinXP", "SXBK", $ichkSXBK)
	_Ini_Add("GoblinXP", "SXAQ", $ichkSXAQ)
	_Ini_Add("GoblinXP", "SXGW", $ichkSXGW)
	_Ini_Add("GoblinXP", "MaxXptoGain", GUICtrlRead($txtMaxXPtoGain))

	; GTFO - Team AiO MOD++
	_Ini_Add("GTFO", "chkUseGTFO", $g_bChkUseGTFO)
	_Ini_Add("GTFO", "txtMinSaveGTFO_Elixir",$g_iTxtMinSaveGTFO_Elixir)
	_Ini_Add("GTFO", "txtMinSaveGTFO_DE", $g_iTxtMinSaveGTFO_DE)
	_Ini_Add("GTFO", "chkUseKickOut", $g_bChkUseKickOut)
	_Ini_Add("GTFO", "txtDonatedCap", $g_iTxtDonatedCap)
	_Ini_Add("GTFO", "txtReceivedCap", $g_iTxtReceivedCap)
	_Ini_Add("GTFO", "chkKickOutSpammers", $g_bChkKickOutSpammers)
	_Ini_Add("GTFO", "txtKickLimit", $g_iTxtKickLimit)

	; Check Grand Warden Mode - Team AiO MOD++
	_Ini_Add("other", "chkCheckWardenMode", $g_bCheckWardenMode ? 1 : 0)
	_Ini_Add("other", "cmbCheckWardenMode", $g_iCheckWardenMode)

	; Restart Search Legend league - Team AiO MOD++
	_Ini_Add("other", "ChkSearchTimeout", $g_bIsSearchTimeout)
	_Ini_Add("other", "SearchTimeout", $g_iSearchTimeout)

EndFunc   ;==>SaveConfig_MOD
