Func BuildProfileForSwitch()
	;SetLog("Rebuild My Switch Accounts list.")
	Local $sDataFromProfile
	$sDataFromProfile = _GUICtrlComboBox_GetList($g_hCmbProfile)
	For $i = 0 To 7
		GUICtrlSetData($cmbWithProfile[$i],"","")
		GUICtrlSetData($cmbWithProfile[$i], $sDataFromProfile, "")
	Next
	GUICtrlSetData($g_hCmbProfile2,"","")
	GUICtrlSetData($g_hCmbProfile2, $sDataFromProfile, "")
	ApplyEnableAcc()
EndFunc

Func InitializeMySwitch()
	ReadEnableAcc()
	ApplyEnableAcc()
EndFunc

Func chkEnableAcc()
	SaveEnableAcc()
	ReadEnableAcc()
	ApplyEnableAcc()
EndFunc

Func SelectAccForSwitch()
	If $g_iBotAction = $eBotStart Then
		MsgBox(0,"Warning!", "Please stop bot before select account.")
		For $i = 0 To 7
			GUICtrlSetState($chkEnableAcc[$i], ($ichkEnableAcc[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
		Next
		Return
	EndIf
	chkEnableAcc()
EndFunc

Func SaveEnableAcc()
	For $i = 0 To 7
		IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "EnableAcc" & $i + 1, (GUICtrlRead($chkEnableAcc[$i]) = $GUI_CHECKED ? 1 : 0))
		IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "WithProfile" & $i + 1, GUICtrlRead($cmbWithProfile[$i]))
		IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "AtkDon" & $i + 1, _GUICtrlComboBox_GetCurSel($cmbAtkDon[$i]))
		IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "Stay" & $i + 1, GUICtrlRead($cmbStayTime[$i]))
		IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "Priority" & $i + 1, (GUICtrlRead($chkPriority[$i]) = $GUI_CHECKED ? 1 : 0))
	Next
	;IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "EnablesPrefSwitch", (GUICtrlRead($chkUseADBLoadVillage) = $GUI_CHECKED ? 1 : 0))
	IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "SwitchMethod", _GUICtrlComboBox_GetCurSel($cmbSwitchMethod))
	IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "CheckVillage", (GUICtrlRead($chkProfileImage) = $GUI_CHECKED ? 1 : 0))
	IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "EnableContinueStay", (GUICtrlRead($chkEnableContinueStay) = $GUI_CHECKED ? 1 : 0))
	IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "TrainTimeLeft", GUICtrlRead($txtTrainTimeLeft))
	IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "ForcePreTrainB4Switch", (GUICtrlRead($chkForcePreTrainB4Switch) = $GUI_CHECKED ? 1 : 0))
	IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "EnableSmartWait", (GUICtrlRead($chkCanCloseGame) = $GUI_CHECKED ? 1 : 0))
	IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "EnableSmartWaitTime", GUICtrlRead($txtCanCloseGameTime))
EndFunc

Func ReadEnableAcc()
	For $i = 0 To 7
		$ichkEnableAcc[$i] = IniRead(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "EnableAcc" & $i + 1, "0")
		$icmbWithProfile[$i] = IniRead(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "WithProfile" & $i + 1, "0")
		$icmbAtkDon[$i] = IniRead(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "AtkDon" & $i + 1, "0")
		$icmbStayTime[$i] = IniRead(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "Stay" & $i + 1, "0")
		$ichkPriority[$i] = IniRead(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "Priority" & $i + 1, "0")
	Next
	;$ichkUseADBLoadVillage = IniRead(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "EnablesPrefSwitch", "0")
	$icmbSwitchMethod = IniRead(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "SwitchMethod", "0")
	$ichkProfileImage = IniRead(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "CheckVillage", "0")
	$ichkEnableContinueStay = IniRead(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "EnableContinueStay", "0")
	$itxtTrainTimeLeft = IniRead(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "TrainTimeLeft", "5")
	$ichkForcePreTrainB4Switch = IniRead(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "ForcePreTrainB4Switch", "0")
	$ichkCanCloseGame = IniRead(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "EnableSmartWait", "0")
	$itxtCanCloseGameTime = IniRead(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "EnableSmartWaitTime", "60")
EndFunc

Func ApplyEnableAcc()
	For $i = 0 To 7
		GUICtrlSetState($chkEnableAcc[$i], ($ichkEnableAcc[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
		setCombolistByText($cmbWithProfile[$i],$icmbWithProfile[$i])
		setCombolistByText($cmbStayTime[$i],$icmbStayTime[$i])
		_GUICtrlComboBox_SetCurSel($cmbAtkDon[$i],$icmbAtkDon[$i])
		GUICtrlSetState($chkPriority[$i], ($ichkPriority[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
	Next
	setCombolistByText($g_hCmbProfile2, GUICtrlRead($g_hCmbProfile))
	;GUICtrlSetState($chkUseADBLoadVillage, ($ichkUseADBLoadVillage = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
	_GUICtrlComboBox_SetCurSel($cmbSwitchMethod,$icmbSwitchMethod)
	GUICtrlSetState($chkProfileImage, ($ichkProfileImage = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
	GUICtrlSetState($chkEnableContinueStay, ($ichkEnableContinueStay = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
	GUICtrlSetData($txtTrainTimeLeft, $itxtTrainTimeLeft)
	GUICtrlSetState($chkForcePreTrainB4Switch, ($ichkForcePreTrainB4Switch = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
	GUICtrlSetState($chkCanCloseGame, ($ichkCanCloseGame = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
	GUICtrlSetData($txtCanCloseGameTime, $itxtCanCloseGameTime)
	buildSwitchList()
	DoCheckSwitchEnable()
EndFunc

Func cmbProfile2()
	setCombolistByText($g_hCmbProfile, GUICtrlRead($g_hCmbProfile2))
	cmbProfile()
EndFunc

Func cmbSwitchMethod()
	$icmbSwitchMethod = _GUICtrlComboBox_GetCurSel($cmbSwitchMethod)
	chkEnableAcc()
EndFunc

Func chkCanCloseGame()
	$ichkCanCloseGame = (GUICtrlRead($chkCanCloseGame) = $GUI_CHECKED ? 1 : 0)
	$itxtCanCloseGameTime = GUICtrlRead($txtCanCloseGameTime)
	chkEnableAcc()
EndFunc

Func setCombolistByText(ByRef $iHandle, $sText)
	Local $aList = _GUICtrlComboBox_GetListArray($iHandle)
	For $i = 1 To $aList[0]
		If $aList[$i] = $sText Then
			_GUICtrlComboBox_SetCurSel($iHandle, $i - 1)
			ExitLoop
		EndIf
	Next
EndFunc


