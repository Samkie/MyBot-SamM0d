; #FUNCTION# ====================================================================================================================
; Name ..........: Functions(AltuFaltu_Mod)
; Description ...: This functions will do Switch between SCID ACC using simple click method. It help to login SCID ACC if Mainscreen stucked on SCID login Screen.
; Syntax ........: SwitchCOCAcc_SCID($NextAccount), _MainScreen_SCIDLogin()
; Parameters ....: $NextAccount
; Return values .: None
; Author ........: AltuFaltu(06-04-18)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SwitchCOCAcc_SCID($NextAccount)

	Local $Success = False
	Setlog("***ALtuFaltu - Start SuperCell ID Switch Account Process***",0x6E0DD0)
	If _Sleep(500) Then Return
	If IsMainPage() Then Click($aButtonSetting[0], $aButtonSetting[1], 1, 0, "Click Setting")
	Setlog("     1.Click on Setting Button",0xFF0099)
	If _Sleep(500) Then Return

	If WaitforVariousImages("SCIDDisconnectBtn",30,1000) = False Then
		SetLog("Cannot load setting page, restart game...", $COLOR_RED)
	Else
		Setlog("     2.Click on SuperCell ID Disconnect Button",0xFF0099)
		If _Sleep(2000) Then Return
		RndClick_AF($g_ClkSCIDDisConnBtnAF)
		If _Sleep(500) Then Return
		If WaitforVariousImages("SCIDLogOutBtn",30,1000) = False Then
			SetLog("Cannot load SuperCell ID LogOut page, restart game...", $COLOR_RED)
		Else
			Setlog("     3.Click on SuperCell ID LogOut Button",0xFF0099)
			If _Sleep(2000) Then Return
			RndClick_AF($g_ClkSCIDLogOutBtnAF)
			If _Sleep(500) Then Return
			If WaitforVariousImages("SCIDLogOutConfirmBtn",30,1000) = False Then
				SetLog("Cannot Find SuperCell ID Confirm Button, restart game...", $COLOR_RED)
			Else
				Setlog("     4.Click on SuperCell ID LogOut Confirm Button",0xFF0099)
				If _Sleep(2000) Then Return
				RndClick_AF($g_ClkSCIDConfirmBtnAF)
				If _Sleep(500) Then Return
				If WaitforVariousImages("SCIDLoginBtn",30,1000) = False Then
					SetLog("Cannot Find SuperCell ID Login Button, restart game...", $COLOR_RED)
				Else
					Setlog("     5.Click on SuperCell ID Login Button",0xFF0099)
					If _Sleep(2000) Then Return
					RndClick_AF($g_ClkSCIDLoginBtnAF)
					If _Sleep(3000) Then Return
					If WaitforVariousImages("SCIDAccSelectPage",30,1000) = False Then
						If WaitforVariousImages("SCIDAccSelectPageSingleAcc",30,1000) = True Then
							SetLog("AltuFaltu - You have only one Acc. of SCID in Emulator and", 0x6E0DD0)
							SetLog("           	You Active Swithch Acc. Soo Funny.", 0x6E0DD0)
							SetLog("Solution - Disable Switch Acc.", 0x6E0DD0)
							BtnStop()
							$g_SwitchSCIDAccFatalErrorAF = True
						Else
							SetLog("Cannot Load SuperCell ID Select Account Page, restart game...", $COLOR_RED)
						EndIf
					Else
						Setlog("     6.Click on SuperCell ID Account No. - " & $NextAccount+1 & ".",0xFF0099)
						Local $AccSlotArea = [390,334+(74*$NextAccount),400,336+(74*$NextAccount)]
						If _Sleep(2000) Then Return
						RndClick_AF($AccSlotArea)
						If _Sleep(3000) Then Return
						$Success = True
						Wait4MainAF()
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	Return $Success

EndFunc

Func _MainScreen_SCIDLogin()

	Local $CurrAccount = -1
	For $i = 0 to 3
		If GUICtrlRead($g_hCmbProfile,_GUICtrlComboBox_GetCurSel($g_hCmbProfile)) = GUICtrlRead($g_ahCmbProfile[$i],_GUICtrlComboBox_GetCurSel($g_ahCmbProfile[$i])) Then
			$CurrAccount = $i
			ExitLoop
		EndIf
	Next
	If $CurrAccount = -1 Then
		If WaitforVariousImages("SCIDAccSelectPageSingleAcc",30,1000) = False Then
			SetLog("AltuFaltu - Login into the Current Profile's Acc is failed.", 0x6E0DD0)
			SetLog("Problem  - You have multiple SCID Acc. in Emulator and ", 0x6E0DD0)
			SetLog("           You didn't specify the Slot of your Current Profile.", 0x6E0DD0)
			SetLog("           So Bot Don't know to Login into which Acc.", 0x6E0DD0)
			SetLog("Solution - Please, Arrange profiles as per Acc Slot in SwitchAcc Section", 0x6E0DD0)
			BtnStop()
		Else
			Setlog("     6.Click on SuperCell ID Single Account Slot.",0xFF0099)
			If _Sleep(2000) Then Return
			Click(380,375)
			If _Sleep(3000) Then Return
			Wait4MainAF()
		EndIf
	Else
		If WaitforVariousImages("SCIDAccSelectPage",30,1000) = False Then
			If WaitforVariousImages("SCIDAccSelectPageSingleAcc",30,1000) = True Then
			SetLog("AltuFaltu - You have only one Acc. of SCID. in Emulator.", 0x6E0DD0)
			SetLog("Warning   - Bot will login to that ID with selected Profile", 0x6E0DD0)
			Setlog("     6.Click on SuperCell ID Single Account Slot.",0xFF0099)
			If _Sleep(2000) Then Return
			Click(380,375)
			If _Sleep(3000) Then Return
			Else
				SetLog("Cannot Load SuperCell ID Select Account Page, restart game...", $COLOR_RED)
			EndIf
		Else
			Setlog("     6.Click on SuperCell ID Account Slot No. - " & $CurrAccount+1 & ".",0xFF0099)
			Local $AccSlotArea = [380,334+(74*$CurrAccount),400,336+(74*$CurrAccount)]
			RndClick_AF($AccSlotArea)
			If _Sleep(3000) Then Return
			Wait4MainAF()
		EndIf
	EndIf

EndFunc

Func Wait4MainAF($bBuilderBase = False)
	Local $iCount
	For $i = 0 To 105
		$iCount += 1
		If $iCount > 120 Then ExitLoop
		If $g_DebugLogAF = 1 Then Setlog("Wait4Main Loop = " & $i & "   ExitLoop = " & $iCount, $COLOR_DEBUG) ; Debug stuck loop
		ForceCaptureRegion()
		_CaptureRegion()
		If _CheckColorPixel($aIsMain[0], $aIsMain[1], $aIsMain[2], $aIsMain[3], $g_bNoCapturePixel, "aIsMain") Then
			If $g_DebugLogAF = 1 Then Setlog("Main Village - Screen cleared, Wait4Main exit", $COLOR_DEBUG)
			Return True
		ElseIf _CheckColorPixel($aIsOnBuilderBase[0], $aIsOnBuilderBase[1], $aIsOnBuilderBase[2], $aIsOnBuilderBase[3], $g_bNoCapturePixel, "aIsOnBuilderBase") Then
			If Not $bBuilderBase Then
				ZoomOut()
				SwitchBetweenBases()
				If $i <> 0 Then $i -= 1
				ContinueLoop
			EndIf
			If $g_DebugLogAF = 1 Then Setlog("Builder Base - Screen cleared, Wait4Main exit", $COLOR_DEBUG)
			Return True
		Else
			If TestCapture() = False And _Sleep($DELAYWAITMAINSCREEN1) Then Return
			; village was attacked okay button
			If _ColorCheck(_GetPixelColor(402, 516, $g_bNoCapturePixel), Hex(0xFFFFFF, 6), 5) And _ColorCheck(_GetPixelColor(405, 537, $g_bNoCapturePixel), Hex(0x5EAC10, 6), 20) Then
				;Click($aButtonVillageWasAttackOK[0],$aButtonVillageWasAttackOK[1],1,0,"#VWAO")
				Click(625,30)
				If _Sleep(1000) Then Return
				Click(625,30)
				If _Sleep(1000) Then Return
				$g_abNotNeedAllTime[0] = True
				$g_abNotNeedAllTime[1] = True
				$g_bIsClientSyncError = False
				If _Sleep(500) Then Return True
				$i = 0
				ContinueLoop
			EndIf
			_CaptureRegion2Sync()
			If _checkObstacles($bBuilderBase) Then $i = 0
		EndIf
	Next
	Return False
EndFunc