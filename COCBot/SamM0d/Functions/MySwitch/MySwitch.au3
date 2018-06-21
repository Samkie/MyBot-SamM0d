; #FUNCTION# ====================================================================================================================
; Name ..........:getNextSwitchList [BETA]
; Description ...:
; Syntax ........:getNextSwitchList()
; Parameters ....:
; Return values .: None
; Author ........: Samkie (8 August, 2017)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getTotalGoogleAccount()
	ForceCaptureRegion()
	Local $x1 = 160
	Local $x2 = 699
	Local $iCount = 0
	Local $aStartPos = _PixelSearch($x2-1,0,$x2,300,Hex(0xFFFFFF, 6),5)

	If IsArray($aStartPos) Then
		If $g_iSamM0dDebug = 1 Then SetLog("$aStartPos: " & $aStartPos[0] & "," & $aStartPos[1])
		$iSlotYOffset = $aStartPos[1]
		_CaptureRegion()
		For $i = 0 To 7
			If _ColorCheck(_GetPixelColor($x1, 96 + $aStartPos[1] + ($i * 72),$g_bNoCapturePixel), Hex(0xFFFFFF,6), 5) And _
				_ColorCheck(_GetPixelColor($x2, 96 + $aStartPos[1] + ($i * 72),$g_bNoCapturePixel), Hex(0xFFFFFF,6), 5) Then
				$iCount += 1
			Else
				ExitLoop
			EndIf
		Next
		If $g_iSamM0dDebug = 1 Then SetLog("Acc. $iCount: " & $iCount)
		Return $iCount
	EndIf
	Return 0
EndFunc

Func SelectGoogleAccount($iSlot)
	; open setting page
	Click($aButtonSMSetting[0],$aButtonSMSetting[1],1,0,"#Setting")

	Local $iCount

	If Not _Wait4Pixel($aButtonClose2[4], $aButtonClose2[5], $aButtonClose2[6], $aButtonClose2[7], 10000, 200) Then
		SetLog("Cannot load setting page, restart game...", $COLOR_RED)
		CloseCoC(True)
		Wait4Main()
		Return False
	EndIf

;~  	Click($aButtonSMSettingTabSetting[0],$aButtonSMSettingTabSetting[1],1,0,"#TabSettings")
;~  	If _Sleep(500) Then Return False

	If _Sleep(250) Then Return False

	If _CheckColorPixel($aButtonGoogleConnectRed[4], $aButtonGoogleConnectRed[5], $aButtonGoogleConnectRed[6], $aButtonGoogleConnectRed[7], $g_bCapturePixel, "aButtonGoogleConnectRed") Then
		Click($aButtonGoogleConnectRed[0],$aButtonGoogleConnectRed[1],1,0,"#ConnectGoogle")
	Else
		Click($aButtonGoogleConnectGreen[0],$aButtonGoogleConnectGreen[1],2,500,"#ConnectGoogle")
	EndIf

	If Not _Wait4Pixel(160,380,0xFFFFFF,10,30000,200) Then
		If $g_iSamM0dDebug = 1 Then SetLog("wait for google account page", $COLOR_DEBUG)
		SetLog("Cannot load google account page, restart game...", $COLOR_RED)
		CloseCoC(True)
		Wait4Main()
		Return False
	EndIf

	$iCount = 0
	Local $bErrorFlag = 0
	While $iCount <= 10
		If _Sleep(1000) Then Return False
		Local $iTotalAcc = getTotalGoogleAccount()
		If $iTotalAcc < $iSlot + 1 Then
			$bErrorFlag += 1
			If $bErrorFlag >= 3 Then
				SetLog("You cannot select account slot " & $iSlot + 1 & ", because you only got total: " & $iTotalAcc, $COLOR_RED)
				AndroidBackButton()
				If _Sleep(500) Then Return False
				AndroidBackButton()
				BotStop()
				Return False
			EndIf
		Else
			Click(241, 84 + $iSlotYOffset + ($iSlot * 72), 1, 0, "#GASe")
			ExitLoop
		EndIf
		$iCount += 1
	WEnd

	Local $iResult
	$iResult = DoLoadVillage()

;	$bNowWaitingConfirm =False

	If $iResult <> 1 And $iResult <> 2 Then Return False

	If _Sleep(500) Then Return False

	If $g_iSamM0dDebug = 1 Then SetLog("$iResult: " & $iResult)

	If _Sleep(5) Then Return False

	If $iResult = 1 Then
		If DoConfirmVillage() = False Then Return False
	Else
		ClickP($aAway,1,0)
	EndIf

	; wait for game reload
	Wait4Main()

	Return True
EndFunc

Func DoLoadVillage()
	Local $iCount = 0
	$iCount = 0
;	$bNowWaitingConfirm = True
	While Not _CheckColorPixel($aButtonSMVillageLoad[4], $aButtonSMVillageLoad[5], $aButtonSMVillageLoad[6], $aButtonSMVillageLoad[7], $g_bCapturePixel, "aButtonSMVillageLoad")
		;If $g_iSamM0dDebug = 1 Then SetLog("village load button Color: " & _GetPixelColor(160, 380,True))
		$iCount += 1
		If $iCount = 90 Then
			SetLog("Cannot load village load button, restart game...", $COLOR_RED)
			CloseCoC(True)
			Wait4Main()
		EndIf
		If $iCount >= 180 Then
			Return 0
		EndIf
		If _CheckColorPixel($aButtonGoogleConnectGreen[4], $aButtonGoogleConnectGreen[5], $aButtonGoogleConnectGreen[6], $aButtonGoogleConnectGreen[7], $g_bCapturePixel, "aButtonGoogleConnectGreen") Then
			Return 2
		EndIf
		If _Sleep(1000) Then Return 0
	WEnd
	Click($aButtonSMVillageLoad[0],$aButtonSMVillageLoad[1],1,0,"#GALo")
	Return 1
EndFunc

Func DoConfirmVillage()

	If Not _Wait4Pixel($aButtonVillageConfirmClose[4],$aButtonVillageConfirmClose[5],$aButtonVillageConfirmClose[6],$aButtonVillageConfirmClose[7],15000,200) Then
		SetLog("Cannot load village confirm button, restart game...", $COLOR_RED)
		CloseCoC(True)
		Wait4Main()
		Return False
	EndIf

	Click($aButtonVillageConfirmText[0],$aButtonVillageConfirmText[1],1,0,"#GATe")

	If _Sleep(100) Then Return False
	If SendText("CONFIRM") = 0 Then
		SetLog("Cannot type CONFIRM to emulator, restart game...", $COLOR_RED)
		CloseCoC(True)
		Wait4Main()
		Return False
	EndIf

	If Not _Wait4Pixel($aButtonVillageConfirmOK[4],$aButtonVillageConfirmOK[5],$aButtonVillageConfirmOK[6],$aButtonVillageConfirmOK[7],15000,200) Then
		SetLog("Cannot confirm village Okay button, restart game...", $COLOR_RED)
		CloseCoC(True)
		Wait4Main()
		Return False
	EndIf

	Click($aButtonVillageConfirmOK[0],$aButtonVillageConfirmOK[1],1,0,"#GACo")

	Return True
EndFunc

Func buildSwitchList()
	Local $OldSwitchList[1][8]
	Local $iCount = 0

	ReDim $OldSwitchList[UBound($aSwitchList)][8]
	$OldSwitchList = $aSwitchList

	ReDim $aSwitchList[$iCount + 1][8]
	$aSwitchList[$iCount][0] = 0
	$aSwitchList[$iCount][1] = 0
	$aSwitchList[$iCount][2] = 0
	$aSwitchList[$iCount][4] = 0
	$aSwitchList[$iCount][5] = 0
	$aSwitchList[$iCount][6] = 0
	$aSwitchList[$iCount][7] = 0
	$iTotalDonateType = 0

	For $i = 0 To 7
		If $ichkEnableAcc[$i] = 1 Then
			If $icmbSwitchMethod = 1 Then
				If Not FileExists(@ScriptDir & "\profiles\" & $icmbWithProfile[$i] & "\shared_prefs\storage.xml") Then
					MsgBox($MB_SYSTEMMODAL, "Error!", "shared_prefs for " & $icmbWithProfile[$i] & " not found." & @CRLF _
					& "Please Load profile " & $icmbWithProfile[$i] & " and goto emulator load village " & $icmbWithProfile[$i] & @CRLF _
					& "Then use get shared_prefs button to get shared_prefs before use this feature.")
					$icmbSwitchMethod = 0
					GUICtrlSetState($chkUseADBLoadVillage, $GUI_UNCHECKED)
					IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "EnablesPrefSwitch", 0)
				EndIf
			EndIf
			If $ichkProfileImage = 1 Then
				If Not FileExists(@ScriptDir & "\profiles\" & $icmbWithProfile[$i] & "\village_92.png") Then
					MsgBox($MB_SYSTEMMODAL, "Error!", "village_92.png for " & $icmbWithProfile[$i] & " not found." & @CRLF _
					& "Please Load profile " & $icmbWithProfile[$i] & " and goto emulator load village " & $icmbWithProfile[$i] & @CRLF _
					& "Then use get shared_prefs button to get village_92.png before use this feature.")
					$ichkProfileImage = 0
					GUICtrlSetState($chkProfileImage, $GUI_UNCHECKED)
					IniWrite(@ScriptDir & "\Profiles\MySwitch.ini", "MySwitch", "CheckVillage", 0)
				EndIf
			EndIf
			ReDim $aSwitchList[$iCount + 1][8]
			$aSwitchList[$iCount][0] = _NowCalc() ;initialize army train time with date and time now
			$aSwitchList[$iCount][1] = TimerInit()
			$aSwitchList[$iCount][2] = $icmbAtkDon[$i] ; atk or don flag
			$aSwitchList[$iCount][3] = $icmbWithProfile[$i] ; profile name
			$aSwitchList[$iCount][4] = $i ; account slot
			$aSwitchList[$iCount][5] = 0
			$aSwitchList[$iCount][6] = $icmbStayTime[$i] ; stay time (minutes)
			$aSwitchList[$iCount][7] = $ichkPriority[$i] ;
			If $icmbAtkDon[$i] = 1 Then
				$iTotalDonateType += 1
			EndIf
			If $icmbWithProfile[$i] = $g_sProfileCurrentName And $iCurActiveAcc <> -1 Then
				$iCurActiveAcc = $i
			EndIf
			$iCount += 1
 		Else
 			If $i = $iCurActiveAcc Then
 				$iCurActiveAcc = -1
 			EndIf
		EndIf
	Next

	;restore army time from old setting if got
	For $i = 0 To UBound($aSwitchList) - 1
		For $j = 0 To UBound($OldSwitchList) - 1
			If $aSwitchList[$i][4] = $OldSwitchList[$j][4] And $aSwitchList[$i][3] = $OldSwitchList[$j][3] Then
				$aSwitchList[$i][0] = $OldSwitchList[$j][0]
				$aSwitchList[$i][5] = $OldSwitchList[$j][5]
				ExitLoop
			EndIf
		Next
	Next

	sortSwitchList()
EndFunc

Func sortSwitchList($bFlagPriority = -1)
	; sort switch list for make atk type first, donate type last
	$iSortEnd = -1
	Local $iMaxCount = UBound($aSwitchList) - 1
	Local $iPriorityCount = 0

	If $bFlagPriority <> - 1 Then
		;_ArrayDisplay($aSwitchList,"Before")
		For $i = 0 to $iMaxCount
			For $j = $i + 1 To $iMaxCount
				If $aSwitchList[$i][7] < $aSwitchList[$j][7] And $aSwitchList[$i][2] = 0 Then
					_ArraySwap($aSwitchList,$i,$j,False)
				EndIf
			Next
		Next

		;_ArrayDisplay($aSwitchList, "After1")
		For $i = 0 to $iMaxCount
			If $aSwitchList[$i][7] = 1 Then
				$iPriorityCount += 1
			Else
				ExitLoop
			EndIf
		Next
		If $iPriorityCount > 1 Then
			_ArraySort($aSwitchList,0,0,$iPriorityCount-1,2)
		EndIf
	EndIf

	;_ArrayDisplay($aSwitchList, "After2 - " & $iPriorityCount)
	_ArraySort($aSwitchList,0,$iPriorityCount,$iMaxCount,2)

	For $i = 0 to $iMaxCount
		If $aSwitchList[$i][2] = 1 Then
			$iSortEnd = $i - 1
			ExitLoop
		EndIf
	Next

	If $iSortEnd <> -1 Then
		If $iSortEnd <> 0 Then
			_ArraySort($aSwitchList,0,$iPriorityCount,$iSortEnd,0)
			If $iSortEnd + 1 < $iMaxCount Then
				_ArraySort($aSwitchList,$iPriorityCount,$iSortEnd + 1,$iMaxCount,0)
			EndIf
		Else
			If $iSortEnd + 1 < $iMaxCount Then
				_ArraySort($aSwitchList,$iPriorityCount,$iSortEnd + 1,$iMaxCount,0)
			EndIf
		EndIf
	Else
		_ArraySort($aSwitchList,0,$iPriorityCount,$iMaxCount,2)
	EndIf

	;_ArrayDisplay($aSwitchList, "After3")
EndFunc

Func getNextSwitchList()
	Local $bFlagDoSortSwitchList = False
	Local $bFlagGotTrainTimeout = False
	Local $iNextAccSlot = $iCurActiveAcc
	Local $iFirstAtkDonAcc = -1
	Local $iStayRemain
	Local $bFlagPriority = -1

	$iMySwitchSmartWaitTime = 0
	SetLog("Start checking is that any accounts ready for switch.",$COLOR_INFO)

	For $i = 0 to UBound($aSwitchList) - 1
		Local $iDateCalc = _DateDiff('s', $aSwitchList[$i][0], _NowCalc()) ;compare date time from last check, return different seconds

		SetLog("Account:" & $aSwitchList[$i][4] + 1 & " - " & $aSwitchList[$i][3] & " [" & ($aSwitchList[$i][2] = 1 ? "D" : "A") &  "] - " & _
		($iDateCalc >= 0 ? "Army getting ready." : "Army getting ready within " & 0 - $iDateCalc & " seconds.") & ($aSwitchList[$i][5] = 1 ? " - PB" : ""),$COLOR_INFO)

		If $iDateCalc >= 0 Then $aSwitchList[$i][5] = 0 ; if current date time over, reset PB flag to enable switch again
		; early 60 seconds for switch change acc if any attack type account train finish soon
		If $iDateCalc >= (-60 * ($iTotalDonateType + 1)) Then
			If $aSwitchList[$i][2] = 0 Then $bFlagGotTrainTimeout = True
			If $bFlagPriority = -1 And $aSwitchList[$i][7] = 1 And ($iNextAccSlot <> $aSwitchList[$i][4]) Then $bFlagPriority = $i
		EndIf
		; check the first donate acc
		If $iFirstAtkDonAcc = -1 Then
			If $aSwitchList[$i][2] = 1 Then
				$iFirstAtkDonAcc = $i ; first donate type account found
			EndIf
		EndIf

		If $aSwitchList[$i][4] = $iCurActiveAcc Then
			$bChangeNextAcc = True
			If $bFlagGotTrainTimeout = False Then
				$iStayRemain = TimerDiff($aSwitchList[$i][1])
				If $aSwitchList[$i][2] = 1 Then ; if current active account is donate type, then check for attack type acc if any available attack type acc for switch, if not just stay donate acc.
					If $ichkSwitchDonTypeOnlyWhenAtkTypeNotReady Then ; hidden option
						SetLog("Attack type account still didn't get ready, stay donate type account.",$COLOR_INFO)
						If $i = UBound($aSwitchList) - 1 Then
							If $iFirstAtkDonAcc <> $i Then ; check switch change other donate acc.
								If $aSwitchList[$iFirstAtkDonAcc][5] = 0 Then ; if not PB time
									If $iStayRemain >= (($aSwitchList[$i][6] * 60) * 1000) Then ; stay ? minutes before change account
										If $g_iSamM0dDebug = 1 Then SetLog("$aSwitchList[$iFirstAtkDonAcc][4]: " & $aSwitchList[$iFirstAtkDonAcc][4])
										SetLog("Switch other donate account: " & $aSwitchList[$iFirstAtkDonAcc][3],$COLOR_INFO)
										Return $aSwitchList[$iFirstAtkDonAcc][4]
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
				; stay ? minutes before change account
				If $iStayRemain <= (($aSwitchList[$i][6] * 60) * 1000) And $aSwitchList[$i][5] = 0 Then
					SetLog("Stay remain: " & ($aSwitchList[$i][6] * 60) - Int($iStayRemain / 1000) & " seconds",$COLOR_INFO)
					$bChangeNextAcc = False
				EndIf
			EndIf
		EndIf
	Next

	If $g_iSamM0dDebug = 1 Then SetLog("$iNextAccSlot: " & $iNextAccSlot)
	If $g_iSamM0dDebug = 1 Then SetLog("$bChangeNextAcc: " & $bChangeNextAcc)
	If $g_iSamM0dDebug = 1 Then SetLog("$bFlagGotTrainTimeout: " & $bFlagGotTrainTimeout)
	If $g_iSamM0dDebug = 1 Then SetLog("$iFirstAtkDonAcc: " & $iFirstAtkDonAcc)
	If $g_iSamM0dDebug = 1 Then SetLog("$bFlagDoSortSwitchList: " & $bFlagDoSortSwitchList)

	If $bFlagGotTrainTimeout = False Then
		If $bChangeNextAcc = False Then Return $iNextAccSlot
	Else
		If $iStayRemain > 0 Then
			SetLog("Stay voided, got attack type account ready for farming.",$COLOR_INFO)
		EndIf
	EndIf

	If $g_iSamM0dDebug = 1 Then SetLog("$iNextAccSlot1: " & $iNextAccSlot)

	If $bFlagPriority <> - 1 Then
		SetLog("Priority Account getting ready soon, switch to Priority Account",$COLOR_INFO)
		; move priority account to next switch account.
		For $i = 0 to UBound($aSwitchList) - 1
			If $aSwitchList[$i][4] = $iNextAccSlot Then
				If $i > $bFlagPriority Then
					For $j = $bFlagPriority To $i - 1
						_ArraySwap($aSwitchList,$j,$j+1,False)
					Next
					ExitLoop
				ElseIf $bFlagPriority > $i Then
					For $j = $bFlagPriority To $i + 2 Step -1
						_ArraySwap($aSwitchList,$j,$j-1,False)
					Next
					ExitLoop
				EndIf
			EndIf
		Next
	EndIf

	For $i = 0 to UBound($aSwitchList) - 1
		If $aSwitchList[$i][4] = $iNextAccSlot Then
			If $i >= UBound($aSwitchList) - 1 Then
				; this will be end of switch list, prepare sort switchlist with train time again
				$bFlagDoSortSwitchList = True
			Else
				$iNextAccSlot = $aSwitchList[$i+1][4]
				If $aSwitchList[$i+1][5] = 0 Then ExitLoop ; select this profile if not is PB activate
			EndIf
		EndIf
	Next

	If $g_iSamM0dDebug = 1 Then SetLog("$iNextAccSlot2: " & $iNextAccSlot)
	If $g_iSamM0dDebug = 1 Then SetLog("$bFlagDoSortSwitchList: " & $bFlagDoSortSwitchList)

	If $bFlagDoSortSwitchList Or $iCurActiveAcc = -1 Then
		sortSwitchList($bFlagPriority)
		;$iNextAccSlot = $aSwitchList[0][4]
		For $i = 0 to UBound($aSwitchList) - 1
			If $aSwitchList[$i][5] = 0 Then  ; select this profile if not is PB activate
				$iNextAccSlot = $aSwitchList[$i][4]
				If $ichkCanCloseGame = 1 Then
					Local $iDateCalc2 = _DateDiff('s', $aSwitchList[$i][0], _NowCalc()) ;compare date time from last check, return different seconds
					;SetLog("$iDateCalc2: " & $iDateCalc2)
					If $iDateCalc2 < 0 Then
						If 0 - $iDateCalc2  > Number($g_iCloseMinimumTime * 60) Then
							SetLog("New loop starting account: " & $aSwitchList[$i][4] + 1 & " - " & $aSwitchList[$i][3], $COLOR_INFO)
							SetLog("Army still got " & 0 - $iDateCalc2 & " second(s) to get ready.", $COLOR_INFO)
							If 0 - $iDateCalc2 > $itxtCanCloseGameTime Then
								$iMySwitchSmartWaitTime = (0 - $iDateCalc2) - $itxtCanCloseGameTime
								;SmartWait4TrainMini((0 - $iDateCalc2) - $itxtCanCloseGameTime)
							Else
								Setlog("Avoid smart wait for train, cause of army getting ready soon.", $COLOR_INFO)
							EndIf
						Else
							Setlog("Smart Wait Time < Minimum Time Required To Close [" & ($g_iCloseMinimumTime * 60) & " Sec.]", $COLOR_INFO)
							Setlog("Wait Train Time = " & 0 - $iDateCalc2 & " seconds.", $COLOR_INFO)
						EndIf
					EndIf
				EndIf
				ExitLoop
			EndIf
		Next
	EndIf

	If $g_iSamM0dDebug = 1 Then SetLog("$iNextAccSlot3: " & $iNextAccSlot)
	Return $iNextAccSlot
EndFunc

Func DoSwitchAcc()
	If _Sleep(500) Then Return

	If $iCurActiveAcc = - 1 Then
		$iDoPerformAfterSwitch = True
	Else
		If $iDoPerformAfterSwitch Then
			For $i = 0 To UBound($aSwitchList) - 1
				If $aSwitchList[$i][4] = $iCurActiveAcc Then
					If $aSwitchList[$i][2] <> 1 Then
						If $g_iSamM0dDebug = 1 Then SetLog("$g_bIsFullArmywithHeroesAndSpells: " & $g_bIsFullArmywithHeroesAndSpells)
						If $g_iSamM0dDebug = 1 Then SetLog("$ichkForcePreTrainB4Switch: " & $ichkForcePreTrainB4Switch)
						If $g_bIsFullArmywithHeroesAndSpells = True Or $ichkForcePreTrainB4Switch = 1 Then ;If $g_bIsFullArmywithHeroesAndSpells = True mean just back from attack, then we check train before switch acc.
							Local $bShare_replay = $g_bIsFullArmywithHeroesAndSpells
							SetLog("Check train before switch account...",$COLOR_ACTION)
							If $ichkModTrain = 1 Then
								ModTrain($ichkForcePreTrainB4Switch = 1)
							Else
								TrainRevamp()
							EndIf
							If $bShare_replay = True Then
								ReplayShare($g_bShareAttackEnableNow, True)
							EndIf
						EndIf
						If $bAvoidSwitch Then
							SetLog("Avoid switch, troops getting ready or soon.", $COLOR_INFO)
							Return
						EndIf
					EndIf
					ExitLoop
				EndIf
			Next
		EndIf
	EndIf

	If $iDoPerformAfterSwitch = False Then Return

	$iNextAcc = getNextSwitchList()

	If $g_iSamM0dDebug = 1 Then SetLog("$iCurActiveAcc: " & $iCurActiveAcc)
	If $g_iSamM0dDebug = 1 Then SetLog("$iNextAcc: " & $iNextAcc)

	If $iCurActiveAcc <> $iNextAcc Then
		If _Sleep(500) Then Return

		If $iCurActiveAcc <> - 1 Then
			;SetLog("Do train army and brew spell",$COLOR_ACTION)
			SetLog("Switch account from " & $icmbWithProfile[$iCurActiveAcc] & " to " & $icmbWithProfile[$iNextAcc] ,$COLOR_ACTION)
			saveCurStats($iCurActiveAcc)
		Else
			SetLog("Switch account start from " & $icmbWithProfile[$iNextAcc] ,$COLOR_ACTION)
		EndIf

		If _Sleep(500) Then Return

		Switch $icmbSwitchMethod
			Case 2
				PoliteCloseCoC("MySwitch", True)
				;If _Sleep(1500) Then Return False
				$iCurActiveAcc = $iNextAcc
				DoVillageLoadSucess($iCurActiveAcc)

			Case 1
				Local $iTempNextACC = -1
				For $i = 0 To UBound($aSwitchList) - 1
					If $aSwitchList[$i][4] = $iNextAcc Then
						$iTempNextACC = $i
						$aSwitchList[$i][1] = TimerInit()
					EndIf
				Next

				If $g_iSamM0dDebug = 1 Then SetLog("$iTempNextACC: " & $iTempNextACC)
				If $g_iSamM0dDebug = 1 Then SetLog("$aSwitchList[$iTempNextACC][3]: " & $aSwitchList[$iTempNextACC][3])
				If $g_iSamM0dDebug = 1 Then SetLog("$aSwitchList[$iTempNextACC][4]: " & $aSwitchList[$iTempNextACC][4])

				If $iTempNextACC <> - 1 Then
					If loadVillageFrom($aSwitchList[$iTempNextACC][3]) = True Then
						$iCurActiveAcc = $iNextAcc
						DoVillageLoadSucess($iCurActiveAcc)
					Else
						$g_bRestart = True
						$iSelectAccError += 1
						If $iSelectAccError > 2 Then
							$iSelectAccError = 0
							DoVillageLoadFailed()
						EndIf
					EndIf
				EndIf
			Case 0
				If $iMySwitchSmartWaitTime > 0 Then
					SmartWait4TrainMini($iMySwitchSmartWaitTime)
					$iMySwitchSmartWaitTime = 0
				EndIf
				If _CheckColorPixel($aButtonSMSetting[4], $aButtonSMSetting[5], $aButtonSMSetting[6], $aButtonSMSetting[7], $g_bCapturePixel, "aButtonSetting") Then
					If SelectGoogleAccount($iNextAcc) = True Then
						$iCurActiveAcc = $iNextAcc
						DoVillageLoadSucess($iCurActiveAcc)
					Else
						$g_bRestart = True
						$iSelectAccError += 1
						If $iSelectAccError > 2 Then
							$iSelectAccError = 0
							DoVillageLoadFailed()
						EndIf
					EndIf
				Else
					SetLog("Cannot find setting button.",$COLOR_RED)
					CloseCoC(True)
					Wait4Main()
					$g_bRestart = True
				EndIf
		EndSwitch

		GUICtrlSetData($grpMySwitch,"Current Active Acc: " & @CRLF & $aSwitchList[$iCurStep][4] + 1 & " - " & $aSwitchList[$iCurStep][3] & " [" & ($aSwitchList[$iCurStep][2] = 1 ? "D" : "A") &  "]")
		If $iCurActiveAcc <> - 1 Then
			GUICtrlSetData($g_hLblProfileName,$icmbWithProfile[$iCurActiveAcc])
		EndIf

		If $g_bCloseWhileTrainingEnable Then
			SetLog("Disable smart wait")
			GUICtrlSetState($g_hChkCloseWhileTraining, $GUI_UNCHECKED)
			$g_bCloseWhileTrainingEnable = False
		EndIf
	EndIf

	ClickP($aAway,1,0)
	If _Sleep(500) Then Return
EndFunc

Func DoVillageLoadSucess($iAcc)
	If $g_iSamM0dDebug = 1 Then SetLog("DoVillageLoadSucess: " & $icmbWithProfile[$iAcc])

	;SetLogCentered(" BOT LOG ", Default, Default, True)

	For $i = 0 To UBound($aSwitchList) - 1
		If $aSwitchList[$i][4] = $iAcc Then
			$iCurStep = $i
			$aSwitchList[$i][1] = TimerInit()
		EndIf
	Next

	setCombolistByText($g_hCmbProfile, $icmbWithProfile[$iAcc])

	SetLog("Prepare to load profile: " & GUICtrlRead($g_hCmbProfile),$COLOR_ACTION)
	cmbProfile()
	If $g_iSamM0dDebug = 1 Then SetLog("$iAcc: " & $iAcc)
	loadCurStats($iAcc)

	; after load new profile, reset variable below for new runbot() loop
	$g_bRestart = False
	$bDonateAwayFlag = False
	$bJustMakeDonate = False
	;$bNowWaitingConfirm = False

	$iDonatedUnit = 0
	$iTimeForLastShareFriendlyChallenge = 0
	$g_bFullArmy = False
	$g_bFullArmyHero = False
	$g_bFullArmySpells = False
	$g_FullCCTroops = False
	$g_bFullCCSpells = False

	$g_bIsClientSyncError = False
	$g_bIsSearchLimit = False
	$g_bQuickattack = False
	$g_asShieldStatus[0] = ""
	$g_asShieldStatus[1] = ""
	$g_asShieldStatus[2] = ""
	$g_sPBStartTime = ""
	$g_bShareAttackEnableNow = False


	myHeroStatus("King","Gray")
	myHeroStatus("Queen","Gray")
	myHeroStatus("Warden","Gray")

	GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
	GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
	GUICtrlSetState($g_hPicLabGray, $GUI_SHOW)

	; Mod Train
	;-----------------------------------------------------
	; reset Global variables for troops
	$tempDisableBrewSpell = False
	$tempDisableTrain = False
	For $i = 0 To UBound($g_avDTtroopsToBeUsed, 1) - 1
		$g_avDTtroopsToBeUsed[$i][1] = 0
	Next
	For $i = 0 To UBound($MyTroops) - 1
		Assign("cur" & $MyTroops[$i][0], 0)
		Assign("OnQ" & $MyTroops[$i][0], 0)
		Assign("OnT" & $MyTroops[$i][0], 0)
	Next

	; reset Global variables for spells
	For $i = $enumLightning To $enumSkeleton
		Assign("Cur" & $MySpells[$i][0] & "Spell", 0)
		Assign("OnQ" & $MySpells[$i][0] & "Spell", 0)
		Assign("OnT" & $MySpells[$i][0] & "Spell", 0)
	Next
	;-----------------------------------------------------

	;$iShouldRearm = (Random(0,1,1) = 0 ? 1 : 0)

	If $g_abNotNeedAllTime[0] = False Then $g_abNotNeedAllTime[0] = (Random(0,1,1) = 1 ? True : False) ; check rearm
	If $g_abNotNeedAllTime[1] = False Then $g_abNotNeedAllTime[1] = (Random(0,1,1) = 1 ? True : False) ; check tomb

	$g_iCommandStop = -1
	$iSelectAccError = 0

	If $icmbSwitchMethod = 2 Then
		If $iMySwitchSmartWaitTime > 0 Then
			SmartWait4TrainMini($iMySwitchSmartWaitTime, 1)
			$iMySwitchSmartWaitTime = 0
		Else
			OpenCoC()
			Wait4Main()
		EndIf
	EndIf
;~ 	If _Sleep(1000) Then Return
;~ 	checkMainScreen(True)
EndFunc

Func DoVillageLoadFailed()
	; Reboot Android
	SetLog("Restart emulator since cannot change account more than 2 times.",$COLOR_RED)
	Local $_NoFocusTampering = $g_bNoFocusTampering
	$g_bNoFocusTampering = True
	RebootAndroid()
	$g_bNoFocusTampering = $_NoFocusTampering
EndFunc

Func DoCheckSwitchEnable()
	; auto enable switch account if current profile are tick as enable switch profile
	$ichkEnableMySwitch = 0

	For $i = 0 To UBound($aSwitchList) - 1
		If $aSwitchList[$i][3] = $g_sProfileCurrentName Then
			$ichkEnableMySwitch = 1
			ExitLoop
		EndIf
	Next

	If UBound($aSwitchList) <= 1 Then $ichkEnableMySwitch = 0

	If $ichkEnableMySwitch = 1 Then
		GUICtrlSetState($chkEnableMySwitch, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkEnableMySwitch, $GUI_UNCHECKED)
	EndIf
EndFunc


Func saveCurStats($iSlot)
	For $i = 0 To 43
		$aProfileStats[$i][$iSlot+1] = Eval($aProfileStats[$i][0])
	Next
EndFunc

Func loadCurStats($iSlot)
	Local $aTemp[4] = [0,0,"",0]
	Local $aTempB[6] = [0,0,0,0,0,0]
	For $i = 0 To 30
		If $i <> 25 Then
			Assign($aProfileStats[$i][0],$aProfileStats[$i][$iSlot+1])
		EndIf
	Next

	If Not IsArray($aProfileStats[31][$iSlot+1]) Then
		$g_aiCurrentLoot = $aTemp
	Else
		$g_aiCurrentLoot = ($aProfileStats[31][$iSlot+1])
	EndIf

	If Not IsArray($aProfileStats[32][$iSlot+1]) Then
		$g_iStatsStartedWith = $aTemp
		$g_iStatsTotalGain = $aTemp
		$g_iStatsLastAttack = $aTemp
		$g_iStatsBonusLast = $aTemp
	Else
		$g_iStatsStartedWith = $aProfileStats[32][$iSlot+1]
		$g_iStatsTotalGain = $aProfileStats[33][$iSlot+1]
		$g_iStatsLastAttack = $aProfileStats[34][$iSlot+1]
		$g_iStatsBonusLast = $aProfileStats[35][$iSlot+1]
	EndIf

	If Not IsArray($aProfileStats[36][$iSlot+1]) Then
		$g_aiAttackedVillageCount = $aTempB
		$g_aiTotalGoldGain = $aTempB
		$g_aiTotalElixirGain = $aTempB
		$g_aiTotalDarkGain = $aTempB
		$g_aiTotalTrophyGain = $aTempB
		$g_aiNbrOfDetectedMines = $aTempB
		$g_aiNbrOfDetectedCollectors = $aTempB
		$g_aiNbrOfDetectedDrills = $aTempB
	Else
		$g_aiAttackedVillageCount = ($aProfileStats[36][$iSlot+1])
		$g_aiTotalGoldGain = $aProfileStats[37][$iSlot+1]
		$g_aiTotalElixirGain = $aProfileStats[38][$iSlot+1]
		$g_aiTotalDarkGain = $aProfileStats[39][$iSlot+1]
		$g_aiTotalTrophyGain = $aProfileStats[40][$iSlot+1]
		$g_aiNbrOfDetectedMines = $aProfileStats[41][$iSlot+1]
		$g_aiNbrOfDetectedCollectors = $aProfileStats[42][$iSlot+1]
		$g_aiNbrOfDetectedDrills = $aProfileStats[43][$iSlot+1]
	EndIf

	If $aProfileStats[25][$iSlot+1] = 0 And $g_iTownHallLevel > 0 Then $aProfileStats[25][$iSlot+1] = $g_iTownHallLevel

	displayStats($iSlot)
EndFunc

Func resetCurStats($iSlot)
;~ 	Local $aTemp[4] = [0,0,"",0]
;~ 	Local $aTempB[6] = [0,0,0,0,0,0]
	For $i = 0 To 43
		$aProfileStats[$i][$iSlot+1] = 0
	Next
;~ 	For $i = 31 To 35
;~ 		$aProfileStats[$i][$iSlot+1] = $aTemp
;~ 	Next
;~ 	For $i = 36 To 43
;~ 		$aProfileStats[$i][$iSlot+1] = $aTempB
;~ 	Next
EndFunc

Func DoViewStats1()
	If $iCurActiveAcc <> - 1 Then
		If UBound($aSwitchList) > 1 Then
			If $iCurStep > 0 Then
				$iCurStep -= 1
			Else
				$iCurStep = UBound($aSwitchList) - 1
			EndIf
		EndIf
		$bUpdateStats = False
		GUICtrlSetState($arrowleft2,$GUI_DISABLE + $GUI_HIDE)
		displayStats($aSwitchList[$iCurStep][4])
		GUICtrlSetData($g_hLblProfileName,$aSwitchList[$iCurStep][3])
		GUICtrlSetData($g_hGrpVillage, GetTranslatedFileIni("MBR GUI Design Bottom", "GrpVillage", "Village") & ": " & $aSwitchList[$iCurStep][3])
		GUICtrlSetState($arrowleft2,$GUI_ENABLE + $GUI_SHOW)
	EndIf
EndFunc

Func DoViewStats2()
	If $iCurActiveAcc <> - 1 Then
		If UBound($aSwitchList) > 1 Then
			If $iCurStep + 1 > UBound($aSwitchList) - 1 Then
				$iCurStep = 0
			Else
				$iCurStep += 1
			EndIf
		EndIf
		$bUpdateStats = False
		GUICtrlSetState($arrowright2,$GUI_DISABLE + $GUI_HIDE)
		displayStats($aSwitchList[$iCurStep][4])
		GUICtrlSetData($g_hLblProfileName,$aSwitchList[$iCurStep][3])
		GUICtrlSetData($g_hGrpVillage, GetTranslatedFileIni("MBR GUI Design Bottom", "GrpVillage", "Village") & ": " & $aSwitchList[$iCurStep][3])
		GUICtrlSetState($arrowright2,$GUI_ENABLE + $GUI_SHOW)
	EndIf
EndFunc

Func displayStats($iSlot)

	If $g_iFirstRun = 1 Then Return

	If $aProfileStats[0][$iSlot+1] > 0 Then
		;GUICtrlSetState($g_hLblLastAttackTemp, $GUI_HIDE)
		;GUICtrlSetState($g_hLblLastAttackBonusTemp, $GUI_HIDE)
		;GUICtrlSetState($g_hLblTotalLootTemp, $GUI_HIDE)
		;GUICtrlSetState($g_hLblHourlyStatsTemp, $GUI_HIDE)
		$aProfileStats[0][$iSlot+1] = 2
	Else
		;GUICtrlSetState($g_hLblLastAttackTemp, $GUI_SHOW)
		;GUICtrlSetState($g_hLblLastAttackBonusTemp, $GUI_SHOW)
		;GUICtrlSetState($g_hLblTotalLootTemp, $GUI_SHOW)
		;GUICtrlSetState($g_hLblHourlyStatsTemp, $GUI_SHOW)

		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootGold], "")
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootElixir], "")
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootDarkElixir], "")
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootTrophy], "")

		GUICtrlSetData($g_hLblResultGoldHourNow, "") ;GUI BOTTOM
		GUICtrlSetData($g_hLblResultElixirHourNow, "");GUI BOTTOM
		GUICtrlSetData($g_hLblResultDEHourNow, "") ;GUI BOTTOM

		GUICtrlSetData($g_ahLblStatsTotalGain[$eLootGold], "")
		GUICtrlSetData($g_ahLblStatsTotalGain[$eLootElixir], "")
		GUICtrlSetData($g_ahLblStatsTotalGain[$eLootDarkElixir], "")
		GUICtrlSetData($g_ahLblStatsTotalGain[$eLootTrophy], "")

		GUICtrlSetData($g_ahLblStatsLastAttack[$eLootGold], "")
		GUICtrlSetData($g_ahLblStatsLastAttack[$eLootElixir], "")
		GUICtrlSetData($g_ahLblStatsLastAttack[$eLootDarkElixir], "")
		GUICtrlSetData($g_ahLblStatsLastAttack[$eLootTrophy], "")

		GUICtrlSetData($g_ahLblStatsBonusLast[$eLootGold], "")
		GUICtrlSetData($g_ahLblStatsBonusLast[$eLootElixir], "")
		GUICtrlSetData($g_ahLblStatsBonusLast[$eLootDarkElixir], "")
	EndIf

	If IsArray($aProfileStats[32][$iSlot+1]) Then
		Local $tempProf = $aProfileStats[32][$iSlot+1]
		If $tempProf[2] <> "" Then
			If GUICtrlGetState($g_hLblResultDENow) = $GUI_ENABLE + $GUI_HIDE Then
				GUICtrlSetState($g_hPicResultDENow, $GUI_SHOW)
				If GUICtrlGetState($g_hLblResultGoldNow) = $GUI_ENABLE + $GUI_SHOW Then
					GUICtrlSetState($g_hLblResultDeNow, $GUI_SHOW)
					GUICtrlSetState($g_hLblResultDEHourNow, $GUI_HIDE)
				Else
					GUICtrlSetState($g_hLblResultDeNow, $GUI_HIDE)
					GUICtrlSetState($g_hLblResultDEHourNow, $GUI_SHOW)
				EndIf
			EndIf
		Else
			If GUICtrlGetState($g_hLblResultDENow) = $GUI_ENABLE + $GUI_SHOW Then
				GUICtrlSetState($g_hLblResultDeNow, $GUI_HIDE)
				GUICtrlSetState($g_hPicResultDENow, $GUI_HIDE)
				GUICtrlSetState($g_hLblResultDEHourNow, $GUI_HIDE)
			EndIf
		EndIf
	Else
		If GUICtrlGetState($g_hLblResultDENow) = $GUI_ENABLE + $GUI_SHOW Then
			GUICtrlSetState($g_hLblResultDeNow, $GUI_HIDE)
			GUICtrlSetState($g_hPicResultDENow, $GUI_HIDE)
			GUICtrlSetState($g_hLblResultDEHourNow, $GUI_HIDE)
		EndIf
	EndIf

	Local $aTemp[4] = [0,0,0,0]
	Local $tempStatsTotalGain
	Local $tempStats

	If Not IsArray($aProfileStats[32][$iSlot+1]) Then
		$tempStats = $aTemp
	Else
		$tempStats = $aProfileStats[32][$iSlot+1]
	EndIf
;~ 	SetLog("$tempStats[$eLootGold]: " & $tempStats[$eLootGold])
;~ 	SetLog("$tempStats[$eLootElixir]: " & $tempStats[$eLootElixir])
;~ 	SetLog("$tempStats[$eLootDarkElixir]: " & $tempStats[$eLootDarkElixir])
;~ 	SetLog("$tempStats[$eLootTrophy]: " & $tempStats[$eLootTrophy])

 	GUICtrlSetData($g_ahLblStatsStartedWith[$eLootGold], _NumberFormat($tempStats[$eLootGold], True))
 	GUICtrlSetData($g_ahLblStatsStartedWith[$eLootElixir], _NumberFormat($tempStats[$eLootElixir], True))
 	GUICtrlSetData($g_ahLblStatsStartedWith[$eLootDarkElixir], _NumberFormat($tempStats[$eLootDarkElixir], True))
 	GUICtrlSetData($g_ahLblStatsStartedWith[$eLootTrophy], _NumberFormat($tempStats[$eLootTrophy], True))

	If Not IsArray($aProfileStats[33][$iSlot+1]) Then
		$tempStats = $aTemp
	Else
		$tempStats = $aProfileStats[33][$iSlot+1]
	EndIf
	$tempStatsTotalGain = $tempStats
 	GUICtrlSetData($g_ahLblStatsTotalGain[$eLootGold], _NumberFormat($tempStats[0], True))
 	GUICtrlSetData($g_ahLblStatsTotalGain[$eLootElixir], _NumberFormat($tempStats[1], True))
 	GUICtrlSetData($g_ahLblStatsTotalGain[$eLootDarkElixir], _NumberFormat($tempStats[2], True))
 	GUICtrlSetData($g_ahLblStatsTotalGain[$eLootTrophy], _NumberFormat($tempStats[3], True))

	If Not IsArray($aProfileStats[34][$iSlot+1]) Then
		$tempStats = $aTemp
	Else
		$tempStats = $aProfileStats[34][$iSlot+1]
	EndIf
 	GUICtrlSetData($g_ahLblStatsLastAttack[$eLootGold], _NumberFormat($tempStats[0], True))
 	GUICtrlSetData($g_ahLblStatsLastAttack[$eLootElixir], _NumberFormat($tempStats[1], True))
 	GUICtrlSetData($g_ahLblStatsLastAttack[$eLootDarkElixir], _NumberFormat($tempStats[2], True))
 	GUICtrlSetData($g_ahLblStatsLastAttack[$eLootTrophy], _NumberFormat($tempStats[3], True))

	If Not IsArray($aProfileStats[35][$iSlot+1]) Then
		$tempStats = $aTemp
	Else
		$tempStats = $aProfileStats[35][$iSlot+1]
	EndIf
 	GUICtrlSetData($g_ahLblStatsBonusLast[$eLootGold], _NumberFormat($tempStats[0], True))
 	GUICtrlSetData($g_ahLblStatsBonusLast[$eLootElixir], _NumberFormat($tempStats[1], True))
 	GUICtrlSetData($g_ahLblStatsBonusLast[$eLootDarkElixir], _NumberFormat($tempStats[2], True))

	GUICtrlSetData($g_hLblresultvillagesskipped, _NumberFormat($aProfileStats[1][$iSlot+1], True))
	GUICtrlSetData($g_hLblResultSkippedHourNow, _NumberFormat($aProfileStats[1][$iSlot+1], True))
	GUICtrlSetData($g_hLblresulttrophiesdropped, _NumberFormat($aProfileStats[2][$iSlot+1], True))

	GUICtrlSetData($g_hLblWallUpgCostGold, _NumberFormat($aProfileStats[3][$iSlot+1], True))
	GUICtrlSetData($g_hLblWallUpgCostElixir, _NumberFormat($aProfileStats[4][$iSlot+1], True))
	GUICtrlSetData($g_hLblBuildingUpgCostGold, _NumberFormat($aProfileStats[5][$iSlot+1], True))
	GUICtrlSetData($g_hLblBuildingUpgCostElixir, _NumberFormat($aProfileStats[6][$iSlot+1], True))
	GUICtrlSetData($g_hLblHeroUpgCost, _NumberFormat($aProfileStats[7][$iSlot+1], True))
	GUICtrlSetData($g_hLblWallgoldmake, $aProfileStats[8][$iSlot+1])
	GUICtrlSetData($g_hLblWallelixirmake, $aProfileStats[9][$iSlot+1])
	GUICtrlSetData($g_hLblNbrOfBuildingUpgGold, $aProfileStats[10][$iSlot+1])
	GUICtrlSetData($g_hLblNbrOfBuildingUpgElixir, $aProfileStats[11][$iSlot+1])
	GUICtrlSetData($g_hLblNbrOfHeroUpg, $aProfileStats[12][$iSlot+1])
	GUICtrlSetData($g_hLblSearchCost, _NumberFormat($aProfileStats[13][$iSlot+1], True))
	GUICtrlSetData($g_hLblTrainCostElixir, _NumberFormat($aProfileStats[14][$iSlot+1], True))
	GUICtrlSetData($g_hLblTrainCostDElixir, _NumberFormat($aProfileStats[15][$iSlot+1], True))
	GUICtrlSetData($g_hLblNbrOfOoS, $aProfileStats[16][$iSlot+1])
	GUICtrlSetData($g_hLblNbrOfTSFailed, $aProfileStats[17][$iSlot+1])
	GUICtrlSetData($g_hLblNbrOfTSSuccess, $aProfileStats[18][$iSlot+1])
	GUICtrlSetData($g_hLblGoldFromMines, _NumberFormat($aProfileStats[19][$iSlot+1], True))
	GUICtrlSetData($g_hLblElixirFromCollectors, _NumberFormat($aProfileStats[20][$iSlot+1], True))
	GUICtrlSetData($g_hLblDElixirFromDrills, _NumberFormat($aProfileStats[21][$iSlot+1], True))
	GUICtrlSetData($g_hLblResultBuilderNow, $aProfileStats[22][$iSlot+1] & "/" & $aProfileStats[23][$iSlot+1])
	GUICtrlSetData($g_hLblResultGemNow, _NumberFormat($aProfileStats[24][$iSlot+1], True))

;~ 	GUICtrlSetData($g_hLblresultvillagesskipped, _NumberFormat($aProfileStats[16][$iSlot+1], True))
;~ 	GUICtrlSetData($g_hLblResultSkippedHourNow, _NumberFormat($aProfileStats[16][$iSlot+1], True))
;~ 	GUICtrlSetData($g_hLblresulttrophiesdropped, _NumberFormat($aProfileStats[17][$iSlot+1], True))
;~ 	GUICtrlSetData($g_hLblNbrOfHeroUpg, $aProfileStats[27][$iSlot+1])


	Local $aTemp[4] = [0,0,0,0]

	Local $tempCurrentLoot[$eLootCount]

	Local $tempAttackedVillageCount[$g_iModeCount+1]
	Local $tempTotalGoldGain[$g_iModeCount+1]
	Local $tempTotalElixirGain[$g_iModeCount+1]
	Local $tempTotalDarkGain[$g_iModeCount+1]
	Local $tempTotalTrophyGain[$g_iModeCount+1]

	Local $tempNbrOfDetectedMines[$g_iModeCount+1]
	Local $tempNbrOfDetectedCollectors[$g_iModeCount+1]
	Local $tempNbrOfDetectedDrills[$g_iModeCount+1]

	If Not IsArray($aProfileStats[31][$iSlot+1]) Then
		$tempCurrentLoot = $aTemp
	Else
		$tempCurrentLoot = $aProfileStats[31][$iSlot+1]
	EndIf

	GUICtrlSetData($g_hLblResultGoldNow, _NumberFormat($tempCurrentLoot[$eLootGold], True))
	GUICtrlSetData($g_hLblResultElixirNow, _NumberFormat($tempCurrentLoot[$eLootElixir], True))
	GUICtrlSetData($g_hLblResultDeNow, _NumberFormat($tempCurrentLoot[$eLootDarkElixir], True))
	GUICtrlSetData($g_hLblResultTrophyNow, _NumberFormat($tempCurrentLoot[$eLootTrophy], True))

	If Not IsArray($aProfileStats[36][$iSlot+1]) Then
		$tempAttackedVillageCount = $aTemp
		$tempTotalGoldGain = $aTemp
		$tempTotalElixirGain = $aTemp
		$tempTotalDarkGain = $aTemp
		$tempTotalTrophyGain = $aTemp
		$tempNbrOfDetectedMines = $aTemp
		$tempNbrOfDetectedCollectors = $aTemp
		$tempNbrOfDetectedDrills = $aTemp
	Else
		$tempAttackedVillageCount = $aProfileStats[36][$iSlot+1]
		$tempTotalGoldGain = $aProfileStats[37][$iSlot+1]
		$tempTotalElixirGain = $aProfileStats[38][$iSlot+1]
		$tempTotalDarkGain = $aProfileStats[39][$iSlot+1]
		$tempTotalTrophyGain = $aProfileStats[40][$iSlot+1]
		$tempNbrOfDetectedMines = $aProfileStats[41][$iSlot+1]
		$tempNbrOfDetectedCollectors = $aProfileStats[42][$iSlot+1]
		$tempNbrOfDetectedDrills = $aProfileStats[43][$iSlot+1]
	EndIf

	Local $iAttackedCount = 0

	For $i = 0 To $g_iModeCount
		GUICtrlSetData($g_hLblAttacked[$i], _NumberFormat($tempAttackedVillageCount[$i], True))
		$iAttackedCount += $tempAttackedVillageCount[$i]

		GUICtrlSetData($g_hLblTotalGoldGain[$i], _NumberFormat($tempTotalGoldGain[$i], True))
		GUICtrlSetData($g_hLblTotalElixirGain[$i], _NumberFormat($tempTotalElixirGain[$i], True))

		GUICtrlSetData($g_hLblTotalDElixirGain[$i], _NumberFormat($tempTotalDarkGain[$i], True))
		GUICtrlSetData($g_hLblTotalTrophyGain[$i], _NumberFormat($tempTotalTrophyGain[$i], True))
	Next

	GUICtrlSetData($g_hLblresultvillagesattacked, _NumberFormat($iAttackedCount, True))
	GUICtrlSetData($g_hLblResultAttackedHourNow, _NumberFormat($iAttackedCount, True))

	For $i = 0 To $g_iModeCount
		If $i = $TS Then ContinueLoop
		GUICtrlSetData($g_hLblNbrOfDetectedMines[$i], $tempNbrOfDetectedMines[$i])
		GUICtrlSetData($g_hLblNbrOfDetectedCollectors[$i], $tempNbrOfDetectedCollectors[$i])
		GUICtrlSetData($g_hLblNbrOfDetectedDrills[$i], $tempNbrOfDetectedDrills[$i])
	Next

	If $aProfileStats[0][$iSlot+1] = 2 Then

		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootGold], _NumberFormat(Round($tempStatsTotalGain[$eLootGold] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h")
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootElixir], _NumberFormat(Round($tempStatsTotalGain[$eLootElixir] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h")
		If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
			GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootDarkElixir], _NumberFormat(Round($tempStatsTotalGain[$eLootDarkElixir] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h")
		EndIf
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootTrophy], _NumberFormat(Round($tempStatsTotalGain[$eLootTrophy] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h")

		GUICtrlSetData($g_hLblResultGoldHourNow, _NumberFormat(Round($tempStatsTotalGain[$eLootGold] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h") ;GUI BOTTOM
		GUICtrlSetData($g_hLblResultElixirHourNow, _NumberFormat(Round($tempStatsTotalGain[$eLootElixir] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h") ;GUI BOTTOM
		If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
			GUICtrlSetData($g_hLblResultDEHourNow, _NumberFormat(Round($tempStatsTotalGain[$eLootDarkElixir] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h") ;GUI BOTTOM
		EndIf
	EndIf

;~    ; SmartZap DE Gain - From ChaCalGyn(LunaEclipse) - DEMEN
	GUICtrlSetData($lblMySmartZap, _NumberFormat($aProfileStats[28][$iSlot+1], True))
	GUICtrlSetData($g_hLblSmartZap, _NumberFormat($aProfileStats[28][$iSlot+1], True))

;~ 	; SmartZap Spells Used  From ChaCalGyn(LunaEclipse) - DEMEN
	GUICtrlSetData($lblMyLightningUsed, _NumberFormat($aProfileStats[30][$iSlot+1], True))
	GUICtrlSetData($g_hLblSmartLightningUsed, _NumberFormat($aProfileStats[30][$iSlot+1], True))
	GUICtrlSetData($g_hLblSmartEarthQuakeUsed, _NumberFormat($aProfileStats[29][$iSlot+1], True))

	_GUI_Value_STATE("HIDE",$g_aGroupListTHLevels)
	If $aProfileStats[25][$iSlot+1] >= 4 And $aProfileStats[25][$iSlot+1] <= 11 Then
		GUICtrlSetState($g_ahPicTHLevels[$aProfileStats[25][$iSlot+1]], $GUI_SHOW)
	EndIf
	GUICtrlSetData($g_hLblTHLevels, $aProfileStats[25][$iSlot+1])

	GUICtrlSetData($g_hLblLeague, "")
	If $aProfileStats[27][$iSlot+1] = 1 Then
		GUICtrlSetData($g_hLblLeague, "1")
	ElseIf $aProfileStats[27][$iSlot+1] = 2 Then
		GUICtrlSetData($g_hLblLeague, "2")
	ElseIf $aProfileStats[27][$iSlot+1] = 3 Then
		GUICtrlSetData($g_hLblLeague, "3")
	EndIf

	_GUI_Value_STATE("HIDE",$g_aGroupLeague)

	If String($aProfileStats[26][$iSlot+1]) = "B" Then
		GUICtrlSetState($g_ahPicLeague[$eLeagueBronze], $GUI_SHOW)
	ElseIf String($aProfileStats[26][$iSlot+1]) = "S" Then
		GUICtrlSetState($g_ahPicLeague[$eLeagueSilver], $GUI_SHOW)
	ElseIf String($aProfileStats[26][$iSlot+1]) = "G" Then
		GUICtrlSetState($g_ahPicLeague[$eLeagueGold], $GUI_SHOW)
	ElseIf String($aProfileStats[26][$iSlot+1]) = "c" Then
		GUICtrlSetState($g_ahPicLeague[$eLeagueCrystal], $GUI_SHOW)
	ElseIf String($aProfileStats[26][$iSlot+1]) = "M" Then
		GUICtrlSetState($g_ahPicLeague[$eLeagueMaster], $GUI_SHOW)
	ElseIf String($aProfileStats[26][$iSlot+1]) = "C" Then
		GUICtrlSetState($g_ahPicLeague[$eLeagueChampion], $GUI_SHOW)
	ElseIf String($aProfileStats[26][$iSlot+1]) = "T" Then
		GUICtrlSetState($g_ahPicLeague[$eLeagueTitan], $GUI_SHOW)
	ElseIf String($aProfileStats[26][$iSlot+1]) = "LE" Then
		GUICtrlSetState($g_ahPicLeague[$eLeagueLegend], $GUI_SHOW)
	Else
		GUICtrlSetState($g_ahPicLeague[$eLeagueUnranked],$GUI_SHOW)
	EndIf

EndFunc

Func btnMakeSwitchADBFolder()
	Local $currentRunState = $g_bRunState
	Local $bFileFlag = 0
	Local $iCount = 0
	Local $bshared_prefs_file = False
	Local $bVillagePng = False
	Local $sMyProfilePath4shared_prefs = @ScriptDir & "\profiles\" & $g_sProfileCurrentName & "\shared_prefs"

	$g_bRunState = True

	_GUICtrlTab_ClickTab($g_hTabMain, 0)
	SetLog(_PadStringCenter(" Start ", 50, "="),$COLOR_INFO)
	If _Sleep(200) Then Return False
	checkMainScreen(False, False)
	If _Sleep(200) Then Return False

	; remove old village before new copy
	If FileExists(@ScriptDir & "\profiles\" & $g_sProfileCurrentName & "\village_92.png") Then
		SetLog("Removing previous village_92.png", $COLOR_INFO)
		FileDelete(@ScriptDir & "\profiles\" & $g_sProfileCurrentName & "\village_92.png")
		If FileExists(@ScriptDir & "\profiles\" & $g_sProfileCurrentName & "\village_92.png") Then
			SetLog("Cannot remove previous village_92.png", $COLOR_INFO)
		Else
			SetLog("Previous village_92.png removed.", $COLOR_INFO)
		EndIf
	EndIf
	If FileExists($sMyProfilePath4shared_prefs) Then
		SetLog("Removing previous shared_prefs", $COLOR_INFO)
		DirRemove($sMyProfilePath4shared_prefs, 1)
		If FileExists($sMyProfilePath4shared_prefs) Then
			SetLog("Cannot remove previous shared_prefs", $COLOR_INFO)
		Else
			SetLog("Previous shared_prefs removed.", $COLOR_INFO)
		EndIf
	EndIf

	If Not _CheckColorPixel($aButtonClose3[4], $aButtonClose3[5], $aButtonClose3[6], $aButtonClose3[7], $g_bCapturePixel, "aButtonClose3") Then
		ClickP($aAway, 1, 0, "#0221") ;Click Away
		If _Sleep($DELAYPROFILEREPORT1) Then Return
		If _CheckColorPixel($aIsMain[0], $aIsMain[1], $aIsMain[2], $aIsMain[3], $g_bCapturePixel, "aIsMain") Then
			Click(30, 40, 1, 0, "#0222") ; Click Info Profile Button
			; Waiting for profile page fully load.
			ForceCaptureRegion()
			$iCount = 0
			While 1
				_CaptureRegion()
				If _ColorCheck(_GetPixelColor(250, 95, $g_bNoCapturePixel), Hex(0XE8E8E0,6), 10) = True And _ColorCheck(_GetPixelColor(360, 145, $g_bNoCapturePixel), Hex(0XE8E8E0,6), 10) = False Then
					ExitLoop
				EndIf
				If _Sleep(250) Then Return False
				$iCount += 1
				If $iCount > 40 Then ExitLoop
			WEnd
		Else
			SetLog("Unable to locate main screen.", $COLOR_ERROR)
			Return
		EndIf
	EndIf

	_CaptureRegion()
	If _CheckColorPixel($aButtonClose3[4], $aButtonClose3[5], $aButtonClose3[6], $aButtonClose3[7], $g_bNoCapturePixel, "aButtonClose3") Then
		Local $iSecondBaseTabHeight
		If _CheckColorPixel(146,146,0XB8B8A8,10,$g_bNoCapturePixel,"Profile Check Builder Base Tab") = True Then
			$iSecondBaseTabHeight = 49
		Else
			$iSecondBaseTabHeight = 0
		EndIf

		Local $hClone = _GDIPlus_BitmapCloneArea($g_hBitmap, 70,127 + $iSecondBaseTabHeight, 80,17, $GDIP_PXF24RGB)
		_GDIPlus_ImageSaveToFile($hClone, @ScriptDir & "\profiles\" & $g_sProfileCurrentName & "\village_92.png")
		If FileExists(@ScriptDir & "\profiles\" & $g_sProfileCurrentName & "\village_92.png") Then
			SetLog("village_92.png captured.", $COLOR_INFO)
			$bFileFlag = BitOR($bFileFlag, 2)
		EndIf

		If $g_sAndroidGameDistributor = $g_sGoogle Then
			ClickP($aAway,1,0)
			If _Sleep(250) Then Return False
			Click($aButtonSMSetting[0],$aButtonSMSetting[1],1,0,"#Setting")
			If Not _Wait4Pixel($aButtonClose2[4], $aButtonClose2[5], $aButtonClose2[6], $aButtonClose2[7], 1500, 100) Then
				SetLog("Cannot load setting page, restart game...", $COLOR_RED)
			EndIf
			If _CheckColorPixel($aButtonGoogleConnectGreen[4], $aButtonGoogleConnectGreen[5], $aButtonGoogleConnectGreen[6], $aButtonGoogleConnectGreen[7], $g_bCapturePixel, "aButtonGoogleConnectGreen") Then
				Click($aButtonGoogleConnectGreen[0],$aButtonGoogleConnectGreen[1],1,0,"#ConnectGoogle")
			EndIf
			If Not _Wait4Pixel($aButtonGoogleConnectRed[4], $aButtonGoogleConnectRed[5], $aButtonGoogleConnectRed[6], $aButtonGoogleConnectRed[7], 1500, 100) Then
				SetLog("Cannot disconnect to google.", $COLOR_RED)
			Else
				SetLog("Disconnected to google.", $COLOR_INFO)
			EndIf
			ClickP($aAway,1,0)
			If Not _Wait4Pixel($aIsMain[0], $aIsMain[1], $aIsMain[2], $aIsMain[3], 1500, 100) Then
				SetLog("Cannot back to main screen.", $COLOR_RED)
			EndIf
		EndIf

		Local $iResult

		PoliteCloseCoC("MySwitch", True)
		;If _Sleep(1500) Then Return False

		If $g_iSamM0dDebug = 1 Then SetLog("$g_sEmulatorInfo4MySwitch: " & $g_sEmulatorInfo4MySwitch)

		$iResult = RunWait($g_sAndroidAdbPath & " -s " & $g_sAndroidAdbDevice & " shell "& Chr(34) & "su -c 'chmod 777 /data/data/" & $g_sAndroidGamePackage & "/shared_prefs; mkdir /sdcard/tempshared; cp /data/data/" & $g_sAndroidGamePackage & _
		"/shared_prefs/* /sdcard/tempshared; exit; exit'" & Chr(34), "", @SW_HIDE)
		If $iResult = 0 Then
			$iResult = RunWait($g_sAndroidAdbPath & " -s " & $g_sAndroidAdbDevice & " pull /sdcard/tempshared " & Chr(34) & $sMyProfilePath4shared_prefs & Chr(34), "", @SW_HIDE)
			If $iResult = 0 Then
				$iResult = RunWait($g_sAndroidAdbPath & " -s " & $g_sAndroidAdbDevice & " shell "& Chr(34) & "su -c 'rm -r /sdcard/tempshared; exit; exit'" & Chr(34), "", @SW_HIDE)
			EndIf
		EndIf

		If @error Then
			SetLog("Failed to run adb command.", $COLOR_ERROR)
		Else
			If $iResult = 0 Then
				If FileExists($sMyProfilePath4shared_prefs & "\storage.xml") Then
					SetLog("shared_prefs captured.", $COLOR_INFO)
					$bFileFlag = BitOR($bFileFlag, 1)
				EndIf
			Else
				SetLog("Failed to run operate adb command.", $COLOR_ERROR)
			EndIf
		EndIf

		Switch $bFileFlag
			Case 3
				SetLog(GetTranslatedFileIni("sam m0d", "MySwitch_Capture_Msg1", "Sucess: shared_prefs copied and village_92.png captured."), $COLOR_INFO)
			Case 2
				SetLog(GetTranslatedFileIni("sam m0d", "MySwitch_Capture_Msg2", "Failed to copy shared_prefs from emulator, but village_92.png captured."), $COLOR_ERROR)
			Case 1
				SetLog(GetTranslatedFileIni("sam m0d", "MySwitch_Capture_Msg3", "Failed to capture village_92.png from emulator, but shared_prefs copied."), $COLOR_ERROR)
			Case Else
				SetLog(GetTranslatedFileIni("sam m0d", "MySwitch_Capture_Msg4", "Failed to copy shared_prefs and capture village_92.png from emulator."), $COLOR_ERROR)
		EndSwitch
		OpenCoC()
		Wait4Main()
	Else
		SetLog(GetTranslatedFileIni("sam m0d", "MySwitch_Capture_Shared_Prefs_Error", "Please open emulator and coc, then go to profile page before doing this action."), $COLOR_ERROR)
	EndIf

	SetLog(_PadStringCenter(" End ", 50, "="),$COLOR_INFO)
	$g_bRunState = $currentRunState
EndFunc

Func Pushshared_prefs($Profilename)
	Local $iResult
	Local $sMyProfilePath4shared_prefs = @ScriptDir & "\profiles\" & $Profilename & "\shared_prefs"
	Local $hostPath = $g_sAndroidPicturesHostPath & $g_sAndroidPicturesHostFolder & "shared_prefs"
	Local $androidPath = $g_sAndroidPicturesPath & StringReplace($g_sAndroidPicturesHostFolder, "\", "/") & "shared_prefs/"
	Local $bSuccess

	If FileExists($sMyProfilePath4shared_prefs & "\storage.xml") Then
		$iResult = DirCopy($sMyProfilePath4shared_prefs, $hostPath, 1)
		If $iResult = 1 Then
			$iResult = RunWait($g_sAndroidAdbPath & " -s " & $g_sAndroidAdbDevice & " shell "& Chr(34) & "su -c 'chmod 777 /data/data/" & $g_sAndroidGamePackage & "/shared_prefs; " & _
			"cp -r " & $androidPath & "* /data/data/" & $g_sAndroidGamePackage & "/shared_prefs; cd /data/data/" & $g_sAndroidGamePackage & "/shared_prefs; " & _
			"find -name 'com.facebook.internal.preferences.APP_SETTINGS.xml' -type f -exec rm -f {} +; " & _
			"find -name 'com.google.android.gcm.xml' -type f -exec rm -f {} +; " & _
			"find -name 'com.mobileapptracking.xml' -type f -exec rm -f {} +; " & _
			"find -name '*.bak' -type f -exec rm -f {} +; " & _
			"exit; exit'" & Chr(34), "", @SW_HIDE)
			$bSuccess = False
			If @error = 0 And $iResult = 0 Then
				SetLog("shared_prefs copy to emulator should be okay.", $COLOR_INFO)
				$bSuccess = True
			Else
				SetLog("shell command failed on copy shared_prefs to game folder, Result= " & $iResult, $COLOR_ERROR)
			EndIf
			$iResult = DirRemove($hostPath, 1)
			If $iResult <> 1 Then
				SetLog("Failed to remove directory " & $hostPath & ", Result= " & $iResult, $COLOR_ERROR)
			EndIf
			If $bSuccess Then Return True
		Else
			SetLog("Failed to copy directory from " & $sMyProfilePath4shared_prefs & " to " & $hostPath & ", Result= " & $iResult, $COLOR_ERROR)
		EndIf
	Else
		SetLog($sMyProfilePath4shared_prefs & "\storage.xml not found.", $COLOR_ERROR)
	EndIf
	Return False
EndFunc

Func btnPushshared_prefs()
	Local $currentRunState = $g_bRunState
	$g_bRunState = True

	GUICtrlSetState($btnPushshared_prefs, $GUI_DISABLE)

	Local $hTimer = __TimerInit()

	Switch $icmbSwitchMethod
		Case 2
			SetLog("Start game client switch")
			If _CheckColorPixel($aIsMain[0], $aIsMain[1], $aIsMain[2], $aIsMain[3], $g_bCapturePixel, "aIsMain") Or _CheckColorPixel($aIsMainGrayed[0], $aIsMainGrayed[1], $aIsMainGrayed[2], $aIsMainGrayed[3], $g_bCapturePixel, "aIsMainGrayed") Then
				ClickP($aAway,1,0)
				If _Sleep(300) Then Return
				PoliteCloseCoC("MySwitch", True)
			Else
				CloseCoC()
			EndIf

			OpenCoC()
			Wait4Main()
		Case 1
			SetLog("Start shared_prefs switch")
			If _CheckColorPixel($aIsMain[0], $aIsMain[1], $aIsMain[2], $aIsMain[3], $g_bCapturePixel, "aIsMain") Or _CheckColorPixel($aIsMainGrayed[0], $aIsMainGrayed[1], $aIsMainGrayed[2], $aIsMainGrayed[3], $g_bCapturePixel, "aIsMainGrayed") Then
				ClickP($aAway,1,0)
				If _Sleep(300) Then Return
				PoliteCloseCoC("MySwitch", True)
			Else
				CloseCoC()
			EndIf
			Pushshared_prefs($g_sProfileCurrentName)
			OpenCoC()
			Wait4Main()
		Case 0
			SetLog("Start google switch")
			If _CheckColorPixel($aIsMain[0], $aIsMain[1], $aIsMain[2], $aIsMain[3], $g_bCapturePixel, "aIsMain") Or _CheckColorPixel($aIsMainGrayed[0], $aIsMainGrayed[1], $aIsMainGrayed[2], $aIsMainGrayed[3], $g_bCapturePixel, "aIsMainGrayed") Then
				ClickP($aAway,1,0)
				If _Sleep(300) Then Return
			Else
				CloseCoC(True)
				Wait4Main()
			EndIf

			Local $i
			Local $sProfile = GUICtrlRead($g_hCmbProfile2)
			Local $iSlot4Switch = -1
			For $i = 0 To 7
				If $icmbWithProfile[$i] = $sProfile Then
						$iSlot4Switch = $i
					ExitLoop
				EndIf
			Next
			If $iSlot4Switch <> -1 Then
				SelectGoogleAccount($iSlot4Switch)
			EndIf
	EndSwitch

	myHeroStatus("King","Gray")
	myHeroStatus("Queen","Gray")
	myHeroStatus("Warden","Gray")

	GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
	GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
	GUICtrlSetState($g_hPicLabGray, $GUI_SHOW)

	SetLog("Switch finished, elapsed: " & Round(__TimerDiff($hTimer) / 1000, 2) & "s")
	GUICtrlSetState($btnPushshared_prefs, $GUI_ENABLE)
	$g_bRunState = $currentRunState
EndFunc

Func loadVillageFrom($Profilename)
	PoliteCloseCoC("MySwitch", True)
	If Pushshared_prefs($Profilename) Then
		If $iMySwitchSmartWaitTime > 0 Then
			SmartWait4TrainMini($iMySwitchSmartWaitTime, 1)
			$iMySwitchSmartWaitTime = 0
		Else
			OpenCoC()
			Wait4Main()
		EndIf
		Return True
	EndIf
	Return False
EndFunc

Func checkProfileCorrect()
	If IsMainPage() Then
		Click($aButtonOpenProfile[0],$aButtonOpenProfile[1],1,0,"#0222")
		If _Sleep(1000) Then Return False

		Local $iCount, $iImageNotMatchCount
		Local $bVillagePageFlag = False
		Local $iSecondBaseTabHeight

		; Waiting for profile page fully load.
		ForceCaptureRegion()
		$iCount = 0
		While 1
			_CaptureRegion()
			If _ColorCheck(_GetPixelColor(250, 95, $g_bNoCapturePixel), Hex(0XE8E8E0,6), 10) = True And _ColorCheck(_GetPixelColor(360, 145, $g_bNoCapturePixel), Hex(0XE8E8E0,6), 10) = False Then
				ExitLoop
			EndIf
			If _Sleep(250) Then Return False
			$iCount += 1
			If $iCount > 40 Then ExitLoop
		WEnd

		$iCount = 0
		$iImageNotMatchCount = 0

		While 1
			_CaptureRegion()
			If _ColorCheck(_GetPixelColor(146, 146, $g_bNoCapturePixel), Hex(0XB8B8A8,6), 10) = True Then
				$iSecondBaseTabHeight = 49
			Else
				$iSecondBaseTabHeight = 0
			EndIf

			If $g_iSamM0dDebug = 1 Then SetLog("_GetPixelColor(85, " & 163 + $iSecondBaseTabHeight & ", True): " & _GetPixelColor(85, 163 + $iSecondBaseTabHeight, $g_bNoCapturePixel))
			If $g_iSamM0dDebug = 1 Then SetLog("_GetPixelColor(20, " & 295 + $iSecondBaseTabHeight & ", True): " & _GetPixelColor(20, 295 + $iSecondBaseTabHeight, $g_bNoCapturePixel))

			$bVillagePageFlag = _ColorCheck(_GetPixelColor(85, 163 + $iSecondBaseTabHeight, $g_bNoCapturePixel), Hex(0X959AB6,6), 20) = True And _ColorCheck(_GetPixelColor(20, 295 + $iSecondBaseTabHeight, $g_bNoCapturePixel), Hex(0X4E4D79,6), 10) = True

			If $bVillagePageFlag = True Then
				_CaptureRegion(68,125 + $iSecondBaseTabHeight,155,146 + $iSecondBaseTabHeight)
				Local $result = DllCall($g_hLibMyBot, "str", "FindTile", "handle", $g_hHBitmap, "str", @ScriptDir & "\profiles\" & $g_sProfileCurrentName & "\village_92.png", "str", "FV", "int", 1)
				If @error Then _logErrorDLLCall($g_sLibMyBotPath, @error)
				If IsArray($result) Then
					If $g_iSamM0dDebug = 1 Then SetLog("DLL Call succeeded " & $result[0], $COLOR_ERROR)
					If $result[0] = "0" Or $result[0] = "" Then
						If $g_iSamM0dDebug = 1 Then SetLog("Image not found", $COLOR_ERROR)
						$bVillagePageFlag = False
						$iImageNotMatchCount += 1
						If $iImageNotMatchCount > 3 Then
							Return False
						EndIf
					ElseIf StringLeft($result[0], 2) = "-1" Then
						SetLog("DLL Error: " & $result[0], $COLOR_ERROR)
					Else
						If $g_iSamM0dDebug = 1 Then SetLog("$result[0]: " & $result[0])
						Local $aCoor = StringSplit($result[0],"|",$STR_NOCOUNT)
						If IsArray($aCoor) Then
							If StringLeft($aCoor[1], 2) <> "-1" Then
								ExitLoop
							EndIf
						EndIf
					EndIf
				EndIf
			Else
				ClickDrag(380, 140 + $g_iMidOffsetY + $iSecondBaseTabHeight, 380, 580 + $g_iMidOffsetY, 500)
			EndIf
			$iCount += 1
			If $iCount > 15 Then
				SetLog("Cannot load profile page...", $COLOR_RED)
				ClickP($aAway,1,0)
				Return False
			EndIf
			If _Sleep(100) Then Return False
		WEnd

		ClickP($aAway,1,0)
		If _Sleep(1000) Then Return True
		Return True
	EndIf
	Return False
EndFunc

Func Wait4Main($bBuilderBase = False)
	Local $iCount
	For $i = 0 To 105
		$iCount += 1
		If $iCount > 120 Then ExitLoop
		If $g_iSamM0dDebug = 1 Then Setlog("Wait4Main Loop = " & $i & "   ExitLoop = " & $iCount, $COLOR_DEBUG) ; Debug stuck loop
		ForceCaptureRegion()
		_CaptureRegion()
		If _CheckColorPixel($aIsMain[0], $aIsMain[1], $aIsMain[2], $aIsMain[3], $g_bNoCapturePixel, "aIsMain") Then
			If $g_iSamM0dDebug = 1 Then Setlog("Main Village - Screen cleared, Wait4Main exit", $COLOR_DEBUG)
			Return True
		ElseIf _CheckColorPixel($aIsOnBuilderBase[0], $aIsOnBuilderBase[1], $aIsOnBuilderBase[2], $aIsOnBuilderBase[3], $g_bNoCapturePixel, "aIsOnBuilderIsland") Then
			If Not $bBuilderBase Then
				ZoomOut()
				SwitchBetweenBases()
				If $i <> 0 Then $i -= 1
				ContinueLoop
			EndIf
			If $g_iSamM0dDebug = 1 Then Setlog("Builder Base - Screen cleared, Wait4Main exit", $COLOR_DEBUG)
			Return True
		Else
			If TestCapture() = False And _Sleep($DELAYWAITMAINSCREEN1) Then Return
			; village was attacked okay button
			If _ColorCheck(_GetPixelColor(402, 516, $g_bNoCapturePixel), Hex(0xFFFFFF, 6), 5) And _ColorCheck(_GetPixelColor(405, 537, $g_bNoCapturePixel), Hex(0x5EAC10, 6), 20) Then
				Click($aButtonVillageWasAttackOK[0],$aButtonVillageWasAttackOK[1],1,0,"#VWAO")
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

Func SmartWait4TrainMini($iWaitTime, $iFlagCloseAndOpenType = 0)
	; Determine state of $StopEmulator flag
	Local $StopEmulator = False
	Local $bFullRestart = False
	Local $bSuspendComputer = False
	If $g_bCloseRandom = True Then $StopEmulator = "random"
	If $g_bCloseEmulator = True Then $StopEmulator = True
	If $g_bSuspendComputer = True Then $bSuspendComputer = True
	SetLog("Smart Wait For Train Enabled.", $COLOR_INFO)

	Switch $iFlagCloseAndOpenType
		Case 0
			UniversalCloseWaitOpenCoC($iWaitTime * 1000, "SmartWait4TrainMini_", $StopEmulator, $bFullRestart, $bSuspendComputer)
		Case 1
			WaitnOpenCoC($iWaitTime * 1000, $bFullRestart, $bSuspendComputer, True)
	EndSwitch
EndFunc