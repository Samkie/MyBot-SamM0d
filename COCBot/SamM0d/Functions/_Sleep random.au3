; #FUNCTION# ====================================================================================================================
; Name ..........: Random _sleep
; Description ...: This file contains all functions of Pico CSV Speed feature
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: Boludoz
; Modified ......: 27/05/2018
; Remarks .......: This file is part of MyBotRun. Copyright 2018
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: ---
;================================================================================================================================

Func cmb_SleepMult()

	Switch _GUICtrlComboBox_GetCurSel($cmb_SleepMult)
		Case 0
			$g_fMultiplicando = 1.25
		Case 1                   
			$g_fMultiplicando = 1.5
		Case 2                   
			$g_fMultiplicando = 2
		Case 3                   
			$g_fMultiplicando = 3
	EndSwitch
EndFunc   ;==>cmb_SleepMult