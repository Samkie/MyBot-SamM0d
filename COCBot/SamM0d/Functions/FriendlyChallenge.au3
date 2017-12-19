; #FUNCTION# ====================================================================================================================
; Name ..........: FriendlyChallenge
; Description ...:
; Syntax ........: FriendlyChallenge()
; Parameters ....:
; Return values .:
; Author ........: Samkie (11 July, 2017)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Global $chkEnableFriendlyChallenge, $ichkEnableFriendlyChallenge, $chkOnlyOnRequest, $ichkOnlyOnRequest, $txtKeywordForRequest, $stxtKeywordForRequest, $txtFriendlyChallengeCoolDownTime, $itxtFriendlyChallengeCoolDownTime, $txtChallengeText, $stxtChallengeText
Global $g_ahChkFriendlyChallengehours[24] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_hChkFriendlyChallengehoursE1 = 0, $g_hChkFriendlyChallengehoursE2 = 0
Global $g_hGrpRequestCC = 0, $g_hLblFriendlyChallengehoursAM = 0, $g_hLblFriendlyChallengehoursPM = 0
Global $g_ahLblFriendlyChallengehoursE = 0
GLobal $g_hLblFriendlyChallengehours[12] = [0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_abFriendlyChallengehours[24] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

Global $chkFriendlyChallengeBase[6], $ichkFriendlyChallengeBase[6]
Global $iTimeForLastShareFriendlyChallenge = 0

Func SetupFriendlyChallengeGUI($x, $y)
	Local $xStart = $x
	Local $yStart = $y
	GUICtrlCreateGroup(GetTranslatedFileIni("sam m0d","Friendly Challenge", "Friend Challenge"), $x , $y, 430, 400)
	$x += 10
	$y += 20
	$chkEnableFriendlyChallenge = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "Enable Friendly Challenge", "Enable Friendly Challenge"), $x , $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkEnableFriendlyChallenge")
	$y += 30

	GUICtrlCreateLabel(GetTranslatedFileIni("sam m0d", "Please select which base to share", "Please select which base to share for Friendly Challenge"), $x, $y,205,40)
	$y += 30
	$chkFriendlyChallengeBase[0] = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "Base 1", "Village Base 1"), $x , $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkFriendlyChallengeBase")
	$y += 20
	$chkFriendlyChallengeBase[1] = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "Base 2", "Village Base 2"), $x , $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkFriendlyChallengeBase")
	$y += 20
	$chkFriendlyChallengeBase[2] = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "Base 3", "Village Base 3"), $x , $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkFriendlyChallengeBase")
	$x += 100
	$y -= 40
	$chkFriendlyChallengeBase[3] = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "Base 4", "War Base 1"), $x , $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkFriendlyChallengeBase")
	$y += 20
	$chkFriendlyChallengeBase[4] = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "Base 5", "War Base 2"), $x , $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkFriendlyChallengeBase")
	$y += 20
	$chkFriendlyChallengeBase[5] = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "Base 6", "War Base 3"), $x , $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkFriendlyChallengeBase")

	$x = $xStart + 220
	$y = $yStart + 40

	$chkOnlyOnRequest = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "Only share up on chat request", "Only share up on chat request, Please enter keyword to below:"), $x , $y, 205, 40, $BS_MULTILINE)
	GUICtrlSetOnEvent(-1, "chkOnlyOnRequest")
	$y += 40
	$txtKeywordForRequest = GUICtrlCreateEdit("", $x, $y, 205, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
	GUICtrlSetOnEvent(-1, "txtKeywordForRequest")

	$x = $xStart + 10
	$y = $yStart + 160

	GUICtrlCreateLabel(GetTranslatedFileIni("sam m0d", "Challenge text", "Challenge text (If more that a line will random select)"), $x, $y)
	$y += 20
	$txtChallengeText = GUICtrlCreateEdit("", $x, $y, 300, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
	GUICtrlSetOnEvent(-1, "txtChallengeText")


	$y += 80
	GUICtrlCreateLabel(GetTranslatedFileIni("sam m0d", "Cool down share", "After each share, cool down how many minutes to share again? :"), $x, $y)
	$x += 220
	$y -= 2
	$txtFriendlyChallengeCoolDownTime = GUICtrlCreateInput("5", $x + 94, $y, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetOnEvent(-1, "txtFriendlyChallengeCoolDownTime")
	$x -= 220

		$y += 30
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", "Only during these hours of each day"), $x, $y, 300, 20, $BS_MULTILINE)
		$y += 20
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Hour",  "Hour") & ":", $x , $y, -1, 15)
		Local $sTxtTip = GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", -1)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblFriendlyChallengehours[0] =  GUICtrlCreateLabel(" 0", $x + 30, $y, 13, 15)
		$g_hLblFriendlyChallengehours[1] = GUICtrlCreateLabel(" 1", $x + 45, $y, 13, 15)
		$g_hLblFriendlyChallengehours[2] = GUICtrlCreateLabel(" 2", $x + 60, $y, 13, 15)
		$g_hLblFriendlyChallengehours[3] = GUICtrlCreateLabel(" 3", $x + 75, $y, 13, 15)
		$g_hLblFriendlyChallengehours[4] = GUICtrlCreateLabel(" 4", $x + 90, $y, 13, 15)
		$g_hLblFriendlyChallengehours[5] = GUICtrlCreateLabel(" 5", $x + 105, $y, 13, 15)
		$g_hLblFriendlyChallengehours[6] = GUICtrlCreateLabel(" 6", $x + 120, $y, 13, 15)
		$g_hLblFriendlyChallengehours[7] = GUICtrlCreateLabel(" 7", $x + 135, $y, 13, 15)
		$g_hLblFriendlyChallengehours[8] = GUICtrlCreateLabel(" 8", $x + 150, $y, 13, 15)
		$g_hLblFriendlyChallengehours[9] = GUICtrlCreateLabel(" 9", $x + 165, $y, 13, 15)
		$g_hLblFriendlyChallengehours[10] = GUICtrlCreateLabel("10", $x + 180, $y, 13, 15)
		$g_hLblFriendlyChallengehours[11] = GUICtrlCreateLabel("11", $x + 195, $y, 13, 15)
		$g_ahLblFriendlyChallengehoursE = GUICtrlCreateLabel("X", $x + 213, $y+2, 11, 11)

		$y += 15
		$g_ahChkFriendlyChallengehours[0] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_ahChkFriendlyChallengehours[1] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_ahChkFriendlyChallengehours[2] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_ahChkFriendlyChallengehours[3] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_ahChkFriendlyChallengehours[4] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_ahChkFriendlyChallengehours[5] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_ahChkFriendlyChallengehours[6] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_ahChkFriendlyChallengehours[7] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_ahChkFriendlyChallengehours[8] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_ahChkFriendlyChallengehours[9] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_ahChkFriendlyChallengehours[10] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_ahChkFriendlyChallengehours[11] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_hChkFriendlyChallengehoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
		   GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
		   _GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", "This button will clear or set the entire row of boxes"))
		   GUICtrlSetOnEvent(-1, "chkFriendlyChallengehoursE1")
		$g_hLblFriendlyChallengehoursAM = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "AM", "AM"), $x + 5, $y)

		$y += 15
		$g_ahChkFriendlyChallengehours[12] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_ahChkFriendlyChallengehours[13] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_ahChkFriendlyChallengehours[14] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_ahChkFriendlyChallengehours[15] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_ahChkFriendlyChallengehours[16] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_ahChkFriendlyChallengehours[17] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_ahChkFriendlyChallengehours[18] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_ahChkFriendlyChallengehours[19] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_ahChkFriendlyChallengehours[20] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_ahChkFriendlyChallengehours[21] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_ahChkFriendlyChallengehours[22] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_ahChkFriendlyChallengehours[23] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
		GUICtrlSetOnEvent(-1, "ChkFriendlyChallengehours")
		$g_hChkFriendlyChallengehoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
		   GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
		   _GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
		   GUICtrlSetOnEvent(-1, "chkFriendlyChallengehoursE2")
		$g_hLblFriendlyChallengehoursPM = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "PM", "PM"), $x + 5, $y)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc

Func ChkFriendlyChallengehours()
	For $i = 0 to 23
		$g_abFriendlyChallengehours[$i] = (GUICtrlRead($g_ahChkFriendlyChallengehours[$i]) = $GUI_CHECKED ? 1: 0)
	Next
EndFunc

Func chkFriendlyChallengehoursE1()
	If GUICtrlRead($g_hChkFriendlyChallengehoursE1) = $GUI_CHECKED And GUICtrlRead($g_ahChkFriendlyChallengehours[0]) = $GUI_CHECKED Then
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkFriendlyChallengehours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkFriendlyChallengehours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_hChkFriendlyChallengehoursE1, $GUI_UNCHECKED)
	ChkFriendlyChallengehours()
EndFunc   ;==>chkFriendlyChallengehoursE1

Func chkFriendlyChallengehoursE2()
	If GUICtrlRead($g_hChkFriendlyChallengehoursE2) = $GUI_CHECKED And GUICtrlRead($g_ahChkFriendlyChallengehours[12]) = $GUI_CHECKED Then
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkFriendlyChallengehours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkFriendlyChallengehours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_hChkFriendlyChallengehoursE2, $GUI_UNCHECKED)
	ChkFriendlyChallengehours()
EndFunc   ;==>chkFriendlyChallengehoursE2

Func saveFriendlyChallengeSetting()
	Local $string = ""
	For $i = 0 To 23
		$string &= (GUICtrlRead($g_ahChkFriendlyChallengehours[$i]) = $GUI_CHECKED ? 1: 0) & "|"
	Next
	_Ini_Add("FriendlyChallenge", "FriendlyChallengePlannedRequestHours", $string)
	$string = ""
	For $i = 0 To 5
		$string &= (GUICtrlRead($chkFriendlyChallengeBase[$i]) = $GUI_CHECKED ? 1: 0) & "|"
	Next
	_Ini_Add("FriendlyChallenge", "FriendlyChallengeBaseForShare", $string)
	_Ini_Add("FriendlyChallenge", "FriendlyChallengeEnable", (GUICtrlRead($chkEnableFriendlyChallenge) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("FriendlyChallenge", "FriendlyChallengeEnableOnlyOnRequest", (GUICtrlRead($chkOnlyOnRequest) = $GUI_CHECKED ? 1 : 0))
	_Ini_Add("FriendlyChallenge", "FriendlyChallengeKeyword", StringReplace(GUICtrlRead($txtKeywordForRequest), @CRLF, "|"))
	_Ini_Add("FriendlyChallenge", "FriendlyChallengeText", StringReplace(GUICtrlRead($txtChallengeText), @CRLF, "|"))
	_Ini_Add("FriendlyChallenge", "FriendlyChallengeCoolDownTime", GUICtrlRead($txtFriendlyChallengeCoolDownTime))
EndFunc

Func readFriendlyChallengeSetting()
	$g_abFriendlyChallengehours = StringSplit(IniRead($g_sProfileConfigPath, "FriendlyChallenge", "FriendlyChallengePlannedRequestHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
	$ichkFriendlyChallengeBase = StringSplit(IniRead($g_sProfileConfigPath, "FriendlyChallenge", "FriendlyChallengeBaseForShare", "0|0|0|0|0|0"), "|", $STR_NOCOUNT)
	IniReadS($ichkEnableFriendlyChallenge, $g_sProfileConfigPath, "FriendlyChallenge", "FriendlyChallengeEnable", "0", "Int")
	IniReadS($ichkOnlyOnRequest, $g_sProfileConfigPath, "FriendlyChallenge", "FriendlyChallengeEnableOnlyOnRequest", "0", "Int")
	$stxtKeywordForRequest = StringReplace(IniRead($g_sProfileConfigPath, "FriendlyChallenge", "FriendlyChallengeKeyword", "friendly|challenge"), "|", @CRLF)
	$stxtChallengeText = StringReplace(IniRead($g_sProfileConfigPath, "FriendlyChallenge", "FriendlyChallengeText", ""), "|", @CRLF)
	IniReadS($itxtFriendlyChallengeCoolDownTime, $g_sProfileConfigPath, "FriendlyChallenge", "FriendlyChallengeCoolDownTime", "5", "Int")
EndFunc

Func applyFriendlyChallengeSetting()
	For $i = 0 To 23
		GUICtrlSetState($g_ahChkFriendlyChallengehours[$i], ($g_abFriendlyChallengehours[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
	Next
	For $i = 0 To 5
		GUICtrlSetState($chkFriendlyChallengeBase[$i], ($ichkFriendlyChallengeBase[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
	Next
	GUICtrlSetState($chkEnableFriendlyChallenge, $ichkEnableFriendlyChallenge = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
	GUICtrlSetState($chkOnlyOnRequest, $ichkOnlyOnRequest = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
	GUICtrlSetData($txtKeywordForRequest, $stxtKeywordForRequest)
	GUICtrlSetData($txtChallengeText, $stxtChallengeText)
	GUICtrlSetData($txtFriendlyChallengeCoolDownTime, $itxtFriendlyChallengeCoolDownTime)
EndFunc

Func chkEnableFriendlyChallenge()
	$ichkEnableFriendlyChallenge = (GUICtrlRead($chkEnableFriendlyChallenge) = $GUI_CHECKED ? 1: 0)
EndFunc

Func chkOnlyOnRequest()
	$ichkOnlyOnRequest = (GUICtrlRead($chkOnlyOnRequest) = $GUI_CHECKED ? 1: 0)
EndFunc

Func chkFriendlyChallengeBase()
	For $i = 0 to 5
		$ichkFriendlyChallengeBase[$i] = (GUICtrlRead($chkFriendlyChallengeBase[$i]) = $GUI_CHECKED ? 1: 0)
	Next
EndFunc

Func txtKeywordForRequest()
	$stxtKeywordForRequest = GUICtrlRead($txtKeywordForRequest)
EndFunc

Func txtChallengeText()
	Local $sInputText = StringReplace(GUICtrlRead($txtChallengeText), @CRLF, "|")
	Local $iCount = 0
	Local $bUpdateDateFlag = False
	While 1
		If StringRight($sInputText,1) = "|" Then
			$sInputText = StringLeft($sInputText, StringLen($sInputText) - 1)
			$bUpdateDateFlag = True
		Else
			If $bUpdateDateFlag Then GUICtrlSetData($txtChallengeText, StringReplace($sInputText, "|", @CRLF))
			ExitLoop
		EndIf
		$iCount += 1
		If $iCount > 10 Then ExitLoop
	WEnd
	$stxtChallengeText = StringReplace($sInputText, "|", @CRLF)
EndFunc

Func txtFriendlyChallengeCoolDownTime()
	$itxtFriendlyChallengeCoolDownTime = Int(GUICtrlRead($txtFriendlyChallengeCoolDownTime))
	$iTimeForLastShareFriendlyChallenge = 0
EndFunc

Func FriendlyChallenge()
	If $ichkEnableFriendlyChallenge = 0 Then Return

	Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
	If $g_abFriendlyChallengehours[$hour[0]] = 0 Then
		SetLog("Friendly Challenge not planned, Skipped..", $COLOR_INFO)
		Return ; exit func if no planned donate checkmarks
	EndIf

	Local $aBaseForShare[1]
	Local $iCount4Share = 0
	For $i = 0 to 5
		If $ichkFriendlyChallengeBase[$i] = 1 Then
			ReDim $aBaseForShare[$iCount4Share + 1]
			$aBaseForShare[$iCount4Share] = $i
			$iCount4Share += 1
		EndIf
	Next
	If $iCount4Share = 0 Then
		SetLog("No base to share for friend challenge, please check your setting.", $COLOR_ERROR)
		Return
	EndIf

	;SetLog("$iDateCalc: " & $iDateCalc)
	If $iTimeForLastShareFriendlyChallenge <> 0 Then
		Local $iDateCalc = _DateDiff('s', $iTimeForLastShareFriendlyChallenge, _NowCalc())
		If $iDateCalc < $itxtFriendlyChallengeCoolDownTime * 60 Then
			SetLog("Waiting for cool down, time left: " & ($itxtFriendlyChallengeCoolDownTime * 60) - $iDateCalc & " seconds.", $COLOR_INFO)
			Return
		EndIf
	EndIf

	ClickP($aAway, 1, 0, "#0167") ;Click Away
	Setlog("Checking Friendly Challenge at Clan Chat", $COLOR_INFO)

	ForceCaptureRegion()
	If _CheckColorPixel($aButtonClanWindowOpen[4], $aButtonClanWindowOpen[5], $aButtonClanWindowOpen[6], $aButtonClanWindowOpen[7], $g_bCapturePixel, "aButtonClanWindowOpen") Then
		Click($aButtonClanWindowOpen[0], $aButtonClanWindowOpen[1], 1, 0, "#0168")
		If _Wait4Pixel($aButtonClanWindowClose[4], $aButtonClanWindowClose[5], $aButtonClanWindowClose[6], $aButtonClanWindowClose[7], 1500) = False Then
			SetLog("Clan Chat Did Not Open - Abandon Friendly Challenge")
			AndroidPageError("FriendlyChallenge")
			Return False
		EndIf
	EndIf

	Local $iLoopCount = 0
	Local $iCount = 0
	While 1
		;If Clan tab is selected.
		ForceCaptureRegion()
		_CaptureRegion()
		If _ColorCheck(_GetPixelColor(189, 24, False), Hex(0x706C50, 6), 20) Then ; color med gray
			ExitLoop
		EndIf
		;If Global tab is selected.
		If _ColorCheck(_GetPixelColor(189, 24, False), Hex(0x383828, 6), 20) Then ; Darker gray
			ClickP($aClanTab, 1, 0, "#0169") ; clicking clan tab
		EndIf
		;counter for time approx 3 sec max allowed for tab to open
		$iLoopCount += 1
		If $iLoopCount >= 5 Then ; allows for up to a sleep of 3000
			SetLog("Cannot switch to Clan Chat Tab - Abandon Friendly Challenge")
			AndroidPageError("FriendlyChallenge")
			ClostChatTab()
			Return False
		EndIf
		If _Sleep($DELAYDONATECC1) Then Return ; delay Allow 15x
	WEnd

	Local $bDoFriendlyChallenge = True
	Local $iBaseForShare = $aBaseForShare[Random(0,UBound($aBaseForShare)-1,1)]

	If $ichkOnlyOnRequest = 1 Then
		$bDoFriendlyChallenge = False
		ForceCaptureRegion()
		_CaptureRegion2(260,85,272,624)
		Local $aLastResult[1][2]
		Local $sDirectory = $g_sSamM0dImageLocation & "\Chat\"
		Local $returnProps="objectpoints"
		Local $aCoor
		Local $aPropsValues
		Local $aCoorXY
		Local $result
		Local $sReturn = ""

		Local $iMax = 0
		Local $jMax = 0
		Local $i, $j, $k
		Local $ClanString

		Local $hHBitmapDivider = GetHHBitmapArea($g_hHBitmap2,0,0,10,539)

		Local $result = findMultiImage($hHBitmapDivider, $sDirectory ,"FV" ,"FV", 0, 0, 0 , $returnProps)
		If $hHBitmapDivider <> 0 Then GdiDeleteHBitmap($hHBitmapDivider)

		$iCount = 0
		If IsArray($result) then
			$iMax = UBound($result) -1
			For $i = 0 To $iMax
				$aPropsValues = $result[$i] ; should be return objectname,objectpoints,objectlevel
				If UBound($aPropsValues) = 1 then
					If $g_iSamM0dDebug = 1 Then SetLog("$aPropsValues[0]: " & $aPropsValues[0], $COLOR_DEBUG)
					$aCoor = StringSplit($aPropsValues[0],"|",$STR_NOCOUNT) ; objectpoints, split by "|" to get multi coor x,y ; same image maybe can detect at different location.
					If IsArray($aCoor) Then
						For $j =  0 to UBound($aCoor) - 1
							$aCoorXY = StringSplit($aCoor[$j],",",$STR_NOCOUNT)
							ReDim $aLastResult[$iCount + 1][2]
							$aLastResult[$iCount][0] = Int($aCoorXY[0])
							$aLastResult[$iCount][1] = Int($aCoorXY[1]) + 82
							$iCount += 1
						Next
					EndIf
				EndIf
			Next
			If $iCount >= 1 Then
				_ArraySort($aLastResult, 1, 0, 0, 1) ; rearrange order by coor Y
				$iMax = UBound($aLastResult) -1
				If $g_iSamM0dDebug = 1 Then SetLog("Total Chat Message: " & $iMax + 1, $COLOR_ERROR)
				_CaptureRegion2(0,0,287,732)
				For $i = 0 To $iMax
					If $g_bChkExtraAlphabets Then
						; Chat Request using "coc-latin-cyr" xml: Latin + Cyrillic derived alphabets / three paragraphs
						If $g_iSamM0dDebug = 1 Then Setlog("Using OCR to read Latin and Cyrillic derived alphabets..", $COLOR_ACTION)
						$ClanString = ""
						$ClanString = getOcrAndCapture("coc-latin-cyr", 30, $aLastResult[$i][1] + 17, 280, 17, Default, Default, False)
						If $ClanString = "" Then
							$ClanString = getOcrAndCapture("coc-latin-cyr", 30, $aLastResult[$i][1] + 31, 280, 17, Default, Default, False)
						Else
							$ClanString &= " " & getOcrAndCapture("coc-latin-cyr", 30, $aLastResult[$i][1] + 31, 280, 17, Default, Default, False)
						EndIf
						If $ClanString = "" Or $ClanString = " " Then
							$ClanString = getOcrAndCapture("coc-latin-cyr", 30, $aLastResult[$i][1] + 44, 280, 17, Default, Default, False)
						Else
							$ClanString &= " " & getOcrAndCapture("coc-latin-cyr", 30, $aLastResult[$i][1] + 44, 280, 17, Default, Default, False)
						EndIf
						If _Sleep($DELAYDONATECC2) Then ExitLoop
					Else ; default
						; Chat Request using "coc-latinA" xml: only Latin derived alphabets / three paragraphs
						If $g_iSamM0dDebug = 1 Then Setlog("Using OCR to read Latin derived alphabets..", $COLOR_ACTION)
						$ClanString = ""
						$ClanString = getOcrAndCapture("coc-latinA", 30, $aLastResult[$i][1] + 17, 280, 17, Default, Default, False)
						If $ClanString = "" Then
							$ClanString = getOcrAndCapture("coc-latinA", 30, $aLastResult[$i][1] + 31, 280, 17, Default, Default, False)
						Else
							$ClanString &= " " & getOcrAndCapture("coc-latinA", 30, $aLastResult[$i][1] + 31, 280, 17, Default, Default, False)
						EndIf
						If $ClanString = "" Or $ClanString = " " Then
							$ClanString = getOcrAndCapture("coc-latinA", 30, $aLastResult[$i][1] + 44, 280, 17, Default, Default, False)
						Else
							$ClanString &= " " & getOcrAndCapture("coc-latinA", 30, $aLastResult[$i][1] + 44, 280, 17, Default, Default, False)
						EndIf
						If _Sleep($DELAYDONATECC2) Then ExitLoop
					EndIf
					; Chat Request using IMGLOC: Chinese alphabet / one paragraph
					If $g_bChkExtraChinese Then
						If $g_iSamM0dDebug = 1 Then Setlog("Using OCR to read the Chinese alphabet..", $COLOR_ACTION)
						If $ClanString = "" Then
							$ClanString = getOcrAndCapture("chinese-bundle", 30, $aLastResult[$i][1] + 43, 160, 15, Default, True, False)
						Else
							$ClanString &= " " & getOcrAndCapture("chinese-bundle", 30, $aLastResult[$i][1] + 43, 160, 15, Default, True, False)
						EndIf
						If _Sleep($DELAYDONATECC2) Then ExitLoop
					EndIf
					; Chat Request using IMGLOC: Korean alphabet / one paragraph
					If $g_bChkExtraKorean Then
						If $g_iSamM0dDebug = 1 Then Setlog("Using OCR to read the Korean alphabet..", $COLOR_ACTION)
						If $ClanString = "" Then
							$ClanString = getOcrAndCapture("korean-bundle", 30, $aLastResult[$i][1] + 43, 160, 15, Default, True, False)
						Else
							$ClanString &= " " & getOcrAndCapture("korean-bundle", 30, $aLastResult[$i][1] + 43, 160, 15, Default, True, False)
						EndIf
						If _Sleep($DELAYDONATECC2) Then ExitLoop
					EndIf
					; Chat Request using IMGLOC: Persian alphabet / one paragraph
					If $g_bChkExtraPersian Then
						If $g_iSamM0dDebug = 1 Then Setlog("Using OCR to read the Persian alphabet..", $COLOR_ACTION)
						If $ClanString = "" Then
							$ClanString = getChatStringPersianMod(30, $aLastResult[$i][1] + 36)
						Else
							$ClanString &= " " & getChatStringPersianMod(30, $aLastResult[$i][1] + 36)
						EndIf
						If _Sleep($DELAYDONATECC2) Then ExitLoop
					EndIf
					If $ichkEnableCustomOCR4CCRequest = 1 Then
						If $g_iSamM0dDebug = 1 Then Setlog("Using custom OCR to read cc request message..", $COLOR_ACTION)
						Local $hHBitmapCustomOCR = GetHHBitmapArea($g_hHBitmap2,30, $aLastResult[$i][1] + 43, 190, $aLastResult[$i][1] + 43 + 15)
						If $ClanString = "" Then
							$ClanString = getMyOcr($hHBitmapCustomOCR, 30, $aLastResult[$i][1] + 43,160,15,"ccrequest",False,True)
						Else
							$ClanString &= " " & getMyOcr($hHBitmapCustomOCR, 30, $aLastResult[$i][1] + 43,160,15,"ccrequest",False,True)
						EndIf

						If $hHBitmapCustomOCR <> 0 Then GdiDeleteHBitmap($hHBitmapCustomOCR)
					EndIf

					If $ClanString = "" Or $ClanString = " " Then
						If $g_iSamM0dDebug = 1 Then SetLog("Unable to read Chat!", $COLOR_ERROR)
					Else
						SetLog("Chat: " & $ClanString)
						Local $asFCKeyword = StringSplit($stxtKeywordForRequest, @CRLF, $STR_ENTIRESPLIT)
						For $j = 1 To UBound($asFCKeyword) - 1
							;SetLog("$asFCKeyword[" & $j & "]: " & $asFCKeyword[$j])
							If StringInStr($ClanString, $asFCKeyword[$j], 2) Then
								Setlog("Keyword found: " & $asFCKeyword[$j], $COLOR_SUCCESS)
								$bDoFriendlyChallenge = True
								Local $ret = StringRegExp($ClanString, '\d+', 1)
								If IsArray($ret) Then
									For $k = 0 To UBound($aBaseForShare) - 1
										If $aBaseForShare[$k] = Int($ret[0] - 1) Then
											$iBaseForShare = Int($ret[0] - 1)
											SetLog("User request challenge base: " & $iBaseForShare + 1, $COLOR_INFO)
											ExitLoop
										EndIf
									Next
								EndIf
								ExitLoop 2
							EndIf
						Next
					EndIf
				Next
			EndIf
		Else
			If $g_iSamM0dDebug = 1 Then SetLog("divide not found.", $COLOR_DEBUG)
		EndIf
		If $g_hHBitmap2 <> 0 Then GdiDeleteHBitmap($g_hHBitmap2)
	EndIf

	If $bDoFriendlyChallenge Then
		SetLog("Prepare for select base: " & $iBaseForShare + 1, $COLOR_INFO)
		If _Wait4Pixel($aButtonFriendlyChallenge[4], $aButtonFriendlyChallenge[5], $aButtonFriendlyChallenge[6], $aButtonFriendlyChallenge[7], 1500, 150, "$aButtonFriendlyChallenge") Then
			Click($aButtonFriendlyChallenge[4], $aButtonFriendlyChallenge[5], 1, 0, "#BtnFC")
			If _Wait4Pixel($aButtonFCChangeLayout[4], $aButtonFCChangeLayout[5], $aButtonFCChangeLayout[6], $aButtonFCChangeLayout[7], 1500, 150, "$aButtonFCChangeLayout") Then
				Click($aButtonFCChangeLayout[4], $aButtonFCChangeLayout[5], 1, 0, "#BtnFCCL")
				If _Wait4Pixel($aButtonFCBack[4], $aButtonFCBack[5], $aButtonFCBack[6], $aButtonFCBack[7], 1500, 150, "$aButtonFCBack") Then
					If CheckNeedSwipeFriendlyChallengeBase($iBaseForShare) Then
						If _Wait4Pixel($aButtonFCStart[4], $aButtonFCStart[5], $aButtonFCStart[6], $aButtonFCStart[7], 1500, 150, "$aButtonFCStart") Then
							Local $bIsBtnStartOk = True
							If $stxtChallengeText <> "" Then
								Click(Random(440,620,1),Random(165,185,1))
								If _Sleep(100) Then Return False
								Local $asText = StringSplit($stxtChallengeText, @CRLF, BitOR($STR_ENTIRESPLIT,$STR_NOCOUNT))
								If IsArray($asText) Then
									Local $sText4Send = $asText[Random(0,UBound($asText)-1,1)]
									SetLog("Send text: " & $sText4Send, $COLOR_DEBUG)
									If $g_bChkBackgroundMode = False And $g_bNoFocusTampering = False Then ControlFocus($g_hAndroidWindow, "", "")
									If SendText($sText4Send) = 0 Then
										Setlog(" challenge text entry failed!", $COLOR_ERROR)
									EndIf
								EndIf
								If Not _Wait4Pixel($aButtonFCStart[4], $aButtonFCStart[5], $aButtonFCStart[6], $aButtonFCStart[7], 1500, 150, "$aButtonFCStart") Then $bIsBtnStartOk = False
							EndIf
							If $bIsBtnStartOk Then
								Click($aButtonFCStart[4], $aButtonFCStart[5], 1, 0, "#BtnFCStart")
								SetLog("Friendly Challenge Shared.", $COLOR_INFO)
								$iTimeForLastShareFriendlyChallenge = _NowCalc()
								ClostChatTab()
								Return True
							EndIf
						Else
							SetLog("Cannot find friendly challenge start button. Maybe the base cannot be select.", $COLOR_RED)
							$ichkFriendlyChallengeBase[$iBaseForShare] = 0
							GUICtrlSetState($chkFriendlyChallengeBase[$iBaseForShare], $GUI_UNCHECKED)
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	ClostChatTab()
	Return False
EndFunc

Func CheckNeedSwipeFriendlyChallengeBase($iBaseSlot)
	If _Sleep(100) Then Return False
;~ 	Local $iCount2 = 0
;~ 	While IsQueueBlockByMsg($iCount2) ; 检查游戏上的讯息，是否有挡着训练界面， 最多30秒
;~ 		If _Sleep(1000) Then ExitLoop
;~ 		$iCount2 += 1
;~ 		If $iCount2 >= 30 Then
;~ 			ExitLoop
;~ 		EndIf
;~ 	WEnd

	; check need swipe
	Local $iSwipeNum = 2
	Local $iCount = 0
	If $iBaseSlot > $iSwipeNum Then
		$iCount = 0
		While Not _ColorCheck(_GetPixelColor(712, 295, True), Hex(0XD3D3CB, 6), 10)
			ClickDrag(700,250,150,250,250)
			If _sleep(250) Then Return False
			$iCount += 1
			If $iCount > 3 Then Return False
		WEnd
		$iBaseSlot -= 3
		Click(Random(200 + ($iBaseSlot * 184), 230 + ($iBaseSlot * 184), 1) , Random(220,270,1))
	Else
		$iCount = 0
		While Not _ColorCheck(_GetPixelColor(146, 295, True), Hex(0XD3D3CB, 6), 10)
			ClickDrag(155,250,705,250,250)
			If _sleep(250) Then Return False
			$iCount += 1
			If $iCount > 3 Then Return False
		WEnd
		Click(Random(200 + ($iBaseSlot * 184), 230 + ($iBaseSlot * 184), 1) , Random(220,270,1))
	EndIf
	Return True
EndFunc

Func ClostChatTab()
	Local $i = 0
	While 1
		If _Sleep(250) Then Return
		ForceCaptureRegion()
		_CaptureRegion()
		Select
			Case _CheckColorPixel($aCloseChat[0], $aCloseChat[1], $aCloseChat[2], $aCloseChat[3], False, "aCloseChat")
				Click($aCloseChat[0], $aCloseChat[1], 1, 0, "#0173") ;Clicks chat thing
			Case _CheckColorPixel($aOpenChatTab[0], $aOpenChatTab[1], $aOpenChatTab[2], $aOpenChatTab[3], False, "aOpenChatTab")
				ExitLoop
			Case _CheckColorPixel($aButtonFCClose[4], $aButtonFCClose[5], $aButtonFCClose[6], $aButtonFCClose[7], False, "aButtonFCClose")
				Click($aButtonFCClose[0], $aButtonFCClose[1], 1, 0, "#BtnFCClose") ;Clicks chat thing
			Case _CheckColorPixel($aButtonFCBack[4], $aButtonFCBack[5], $aButtonFCBack[6], $aButtonFCBack[7], False, "aButtonFCBack")
				AndroidBackButton()
			Case Else
				ClickP($aAway, 1, 0, "#0167") ;Click Away
				$i += 1
				If $i > 30 Then
					SetLog("Error finding Clan Tab to close...", $COLOR_ERROR)
					AndroidPageError("FriendlyChallenge")
					ExitLoop
				EndIf
		EndSelect
	WEnd
	If _Sleep(100) Then Return
EndFunc

Func getChatStringPersianMod($x_start, $y_start, $bConvert = True) ; -> Get string chat request - Persian - "DonateCC.au3"
	Local $bUseOcrImgLoc = True
	Local $OCRString = getOcrAndCapture("persian-bundle", $x_start, $y_start, 240, 21, Default, $bUseOcrImgLoc, False)
	If $bConvert = True Then
		$OCRString = StringReverse($OCRString)
		$OCRString = StringReplace($OCRString, "A", "?")
		$OCRString = StringReplace($OCRString, "B", "?")
		$OCRString = StringReplace($OCRString, "C", "?")
		$OCRString = StringReplace($OCRString, "D", "?")
		$OCRString = StringReplace($OCRString, "F", "?")
		$OCRString = StringReplace($OCRString, "G", "?")
		$OCRString = StringReplace($OCRString, "J", "?")
		$OCRString = StringReplace($OCRString, "H", "?")
		$OCRString = StringReplace($OCRString, "R", "?")
		$OCRString = StringReplace($OCRString, "K", "?")
		$OCRString = StringReplace($OCRString, "K", "?")
		$OCRString = StringReplace($OCRString, "M", "?")
		$OCRString = StringReplace($OCRString, "N", "?")
		$OCRString = StringReplace($OCRString, "P", "?")
		$OCRString = StringReplace($OCRString, "S", "?")
		$OCRString = StringReplace($OCRString, "T", "?")
		$OCRString = StringReplace($OCRString, "V", "?")
		$OCRString = StringReplace($OCRString, "Y", "?")
		$OCRString = StringReplace($OCRString, "L", "?")
		$OCRString = StringReplace($OCRString, "Z", "?")
		$OCRString = StringReplace($OCRString, "X", "?")
		$OCRString = StringReplace($OCRString, "Q", "?")
		$OCRString = StringReplace($OCRString, ",", ",")
		$OCRString = StringReplace($OCRString, "0", " ")
		$OCRString = StringReplace($OCRString, "1", ".")
		$OCRString = StringReplace($OCRString, "22", "?")
		$OCRString = StringReplace($OCRString, "44", "?")
		$OCRString = StringReplace($OCRString, "55", "?")
		$OCRString = StringReplace($OCRString, "66", "?")
		$OCRString = StringReplace($OCRString, "77", "?")
		$OCRString = StringReplace($OCRString, "88", "??")
		$OCRString = StringReplace($OCRString, "99", "?")
		$OCRString = StringStripWS($OCRString, 1 + 2)
	EndIf
	Return $OCRString
EndFunc   ;==>getChatStringPersian