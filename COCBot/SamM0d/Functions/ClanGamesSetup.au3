; #FUNCTION# ====================================================================================================================
; Name ..........: ClanGamesSetup
; Description ...:
; Syntax ........: ClanGamesSetup()
; Parameters ....:
; Return values .:
; Author ........: BOLUDOZ(2018)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Global $g_ahChkClanGamesSetuphours[24] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_hChkClanGamesSetuphoursE1 = 0, $g_hChkClanGamesSetuphoursE2 = 0
Global $g_hLblClanGamesSetuphoursAM = 0, $g_hLblClanGamesSetuphoursPM = 0
Global $g_ahLblClanGamesSetuphoursE = 0
GLobal $g_hLblClanGamesSetuphours[12] = [0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_abClanGamesSetuphours[24] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

Global $iTimeForLastShareClanGamesSetup = 0

Func SetupClanGamesSetupGUI($x, $y)
	Local $xStart = $x
	Local $yStart = $y
		Local $grpClanHopAF = GUICtrlCreateGroup(GetTranslatedFileIni("AF_Mod", 16, "Clan Games"), $x, $y, 430, 250)
		$y += 30
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", "Only during these hours of each day"), $x, $y, 300, 20, $BS_MULTILINE)
		$y += 20
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Hour",  "Hour") & ":", $x , $y, -1, 15)
		Local $sTxtTip = GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", -1)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblClanGamesSetuphours[0] =  GUICtrlCreateLabel(" 0", $x + 30, $y, 13, 15)
		$g_hLblClanGamesSetuphours[1] = GUICtrlCreateLabel(" 1", $x + 45, $y, 13, 15)
		$g_hLblClanGamesSetuphours[2] = GUICtrlCreateLabel(" 2", $x + 60, $y, 13, 15)
		$g_hLblClanGamesSetuphours[3] = GUICtrlCreateLabel(" 3", $x + 75, $y, 13, 15)
		$g_hLblClanGamesSetuphours[4] = GUICtrlCreateLabel(" 4", $x + 90, $y, 13, 15)
		$g_hLblClanGamesSetuphours[5] = GUICtrlCreateLabel(" 5", $x + 105, $y, 13, 15)
		$g_hLblClanGamesSetuphours[6] = GUICtrlCreateLabel(" 6", $x + 120, $y, 13, 15)
		$g_hLblClanGamesSetuphours[7] = GUICtrlCreateLabel(" 7", $x + 135, $y, 13, 15)
		$g_hLblClanGamesSetuphours[8] = GUICtrlCreateLabel(" 8", $x + 150, $y, 13, 15)
		$g_hLblClanGamesSetuphours[9] = GUICtrlCreateLabel(" 9", $x + 165, $y, 13, 15)
		$g_hLblClanGamesSetuphours[10] = GUICtrlCreateLabel("10", $x + 180, $y, 13, 15)
		$g_hLblClanGamesSetuphours[11] = GUICtrlCreateLabel("11", $x + 195, $y, 13, 15)
		$g_ahLblClanGamesSetuphoursE = GUICtrlCreateLabel("X", $x + 213, $y+2, 11, 11)

		$y += 15
		$g_ahChkClanGamesSetuphours[0] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_ahChkClanGamesSetuphours[1] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_ahChkClanGamesSetuphours[2] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_ahChkClanGamesSetuphours[3] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_ahChkClanGamesSetuphours[4] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_ahChkClanGamesSetuphours[5] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_ahChkClanGamesSetuphours[6] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_ahChkClanGamesSetuphours[7] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_ahChkClanGamesSetuphours[8] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_ahChkClanGamesSetuphours[9] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_ahChkClanGamesSetuphours[10] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_ahChkClanGamesSetuphours[11] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_hChkClanGamesSetuphoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
		   GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
		   _GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", "This button will clear or set the entire row of boxes"))
		   GUICtrlSetOnEvent(-1, "chkClanGamesSetuphoursE1")
		$g_hLblClanGamesSetuphoursAM = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "AM", "AM"), $x + 5, $y)

		$y += 15
		$g_ahChkClanGamesSetuphours[12] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_ahChkClanGamesSetuphours[13] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_ahChkClanGamesSetuphours[14] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_ahChkClanGamesSetuphours[15] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_ahChkClanGamesSetuphours[16] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_ahChkClanGamesSetuphours[17] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_ahChkClanGamesSetuphours[18] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_ahChkClanGamesSetuphours[19] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_ahChkClanGamesSetuphours[20] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_ahChkClanGamesSetuphours[21] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_ahChkClanGamesSetuphours[22] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_ahChkClanGamesSetuphours[23] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkClanGamesSetuphours")
		$g_hChkClanGamesSetuphoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
		   GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
		   _GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
		   GUICtrlSetOnEvent(-1, "chkClanGamesSetuphoursE2")
		$g_hLblClanGamesSetuphoursPM = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "PM", "PM"), $x + 5, $y)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc

Func ChkClanGamesSetuphours()
	For $i = 0 to 23
		$g_abClanGamesSetuphours[$i] = (GUICtrlRead($g_ahChkClanGamesSetuphours[$i]) = $GUI_CHECKED ? 1: 0)
	Next
EndFunc

Func chkClanGamesSetuphoursE1()
	If GUICtrlRead($g_hChkClanGamesSetuphoursE1) = $GUI_CHECKED And GUICtrlRead($g_ahChkClanGamesSetuphours[0]) = $GUI_CHECKED Then
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkClanGamesSetuphours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkClanGamesSetuphours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_hChkClanGamesSetuphoursE1, $GUI_UNCHECKED)
	ChkClanGamesSetuphours()
EndFunc   ;==>chkClanGamesSetuphoursE1

Func chkClanGamesSetuphoursE2()
	If GUICtrlRead($g_hChkClanGamesSetuphoursE2) = $GUI_CHECKED And GUICtrlRead($g_ahChkClanGamesSetuphours[12]) = $GUI_CHECKED Then
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkClanGamesSetuphours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkClanGamesSetuphours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_hChkClanGamesSetuphoursE2, $GUI_UNCHECKED)
	ChkClanGamesSetuphours()
EndFunc   ;==>chkClanGamesSetuphoursE2

Func saveClanGamesSetupSetting()
	Local $string = ""
	For $i = 0 To 23
		$string &= (GUICtrlRead($g_ahChkClanGamesSetuphours[$i]) = $GUI_CHECKED ? 1: 0) & "|"
	Next
	_Ini_Add("ClanGamesSetup", "ClanGamesSetupPlannedRequestHours", $string)
	$string = ""
EndFunc

Func readClanGamesSetupSetting()
	$g_abClanGamesSetuphours = StringSplit(IniRead($g_sProfileConfigPath, "ClanGamesSetup", "ClanGamesSetupPlannedRequestHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
EndFunc

Func applyClanGamesSetupSetting()
	For $i = 0 To 23
		GUICtrlSetState($g_ahChkClanGamesSetuphours[$i], ($g_abClanGamesSetuphours[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
Next
EndFunc

