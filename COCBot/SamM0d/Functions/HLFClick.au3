; #FUNCTION# ====================================================================================================================
; Name ..........: HLFClick v0.5
; Description ...: Implemental Advanced Random Click On The Button Area Like Human
;                  Even we already set to Random Click, but some button like Returm Home, Surrender, Those Still Click on same pixel.
;                  Since Mybot is an open source program, if Supercell need make spy on it,
;                  away click will be the high risk for SC Psychic Octopus looking for, not human can be click at the same pixel at x1,y40
;
;                  With old method of remove troops all fast tempo click at same pixel, so here i also randomize it
;				   Re-Define all the button region, and random click inside the button region
;				   I know this is not efficient for the code CheckClickMsg using string to check the what is click, but as a mod the only way for easy maintain to upgrade if got new official release XD
;                  From the official release, i still found out some click use the same debug code #
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Samkie
; Modified ......: 25 Jun 2018
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global Const $aButtonClose1[9] 	                = [817, 114, 836, 134, 824, 121, 0xFFFFFF, 10, "=-= Close Train [X]"] ; Train window, Close Button
Global Const $aButtonClose2[9]                  = [755, 106, 775, 126, 764, 114, 0xFFFFFF, 10, "=-= Close Setting [X] | Def / Atk Log [X]"] ; Def / Atk log window / setting window, Close Button
Global Const $aButtonClose3[9]                  = [815,  65, 836,  90, 826,  73, 0xFFFFFF, 10, "=-= Close Profile/League/Clan Games [X]"] ; Profile / League page/ Clan Games, Close Button
Global Const $aButtonClose4[9]                  = [620, 180, 642, 200, 632, 188, 0xFFFFFF, 10, "=-= Close Shield Info [X]"] ; PB Info page, Close Button
Global Const $aButtonClose5[9] 	                = [806,  27, 828,  52, 817,  37, 0xFFFFFF, 10, "=-= Close Shop [X]"] ; Shop, Close Button  / Same area with map editor close button
Global Const $aButtonClose6[9]                  = [790,  25, 818,  48, 804,  33, 0xFFFFFF, 10, "=-= Close Launch Attack [X]"] ; Launch Attack Page, Close Button
Global Const $aButtonClose7[9]                  = [720, 134, 738, 155, 717, 152, 0xE91313, 10, "=-= Close Laboratory [X]"] ; Laboratory Page, Close Button
Global Const $aButtonClose8[9]                  = [696, 180, 719, 207, 692, 201, 0xE91219, 10, "=-= Close Daily Discounts [X]"] ; Laboratory Page, Close Button
Global Const $aButtonCloseAway[9]               = [150,   4, 175,  14,   0,   0, 0x0     ,  0, "=-= Random Away Coordinate"]

;~ ; ScreenCoordinates - first 4 values store the region [x1,y1,x2,y2] that can click; values 5,6,7,8 is the color check pixel x,y,color,tolerance level for confirm the button exist if needed.
Global Const $aButtonArmyTab[9]                 = [ 30, 115, 150, 140,  40, 111, 0xF9F9F7, 20, "=-= Army Tab"]
Global Const $aButtonTrainTroopsTab[9]          = [190, 115, 300, 140, 200, 111, 0xF9F9F7, 20, "=-= Train Troops Tab"]
Global Const $aButtonBrewSpellsTab[9]           = [350, 115, 460, 140, 360, 111, 0xF9F9F7, 20, "=-= Brew Spells Tab"]

Global Const $aButtonSeigeMachineTab[9]         = [500, 115, 620, 140, 625, 111, 0xFAFAF7, 20, "=-= Seige Machine Tab"]

Global Const $aButtonQuickTrainTab1[9]          = [500, 115, 620, 140, 510, 111, 0xFAFAF7, 20, "=-= Quick Train Tab Without Seige Machine Tab Exist"]
Global Const $aButtonQuickTrainTab2[9]          = [665, 115, 770, 140, 660, 111, 0xFAFAF7, 20, "=-= Quick Train Tab With Seige Machine Tab Exist"]

Global Const $aButtonOpenTrainArmy[9]  	  	    = [ 25, 570,  50, 600,  50, 567, 0xEEAF45, 20, "=-= Open Train Army Page"] ; Main Screen, Army Train Button
Global Const $aButtonOpenProfile[9]    	  	    = [ 28,  23,  46,  46,  38,  18, 0x10D0F0, 20, "=-= Open Profile Page"] ; Main page, Open Profile Button

Global Const $aButtonOpenShieldInfo[9] 	  	    = [430,   7, 442,  20, 436,  14, 0xF5F5ED,  6, "=-= Open Shield Info Page"] ; main page, open shield info page
Global Const $aButtonOpenLaunchAttack[9] 		= [ 30, 640,  90, 700,  22, 674, 0x9A4916, 30, "=-= Open Launce Attack Page"] ; Main Page, Attack! Button

Global Const $aButtonClanWindowOpen[9]   	    = [  8, 355,  28, 410,  16, 400, 0xC55115, 20, "=-= Open Chat Window"] ; main page, clan chat Button
Global Const $aButtonClanWindowClose[9]  	    = [321, 355, 342, 410, 330, 400, 0xC55115, 20, "=-= Close Chat Window"] ; main page, clan chat Button
Global Const $aButtonClanChatTab[9]    	  	    = [175,  14, 275,  30, 280,  30, 0x706C50, 20, "=-= Switch to Clan Channel"] ; Chat page, ClanChat Tab
Global Const $aButtonClanDonateScrollUp[9] 	    = [290, 100, 300, 112, 295, 100, 0xFFFFFF, 10, "=-= Donate Scroll Up"] ; Donate / Chat Page, Scroll up Button
Global Const $aButtonClanDonateScrollDown[9] 	= [290, 650, 300, 662, 295, 655, 0xFFFFFF, 10, "=-= Donate Scroll Down"] ; Donate / Chat Page, Scroll Down Button

Global Const $aButtonAttackReturnHome[9]     	= [385, 558, 480, 598, 440, 588, 0x60B010, 20, "=-= Return Home"] ; IsReturnHomeBattlePage, ReturnHome Button
Global Const $aButtonAttackSurrender[9]      	= [ 25, 585, 110, 609,  66, 606, 0xC00000, 20, "=-= Surrender Battle"] ; Attack Page, Surrender Button
Global Const $aButtonAttackEndBattle[9]      	= [ 25, 585, 110, 609,  66, 606, 0xC00000, 20, "=-= End Battle"] ; Attack Page, EndBattle Button
Global Const $aButtonAttackNext[9] 	            = [710, 560, 830, 600, 780, 576, 0xD34300, 20, "=-= Next"] ; Village Search Next Button
Global Const $aButtonAttackFindMatch[9] 		= [200, 535, 300, 600, 148, 529, 0xF8E0A2, 30, "=-= Find A Match"] ; Attack Page Find A Match Button
Global Const $aButtonAttackFindMatchWShield[9]  = [200, 490, 300, 530, 148, 484, 0xF8E0A4, 30, "=-= Find A Match (With Shield)"] ; Attack Page Find A Match Button With Shield

Global Const $aButtonRequestCC[9] 			    = [680, 550, 765, 580, 758, 572, 0x76C01E, 20, "=-= Request CC"] ; Train, RequestCC Button
Global Const $aButtonRequestCCText[9] 		    = [370, 130, 510, 170, 430, 170, 0xFFFFFF, 10, "=-= Select Text"] ; RequestCC, TXT Button
Global Const $aButtonRequestCCSend[9] 		    = [470, 215, 570, 255, 520, 254, 0x60AC10, 20, "=-= Send Request"] ; RequestCC, Send Button

Global Const $aButtonSMSetting[9]				= [810, 575, 830, 595, 814, 569, 0xFFFFFF, 10, "=-= Setting"]
Global Const $aButtonSettingTabSetting[9]		= [388, 110, 484, 130, 434, 110, 0xF0F4F0, 10, "=-= Tab Settings"]
Global Const $aButtonGoogleConnectRed[9]		= [410, 410, 460, 430, 431, 431, 0xD00408, 20, "=-= Connect Red"]
Global Const $aButtonGoogleConnectGreen[9]	  	= [410, 410, 460, 430, 431, 408, 0xD0E878, 20, "=-= Connect Green"]

Global Const $aButtonSMVillageLoad[9] 		    = [480, 415, 550, 445, 455, 437, 0x72C11D, 20, "=-= Village Load"]
Global Const $aButtonVillageCancel[9] 		    = [310, 415, 380, 445, 288, 433, 0xED7531, 20, "=-= Village Cancel"]

Global Const $aButtonVillageConfirmClose[9]     = [575,  20, 595,  40, 562,  37, 0x605450, 20, "=-= Village Confirm Close"]
Global Const $aButtonVillageConfirmText[9]      = [320, 190, 375, 200, 350, 195, 0xFFFFFF,  5, "=-= Village Confirm Text"]
Global Const $aButtonVillageConfirmOK[9]        = [500, 185, 555, 205, 480, 198, 0x76C01E, 20, "=-= Village Confirm Okay"]
Global Const $aButtonVillageWasAttackOK[9]	    = [380, 505, 470, 540, 405, 537, 0x5EAC10, 20, "=-= Village Was Attacked Confirm Okay"]

Global Const $aButtonEditArmy[9]                = [740, 510, 800, 536, 800, 520, 0XC0E968, 20, "=-= Edit Army"]
Global Const $aButtonEditCancel[9]              = [740, 500, 800, 520, 800, 515, 0XE91217, 20, "=-= Edit Army Cancel"]
Global Const $aButtonEditOkay[9]                = [740, 562, 800, 582, 800, 560, 0XDDF685, 20, "=-= Edit Army Okay"]

Global Const $aButtonFriendlyChallenge[9]       = [160, 700, 220, 714, 200, 693, 0XDDF685, 20, "=-= Friendly Challenge"]
Global Const $aButtonFCChangeLayout[9]          = [200, 290, 280, 305, 240, 285, 0XDDF685, 20, "=-= Change Layout"]
Global Const $aButtonFCStart[9]                 = [500, 290, 550, 305, 530, 284, 0XDBF685, 20, "=-= Start Share Challenge"]
Global Const $aButtonFCBack[9]                  = [160, 106, 195, 120, 180, 116, 0XF5FDFF, 10, "=-= Back To Challenge"]
Global Const $aButtonFCClose[9]                 = [690, 103, 710, 125, 700, 111, 0xFFFFFF, 10, "=-= Close Challenge"]

Global Const $aButtonGuardRemove[9]             = [500, 260, 560, 275, 530, 275, 0XE51115, 15,"=-= Guard Remove"]
Global Const $aButtonGuardConfirmRemove[9]      = [485, 417, 543, 444, 510, 445, 0X6AB91D, 15,"=-= Confirm Guard Remove"]

Global Const $aButtonTrainArmy1[9]              = [750, 350, 800, 365, 735, 350, 0XCDF175, 20, "=-= Quick Train Army 1"]
Global Const $aButtonTrainArmy2[9]              = [750, 467, 800, 482, 735, 467, 0XD5F17D, 20, "=-= Quick Train Army 2"]
Global Const $aButtonTrainArmy3[9]              = [750, 583, 800, 602, 735, 586, 0XCDED75, 20, "=-= Quick Train Army 3"]

Func CheckClickMsg(ByRef $x, ByRef $y, ByRef $times, ByRef $speed, ByRef $MsgCode)
	; return 0, do nothing
	; return 1, success do randomize and let continue perform click
	; return 2, use HMLClick or HMLPureClick, cancel the original click (Click, PureClick)
	If ($x = 1 And $y = 40) Or ($x = 0 And $y = 10) or ($x = 175 And $y = 10) Then
		; replace the away click
		Return HMLClickAway($x, $y, $MsgCode)
	Else
	Switch $MsgCode
		Case "#GuardConfirmRemove"
			$MsgCode = $aButtonGuardConfirmRemove[8]
			Return HMLClickPR($aButtonGuardConfirmRemove,$x,$y,1)
		Case "#GuardRemove"
			$MsgCode = $aButtonGuardRemove[8]
			Return HMLClickPR($aButtonGuardRemove,$x,$y,1)
		Case "#BtnFCStart"
			$MsgCode = $aButtonFCStart[8]
			Return HMLClickPR($aButtonFCStart,$x,$y)
		Case "#BtnClose"
			$MsgCode = $aButtonFCClose[8]
			Return HMLClickPR($aButtonFCClose,$x,$y,1)
		Case "#BtnFCCL"
			$MsgCode = $aButtonFCChangeLayout[8]
			Return HMLClickPR($aButtonFCChangeLayout,$x,$y)
		Case "#BtnFCBack"
			$MsgCode = $aButtonFCBack[8]
			Return HMLClickPR($aButtonFCBack,$x,$y)
		Case "#BtnFC"
			$MsgCode = $aButtonFriendlyChallenge[8]
			Return HMLClickPR($aButtonFriendlyChallenge,$x,$y)
		Case "#VWAO"
			$MsgCode = $aButtonVillageWasAttackOK[8]
			Return HMLClickPR($aButtonVillageWasAttackOK,$x,$y)
		Case "#BS01","#BS02","#TT01"
			Return 1
		Case "ChatCollapseBtn"
			$MsgCode = $aButtonClanWindowClose[8]
			Return HMLClickPR($aButtonClanWindowClose,$x,$y)
		Case "ArmyTab"
			$MsgCode = $aButtonArmyTab[8]
			Return HMLClickPR($aButtonArmyTab,$x,$y,2)
		Case "BrewSpellsTab"
			$MsgCode = $aButtonBrewSpellsTab[8]
			Return HMLClickPR($aButtonBrewSpellsTab,$x,$y,2)
		Case "QuickTrainTab1"
			$MsgCode = $aButtonQuickTrainTab1[8]
			Return HMLClickPR($aButtonQuickTrainTab1,$x,$y,2)
		Case "QuickTrainTab2"
			$MsgCode = $aButtonQuickTrainTab2[8]
			Return HMLClickPR($aButtonQuickTrainTab2,$x,$y,2)
		Case "TrainTroopsTab"
			$MsgCode = $aButtonTrainTroopsTab[8]
			Return HMLClickPR($aButtonTrainTroopsTab,$x,$y,2)
		Case "OpenTrainBtn"
			$MsgCode = $aButtonOpenTrainArmy[8]
			Return HMLClickPR($aButtonOpenTrainArmy,$x,$y)
		Case "#EditArmy"
			$MsgCode = $aButtonEditArmy[8]
			Return HMLClickPR($aButtonEditArmy,$x,$y)
		Case "#EditArmyOkay"
			$MsgCode = $aButtonEditOkay[8]
			Return HMLClickPR($aButtonEditOkay,$x,$y)
		Case "#TabSettings"
			$MsgCode = $aButtonSettingTabSetting[8]
			Return HMLClickPR($aButtonSettingTabSetting,$x,$y,2)
		Case "#VL01"
			$MsgCode = $aButtonVillageCancel[8]
			Return HMLClickPR($aButtonVillageCancel,$x,$y)
		Case "#GALo"
			$MsgCode = $aButtonSMVillageLoad[8]
			Return HMLClickPR($aButtonSMVillageLoad,$x,$y)
		Case "#GATe"
			$MsgCode = $aButtonVillageConfirmText[8]
			Return HMLClickPR($aButtonVillageConfirmText,$x,$y)
		Case "#GACo"
			$MsgCode = $aButtonVillageConfirmOK[8]
			Return HMLClickPR($aButtonVillageConfirmOK,$x,$y)
		Case "#Setting"
			$MsgCode = $aButtonSMSetting[8]
			Return HMLClickPR($aButtonSMSetting,$x,$y, 1)
		Case "#ConnectGoogle"
			$MsgCode = $aButtonGoogleConnectGreen[8]
			Return HMLClickPR($aButtonGoogleConnectGreen,$x,$y)
		Case "QuickTrainTabBtn"
			$MsgCode = "=-= QuickTrainTabBtn"
			$x = Random($x-10, $x+25,1)
			$y = Random($y-3, $y+3,1)
			Return 1
		Case "Army1","Army2","Army3","Previous Army"
			;If $g_bDebugClick And $EnableHMLSetLog = 1 Then SetLog("Randomize click pixel of " & $MsgCode & " Button - ValIn: X=" & $x & " Y=" & $y,$COLOR_HMLClick_LOG)
			$MsgCode = "=-= " & $MsgCode
			$x = Random($x-10, $x+25,1)
			$y = Random($y-4, $y+4,1)
			Return 1
		Case "#0176","#0171"
			$MsgCode = $aButtonCloseAway[8]
			Return HMLClickPR($aButtonCloseAway,$x,$y)
		Case "#0666","#0096","#0097","#0098","#0102","#0103","#0104","#0105","#0106","#0107","#0108","#0109"; Randomize all troops drop pixel (DropTroopFromINI #0666, DropOnPixel #0096,#0097,#0098, DropOnEdge #0102,#0103,#0104,#0105,#0106,#0107,#0108,#0109)
			For $i = 0 To $times - 1
				HMLPureClick(Random($x-1,$x+1,1),Random($y-1,$y+1,1),1,$speed,"#R666")
			Next
			Return 2
		Case "#0168","#0510"
			$bDonateAwayFlag = True
			$MsgCode = $aButtonClanWindowOpen[8]
			Return HMLClickPR($aButtonClanWindowOpen,$x,$y)
		Case "#0169"
			$MsgCode = $aButtonClanChatTab[8]
			Return HMLClickPR($aButtonClanChatTab,$x,$y,2)
		Case "#0173","#0136","#0511"
			$bDonateAwayFlag = False
			$MsgCode = $aButtonClanWindowClose[8] & " From: " & $MsgCode
			Return HMLClickPR($aButtonClanWindowClose,$x,$y,1)
		Case "#0101"
			$MsgCode = $aButtonAttackReturnHome[8]
			Return HMLClickPR($aButtonAttackReturnHome,$x,$y)
		Case "#9997"
			$MsgCode = $aButtonOpenShieldInfo[8]
			Return HMLClickPR($aButtonOpenShieldInfo,$x,$y,1)
		Case "#0099"
			$MsgCode = $aButtonAttackSurrender[8]
			Return HMLClickPR($aButtonAttackSurrender,$x,$y)
		Case "#0172"
			If $y < 120 Then
				$MsgCode = $aButtonClanDonateScrollUp[8]
				Return HMLClickPR($aButtonClanDonateScrollUp,$x,$y,1)
			Else
				$MsgCode = $aButtonClanDonateScrollDown[8]
				Return HMLClickPR($aButtonClanDonateScrollDown,$x,$y,1)
			EndIf
		Case "#0315"
			$MsgCode = $aButtonClose5[8]
			Return HMLClickPR($aButtonClose5,$x,$y,1) ;Shop, Close Button
		Case "#0253"
			$MsgCode = $aButtonRequestCC[8]
			Return HMLClickPR($aButtonRequestCC,$x,$y,1)
		Case "#0254"
			$MsgCode = $aButtonRequestCCText[8]
			Return HMLClickPR($aButtonRequestCCText,$x,$y,1)
		Case "#0256"
			$MsgCode = $aButtonRequestCCSend[8]
			Return HMLClickPR($aButtonRequestCCSend,$x,$y,1)
		Case "#0222"
			$MsgCode = $aButtonOpenProfile[8]
			Return HMLClickPR($aButtonOpenProfile,$x,$y,1)
		Case "#0223"
			$MsgCode = $aButtonClose3[8]
			Return HMLClickPR($aButtonClose3,$x,$y,1) ; Profile page close
		Case "#0293","#0334","#0347","#1293"
			$MsgCode = $aButtonOpenTrainArmy[8] & " From: " & $MsgCode
			Return HMLClickPR($aButtonOpenTrainArmy,$x,$y,1)
		Case "#0155"
			$MsgCode = $aButtonAttackNext[8]
			Return HMLClickPR($aButtonAttackNext,$x,$y)
		Case "#0149"
			$MsgCode = $aButtonOpenLaunchAttack[8]
			Return HMLClickPR($aButtonOpenLaunchAttack,$x,$y,1)
		Case "#0150"
			If _CheckColorPixel($aButtonAttackFindMatch[4], $aButtonAttackFindMatch[5], $aButtonAttackFindMatch[6], $aButtonAttackFindMatch[7], $g_bCapturePixel, "aButtonAttackFindMatch") Then
				$MsgCode = $aButtonAttackFindMatch[8]
				Return HMLClickPR($aButtonAttackFindMatch,$x,$y,1)
			ElseIf _CheckColorPixel($aButtonAttackFindMatchWShield[4], $aButtonAttackFindMatchWShield[5], $aButtonAttackFindMatchWShield[6], $aButtonAttackFindMatchWShield[7], $g_bCapturePixel, "aButtonAttackFindMatchWShield") Then
				$MsgCode = $aButtonAttackFindMatchWShield[8]
				Return HMLClickPR($aButtonAttackFindMatchWShield,$x,$y,1)
			Else
				Return 0
			EndIf
		Case "#0236"
			$MsgCode = "=-= Atk Log Button"
			$x = Random($x-5, $x+5,1)
			$y = Random($y, $y+10,1)
			Return 1
		Case "#0117"
			$MsgCode = "=-= Okay Button"
			$x = Random($x-15, $x+15,1)
			$y = Random($y-10, $y+10,1)
			Return 1
		Case "#0225"
			$MsgCode = "=-= TownHall"
			$x = Random($x-2, $x+2,1)
			$y = Random($y, $y+7,1)
			Return 1
		Case "#0430"
			$MsgCode = "=-= Collector"
			$x = Random($x-4, $x+4,1)
			$y = Random($y-4, $y+4,1)
			Return 1
		Case "#0290"
			$MsgCode = "=-= Create Spell"
			$x = Random($x-20, $x+20,1)
			$y = Random($y-10, $y+10,1)
			Return 1
		Case "#0174"
			$MsgCode = "=-= Donate Button"
			$x = Random($x-20, $x+20,1)
			$y = Random($y, $y+15,1)
			Return 1
		Case "#0111","#0092","#0094","#X998","#0090"
			$MsgCode = "=-= SelectTroop - From: " & $MsgCode
			$x = Random($x-8, $x+8,1)
			$y = Random($y, $y+30,1)
			Return 1
		Case "#0330"
			$MsgCode = "=-= LootCart"
			$x = Random($x-5, $x,1)
			$y = Random($y-1, $y+2,1)
			Return 1
		Case "#0331"
			$MsgCode = "=-= LootCart Collect Button"
			$x = Random($x-20, $x+20,1)
			$y = Random($y-20, $y+10,1)
			Return 1
		Case "#0316"
			$MsgCode = "=-=  Upgrade Wall With Gold"
			$x = Random($x, $x+30,1)
			$y = Random($y, $y+20,1)
			Return 1
		Case "#0317"
			$MsgCode = "=-= Confirm With Gold"
			$x = Random($x-30, $x,1)
			$y = Random($y, $y+30,1)
			Return 1
		Case "#0318"
			$MsgCode = "=-= Confirm With Elixir"
			$x = Random($x-30, $x,1)
			$y = Random($y, $y+30,1)
			Return 1
		Case "#0322"
			$MsgCode = "=-= Upgrade Wall With Elixir"
			$x = Random($x, $x+30,1)
			$y = Random($y, $y+20,1)
			Return 1
		Case "#0600","#0175"
			$MsgCode = "=-= Donate Troops / Spell From: " & $MsgCode
			$x = Random($x-5, $x+25,1)
			$y = Random($y-30, $y,1)
			Return 1
		Case Else
			Return 0
	EndSwitch
	EndIf
	Return 0
EndFunc ;==>CheckClickMsg

Func RemoveAllTroopAlreadyTrain()
	If $g_bDebugSetlogTrain Then SetLog("====Start Delete Troops====",$COLOR_HMLClick_LOG)
	Local $iRanX = Random(817,829,1)
	Local $iRanY = Random(166 + $g_iMidOffsetY,177 + $g_iMidOffsetY,1)
	Local $iRanX2 = Random(746,758,1)
	Local $iRanX3 = Random(677,688,1)
	Local $iRanX4 = Random(606,616,1)
	Local $iCount = 0

	ForceCaptureRegion()
	While Not _ColorCheck(_GetPixelColor(823, 175 + $g_iMidOffsetY, True), Hex(0xCFCFC8, 6), 20) ; while not disappears  green arrow
		; FFF delete
		If isProblemAffectBeforeClick($iCount) Then ExitLoop
		Local $iRanTime = Random(8,12,1)
		For $i = 0 To $iRanTime
			HMLPureClick(Random($iRanX-2,$iRanX+2,1), Random($iRanY-2,$iRanY+2,1),1,0,"#0702")
			HMLPureClick(Random($iRanX2-2,$iRanX2+2,1), Random($iRanY-2,$iRanY+2,1),1,0,"#0702")
			HMLPureClick(Random($iRanX3-2,$iRanX3+2,1), Random($iRanY-2,$iRanY+2,1),1,0,"#0702")
			HMLPureClick(Random($iRanX4-2,$iRanX4+2,1), Random($iRanY-2,$iRanY+2,1),1,0,"#0702")
			If _Sleep(Random(($g_iTrainClickDelay*90)/100, ($g_iTrainClickDelay*110)/100, 1), False) Then ExitLoop
		Next
		$iCount += 1
		If $iCount > 30 Then ExitLoop
	WEnd
	; reset variable
	For $i = 0 To UBound($MyTroops) - 1
		Assign("OnQ" & $MyTroops[$i][0], 0)
	Next
	For $i = 0 To UBound($MyTroops) - 1
		Assign("OnT" & $MyTroops[$i][0], 0)
	Next

	If $g_bDebugSetlogTrain Then SetLog("====Ended Delete Troops====",$COLOR_HMLClick_LOG)
EndFunc

Func RemoveAllPreTrainTroops()

	Local $bExipLoop = False
	Local $iLoopCount = 0
	Local $iRandX0,$iRandX1,$iRandX2,$iRandX3,$iRandX4,$iRandX5,$iRandX6,$iRandX7,$iRandX8,$iRandX9,$iRandX10,$iRandX11
	While $bExipLoop = False
		_CaptureRegion()
		For $i = 0 To 10
			Assign("iRandX" & $i, False)
		Next
		Local $bStillNeedRemove =False
		For $i = 0 To 10
			If _ColorCheck(_GetPixelColor(120 + ($i * 70.5) , 157 + $g_iMidOffsetY, False), Hex(0xD7AFA9, 6), 10) Then
				Assign("iRandX" & $i, True)
				$bStillNeedRemove = True
			EndIf
		Next
		If $bStillNeedRemove Then
			Local $iRanTime = Random(8,12,1)
			For $j = 0 To $iRanTime
				For $i = 0 to 10
					If Eval("iRandX" & $i) Then
						HMLPureClick(Random(120 + ($i * 70.5)-2, 120 + ($i * 70.5)+2, 1), Random(200,204,1),1,0,"#0702")
					EndIf
				Next
				If _Sleep(Random(($g_iTrainClickDelay*90)/100, ($g_iTrainClickDelay*110)/100, 1), False) Then ExitLoop
			Next
		Else
			$bExipLoop = True
		EndIf
		$iLoopCount += 1
		If $iLoopCount > 30 Then ExitLoop
	WEnd
	; reset variable
	For $i = 0 To UBound($MyTroops) - 1
		Assign("OnQ" & $MyTroops[$i][0], 0)
	Next
EndFunc

Func RemoveTrainTroops($iSlot, $iCount)
	Local $iLoopCount = 0
	While $iLoopCount < $iCount
		HMLPureClick(Random(118 + ($iSlot * 70.5)-2, 118 + ($iSlot * 70.5)+2, 1), Random(200,204,1),1,0,"#RTS")
		If _Sleep(Random(($g_iTrainClickDelay*90)/100, ($g_iTrainClickDelay*110)/100, 1), False) Then ExitLoop
		$iLoopCount += 1
	WEnd
EndFunc

Func RemoveCCTroops($iSlot, $iCount)
	Local $iLoopCount = 0
	While $iLoopCount < $iCount
		HMLPureClick(Random(80 + ($iSlot * 74)-2, 80 + ($iSlot * 74)+2, 1), Random(571,575,1),1,0,"#RTS")
		If _Sleep(Random(($g_iTrainClickDelay*90)/100, ($g_iTrainClickDelay*110)/100, 1), False) Then ExitLoop
		$iLoopCount += 1
	WEnd
EndFunc

Func RemoveCCSpells($iSlot, $iCount, $iOffsetSlot)
	Local $iLoopCount = 0
	$iOffsetSlot += 58
	While $iLoopCount < $iCount
		HMLPureClick(Random($iOffsetSlot + ($iSlot * 74)-2, $iOffsetSlot + ($iSlot * 74)+2, 1), Random(571,575,1),1,0,"#RTS")
		If _Sleep(Random(($g_iTrainClickDelay*90)/100, ($g_iTrainClickDelay*110)/100, 1), False) Then ExitLoop
		$iLoopCount += 1
	WEnd
EndFunc

Func HMLClickAway(ByRef $x, ByRef $y, ByRef $MsgCode)
	If $bDonateAwayFlag = True Then
		Return HMLClickPR($aButtonCloseAway,$x,$y)
	Else
		ForceCaptureRegion()
		_CaptureRegion()
		If _CheckPixel($aIsMain) Or _CheckPixel($aIsOnBuilderBase) Then
			; randomize some pixel area we usually aways click, like train page, League page and profile page close area
			; even if the close button not exist, we use to Away
			$MsgCode = "=-= Random Away Coordinate =-= " & $MsgCode
			Return HMLClickPR($aButtonCloseAway,$x,$y)
		Else
			If _CheckPixel($aIsMainGrayed) Or _CheckPixel($aIsOnBuilderBaseGrayed) Then
				For $i = 1 To 8
					Local $tempButton = Eval("aButtonClose" & $i)
					Local $sMsg = Default
					If $EnableHMLSetLog = 1 Then $sMsg = "aButtonClose" & $i
					If _CheckColorPixel($tempButton[4], $tempButton[5], $tempButton[6], $tempButton[7], $g_bNoCapturePixel, $sMsg) Then
						$MsgCode = $tempButton[8]
						Return HMLClickPR($tempButton,$x,$y)
					EndIf
				Next
				; randomize some pixel area we usually aways click, like train page, League page and profile page close area
				; even if the close button not exist, we use to Away
				$MsgCode = "=-= Random Away Coordinate =-= " & $MsgCode
				Return HMLClickPR($aButtonCloseAway,$x,$y)
			Else
				Return 0
			EndIf
		EndIf
	EndIf
EndFunc

Func HMLClickPR($point, ByRef $x, ByRef $y, $checkpixelcolor = 0, $bForceReCapRegion = True)
	Switch $checkpixelcolor
		Case 1
			; Do Check color if the pixel color define at button variable = true then we click
			If _CheckColorPixel($point[4], $point[5], $point[6], $point[7], $bForceReCapRegion) Then
				$x = Random($point[0],$point[2],1)
				$y = Random($point[1],$point[3],1)
				Return 1
			Else
				If $g_bDebugClick And $EnableHMLSetLog = 1 Then SetLog($point[8] & " @ Pixel Color Not Match then skip click =-= x,y,color1,color2: " & $point[4] & "," & $point[5] & "," & Hex($point[6],6) & "," & _GetPixelColor($point[4], $point[5], True), $COLOR_RED)
				Return 2
			EndIf
		Case 2
			; Do Check color if the pixel color define at button variable = false then we click
			If Not _CheckColorPixel($point[4], $point[5], $point[6], $point[7], $bForceReCapRegion) Then
				$x = Random($point[0],$point[2],1)
				$y = Random($point[1],$point[3],1)
				Return 1
			Else
				If $g_bDebugClick And $EnableHMLSetLog = 1 Then SetLog($point[8] & " @ Pixel Color Match then skip click =-= x,y,color1,color2: " & $point[4] & "," & $point[5] & "," & Hex($point[6],6) & "," & _GetPixelColor($point[4], $point[5], True), $COLOR_RED)
				Return 2
			EndIf
		Case Else
			; No check pixel color, just randomize the click
			$x = Random($point[0],$point[2],1)
			$y = Random($point[1],$point[3],1)
			Return 1
	EndSwitch
EndFunc ;===>HMLClickPR

Func HMLPureClick($x, $y, $times = 1, $speed = 0, $debugtxt = "") ; original Code from PureClick
	If $EnableHMLSetLog = 1 Then
		;Local $txt = _DecodeDebug($debugtxt)
		SetLog("HMLPureClick X:" & $x & " Y:" & $y & " T:" & $times & " S:" & $speed & " DMsg:" & $debugtxt, $COLOR_HMLClick_LOG, "Verdana", "7.5", 0)
	EndIf
	If TestCapture() Then Return

    If $g_bAndroidAdbClick = True Then
	   AndroidClick($x, $y, $times, $speed, False)
	EndIf
	If $g_bAndroidAdbClick = True Then
	   Return
    EndIf

    Local $SuspendMode = ResumeAndroid()
	If $times <> 1 Then
		For $i = 0 To ($times - 1)
			MoveMouseOutBS()
			_ControlClick($x, $y)
			If _Sleep($speed, False) Then ExitLoop
		Next
	Else
		MoveMouseOutBS()
		_ControlClick($x, $y)
	EndIf
    SuspendAndroid($SuspendMode)
EndFunc

Func HMLClick($x, $y, $times = 1, $speed = 0, $debugtxt = "") ; original Code from Click
	If $EnableHMLSetLog = 1 Then
		;Local $txt = _DecodeDebug($debugtxt)
		SetLog("HMLClick X:" & $x & " Y:" & $y & " T:" & $times & " S:" & $speed & " DMsg:" & $debugtxt, $COLOR_HMLClick_LOG, "Verdana", "7.5", 0)
	EndIf

	If TestCapture() Then Return

    If $g_bAndroidAdbClick = True Then
		AndroidClick($x, $y, $times, $speed)
	EndIf
	If $g_bAndroidAdbClick = True Then
	   Return
    EndIf

    Local $SuspendMode = ResumeAndroid()
	If $times <> 1 Then
		For $i = 0 To ($times - 1)
			If isProblemAffectBeforeClick($i) Then
				If $g_bDebugClick Then Setlog("VOIDED Click " & $x & "," & $y & "," & $times & "," & $speed & " " & $debugtxt, $COLOR_ERROR, "Verdana", "7.5", 0)
				checkMainScreen(False)
				SuspendAndroid($SuspendMode)
				Return  ; if need to clear screen do not click
			EndIf
			MoveMouseOutBS()
			_ControlClick($x, $y)
			If _Sleep($speed, False) Then ExitLoop
		Next
	Else
		If isProblemAffectBeforeClick() Then
			If $g_bDebugClick Then Setlog("VOIDED Click " & $x & "," & $y & "," & $times & "," & $speed & " " & $debugtxt, $COLOR_ERROR, "Verdana", "7.5", 0)
			checkMainScreen(False)
			SuspendAndroid($SuspendMode)
			Return  ; if need to clear screen do not click
		EndIf
		MoveMouseOutBS()
		_ControlClick($x, $y)
	EndIf
    SuspendAndroid($SuspendMode)
EndFunc
