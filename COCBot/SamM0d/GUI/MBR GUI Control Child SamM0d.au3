Func chkMyTroopOrder()
	If GUICtrlRead($chkMyTroopsOrder) = $GUI_CHECKED Then
		$ichkMyTroopsOrder = 1
	Else
		$ichkMyTroopsOrder = 0
	EndIf
EndFunc

Func cmbMyTroopOrder()
	Local $tempOrder[19]
	For $i = 0 To 18
		$tempOrder[$i] = Int(GUICtrlRead(Eval("cmbMy" & $MyTroops[$i][0] & "Order")))
	Next
	For $i = 0 To 18
		If $tempOrder[$i] <> $MyTroops[$i][1] Then
			For $j = 0 To 18
				If $MyTroops[$j][1] = $tempOrder[$i] Then
					$tempOrder[$j] = Int($MyTroops[$i][1])
					ExitLoop
				EndIf
			Next
			ExitLoop
		EndIf
	Next
	For $i = 0 To 18
		$MyTroopsSetting[$icmbTroopSetting][$i][1] = Int($tempOrder[$i])
		$MyTroops[$i][1] = $MyTroopsSetting[$icmbTroopSetting][$i][1]
		_GUICtrlComboBox_SetCurSel(Eval("cmbMy" & $MyTroops[$i][0] & "Order"), $MyTroops[$i][1]-1)
	Next
	;_ArrayDisplay($MyTroops,"MyTroops")
EndFunc

Func UpdateTroopSetting()
	For $i = 0 To UBound($MyTroops) - 1
		$MyTroopsSetting[$icmbTroopSetting][$i][0] = Int(GUICtrlRead(Eval("txtMy" & $MyTroops[$i][0])))
		$MyTroops[$i][3] =  $MyTroopsSetting[$icmbTroopSetting][$i][0]
	Next
	UpdateTroopSize()
	If $g_iSamM0dDebug = 1 Then SetLog("$g_iMyTroopsSize: " & $g_iMyTroopsSize)
EndFunc

Func UpdateTroopSize()
	$g_iMyTroopsSize = 0
	For $i = 0 To UBound($MyTroops) - 1
		$g_iMyTroopsSize += $MyTroops[$i][3] * $MyTroops[$i][2]
	Next
	Local $iTempCampSize = 0
	If $g_iTotalCampSpace = 0 Then
		If GUICtrlRead($g_hChkTotalCampForced) = $GUI_CHECKED Then
			$iTempCampSize = GUICtrlRead($g_hTxtTotalCampForced)
		EndIf
	Else
		If GUICtrlRead($g_hChkTotalCampForced) = $GUI_CHECKED And Number(GUICtrlRead($g_hTxtTotalCampForced)) > $g_iTotalCampSpace Then
			$iTempCampSize = Number(GUICtrlRead($g_hTxtTotalCampForced))
		Else
			$iTempCampSize = $g_iTotalCampSpace
		EndIf
	EndIf
	$g_iTrainArmyFullTroopPct = Int(GUICtrlRead($g_hTxtFullTroop))
	GUICtrlSetData($lblTotalCapacityOfMyTroops,GetTranslatedFileIni("sam m0d", 76, "Total") & ": " & $g_iMyTroopsSize & "/" & Int(($iTempCampSize * $g_iTrainArmyFullTroopPct) / 100))
	If $g_iMyTroopsSize > (($iTempCampSize * $g_iTrainArmyFullTroopPct) / 100) Then
		GUICtrlSetColor($lblTotalCapacityOfMyTroops,$COLOR_RED)
		GUICtrlSetData($idProgressbar,100)
		_SendMessage(GUICtrlGetHandle($idProgressbar), $PBM_SETSTATE, 2) ; red
	Else
		GUICtrlSetColor($lblTotalCapacityOfMyTroops,$COLOR_BLACK)
		GUICtrlSetData($idProgressbar, Int(($g_iMyTroopsSize / (($iTempCampSize * $g_iTrainArmyFullTroopPct) / 100)) * 100))
		_SendMessage(GUICtrlGetHandle($idProgressbar), $PBM_SETSTATE, 1) ; green
	EndIf
EndFunc

Func cmbMySpellOrder()
	Local $tempOrder[10]

	For $i = 0 To 9
		$tempOrder[$i] = Int(GUICtrlRead(Eval("cmbMy" & $MySpells[$i][0] & "SpellOrder")))
	Next
	For $i = 0 To 9
		If $tempOrder[$i] <> $MySpells[$i][1] Then
			For $j = 0 To 9
				If $MySpells[$j][1] = $tempOrder[$i] Then
					$tempOrder[$j] = Int($MySpells[$i][1])
					ExitLoop
				EndIf
			Next
			ExitLoop
		EndIf
	Next
	For $i = 0 To 9
		$MySpellSetting[$icmbTroopSetting][$i][1] = Int($tempOrder[$i])
		$MySpells[$i][1] =  $MySpellSetting[$icmbTroopSetting][$i][1]
		_GUICtrlComboBox_SetCurSel(Eval("cmbMy" & $MySpells[$i][0] & "SpellOrder"), $MySpells[$i][1]-1)
	Next
EndFunc

Func UpdatePreSpellSetting()
	$g_bDoPrebrewspell = 0
	For $i = 0 To UBound($MySpells) - 1
		If GUICtrlRead(Eval("chkPre" & $MySpells[$i][0])) = $GUI_CHECKED Then
			$MySpellSetting[$icmbTroopSetting][$i][2] = 1
		Else
			$MySpellSetting[$icmbTroopSetting][$i][2] = 0
		EndIf
		Assign("ichkPre" & $MySpells[$i][0],  $MySpellSetting[$icmbTroopSetting][$i][2])
		$g_bDoPrebrewspell = BitOR($g_bDoPrebrewspell, $MySpellSetting[$icmbTroopSetting][$i][2])
	Next
EndFunc

Func UpdateSpellSetting()
	$g_iMySpellsSize = 0
	For $i = 0 To UBound($MySpells) - 1
		$MySpellSetting[$icmbTroopSetting][$i][0] = Int(GUICtrlRead(Eval("txtNum" & $MySpells[$i][0] & "Spell")))
		$MySpells[$i][3] = $MySpellSetting[$icmbTroopSetting][$i][0]
		$g_iMySpellsSize += $MySpells[$i][3] * $MySpells[$i][2]
	Next
	If $g_iMySpellsSize < GUICtrlRead($txtTotalCountSpell2) + 1 Then
		GUICtrlSetBkColor($txtNumLightningSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumHealSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumRageSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumJumpSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumFreezeSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumCloneSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumPoisonSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumEarthSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumHasteSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumSkeletonSpell, $COLOR_MONEYGREEN)
	Else
		GUICtrlSetBkColor($txtNumLightningSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumHealSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumRageSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumFreezeSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumCloneSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumJumpSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumPoisonSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumEarthSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumHasteSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumSkeletonSpell, $COLOR_RED)
	EndIf
	If $g_iSamM0dDebug = 1 Then SetLog("$g_iMySpellsSize: " & $g_iMySpellsSize)
EndFunc

Func chkDisablePretrainTroops()
	$ichkDisablePretrainTroops = (GUICtrlRead($chkDisablePretrainTroops) = $GUI_CHECKED ? 1 : 0)
EndFunc

;~ Func chkEnableADBClick()
;~ 	$g_bAndroidAdbClicksEnabled = (GUICtrlRead($chkEnableADBClick) = $GUI_CHECKED ? 1 : 0)
;~ EndFunc

Func chkCustomTrain()
	$ichkModTrain = (GUICtrlRead($chkModTrain) = $GUI_CHECKED ? 1 : 0)
EndFunc

Func cmbTroopSetting()
	For $i = 0 To UBound($MyTroops) - 1
		$MyTroopsSetting[$icmbTroopSetting][$i][0] = Int(GUICtrlRead(Eval("txtMy" & $MyTroops[$i][0])))
		$MyTroopsSetting[$icmbTroopSetting][$i][1] = Int(GUICtrlRead(Eval("cmbMy"& $MyTroops[$i][0] & "Order")))
	Next
	For $i = 0 To UBound($MySpells) - 1
		If GUICtrlRead(Eval("chkPre" & $MySpells[$i][0])) = $GUI_CHECKED Then
			$MySpellSetting[$icmbTroopSetting][$i][2] = 1
		Else
			$MySpellSetting[$icmbTroopSetting][$i][2] = 0
		EndIf
		$MySpellSetting[$icmbTroopSetting][$i][0] = Int(GUICtrlRead(Eval("txtNum" & $MySpells[$i][0] & "Spell")))
		$MySpellSetting[$icmbTroopSetting][$i][1] = Int(GUICtrlRead(Eval("cmbMy" & $MySpells[$i][0] & "SpellOrder")))
	Next

	$icmbTroopSetting = _GUICtrlComboBox_GetCurSel($cmbTroopSetting)

	;$ichkMyTroopsOrder = IniRead($g_sProfileConfigPath, "MyTroops", "Order" & $icmbTroopSetting, "0")

	For $i = 0 To UBound($MyTroops) - 1
		$MyTroops[$i][3] =  $MyTroopsSetting[$icmbTroopSetting][$i][0]
		$MyTroops[$i][1] =  $MyTroopsSetting[$icmbTroopSetting][$i][1]
	Next
	$g_bDoPrebrewspell = 0
	For $i = 0 To UBound($MySpells) - 1
		Assign("ichkPre" & $MySpells[$i][0],  $MySpellSetting[$icmbTroopSetting][$i][2])
		$g_bDoPrebrewspell = BitOR($g_bDoPrebrewspell, $MySpellSetting[$icmbTroopSetting][$i][2])
		$MySpells[$i][3] =  $MySpellSetting[$icmbTroopSetting][$i][0]
		$MySpells[$i][1] =  $MySpellSetting[$icmbTroopSetting][$i][1]
	Next

	For $i = 0 To UBound($MyTroops)-1
		GUICtrlSetData(Eval("txtMy" & $MyTroops[$i][0]), $MyTroops[$i][3])
		_GUICtrlComboBox_SetCurSel(Eval("cmbMy" & $MyTroops[$i][0] & "Order"), $MyTroops[$i][1]-1)
	Next

	For $i = 0 To UBound($MySpells)-1
		If Eval("ichkPre" & $MySpells[$i][0]) = 1 Then
			GUICtrlSetState(Eval("chkPre" & $MySpells[$i][0]), $GUI_CHECKED)
		Else
			GUICtrlSetState(Eval("chkPre" & $MySpells[$i][0]), $GUI_UNCHECKED)
		EndIf
		GUICtrlSetData(Eval("txtNum" & $MySpells[$i][0] & "Spell"), $MySpells[$i][3])
		_GUICtrlComboBox_SetCurSel(Eval("cmbMy" & $MySpells[$i][0] & "SpellOrder"), $MySpells[$i][1]-1)
	Next

	;cmbMyTroopOrder()
	;cmbMySpellOrder()
	UpdateTroopSize()
	lblMyTotalCountSpell()
EndFunc

Func cmbMyQuickTrain()
	$icmbMyQuickTrain = _GUICtrlComboBox_GetCurSel($cmbMyQuickTrain)
EndFunc

Func btnResetTroops()
	For $i = 0 To 18
		GUICtrlSetData(Eval("txtMy" & $MyTroops[$i][0]),"0")
		$MyTroops[$i][3] = 0
	Next
	UpdateTroopSetting()
EndFunc

Func btnResetOrder()
	For $i = 0 To 18
		_GUICtrlComboBox_SetCurSel(Eval("cmbMy" & $MyTroops[$i][0] & "Order"), $i)
		$MyTroops[$i][1] = $i + 1
	Next
EndFunc

Func btnResetSpells()
	For $i = 0 To 9
		GUICtrlSetData(Eval("txtNum" & $MySpells[$i][0] & "Spell"),"0")
		$MySpells[$i][3] = 0
	Next
EndFunc

Func btnResetSpellOrder()
	For $i = 0 To 9
		_GUICtrlComboBox_SetCurSel(Eval("cmbMy" & $MySpells[$i][0] & "SpellOrder"), $i)
		$MySpells[$i][1] = $i + 1
	Next
EndFunc

Func chkUnitFactor()
	If GUICtrlRead($chkUnitFactor) = $GUI_CHECKED Then
		$ichkUnitFactor = 1
		GUICtrlSetState($txtUnitFactor, $GUI_ENABLE)
	Else
		$ichkUnitFactor = 0
		GUICtrlSetState($txtUnitFactor, $GUI_DISABLE)
	EndIf
	$itxtUnitFactor = GUICtrlRead($txtUnitFactor)
EndFunc

Func chkWaveFactor()
	If GUICtrlRead($chkWaveFactor) = $GUI_CHECKED Then
		$ichkWaveFactor = 1
		GUICtrlSetState($txtWaveFactor, $GUI_ENABLE)
	Else
		$ichkWaveFactor = 0
		GUICtrlSetState($txtWaveFactor, $GUI_DISABLE)
	EndIf
	$itxtWaveFactor = GUICtrlRead($txtWaveFactor)
EndFunc

Func chkDBCollectorsNearRedline()
	If GUICtrlRead($chkDBCollectorsNearRedline) = $GUI_CHECKED Then
		$ichkDBCollectorsNearRedline = 1
	Else
		$ichkDBCollectorsNearRedline = 0
	EndIf
EndFunc

Func cmbRedlineTiles()
	$icmbRedlineTiles = _GUICtrlComboBox_GetCurSel($cmbRedlineTiles)
EndFunc

Func chkEnableDeleteExcessTroops()
	If GUICtrlRead($chkEnableDeleteExcessTroops) = $GUI_CHECKED Then
		$ichkEnableDeleteExcessTroops = 1
	Else
		$ichkEnableDeleteExcessTroops = 0
	EndIf
EndFunc

Func chkEnableDeleteExcessSpells()
	If GUICtrlRead($chkEnableDeleteExcessSpells) = $GUI_CHECKED Then
		$ichkEnableDeleteExcessSpells = 1
	Else
		$ichkEnableDeleteExcessSpells = 0
	EndIf
EndFunc

Func chkForcePreBrewSpell()
	If GUICtrlRead($chkForcePreBrewSpell) = $GUI_CHECKED Then
		$ichkForcePreBrewSpell = 1
	Else
		$ichkForcePreBrewSpell = 0
	EndIf
EndFunc

Func chkAutoDock()
	If GUICtrlRead($chkAutoDock) = $GUI_CHECKED Then
		$ichkAutoDock = 1
		If $g_bChkAutoHideEmulator Then
			$g_bChkAutoHideEmulator = False
			GUICtrlSetState($chkAutoHideEmulator, $GUI_UNCHECKED)
		EndIf
	Else
		$ichkAutoDock = 0
	EndIf
EndFunc

Func chkAutoHideEmulator()
	If GUICtrlRead($chkAutoHideEmulator) = $GUI_CHECKED Then
		$g_bChkAutoHideEmulator = True
		If $ichkAutoDock Then
			$ichkAutoDock = 0
			GUICtrlSetState($chkAutoDock, $GUI_UNCHECKED)
		EndIf
	Else
		$g_bChkAutoHideEmulator = False
	EndIf
EndFunc

Func chkAutoMinimizeBot()
	If GUICtrlRead($chkAutoMinimizeBot) = $GUI_CHECKED Then
		$g_bChkAutoMinimizeBot = True
	Else
		$g_bChkAutoMinimizeBot = False
	EndIf
EndFunc

Func lblMyTotalCountSpell()
	_GUI_Value_STATE("HIDE", $groupListMySpells)
	; calculate $iTotalTrainSpaceSpell value
	$g_iMySpellsSize = Int((GUICtrlRead($txtNumLightningSpell) * 2) + (GUICtrlRead($txtNumHealSpell) * 2) + (GUICtrlRead($txtNumRageSpell) * 2) + (GUICtrlRead($txtNumJumpSpell) * 2) + _
			(GUICtrlRead($txtNumFreezeSpell) * 2) + (GUICtrlRead($txtNumCloneSpell) * 4) + GUICtrlRead($txtNumPoisonSpell) + GUICtrlRead($txtNumHasteSpell) + GUICtrlRead($txtNumEarthSpell) + GUICtrlRead($txtNumSkeletonSpell))

	_GUICtrlComboBox_SetCurSel($g_hTxtTotalCountSpell, _GUICtrlComboBox_GetCurSel($txtTotalCountSpell2))

	If $g_iMySpellsSize < GUICtrlRead($txtTotalCountSpell2) + 1 Then
		GUICtrlSetBkColor($txtNumLightningSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumHealSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumRageSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumJumpSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumFreezeSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumCloneSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumPoisonSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumEarthSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumHasteSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumSkeletonSpell, $COLOR_MONEYGREEN)
	Else
		GUICtrlSetBkColor($txtNumLightningSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumHealSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumRageSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumFreezeSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumCloneSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumJumpSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumPoisonSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumEarthSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumHasteSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumSkeletonSpell, $COLOR_RED)
	EndIf
	$g_iTownHallLevel = Int($g_iTownHallLevel)
	If $g_iTownHallLevel > 4 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $groupMyLightning)
	Else
		GUICtrlSetData($txtNumLightningSpell, 0)
		GUICtrlSetData($txtNumRageSpell, 0)
		GUICtrlSetData($txtNumHealSpell, 0)
		GUICtrlSetData($txtNumJumpSpell, 0)
		GUICtrlSetData($txtNumFreezeSpell, 0)
		GUICtrlSetData($txtNumCloneSpell, 0)
		GUICtrlSetData($txtNumPoisonSpell, 0)
		GUICtrlSetData($txtNumEarthSpell, 0)
		GUICtrlSetData($txtNumHasteSpell, 0)
		GUICtrlSetData($txtNumSkeletonSpell, 0)
		GUICtrlSetData($txtTotalCountSpell2, 0)
	EndIf
	If $g_iTownHallLevel > 5 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $groupMyHeal)
	Else
		GUICtrlSetData($txtNumRageSpell, 0)
		GUICtrlSetData($txtNumJumpSpell, 0)
		GUICtrlSetData($txtNumFreezeSpell, 0)
		GUICtrlSetData($txtNumCloneSpell, 0)
		GUICtrlSetData($txtNumPoisonSpell, 0)
		GUICtrlSetData($txtNumEarthSpell, 0)
		GUICtrlSetData($txtNumHasteSpell, 0)
		GUICtrlSetData($txtNumSkeletonSpell, 0)
	EndIf
	If $g_iTownHallLevel > 6 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $groupMyRage)
	Else
		GUICtrlSetData($txtNumJumpSpell, 0)
		GUICtrlSetData($txtNumFreezeSpell, 0)
		GUICtrlSetData($txtNumCloneSpell, 0)
		GUICtrlSetData($txtNumPoisonSpell, 0)
		GUICtrlSetData($txtNumEarthSpell, 0)
		GUICtrlSetData($txtNumHasteSpell, 0)
		GUICtrlSetData($txtNumSkeletonSpell, 0)
	EndIf
	If $g_iTownHallLevel > 7 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $groupMyPoison)
		_GUI_Value_STATE("SHOW", $groupMyEarthquake)
	Else
		GUICtrlSetData($txtNumJumpSpell, 0)
		GUICtrlSetData($txtNumFreezeSpell, 0)
		GUICtrlSetData($txtNumCloneSpell, 0)
		GUICtrlSetData($txtNumHasteSpell, 0)
		GUICtrlSetData($txtNumSkeletonSpell, 0)
	EndIf
	If $g_iTownHallLevel > 8 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $groupMyJumpSpell)
		_GUI_Value_STATE("SHOW", $groupMyFreeze)
		_GUI_Value_STATE("SHOW", $groupMyHaste)
		_GUI_Value_STATE("SHOW", $groupMySkeleton)
	Else
		GUICtrlSetData($txtNumCloneSpell, 0)
	EndIf
	If $g_iTownHallLevel > 9 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $groupMyClone)
	EndIf
	If $g_iSamM0dDebug = 1 Then SetLog("$g_iMySpellsSize: " & $g_iMySpellsSize)

EndFunc   ;==>lblTotalCountSpell

Func chkCheck4CC()
	If GUICtrlRead($chkCheck4CC) = $GUI_CHECKED Then
		$ichkCheck4CC = 1
		GUICtrlSetState($txtCheck4CCWaitTime, $GUI_ENABLE)

	Else
		$ichkCheck4CC = 0
		GUICtrlSetState($txtCheck4CCWaitTime, $GUI_DISABLE)
	EndIf
	$itxtCheck4CCWaitTime = GUICtrlRead($txtCheck4CCWaitTime)
	If $itxtCheck4CCWaitTime = 0 Then
		$itxtCheck4CCWaitTime = 7
		GUICtrlSetData($txtCheck4CCWaitTime,$itxtCheck4CCWaitTime)
	EndIf
EndFunc

Func chkWait4CC()
	If GUICtrlRead($chkWait4CC) = $GUI_CHECKED Then
		$g_iChkWait4CC = 1
		GUICtrlSetState($txtCCStrength, $GUI_ENABLE)
		GUICtrlSetState($cmbCCTroopSlot1, $GUI_ENABLE)
		GUICtrlSetState($cmbCCTroopSlot2, $GUI_ENABLE)
		GUICtrlSetState($cmbCCTroopSlot3, $GUI_ENABLE)
		GUICtrlSetState($txtCCTroopSlotQty1, $GUI_ENABLE)
		GUICtrlSetState($txtCCTroopSlotQty2, $GUI_ENABLE)
		GUICtrlSetState($txtCCTroopSlotQty3, $GUI_ENABLE)
	Else
		$g_iChkWait4CC = 0
		GUICtrlSetState($txtCCStrength, $GUI_DISABLE)
		GUICtrlSetState($cmbCCTroopSlot1, $GUI_DISABLE)
		GUICtrlSetState($cmbCCTroopSlot2, $GUI_DISABLE)
		GUICtrlSetState($cmbCCTroopSlot3, $GUI_DISABLE)
		GUICtrlSetState($txtCCTroopSlotQty1, $GUI_DISABLE)
		GUICtrlSetState($txtCCTroopSlotQty2, $GUI_DISABLE)
		GUICtrlSetState($txtCCTroopSlotQty3, $GUI_DISABLE)
	EndIf
	$CCStrength = GUICtrlRead($txtCCStrength)

	$iCCTroopSlot1 = _GUICtrlComboBox_GetCurSel($cmbCCTroopSlot1)
	$iCCTroopSlot2 = _GUICtrlComboBox_GetCurSel($cmbCCTroopSlot2)
	$iCCTroopSlot3 = _GUICtrlComboBox_GetCurSel($cmbCCTroopSlot3)
	$iCCTroopSlotQty1 = GUICtrlRead($txtCCTroopSlotQty1)
	$iCCTroopSlotQty2 = GUICtrlRead($txtCCTroopSlotQty2)
	$iCCTroopSlotQty3 = GUICtrlRead($txtCCTroopSlotQty3)
EndFunc

Func chkWait4CCSpell()
	If GUICtrlRead($chkWait4CCSpell) = $GUI_CHECKED Then
		$g_iChkWait4CCSpell = 1
		GUICtrlSetState($cmbCCSpellSlot1, $GUI_ENABLE)
		GUICtrlSetState($cmbCCSpellSlot2, $GUI_ENABLE)
		GUICtrlSetState($txtCCSpellSlotQty1, $GUI_ENABLE)
		GUICtrlSetState($txtCCSpellSlotQty2, $GUI_ENABLE)
	Else
		$g_iChkWait4CCSpell = 0
		GUICtrlSetState($cmbCCSpellSlot1, $GUI_DISABLE)
		GUICtrlSetState($cmbCCSpellSlot2, $GUI_DISABLE)
		GUICtrlSetState($txtCCSpellSlotQty1, $GUI_DISABLE)
		GUICtrlSetState($txtCCSpellSlotQty2, $GUI_DISABLE)
	EndIf
	$iCCSpellSlot1 = _GUICtrlComboBox_GetCurSel($cmbCCSpellSlot1)
	$iCCSpellSlot2 = _GUICtrlComboBox_GetCurSel($cmbCCSpellSlot2)
	$iCCSpellSlotQty1 = GUICtrlRead($txtCCSpellSlotQty1)
	$iCCSpellSlotQty2 = GUICtrlRead($txtCCSpellSlotQty2)
EndFunc

Func txtStickToTrainWindow()
	$itxtStickToTrainWindow = GUICtrlRead($txtStickToTrainWindow)
	If $itxtStickToTrainWindow > 5 Then
		$itxtStickToTrainWindow = 5
		GUICtrlSetData($txtStickToTrainWindow,5)
	EndIf
EndFunc

Func chkIncreaseGlobalDelay()
	If GUICtrlRead($chkIncreaseGlobalDelay) = $GUI_CHECKED Then
		$ichkIncreaseGlobalDelay = 1
		GUICtrlSetState($txtIncreaseGlobalDelay, $GUI_ENABLE)
	Else
		$ichkIncreaseGlobalDelay = 0
		GUICtrlSetState($txtIncreaseGlobalDelay, $GUI_DISABLE)
	EndIf
	$itxtIncreaseGlobalDelay = GUICtrlRead($txtIncreaseGlobalDelay)
EndFunc

;~ Func cmbCoCVersion()
;~ 	Local $iSection = GUICtrlRead($cmbCoCVersion)
;~ 	$AndroidGamePackage = IniRead(@ScriptDir & "\COCBot\COCVersions.ini",$iSection,"1PackageName",$AndroidGamePackage)
;~ 	$AndroidGameClass = IniRead(@ScriptDir & "\COCBot\COCVersions.ini",$iSection,"2ActivityName",$AndroidGameClass)
;~ EndFunc

Func cmbZapMethod()
	If GUICtrlRead($chkUseSamM0dZap) = $GUI_CHECKED Then
		$ichkUseSamM0dZap = 1
	Else
		$ichkUseSamM0dZap = 0
	EndIf
EndFunc   ;==>chkSmartLightSpell

Func chkEnableHLFClickSetlog()
	If GUICtrlRead($chkEnableHLFClickSetlog) = $GUI_CHECKED Then
		$EnableHMLSetLog = 1
	Else
		$EnableHMLSetLog = 0
	EndIf
	SetLog("HLFClickSetlog " & ($EnableHMLSetLog = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkEnableHLFClickSetlog

Func sldHLFClickDelayTime()
	$isldHLFClickDelayTime = GUICtrlRead($sldHLFClickDelayTime)
	GUICtrlSetData($lblHLFClickDelayTime, $isldHLFClickDelayTime & " ms")
EndFunc   ;==>sldHLFClickDelayTime

Func chkEnableHLFClick()
	If GUICtrlRead($chkEnableHLFClick) = $GUI_CHECKED Then
		GUICtrlSetState($sldHLFClickDelayTime, $GUI_ENABLE)
		$ichkEnableHLFClick = 1
	Else
		GUICtrlSetState($sldHLFClickDelayTime, $GUI_DISABLE)
		$ichkEnableHLFClick = 0
	EndIf
EndFunc

Func chkSmartUpdateWall()
	If GUICtrlRead($chkSmartUpdateWall) = $GUI_CHECKED Then
		GUICtrlSetState($txtClickWallDelay, $GUI_ENABLE)
		If $g_bDebugSetlog Then SetLog("BaseNode: " & $aBaseNode[0] & "," & $aBaseNode[1])
		If $g_bDebugSetlog Then SetLog("LastWall: " & $aLastWall[0] & "," & $aLastWall[1])
		If $g_bDebugSetlog Then SetLog("FaceDirection: " & $iFaceDirection)
	Else
		GUICtrlSetState($txtClickWallDelay, $GUI_DISABLE)
		; reset all data
		$aLastWall[0] = -1
		$aLastWall[1] = -1
		$aBaseNode[0] = -1
		$aBaseNode[1] = -1
		$iFaceDirection = 1
	EndIf
EndFunc

Func chkDropCCFirst()
	$ichkDropCCFirst = (GUICtrlRead($chkDropCCFirst) = $GUI_CHECKED ? 1 : 0)
EndFunc

Func ForcePretrainTroops()
	$ichkForcePreTrainTroops = (GUICtrlRead($chkForcePreTrainTroops) = $GUI_CHECKED ? 1: 0)
	$itxtForcePreTrainStrength = GUICtrlRead($txtForcePreTrainStrength)
EndFunc

;~ Func chkEnableCacheTroopImageFirst()
;~ 	$ichkEnableCacheTroopImageFirst	= (GUICtrlRead($chkEnableCacheTroopImageFirst) = $GUI_CHECKED ? 1: 0)
;~ EndFunc

Func chkEnableCustomOCR4CCRequest()
	$ichkEnableCustomOCR4CCRequest = (GUICtrlRead($chkEnableCustomOCR4CCRequest) = $GUI_CHECKED ? 1 : 0)
EndFunc

Func chkEnableUseEventTroop()
	$ichkEnableUseEventTroop = (GUICtrlRead($chkEnableUseEventTroop) = $GUI_CHECKED ? 1 : 0)
EndFunc

Func chkEnableDonateWhenReady()
	$ichkEnableDonateWhenReady = (GUICtrlRead($chkEnableDonateWhenReady) = $GUI_CHECKED ? 1 : 0)
EndFunc

Func chkEnableStopBotWhenLowBattery()
	$ichkEnableStopBotWhenLowBattery = (GUICtrlRead($chkEnableStopBotWhenLowBattery) = $GUI_CHECKED ? 1 : 0)
EndFunc

;~ Func chkRemoveSpecialObstacleBB()
;~ 	If GUICtrlRead($chkRemoveSpecialObstacleBB) = $GUI_CHECKED Then
;~ 		$ichkRemoveSpecialObstacleBB = 1
;~ 	Else
;~ 		$ichkRemoveSpecialObstacleBB = 0
;~ 	EndIf
;~ EndFunc

;~ Func chkDisablePauseTrayTip()
;~ 	$ichkDisablePauseTrayTip = (GUICtrlRead($chkDisablePauseTrayTip) = $GUI_CHECKED ? 1 : 0)
;~ EndFunc

Func chkBotLogLineLimit()
	$ichkBotLogLineLimit = (GUICtrlRead($chkBotLogLineLimit) = $GUI_CHECKED ? 1 : 0)
	GUICtrlSetState($txtLogLineLimit, ($ichkBotLogLineLimit = 1 ? $GUI_ENABLE : $GUI_DISABLE))
EndFunc

Func txtLogLineLimit()
	$itxtLogLineLimit = GUICtrlRead($txtLogLineLimit)
EndFunc

Func chkEnableLogoutLimit()
	$ichkEnableLogoutLimit = (GUICtrlRead($chkEnableLogoutLimit) = $GUI_CHECKED ? 1 : 0)
	GUICtrlSetState($txtLogoutLimitTime, ($ichkEnableLogoutLimit = 1 ? $GUI_ENABLE : $GUI_DISABLE))
EndFunc

Func txtLogoutLimitTime()
	$itxtLogoutLimitTime = GUICtrlRead($txtLogoutLimitTime)
EndFunc

Func chkEnableLimitDonateUnit()
	$ichkEnableLimitDonateUnit = (GUICtrlRead($chkEnableLimitDonateUnit) = $GUI_CHECKED ? 1 : 0)
	GUICtrlSetState($txtLimitDonateUnit, ($ichkEnableLimitDonateUnit = 1 ? $GUI_ENABLE : $GUI_DISABLE))
EndFunc

Func txtLimitDonateUnit()
	$itxtLimitDonateUnit = GUICtrlRead($txtLimitDonateUnit)
EndFunc

Func g_hChkSamM0dDebugOCR()
	$g_iSamM0dDebugOCR = (GUICtrlRead($g_hChkSamM0dDebugOCR) = $GUI_CHECKED ? 1 : 0)
EndFunc

Func g_hChkSamM0dDebug()
	$g_iSamM0dDebug = (GUICtrlRead($g_hChkSamM0dDebug) = $GUI_CHECKED ? 1 : 0)
EndFunc

Func g_hchkSamM0dImage()
	$g_iSamM0dDebugImage = (GUICtrlRead($g_hchkSamM0dImage) = $GUI_CHECKED ? 1 : 0)
EndFunc

; CSV Deployment Speed Mod
Func sldSelectedSpeedDB()
	$isldSelectedCSVSpeed[$DB] = GUICtrlRead($sldSelectedSpeedDB)
	Local $speedText = $iCSVSpeeds[$isldSelectedCSVSpeed[$DB]] & "x";
	IF $isldSelectedCSVSpeed[$DB] = 4 Then $speedText = GetTranslatedFileIni("sam m0d", "Normal", "Normal")
	GUICtrlSetData($lbltxtSelectedSpeedDB, $speedText & " " &  GetTranslatedFileIni("sam m0d", "speed", "speed"))
EndFunc   ;==>sldSelectedSpeedDB

Func sldSelectedSpeedAB()
	$isldSelectedCSVSpeed[$LB] = GUICtrlRead($sldSelectedSpeedAB)
	Local $speedText = $iCSVSpeeds[$isldSelectedCSVSpeed[$LB]] & "x";
	IF $isldSelectedCSVSpeed[$LB] = 4 Then $speedText = GetTranslatedFileIni("sam m0d", "Normal", "Normal")
	GUICtrlSetData($lbltxtSelectedSpeedAB, $speedText & " " &  GetTranslatedFileIni("sam m0d", "speed", "speed"))
EndFunc

Func AttackNowLB()
	Setlog("Begin Live Base Attack TEST")
	$g_iMatchMode = $LB
	$g_aiAttackAlgorithm[$LB] = 1
	$g_sAttackScrScriptName[$LB] = GuiCtrlRead($g_hCmbScriptNameAB)

	Local $currentRunState = $g_bRunState
	$g_bRunState = True

	ForceCaptureRegion()
	_CaptureRegion2()

	Setlog("Check ZoomOut...", $COLOR_INFO)
	If CheckZoomOut2("VillageSearch", False, False) = False Then
		$i = 0
		Local $bMeasured
		Do
			$i += 1
			If _Sleep($DELAYPREPARESEARCH2) Then Return ; wait 500 ms
			ForceCaptureRegion()
			_CaptureRegion2()
			$bMeasured = CheckZoomOut2("VillageSearch", True, False)
		Until $bMeasured = True Or $i >= 2
		If $bMeasured = False Then
			SetLog("CheckZoomOut failed!", $COLOR_ERROR)
			Return ; exit func
		EndIf
	EndIf

	ResetTHsearch()
	_ObjDeleteKey($g_oBldgAttackInfo, "")

	PrepareAttack($g_iMatchMode)
	Attack()
	SetLog("Check Heroes Health and waiting battle for end.", $COLOR_INFO)
	While IsAttackPage() And ($g_bCheckKingPower Or $g_bCheckQueenPower Or $g_bCheckWardenPower)
		CheckHeroesHealth()
		If _Sleep(500) Then Return
	WEnd

	Setlog("End Live Base Attack TEST")
	$g_bRunState = $currentRunState
EndFunc ; ==>AttackNowLB

Func AttackNowDB()
	Setlog("Begin Dead Base Attack TEST")
	$g_iMatchMode = $DB
	$g_aiAttackAlgorithm[$DB] = 1
	$g_sAttackScrScriptName[$DB] = GuiCtrlRead($g_hCmbScriptNameDB)

	Local $currentRunState = $g_bRunState
	$g_bRunState = True

	ForceCaptureRegion()
	_CaptureRegion2()

	Setlog("Check ZoomOut...", $COLOR_INFO)
	If CheckZoomOut2("VillageSearch", False, False) = False Then
		$i = 0
		Local $bMeasured
		Do
			$i += 1
			If _Sleep($DELAYPREPARESEARCH2) Then Return ; wait 500 ms
			ForceCaptureRegion()
			_CaptureRegion2()
			$bMeasured = CheckZoomOut2("VillageSearch", True, False)
		Until $bMeasured = True Or $i >= 2
		If $bMeasured = False Then
			SetLog("CheckZoomOut failed!", $COLOR_ERROR)
			Return ; exit func
		EndIf
	EndIf

	ResetTHsearch()
	_ObjDeleteKey($g_oBldgAttackInfo, "")

	FindTownhall(True)

	PrepareAttack($g_iMatchMode)
	Attack()
	SetLog("Check Heroes Health and waiting battle for end.", $COLOR_INFO)
	While IsAttackPage() And ($g_bCheckKingPower Or $g_bCheckQueenPower Or $g_bCheckWardenPower)
		CheckHeroesHealth()
		If _Sleep(500) Then Return
	WEnd
	Setlog("End Dead Base Attack TEST")
	$g_bRunState = $currentRunState
EndFunc ;==>AttackNowDB

Func CheckZoomOut2($sSource = "CheckZoomOut", $bCheckOnly = False, $bForecCapture = True)
	If $bForecCapture = True Then
		_CaptureRegion2()
	EndIf
	Local $aVillageResult = SearchZoomOut(False, True, $sSource, False)
	If IsArray($aVillageResult) = 0 Or $aVillageResult[0] = "" Then
		; not zoomed out, Return
		If $bCheckOnly = False Then
			SetLog("Not Zoomed Out! try to zoom out...", $COLOR_ERROR)
			ZoomOut()
		EndIf
		Return False
	EndIf
	Return True
EndFunc   ;==>CheckZoomOut2

Func _BatteryStatus()
	If $ichkEnableStopBotWhenLowBattery = 1 And $g_bCheckBattery = True Then
		Local $aData = _WinAPI_GetSystemPowerStatus()
		If @error Then Return
		If BitAND($aData[1], 0x8) Then
			; On charging, just leave it
		Else
			If $aData[2] <= 10 Then
				If IsAttackPage() = False Then
					SetLog("Stopping Bot because your System is running on low battery! Left: " & $aData[2] & "%", $COLOR_WARNING)
					PoliteCloseCoC("_BatteryStatus", _CheckPixel($aIsMain, True))
					BotStop()
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_BatteryStatus