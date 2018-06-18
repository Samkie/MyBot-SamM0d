; #FUNCTION# ====================================================================================================================
; Name ..........: Functions(AltuFaltu_Mod)
; Description ...: This functions will do all config operation like save or restore gui data into or from ini files.
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

Func AF_ApplyReadSwitchAcc()

	GUICtrlSetState($g_chkSCIDSwitchAccAF, $g_ichkSCIDSwitchAccAF ? $GUI_CHECKED : $GUI_UNCHECKED)
	chkSCIDSwitchAccAF()

EndFunc

Func AF_ApplySaveSwitchAcc()

	$g_ichkSCIDSwitchAccAF = (GUICtrlRead($g_chkSCIDSwitchAccAF) = $GUI_CHECKED)

EndFunc

Func AF_ReadConfigSwitchAcc($sSwitchAccFile = -1)

	If $sSwitchAccFile = -1 Then
		IniReadS($g_ichkSCIDSwitchAccAF, $g_sProfileConfigPath, "SwitchAccount", "AF_ChkSCIDSwitchAcc", False, "bool")
	Else
		$g_ichkSCIDSwitchAccAF = IniRead($sSwitchAccFile, "SwitchAccount", "AF_ChkSCIDSwitchAcc", $g_chkSCIDSwitchAccAF ? "1" : "0") = "1"
	EndIf

EndFunc

Func AF_SaveConfigSwitchAcc($sSwitchAccFile = -1)

	If $sSwitchAccFile = -1 Then
		_Ini_Add("SwitchAccount", "AF_ChkSCIDSwitchAcc", $g_ichkSCIDSwitchAccAF)
	Else
		IniWrite($sSwitchAccFile, "SwitchAccount", "AF_ChkSCIDSwitchAcc", $g_ichkSCIDSwitchAccAF ? 1 : 0)
	EndIf

EndFunc