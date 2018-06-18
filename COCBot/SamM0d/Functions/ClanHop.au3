; #FUNCTION# ====================================================================================================================
; Name ..........: ClanHop
; Description ...:
; Syntax ........: ClanHop()
; Parameters ....:
; Return values .:
; Author ........: BOLUDOZ(2018)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Global $g_ahChkClanHophours[24] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_hChkClanHophoursE1 = 0, $g_hChkClanHophoursE2 = 0
Global $g_hLblClanHophoursAM = 0, $g_hLblClanHophoursPM = 0
Global $g_ahLblClanHophoursE = 0
GLobal $g_hLblClanHophours[12] = [0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_abClanHophours[24] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]                                            
; #FUNCTION# ============================================================================================================================
; Name ..........: ClanHop
; Version........:
; Description ...: This function joins/quit random clans and fills requests indefinitly
; Syntax ........: clanHop()
; Parameters ....: None
; Return values .: None
; Author ........: zengzeng, MantasM (complete overhaul)
; Modified ......: Rhinoceros, Team AiO MOD++ (2018)
; Remarks .......: This file is a part of MyBotRun. Copyright 2018
; ................ MyBotRun is distributed under the terms of the GNU GPL
; Related .......: No
; =======================================================================================================================================

Func ClanHop()

	If Not $g_bChkClanHop Then Return

	SetLog("Start Clan Hopping", $COLOR_INFO)
	Local $sTimeStartedHopping = _NowCalc()

	Local $iPosJoinedClans = 0, $iScrolls = 0, $iHopLoops = 0, $iErrors = 0

	Local $aJoinClanBtn[4] = [157, 510, 0x6CBB1F, 20] ; Green Join Button on Chat Tab when you are not in a Clan
	Local $aClanPage[4] = [768, 398, 0xCE0D0E, 20] ; Red Leave Clan Button on Clan Page
	Local $aClanPageJoin[4] = [768, 398, 0x74BD2F, 20] ; Green Join Clan Button on Clan Page
	Local $aJoinClanPage[4] = [720, 310, 0xEBCC80, 20] ; Trophy Amount of Clan Background of first Clan
	Local $aClanChat[4] = [105, 650, 0x86C808, 40] ; *Your Name* joined the Clan Message Check to verify loaded Clan Chat
	Local $aChatTab[4] = [189, 24, 0x706C50, 20] ; Clan Chat Tab on Top, check if right one is selected
	Local $aGlobalTab[4] = [189, 24, 0x383828, 20] ; Global Chat Tab on Top, check if right one is selected
	Local $aClanBadgeNoClan[4] = [151, 307, 0xF05838, 20]; Orange Tile of Clan Logo on Chat Tab if you are not in a Clan

	Local $aClanNameBtn[2] = [89, 63] ; Button to open Clan Page from Chat Tab

	$g_iCommandStop = 0 ; Halt Attacking

	If Not IsMainPage() Then
		SetLog("Couldn't locate Mainscreen!", $COLOR_ERROR)
		Return
	EndIf

	While 1

		ClickP($aAway, 1, 0) ; Click away any open Windows
		If _Sleep($DELAYRESPOND) Then Return

		If $iErrors >= 10 Then
			Local $y = 0
			SetLog("Too Many Errors occured in current ClanHop Loop. Leaving ClanHopping!", $COLOR_ERROR)
			While 1
				If _Sleep(50) Then Return
				If _ColorCheck(_GetPixelColor($aCloseChat[0], $aCloseChat[1], True), Hex($aCloseChat[2], 6), $aCloseChat[3]) Then
					; Clicks chat Button
					Click($aCloseChat[0], $aCloseChat[1], 1, 0, "#0173") ;Clicks chat close button
					ExitLoop
				Else
					If _Sleep(100) Then Return
					$y += 1
					If $y > 30 Then
						SetLog("Error finding Clan Tab to close.", $COLOR_ERROR)
						AndroidPageError("ClanHop")
						ExitLoop
					EndIf
				EndIf
			WEnd
			Return
		EndIf

		If $iScrolls >= 8 Then
			CloseCoc(True) ; Restarting to get some new Clans
			$iScrolls = 0
			$iPosJoinedClans = 0
		EndIf

		ForceCaptureRegion()
		If Not _CheckPixel($aChatTab, $g_bCapturePixel) Then ClickP($aOpenChat, 1, 0) ; Clicks chat tab
		If _Sleep($DELAYDONATECC4) Then Return

		Local $iCount = 0
		While 1
			;If Clan tab is selected.
			If _CheckPixel($aChatTab, $g_bCapturePixel) Then ; color med gray
				ExitLoop
			EndIf
			;If Global tab is selected.
			If _CheckPixel($aGlobalTab, $g_bCapturePixel) Then ; Darker gray
				If _Sleep($DELAYDONATECC1) Then Return ;small delay to allow tab to completely open
				ClickP($aClanTab, 1, 0, "#0169") ; clicking clan tab
				If _Sleep(500) Then Return ; Delay to wait till Clan Page is fully up and visible so the next Color Check won't fail ;)
				ExitLoop
			EndIf
			;counter for time approx 3 sec max allowed for tab to open
			$iCount += 1
			If $iCount >= 15 Then ; allows for up to a sleep of 3000
				SetLog("Clan Chat Did Not Open - Abandon ClanHop")
				AndroidPageError("ClanHop")
				Return
			EndIf
		WEnd

		If Not _CheckPixel($aClanBadgeNoClan, $g_bCapturePixel) Then ; If Still in Clan
			SetLog("Still in a Clan! Leaving the Clan now")
			ClickP($aClanNameBtn)
			If _WaitForCheckPixel($aClanPage, $g_bCapturePixel, Default, "Wait for Clan Page:") Then
				ClickP($aClanPage)
				If Not ClickOkay("ClanHop") Then
					SetLog("Okay Button not found! Starting over again", $COLOR_ERROR)
					$iErrors += 1
					ContinueLoop
				Else
					SetLog("Successfully left Clan", $COLOR_SUCCESS)
					If _Sleep(400) Then Return
				EndIf
			Else
				SetLog("Clan Page did not open! Starting over again", $COLOR_ERROR)
				$iErrors += 1
				ContinueLoop
			EndIf
		EndIf

		If _CheckPixel($aJoinClanBtn, $g_bCapturePixel) Then ; Click on Green Join Button on Donate Window
			SetLog("Opening Join Clan Page", $COLOR_INFO)
			ClickP($aJoinClanBtn)
		Else
			SetLog("Join Clan Button not visible! Starting over again", $COLOR_ERROR)
			$iErrors += 1
			ContinueLoop
		EndIf

		If Not _WaitForCheckPixel($aJoinClanPage, $g_bCapturePixel, Default, "Wait For Join Clan Page:") Then ; Wait For The golden Trophy Background of the First Clan in list
			SetLog("Joinable Clans did not show.. Starting over again", $COLOR_ERROR)
			$iErrors += 1
			ContinueLoop
		EndIf

		;Go through all Clans of the list 1 by 1
		If $iPosJoinedClans >= 7 Then
			ClickDrag(333, 668, 333, 286, 300)
			$iScrolls += 1
			$iPosJoinedClans = 0
		EndIf

		Click(161, 286 + ($iPosJoinedClans * 55)) ; Open specific Clans Page
		$iPosJoinedClans += 1
		If _Sleep(300) Then Return
		If Not _WaitForCheckPixel($aClanPageJoin, $g_bCapturePixel, Default, "Wait For Clan Page:") Then ; Check if Clan Page itself opened up
			SetLog("Clan Page did not open. Starting over again", $COLOR_ERROR)
			$iErrors += 1
			ContinueLoop
		EndIf

		ClickP($aClanPageJoin) ; Join Clan

		If Not _WaitForCheckPixel($aClanChat, $g_bCapturePixel, Default, "Wait For Clan Chat:") Then ; Check for your "joined the Clan" Message to verify that Chat loaded successfully
			SetLog("Could not verify loaded Clan Chat. Starting over again", $COLOR_ERROR)
			$iErrors += 1
			ContinueLoop
		EndIf

		DonateCC(False) ; Start Donate Sequence

		If _Sleep(300) Then Return ; Little Sleep if requests got filled and chat moves

		DonateCC(False)

		ForceCaptureRegion()
		If Not _CheckPixel($aChatTab, $g_bCapturePixel) Then ClickP($aOpenChat, 1, 0, "#0168") ; Clicks chat tab
		If _Sleep($DELAYDONATECC4) Then Return

		ClickP($aClanNameBtn) ;  Click the Clan Banner in Top left corner of donate window

		If _WaitForCheckPixel($aClanPage, $g_bCapturePixel, Default, "Wait for Clan Page:") Then ; Leave the Clan
			ClickP($aClanPage)
			If Not ClickOkay("ClanHop") Then
				SetLog("Okay Button not found! Starting over again", $COLOR_ERROR)
				$iErrors += 1
				ContinueLoop
			Else
				SetLog("Successfully left Clan", $COLOR_SUCCESS)
				If _Sleep(400) Then Return
			EndIf
		Else
			SetLog("Clan Page did not open! Starting over again", $COLOR_ERROR)
			$iErrors += 1
			ContinueLoop
		EndIf

		If $iHopLoops >= 5 Then
			; Update Troops and Spells Capacity
			Local $i = 0
			While 1
				If _Sleep(100) Then Return
				If _CheckPixel($aCloseChat, $g_bCapturePixel) Then
					; Clicks chat Button
					Click($aCloseChat[0], $aCloseChat[1], 1, 0, "#0173") ;Clicks chat close button
					ExitLoop
				Else
					If _Sleep(100) Then Return
					$i += 1
					If $i > 30 Then
						SetLog("Error finding Clan Tab to close.", $COLOR_ERROR)
						AndroidPageError("ClanHop")
						ExitLoop
					EndIf
				EndIf
			WEnd
			TrainRevamp()
			$iHopLoops = 0

		EndIf

		If _DateDiff("h", $sTimeStartedHopping, _NowCalc) > 1 Then ExitLoop
		$iHopLoops += 1
	WEnd

EndFunc   ;==>ClanHop                                                                                                                                                                  

Func SetupClanHopGUI($x, $y)
	Local $xStart = $x
	Local $yStart = $y

		Local $grpClanHopAF = GUICtrlCreateGroup(GetTranslatedFileIni("AF_Mod", 15, "Clan Hop"), $x, $y, 430, 250)
		$y += 20

		$g_bChkClanHop = GUICtrlCreateCheckbox(GetTranslatedFileIni("AF_Mod", 15, "Clan Hop"), $x + 120, $y+45, -1, -1)
		Local $sTxtTip = GetTranslatedFileIni("AF_Mod", 15, "Clan Hop")
		_GUICtrlSetTip(-1, $sTxtTip)
		$x = $xStart + 10
		$y = $yStart + 100
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", "Only during these hours of each day"), $x, $y, 300, 20, $BS_MULTILINE)
		$y += 20
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Hour",  "Hour") & ":", $x , $y, -1, 15)
		Local $sTxtTip = GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", -1)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblClanHophours[0] =  GUICtrlCreateLabel(" 0", $x + 30, $y, 13, 15)
		$g_hLblClanHophours[1] = GUICtrlCreateLabel(" 1", $x + 45, $y, 13, 15)
		$g_hLblClanHophours[2] = GUICtrlCreateLabel(" 2", $x + 60, $y, 13, 15)
		$g_hLblClanHophours[3] = GUICtrlCreateLabel(" 3", $x + 75, $y, 13, 15)
		$g_hLblClanHophours[4] = GUICtrlCreateLabel(" 4", $x + 90, $y, 13, 15)
		$g_hLblClanHophours[5] = GUICtrlCreateLabel(" 5", $x + 105, $y, 13, 15)
		$g_hLblClanHophours[6] = GUICtrlCreateLabel(" 6", $x + 120, $y, 13, 15)
		$g_hLblClanHophours[7] = GUICtrlCreateLabel(" 7", $x + 135, $y, 13, 15)
		$g_hLblClanHophours[8] = GUICtrlCreateLabel(" 8", $x + 150, $y, 13, 15)
		$g_hLblClanHophours[9] = GUICtrlCreateLabel(" 9", $x + 165, $y, 13, 15)
		$g_hLblClanHophours[10] = GUICtrlCreateLabel("10", $x + 180, $y, 13, 15)
		$g_hLblClanHophours[11] = GUICtrlCreateLabel("11", $x + 195, $y, 13, 15)
		$g_ahLblClanHophoursE = GUICtrlCreateLabel("X", $x + 213, $y+2, 11, 11)

		$y += 15
		$g_ahChkClanHophours[0] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[1] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[2] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[3] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[4] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[5] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[6] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[7] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[8] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[9] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[10] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[11] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_hChkClanHophoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
		   GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
		   _GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", "This button will clear or set the entire row of boxes"))
		   GUICtrlSetOnEvent(-1, "chkClanHophoursE1")
		$g_hLblClanHophoursAM = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "AM", "AM"), $x + 5, $y)

		$y += 15
		$g_ahChkClanHophours[12] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[13] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[14] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[15] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[16] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[17] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[18] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[19] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[20] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[21] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[22] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_ahChkClanHophours[23] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanHophours")
		$g_hChkClanHophoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
		   GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
		   _GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
		   GUICtrlSetOnEvent(-1, "chkClanHophoursE2")
		$g_hLblClanHophoursPM = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "PM", "PM"), $x + 5, $y)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc

Func ChkClanHophours()
	For $i = 0 to 23
		$g_abClanHophours[$i] = (GUICtrlRead($g_ahChkClanHophours[$i]) = $GUI_CHECKED ? 1: 0)
	Next
EndFunc

Func chkClanHophoursE1()
	If GUICtrlRead($g_hChkClanHophoursE1) = $GUI_CHECKED And GUICtrlRead($g_ahChkClanHophours[0]) = $GUI_CHECKED Then
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkClanHophours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkClanHophours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_hChkClanHophoursE1, $GUI_UNCHECKED)
	ChkClanHophours()
EndFunc   ;==>chkClanHophoursE1

Func chkClanHophoursE2()
	If GUICtrlRead($g_hChkClanHophoursE2) = $GUI_CHECKED And GUICtrlRead($g_ahChkClanHophours[12]) = $GUI_CHECKED Then
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkClanHophours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkClanHophours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_hChkClanHophoursE2, $GUI_UNCHECKED)
	ChkClanHophours()
EndFunc   ;==>chkClanHophoursE2

Func saveClanHopSetting()
	Local $string = ""
	For $i = 0 To 23
		$string &= (GUICtrlRead($g_ahChkClanHophours[$i]) = $GUI_CHECKED ? 1: 0) & "|"
	Next
	_Ini_Add("ClanHop", "ClanHopPlannedRequestHours", $string)
	$string = ""
	_Ini_Add("donate", "chkClanHop", $g_bChkClanHop ? 1 : 0)	; Clan HOP
EndFunc

Func readClanHopSetting()
	$g_abClanHophours = StringSplit(IniRead($g_sProfileConfigPath, "ClanHop", "ClanHopPlannedRequestHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
 	$g_bChkClanHop = (IniRead($g_sProfileConfigPath, "donate", "chkClanHop", "0") = "1")	; Clan HOP

	EndFunc

Func applyClanHopSetting()
	For $i = 0 To 23
		GUICtrlSetState($g_ahChkClanHophours[$i], ($g_abClanHophours[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
		
	GUICtrlSetState($g_hChkClanHop, $g_bChkClanHop ? $GUI_CHECKED : $GUI_UNCHECKED)	; Clan HOP
	$g_bChkClanHop = (GUICtrlRead($g_hChkClanHop) = $GUI_CHECKED)	; Clan HOP

Next
EndFunc

