; #FUNCTION# ====================================================================================================================
; Name ..........:
; Description ...: This file Includes all functions to current GUI
; Syntax ........: RemoveSpecialObstacleBB()
; Parameters ....: None
; Return values .: None
; Author ........: Samkie(25 Jun, 2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func RemoveSpecialObstacleBB()
	If $ichkRemoveSpecialObstacleBB <> 1 Then Return

	If $g_iSamM0dDebug = 1 Then SetLog("Begin RemoveSpecialObstacleBB()")
	SetLog("Checking special Obstacle...", $COLOR_ACTION)
	getBuilderCount(True, True)
	If $g_iFreeBuilderCountBB = $g_iTotalBuilderCountBB Then
		ClickP($aAway, 1, 0, "#BB")
		If _Sleep(200) Then Return
		BuildingClick(400,591)
		If _Sleep(300) Then Return
		Local $iTreeCoust = getMyOcr(0,407,595 + $g_iMidOffsetY,47,15,"armycap",True)
		If $iTreeCoust = 2000 Then
			SetLog("Found and remove it.", $COLOR_SUCCESS)
			HMLPureClick(Random(410,450,1), Random(640,670,1))
			If _Sleep(200) Then Return
			ClickP($aAway, 1, 0, "#BB")
			Return
		EndIf
		ClickP($aAway, 1, 0, "#BB")
		If _Sleep(200) Then Return
		; second try if not found
		BuildingClick(388,584)
		If _Sleep(300) Then Return
		Local $iTreeCoust = getMyOcr(0,407,595 + $g_iMidOffsetY,47,15,"armycap",True)
		If $iTreeCoust = 2000 Then
			SetLog("Found and remove it.", $COLOR_SUCCESS)
			If _Sleep(200) Then Return
			ClickP($aAway, 1, 0, "#BB")
			Return
		EndIf
	EndIf
	ClickP($aAway, 1, 0, "#BB")
	SetLog("Not found.", $COLOR_ACTION)
	If $g_iSamM0dDebug = 1 Then SetLog("End RemoveSpecialObstacleBB()")
EndFunc