
$y += 5
;$grpMySwitch = GUICtrlCreateGroup(GetTranslatedFileIni("sam m0d",25, "Switch Google Account And Profile"), $x-5, $y, 438, 340)
$grpMySwitch = GUICtrlCreateGroup(GetTranslatedFileIni("sam m0d",25, "Switch Google Account And Profile"), $x-5, $y, 430, 335)


$chkEnableMySwitch = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 26, "Enable switch account"), $x, $y+20, 180, -1)
	GUICtrlSetFont (-1,9, 800)
	;GUICtrlSetOnEvent(-1, "chkEnableAcc")
	GUICtrlSetState(-1,$GUI_DISABLE)


GUICtrlCreateLabel(GetTranslatedFileIni("sam m0d", "Switch method label", "Switch Method: "), $x + 180, $y + 20, 100, -1, $SS_RIGHT)
$cmbSwitchMethod = GUICtrlCreateCombo("", $x + 300 , $y + 15, 100, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "Switch method", "Google: build in google switch; Shared_Prefs: Use ADB replace the shared_prefs file to emulator; Game Client: just logout game and changing coc game client base on profile."))
	GUICtrlSetData(-1, "Google|Shared_Prefs|Game Client","Google")
	GUICtrlSetState(-1, $GUI_SHOW)
	GUICtrlSetOnEvent(-1, "cmbSwitchMethod")

;$lblActiveAcc = GUICtrlCreateLabel("Current Active Acc:", $x+200, $y+15, 220, 50,$SS_CENTER)

$y += 45
For $i = 0 To 7
	$chkEnableAcc[$i] = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 27 + $i, "Google Account slot " & $i + 1 & " with profile: "), $x, $y, -1, -1)
		GUICtrlSetOnEvent(-1, "SelectAccForSwitch")
	$cmbWithProfile[$i] = GUICtrlCreateCombo("", $x + 185, $y + 1, 110, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetOnEvent(-1, "chkEnableAcc")
	$cmbAtkDon[$i] = GUICtrlCreateCombo("", $x + 300, $y + 1, 58, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, GetTranslatedFileIni("sam m0d", "SwitchTypeAttack", "Attack") & "|" & GetTranslatedFileIni("sam m0d", "SwitchTypeDonate", "Donate"), GetTranslatedFileIni("sam m0d", "SwitchTypeAttack", "Attack"))
		GUICtrlSetOnEvent(-1, "chkEnableAcc")
	$cmbStayTime[$i] = GUICtrlCreateCombo("", $x + 363, $y + 1, 38, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "0|5|10|15|30","0")
		_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "Setting for Stay how long (minutes) with this account.", "Setting for Stay how long (minutes) with this account."))
		GUICtrlSetOnEvent(-1, "chkEnableAcc")
	$chkPriority[$i] = GUICtrlCreateCheckbox(" ", $x + 405, $y + 6, 12, 12)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "High Priority", "High Priority - Always switch to this account when troops ready."))
	GUICtrlSetOnEvent(-1, "chkEnableAcc")
	$y += 23
Next

$y += 15
$chkProfileImage = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 41, "Do Check village and profile after load."), $x, $y, -1, -1)
	_GUICtrlSetTip(-1, "Check the village name at game profile page there, confirm the village load correctly.")
	GUICtrlSetOnEvent(-1, "chkEnableAcc")

$y += 22
$chkEnableContinueStay = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "ContinueStay", "Avoid switch, if troops getting ready within [Minute(s)]: "), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkEnableAcc")

$txtTrainTimeLeft = GUICtrlCreateInput("5", $x + 290, $y+2, 35, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "ContinueStayValue", "Please enter how many minute(s)"))
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "chkEnableAcc")

$y += 22
$chkCanCloseGame = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "Smart wait for train", "Enable smart wait for train. Login back when train time left second(s): "), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkCanCloseGame")
$txtCanCloseGameTime = GUICtrlCreateInput("60", $x + 360, $y+2, 35, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "smart wait for train text", "Please enter how many second(s)"))
	GUICtrlSetLimit(-1, 4)
	GUICtrlSetOnEvent(-1, "chkCanCloseGame")

$y += 22
$chkForcePreTrainB4Switch = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "ForcePreTrainWhenSwitch", "Force pre-train troops for attack type account before switch."), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkEnableAcc")

GUICtrlCreateGroup("", -99, -99, 1, 1)

ReadEnableAcc()
ApplyEnableAcc()
