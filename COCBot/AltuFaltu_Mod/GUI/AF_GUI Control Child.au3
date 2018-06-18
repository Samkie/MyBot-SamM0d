; #FUNCTION# ====================================================================================================================
; Name ..........: Functions(AltuFaltu_Mod)
; Description ...: This functions will do all GUI operation and control.
; Syntax ........: None
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

Func chkSCIDSwitchAccAF()

	If GUICtrlRead($g_chkSCIDSwitchAccAF) = $GUI_CHECKED Then
		$g_ichkSCIDSwitchAccAF = 1
		GUICtrlSetState($g_hRadSwitchGooglePlay, $GUI_DISABLE)
		GUICtrlSetState($g_hRadSwitchSuperCellID, $GUI_DISABLE)
		GUICtrlSetState($g_hRadSwitchSharedPrefs, $GUI_DISABLE)
		If _GUICtrlComboBox_GetCurSel($g_hCmbTotalAccount) > 2 Then
			_GUICtrlComboBox_SetCurSel($g_hCmbTotalAccount,2)
			For $i = 4 to 7
				GUICtrlSetState($g_ahChkAccount[$i], $GUI_UNCHECKED)
				_GUI_Value_STATE("HIDE", $g_ahChkAccount[$i] & "#" & $g_ahCmbProfile[$i] & "#" & $g_ahChkDonate[$i])
				chkAccount($i)
			Next
		EndIf
	Else
		$g_ichkSCIDSwitchAccAF = 0
		If _GUICtrlComboBox_GetCurSel($g_hCmbSwitchAcc) > 0 Then
			GUICtrlSetState($g_hRadSwitchGooglePlay, $GUI_ENABLE)
			GUICtrlSetState($g_hRadSwitchSuperCellID, $GUI_ENABLE)
			GUICtrlSetState($g_hRadSwitchSharedPrefs, $GUI_ENABLE)
		EndIf
	EndIf

EndFunc

Func disableSwitchAcc()

	For $i = 0 to 7
		GUICtrlSetState($g_ahChkAccount[$i], $GUI_UNCHECKED)
		_GUICtrlComboBox_SetCurSel($g_ahCmbProfile[$i],-1)
		_GUI_Value_STATE("HIDE", $g_ahChkAccount[$i] & "#" & $g_ahCmbProfile[$i] & "#" & $g_ahChkDonate[$i])
		chkAccount($i)
	Next
	GUICtrlSetState($g_hChkSwitchAcc, $GUI_UNCHECKED)
	_GUICtrlComboBox_SetCurSel($g_hCmbTotalAccount,0)

EndFunc