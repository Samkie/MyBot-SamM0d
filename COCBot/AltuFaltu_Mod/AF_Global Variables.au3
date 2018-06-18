; #FUNCTION# ====================================================================================================================
; Name ..........: Global Variables(AltuFaltu_Mod)
; Description ...: This file Includes all Declared variables, constant, or create an array.
; Syntax ........: Global
; Parameters ....: None
; Return values .: None
; Author ........: AltuFaltu(06-04-18)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;Glabal Variables for Debugging
Global $g_DebugLogAF = 0
Global $g_DebugImageAF = 0

;Global variables to hold GUI master and global values
Global $g_hTabMod_AF
Global $g_chkSCIDSwitchAccAF, $g_ichkSCIDSwitchAccAF
Global Enum $g_eFull, $g_eRemained, $g_eNoTrain
Global $g_abRCheckWrongArmyCamp[2] = [False, False] ; Result of checking wrong Troops & Spells
Global $g_bChkMultiClick, $g_iMultiClick = 1
Global $g_aiQueueTroops[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiQueueSpells[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

Global $aIsOnBuilderBase[4] = [359, 9, 0x75BDE4, 6] ; Check the Gold Coin from resources , is a square not round

;Global Variables to hold Function Data
Global $g_SwitchSCIDAccFatalErrorAF = False
Global $g_ClkSCIDDisConnBtnAF[4] = [370,215,500,230]
Global $g_ClkSCIDLogOutBtnAF[4] = [605,285,710,310]
Global $g_ClkSCIDConfirmBtnAF[4] = [455,430,615,455]
Global $g_ClkSCIDLoginBtnAF[4] = [300,620,555,640]