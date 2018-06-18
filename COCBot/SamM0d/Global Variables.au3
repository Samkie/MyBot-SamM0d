; #FUNCTION# ====================================================================================================================
; Name ..........: Global Variables
; Description ...: This file Includes several files in the current script and all Declared variables, constant, or create an array.
; Syntax ........: #include , Global
; Parameters ....: None
; Return values .: None
; Author ........: Samkie (30, May 2017)
; Modified ......: Everyone all the time  :)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Global $g_hTabMod
Global $g_hCmbProfile2
Global $g_iScreenSizeErrorCount = 0
#include "functions\ModTrain\Mod Train Global Variables.au3"

;===============SamM0d Global Translate Variables====================
Global $CustomTrain_MSG_1
Global $CustomTrain_MSG_2
Global $CustomTrain_MSG_3
Global $CustomTrain_MSG_4
Global $CustomTrain_MSG_5
Global $CustomTrain_MSG_6
Global $CustomTrain_MSG_7
Global $CustomTrain_MSG_8
Global $CustomTrain_MSG_9
Global $CustomTrain_MSG_10
Global $CustomTrain_MSG_11
Global $CustomTrain_MSG_12
Global $CustomTrain_MSG_13
Global $CustomTrain_MSG_14
Global $CustomTrain_MSG_15
Global $CustomTrain_MSG_DarkElixir
Global $CustomTrain_MSG_Elixir
;============================================================

Global $g_iSamM0dDebug = 0
Global $g_iSamM0dDebugOCR = 0
Global $g_iSamM0dDebugImage = 0
Global $g_iFailedToZoomOutCount = 0

Global $COLOR_HMLClick_LOG =0x004040

Global $g_hChkSamM0dDebugOCR, $g_hChkSamM0dDebug, $g_hchkSamM0dImage, $g_hBtnMakeImageForTrainButtons
Global $g_sLeague, $g_iLeagueNo
Global $bIDoScanMineAndElixir = False
Global $bUpdateStats = False
Global $ichkAutoDock = 1
Global $bJustMakeDonate = False
Global $ichkDropCCFirst = 0

;Global $TopLeftOri[5][2] = [[75, 306], [154, 246], [233, 186], [312, 126], [391, 66]]
;Global $TopRightOri[5][2] = [[460, 70], [538, 129], [617, 189], [695, 248], [774, 308]]
;Global $BottomLeftOri[5][2] = [[80, 394], [148, 446], [217, 497], [286, 549], [354, 600]]
;Global $BottomRightOri[5][2] = [[515, 610], [589, 554], [663, 497], [737, 443], [811, 384]]

;~ ; Remove Special Obstacle at Builder Base
;~ Global $ichkRemoveSpecialObstacleBB, $chkRemoveSpecialObstacleBB

; Donate not over unit
Global $ichkEnableLimitDonateUnit, $chkEnableLimitDonateUnit, $itxtLimitDonateUnit, $txtLimitDonateUnit, $iDonatedUnit

; max logout time
Global $ichkEnableLogoutLimit, $chkEnableLogoutLimit, $itxtLogoutLimitTime, $txtLogoutLimitTime

; auto hide emulator, minimize bot after start
Global $chkAutoHideEmulator, $chkAutoMinimizeBot
Global $g_bChkAutoHideEmulator = False
Global $g_bFlagHideEmulator = False
Global $g_bChkAutoMinimizeBot = False
Global $g_bFlagMinimizeBot = False

;~ ; pause tray tip
;~ Global $chkDisablePauseTrayTip, $ichkDisablePauseTrayTip

; unit wave factor
Global $ichkUnitFactor
Global $itxtUnitFactor
Global $ichkWaveFactor
Global $itxtWaveFactor
Global $chkUnitFactor, $txtUnitFactor, $chkWaveFactor, $txtWaveFactor

; global delay increse
Global $ichkIncreaseGlobalDelay = 0
Global $itxtIncreaseGlobalDelay = 10

; stick to train page
Global $itxtStickToTrainWindow = 2

; Wait For CC
; GUI object declared
Global $chkWait4CC, $chkWait4CCSpell, $txtCCStrength
Global $grpClanCastle

Global $cmbCCTroopSlot1, $cmbCCTroopSlot2, $cmbCCTroopSlot3
Global $txtCCTroopSlotQty1, $txtCCTroopSlotQty2, $txtCCTroopSlotQty3

Global $iCCTroopSlot1, $iCCTroopSlot2, $iCCTroopSlot3
Global $iCCTroopSlotQty1, $iCCTroopSlotQty2, $iCCTroopSlotQty3

Global $cmbCCSpellSlot1, $cmbCCSpellSlot2
Global $txtCCSpellSlotQty1, $txtCCSpellSlotQty2
Global $iCCSpellSlot1, $iCCSpellSlot2
Global $iCCSpellSlotQty1, $iCCSpellSlotQty2


Global $g_iChkWait4CC = False
Global $CurCCCamp = 0
Global $CurTotalCCCamp = 0
Global $CCCapacity = 0
Global $CCStrength = 100
Global $FullCCTroops = False
; Wait For CC Spell
Global $g_iChkWait4CCSpell = False
Global $g_iCurCCSpellCamp = 0
Global $g_iCurTotalCCSpellCamp = 0
Global $g_bFullCCSpells = False


;~ Global $chkEnableADBClick
Global $chkDropCCFirst

; check for cc
Global $ichkCheck4CC = 0
Global $itxtCheck4CCWaitTime = 7

; Multi Finger Attack Style Setting
Global Enum $directionLeft, $directionRight
Global Enum $sideBottomRight, $sideTopLeft, $sideBottomLeft, $sideTopRight
Global Enum $mfRandom, $mfFFStandard, $mfFFSpiralLeft, $mfFFSpiralRight, $mf8FBlossom, $mf8FImplosion, $mf8FPinWheelLeft, $mf8FPinWheelRight

Global $iMultiFingerStyle = 0

Global Enum  $eCCSpell = $eSkSpell + 1
Global $lblDBMultiFinger, $cmbDBMultiFinger

; SmartZap GUI variables from ChaCalGyn (LunaEclipse) - DEMEN
Global $ichkSmartZapDB = 1
Global $ichkSmartZapSaveHeroes = 1
Global $ichkSmartZapRnd = 1
Global $itxtMinDE = 400
; SmartZap stats from ChaCalGyn (LunaEclipse) - DEMEN
;Global $smartZapGain = 0
;Global $numLSpellsUsed = 0
; SmartZap Array to hold Total Amount of DE available from Drill at each level (1-6) from ChaCalGyn (LunaEclipse) - DEMEN
;Global Const $drillLevelHold[6] = [120,225,405,630,960,1350]
; SmartZap Array to hold Amount of DE available to steal from Drills at each level (1-6) from ChaCalGyn (LunaEclipse) - DEMEN
;Global Const $drillLevelSteal[6] = [59,102,172,251,343,479]

;samm0d zap
Global $ichkUseSamM0dZap = 1
Global $ichkDrillExistBeforeZap = 1
Global $itxtMinDEGetFromDrill = 120
Global $numLSpellDrop = 0
Global $debugZapSetLog = 0
Global $ichkPreventTripleZap = 1
Global $grpSmartZap, $chkUseSamM0dZap, $lblMinDark2, $txtMinDark2, $chkSmartZapDB2, $chkSmartZapSaveHeroes2, $chkSmartZapRnd, $chkDrillExistBeforeZap, $chkPreventTripleZap, $lblMinDEGetFromDrill, $txtMinDEGetFromDrill, _
$lblMySmartZap, $lblMyLightningUsed, $chkSmartZapDB, $chkSmartZapSaveHeroes, $txtMinDark

; samm0d chinese request
Global $ichkEnableCustomOCR4CCRequest = 0

; Check Collectors Outside - Added by TheRevenor
#region Check Collectors Outside
; collectors outside filter
Global $ichkDBMeetCollOutside, $iDBMinCollOutsidePercent = 80, $iCollOutsidePercent ; check later if $iCollOutsidePercent obsolete
; constants
Global Const $THEllipseWidth = 200, $THEllipseHeigth = 150, $CollectorsEllipseWidth = 130, $CollectorsEllipseHeigth = 97.5
Global Const $centerX = 430, $centerY = 335 ; check later if $THEllipseWidth, $THEllipseHeigth obsolete
Global $hBitmapFirst
;samm0d
Global $ichkSkipCollectorCheckIF = 1
Global $itxtSkipCollectorGold = 400000
Global $itxtSkipCollectorElixir = 400000
Global $itxtSkipCollectorDark = 0
Global $ichkSkipCollectorCheckIFTHLevel = 1
Global $itxtIFTHLevel = 7
Global $ichkDBCollectorsNearRedline = 0
Global $icmbRedlineTiles = 1
Global $chkDBMeetCollOutside, $txtDBMinCollOutsidePercent, $chkDBCollectorsNearRedline, $cmbRedlineTiles, $chkSkipCollectorCheckIF, $lblSkipCollectorGold, $txtSkipCollectorGold, $lblSkipCollectorElixir, _
$txtSkipCollectorElixir, $lblSkipCollectorDark, $txtSkipCollectorDark, $chkSkipCollectorCheckIFTHLevel, $txtIFTHLevel
#endregion

; Check League For DeadBase
Global $chkDBNoLeague, $chkABNoLeague, $iChkNoLeague[$g_iModeCount]
Global $aNoLeague[4] 		 = [30, 30, 0x616568, 20] ; No League Shield

; HLFClick by Samkie
Global $ichkEnableHLFClick = 1
Global $isldHLFClickDelayTime = 400
Global $ichkEnableHLFClickSetlog = 0
Global $iHLFClickMin = 7 ; Minimum click per wave
Global $iHLFClickMax = 14 ; Maximum click per wave
Global $EnableHMLSetLog = 0
Global $bDonateAwayFlag = False

; HLFClick GUI
Global $grpHLFClick, $lblHLFClickDelay, $lblDesc1, $chkEnableHLFClick, $lblHLFClickDelayTime, $sldHLFClickDelayTime, $chkEnableHLFClickSetlog


; advanced update for wall by Samkie
Global $ichkSmartUpdateWall = 1
Global $itxtClickWallDelay = 500
Global $aBaseNode[2] = [-1,-1] ;first found with core
Global $aLastWall[2] = [-1,-1]
Global $iFaceDirection = -1

Global $grpStatsMisc, $chkSmartUpdateWall,$txtClickWallDelay, $chkEnableCustomOCR4CCRequest, $chkCheck4CC, $txtCheck4CCWaitTime, $chkIncreaseGlobalDelay, $txtIncreaseGlobalDelay, _
$chkAutoDock

; CSV Deployment Speed Mod
Global $isldSelectedCSVSpeed[$g_iModeCount], $iCSVSpeeds[19]
$isldSelectedCSVSpeed[$DB] = 4
$isldSelectedCSVSpeed[$LB] = 4
$iCSVSpeeds[0] = .1
$iCSVSpeeds[1] = .25
$iCSVSpeeds[2] = .5
$iCSVSpeeds[3] = .75
$iCSVSpeeds[4] = 1
$iCSVSpeeds[5] = 1.25
$iCSVSpeeds[6] = 1.5
$iCSVSpeeds[7] = 1.75
$iCSVSpeeds[8] = 2
$iCSVSpeeds[9] = 2.25
$iCSVSpeeds[10] = 2.5
$iCSVSpeeds[11] = 2.75
$iCSVSpeeds[12] = 3
$iCSVSpeeds[13] = 5
$iCSVSpeeds[14] = 8
$iCSVSpeeds[15] = 10
$iCSVSpeeds[16] = 20
$iCSVSpeeds[17] = 50
$iCSVSpeeds[18] = 99
Global $grpScriptSpeedDB, $lbltxtSelectedSpeedDB, $sldSelectedSpeedDB, $grpScriptSpeedAB, $lbltxtSelectedSpeedAB, $sldSelectedSpeedAB

Global $btnAttNowDB, $btnAttNowLB

; MySwitch
; GUI
Global $g_ahLblStatsSwitchTotal[4]
Global $g_ahLblStatsSwitchGPH[4]
Global $grpMySwitch, $chkEnableMySwitch, $chkProfileImage, $g_hLblProfileName, $arrowleft2, $arrowright2, $btnMakeSwitchADBFolder, $cmbSwitchMethod, $btnPushshared_prefs
;Global $chkUseADBLoadVillage
Global $chkEnableAcc[8], $cmbWithProfile[8], $cmbAtkDon[8], $cmbStayTime[8], $chkPriority[8]

;Global $ichkUseADBLoadVillage = 0
Global $icmbSwitchMethod = 0
Global $iSelectAccError = 0
Global $iTotalDonateType = 0
Global $iCheckAccProfileError = 0
Global $iSlotYOffset = 0
Global $chkUseADBLoadVillage
Global $lblActiveAcc
Global $chkCanCloseGame, $txtCanCloseGameTime

Global $ichkProfileImage = 0
Global $ichkEnableAcc[8] = [0,0,0,0,0,0,0,0]
Global $icmbWithProfile[8] = [0,0,0,0,0,0,0,0]
Global $icmbAtkDon[8] = [0,0,0,0,0,0,0,0]
Global $icmbStayTime[8] = [0,0,0,0,0,0,0,0]
Global $ichkPriority[8] = [0,0,0,0,0,0,0,0]

Global $ichkEnableMySwitch = 0
Global $ichkCanCloseGame = 1
Global $itxtCanCloseGameTime = 180
Global $iMySwitchSmartWaitTime = 0
Global $iDoPerformAfterSwitch = False
Global $iCurActiveAcc = -1
Global $iNextAcc = 0
Global $iCurStep = 0
Global $iSortEnd = 0
Global $bChangeNextAcc = True
Global $ichkEnableContinueStay, $chkEnableContinueStay, $itxtTrainTimeLeft, $txtTrainTimeLeft, $ichkForcePreTrainB4Switch, $chkForcePreTrainB4Switch
Global $ichkSwitchDonTypeOnlyWhenAtkTypeNotReady = False
Global $bAvoidSwitch = False
;Global $bNowWaitingConfirm = False

; use Event troop
Global $ichkEnableUseEventTroop, $chkEnableUseEventTroop

; donate only when troop pre train ready
Global $ichkEnableDonateWhenReady, $chkEnableDonateWhenReady

; stop bot when low battery
Global $ichkEnableStopBotWhenLowBattery, $chkEnableStopBotWhenLowBattery
Global $g_bCheckBattery = False

; bot log
Global $chkBotLogLineLimit, $ichkBotLogLineLimit, $txtLogLineLimit, $itxtLogLineLimit


Global $aSwitchList[1][8]

Global $aProfileStats[44][9] = _
[["g_iFirstAttack",0,0,0,0,0,0,0,0], _
["g_iSkippedVillageCount",0,0,0,0,0,0,0,0], _
["g_iDroppedTrophyCount",0,0,0,0,0,0,0,0], _
["g_iCostGoldWall",0,0,0,0,0,0,0,0], _
["g_iCostElixirWall",0,0,0,0,0,0,0,0], _
["g_iCostGoldBuilding",0,0,0,0,0,0,0,0], _
["g_iCostElixirBuilding",0,0,0,0,0,0,0,0], _
["g_iCostDElixirHero",0,0,0,0,0,0,0,0], _
["g_iNbrOfWallsUppedGold",0,0,0,0,0,0,0,0], _
["g_iNbrOfWallsUppedElixir",0,0,0,0,0,0,0,0], _
["g_iNbrOfBuildingsUppedGold",0,0,0,0,0,0,0,0], _
["g_iNbrOfBuildingsUppedElixir",0,0,0,0,0,0,0,0], _
["g_iNbrOfHeroesUpped",0,0,0,0,0,0,0,0], _
["g_iSearchCost",0,0,0,0,0,0,0,0], _
["g_iTrainCostElixir",0,0,0,0,0,0,0,0], _
["g_iTrainCostDElixir",0,0,0,0,0,0,0,0], _
["g_iNbrOfOoS",0,0,0,0,0,0,0,0], _
["g_iNbrOfTHSnipeFails",0,0,0,0,0,0,0,0], _
["g_iNbrOfTHSnipeSuccess",0,0,0,0,0,0,0,0], _
["g_iGoldFromMines",0,0,0,0,0,0,0,0], _
["g_iElixirFromCollectors",0,0,0,0,0,0,0,0], _
["g_iDElixirFromDrills",0,0,0,0,0,0,0,0], _
["g_iFreeBuilderCount",0,0,0,0,0,0,0,0], _
["g_iTotalBuilderCount",0,0,0,0,0,0,0,0], _
["g_iGemAmount",0,0,0,0,0,0,0,0], _
["g_iTownHallLevel",0,0,0,0,0,0,0,0], _
["g_sLeague",0,0,0,0,0,0,0,0], _
["g_iLeagueNo",0,0,0,0,0,0,0,0], _
["g_iSmartZapGain",0,0,0,0,0,0,0,0], _
["g_iNumEQSpellsUsed",0,0,0,0,0,0,0,0], _
["g_iNumLSpellsUsed",0,0,0,0,0,0,0,0], _
["g_aiCurrentLoot",0,0,0,0,0,0,0,0], _
["g_iStatsStartedWith",0,0,0,0,0,0,0,0], _
["g_iStatsTotalGain",0,0,0,0,0,0,0,0], _
["g_iStatsLastAttack",0,0,0,0,0,0,0,0], _
["g_iStatsBonusLast",0,0,0,0,0,0,0,0], _
["g_aiAttackedVillageCount",0,0,0,0,0,0,0,0], _
["g_aiTotalGoldGain",0,0,0,0,0,0,0,0], _
["g_aiTotalElixirGain",0,0,0,0,0,0,0,0], _
["g_aiTotalDarkGain",0,0,0,0,0,0,0,0], _
["g_aiTotalTrophyGain",0,0,0,0,0,0,0,0], _
["g_aiNbrOfDetectedMines",0,0,0,0,0,0,0,0], _
["g_aiNbrOfDetectedCollectors",0,0,0,0,0,0,0,0], _
["g_aiNbrOfDetectedDrills",0,0,0,0,0,0,0,0]]