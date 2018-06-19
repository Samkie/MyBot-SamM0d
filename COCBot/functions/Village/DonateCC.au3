; #FUNCTION# ====================================================================================================================
; Name ..........: DonateCC
; Description ...: This file includes functions to Donate troops
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Zax (2015)
; Modified ......: Safar46 (2015), Hervidero (2015-04), HungLe (2015-04), Sardo (2015-08), Promac (2015-12), Hervidero (2016-01), MonkeyHunter (2016-07),
;				   CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;Global $g_iTotalDonateCapacity, $g_iTotalDonateSpellCapacity
Global $g_iTotalDonateTroopCapacity, $g_iTotalDonateSpellCapacity, $g_iTotalDonateSiegeMachineCapacity
Global $g_iDonTroopsLimit = 8, $iDonSpellsLimit = 1, $g_iDonTroopsAv = 0, $g_iDonSpellsAv = 0
Global $g_iDonTroopsQuantityAv = 0, $g_iDonTroopsQuantity = 0, $g_iDonSpellsQuantityAv = 0, $g_iDonSpellsQuantity = 0
Global $g_bSkipDonTroops = False, $g_bSkipDonSpells = False
Global $g_bDonateAllRespectBlk = False ; is turned on off durning donate all section, must be false all other times
Global $g_aiDonatePixel ; array holding x, y position of donate button in chat window

Func PrepareDonateCC()
	$g_aiPrepDon[0] = 0
	$g_aiPrepDon[1] = 0
	For $i = 0 To $eTroopCount - 1 + $g_iCustomDonateConfigs
		$g_aiPrepDon[0] = BitOR($g_aiPrepDon[0], ($g_abChkDonateTroop[$i] ? 1 : 0))
		$g_aiPrepDon[1] = BitOR($g_aiPrepDon[1], ($g_abChkDonateAllTroop[$i] ? 1 : 0))
	Next

	$g_aiPrepDon[2] = 0
	$g_aiPrepDon[3] = 0
	For $i = 0 To $eSpellCount - 1
		If $i <> $eSpellClone Then
			$g_aiPrepDon[2] = BitOR($g_aiPrepDon[2], ($g_abChkDonateSpell[$i] ? 1 : 0))
			$g_aiPrepDon[3] = BitOR($g_aiPrepDon[3], ($g_abChkDonateAllSpell[$i] ? 1 : 0))
		EndIf
	Next

	$g_iActiveDonate = BitOR($g_aiPrepDon[0], $g_aiPrepDon[1], $g_aiPrepDon[2], $g_aiPrepDon[3])
EndFunc   ;==>PrepareDonateCC

Func DonateCC($bCheckForNewMsg = False)

	Local $bDonateTroop = ($g_aiPrepDon[0] = 1)

	Local $bDonateAllTroop = ($g_aiPrepDon[1] = 1)

	Local $bDonateSpell = ($g_aiPrepDon[2] = 1)
	Local $bDonateAllSpell = ($g_aiPrepDon[3] = 1)

	Local $bDonate = ($g_iActiveDonate = 1)

	Local $bOpen = True, $bClose = False

	Local $ReturnT = ($g_CurrentCampUtilization >= ($g_iTotalCampSpace * $g_iTrainArmyFullTroopPct / 100) * .95) ? (True) : (False)

	Local $ClanString = ""

	If Not $bDonate Or Not $g_bDonationEnabled Then
		If $g_bDebugSetlog Then SetDebugLog("Donate Clan Castle troops skip", $COLOR_DEBUG)
		Return ; exit func if no donate checkmarks
	EndIf

	Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)

	If Not $g_abDonateHours[$hour[0]] And $g_bDonateHoursEnable Then
		If $g_bDebugSetlog Then SetDebugLog("Donate Clan Castle troops not planned, Skipped..", $COLOR_DEBUG)
		Return ; exit func if no planned donate checkmarks
	EndIf

	Local $y = 90

	;check for new chats first
	If $bCheckForNewMsg Then
		If Not _ColorCheck(_GetPixelColor(26, 312 + $g_iMidOffsetY, True), Hex(0xf00810, 6), 20) And $g_iCommandStop <> 3 Then Return ;exit if no new chats
	EndIf

	; samm0d
	If $ichkEnableDonateWhenReady = 1 Then
		Dim $bGotUnitToDonate = False
		For $i = 0 To UBound($MyTroops) - 1
			If Eval("Ready" & $MyTroops[$i][0]) > 0 Then
				$bGotUnitToDonate = True
				ExitLoop
			EndIf
		Next

		For $i = 0 To UBound($MySpells) - 1
			If Eval("Ready" & $MySpells[$i][0] & "Spell") > 0 Then
				$bGotUnitToDonate = True
				ExitLoop
			EndIf
		Next
		If $bGotUnitToDonate = False Then
			SetLog("Pre-Train and Pre-Brew not ready, skip donation.", $COLOR_RED)
			Return
		EndIf
	EndIf

	;Opens clan tab and verbose in log
	ClickP($aAway, 1, 0, "#0167") ;Click Away
	SetLog("Checking for Donate Requests in Clan Chat", $COLOR_INFO)

	ForceCaptureRegion()
	If Not _CheckPixel($aChatTab, $g_bCapturePixel) Or Not _CheckPixel($aChatTab2, $g_bCapturePixel) Or Not _CheckPixel($aChatTab3, $g_bCapturePixel) Then ClickP($aOpenChat, 1, 0, "#0168") ; Clicks chat tab
	If _Sleep($DELAYDONATECC4) Then Return

	Local $iLoopCount = 0
	While 1
		;If Clan tab is selected.
		If _ColorCheck(_GetPixelColor(189, 24, True), Hex(0x706C50, 6), 20) Then ; color med gray
			ExitLoop
		EndIf
		;If Global tab is selected.
		If _ColorCheck(_GetPixelColor(189, 24, True), Hex(0x383828, 6), 20) Then ; Darker gray
			; samm0d - reverse click and sleep, not sleep and click
			ClickP($aClanTab, 1, 0, "#0169") ; clicking clan tab
			If _Sleep($DELAYDONATECC1) Then Return ;small delay to allow tab to completely open
			ExitLoop
		EndIf
		;counter for time approx 3 sec max allowed for tab to open
		$iLoopCount += 1
		If $iLoopCount >= 15 Then ; allows for up to a sleep of 3000
			SetLog("Clan Chat Did Not Open - Abandon Donate")
			AndroidPageError("DonateCC")
			Return
		EndIf
		If _Sleep($DELAYDONATECC1) Then Return ; delay Allow 15x
	WEnd

	Local $Scroll
	Local $donateCCfilter = False

	; samm0d
	Local $bDonateWindowOpen = False
	Local $bDonateFlag = False
	Local $canDonCustomA = False
	Local $canDonCustomB = False
	Local $canDonCustomC = False
	Local $canDonCustomD = False

	; add scroll here
	While 1
		ForceCaptureRegion()
		If _CheckColorPixel(295,100,0xFFFFFF,10) And _CheckColorPixel(301,111,0x5DA515,20) Then
			$bDonate = True
			Click($aButtonClanDonateScrollUp[0], $aButtonClanDonateScrollUp[1], 1, 0, "#0172")
			If _Sleep($DELAYDONATECC2 + 100) Then ExitLoop
			ContinueLoop
		EndIf
		ExitLoop
	WEnd

	While $bDonate
		checkAttackDisable($g_iTaBChkIdle) ; Early Take-A-Break detection
		$ClanString = ""

		;samm0d reset value
		;=========================
		$bDonateFlag = False
		$bDonateWindowOpen = False
		$g_bDonateAllRespectBlk = False

		For $i = 0 To UBound($g_aiDonateTroopPriority) - 1
			Local $iTroopIndex = $g_aiDonateTroopPriority[$i]
			Assign("canDon" & $g_asTroopShortNames[$iTroopIndex], False)
		Next
		$canDonCustomA = False
		$canDonCustomB = False
		$canDonCustomC = False
		$canDonCustomD = False

		For $i = 0 To UBound($g_aiDonateSpellPriority) - 1
			Local $iSpellIndex = $g_aiDonateSpellPriority[$i]
			Assign("canDon" & $g_asSpellNames[$iSpellIndex], False)
		Next

		;If _Sleep($DELAYDONATECC2) Then ExitLoop
		ForceCaptureRegion()
		If _Wait4Pixel($aButtonClanWindowClose[4],$aButtonClanWindowClose[5],$aButtonClanWindowClose[6],$aButtonClanWindowClose[7],1000,100,"aButtonClanWindowClose") = False Then
			SetLog("Close Chat button not found - Abandon Donate", $COLOR_RED)
			ExitLoop
		EndIf

		;==========================

		;$g_aiDonatePixel = _MultiPixelSearch(202, $y, 224, 660 + $g_iBottomOffsetY, 50, 1, Hex(0x98D057, 6), $aChatDonateBtnColors, 20)
		$g_aiDonatePixel = _MultiPixelSearch(200, $y, 230, 660 + $g_iBottomOffsetY, -2, 1, Hex(0x6da725, 6), $aChatDonateBtnColors, 20)
		If IsArray($g_aiDonatePixel) Then ; if Donate Button found
			If $g_bDebugSetlog Then SetDebugLog("$g_aiDonatePixel: (" & $g_aiDonatePixel[0] & "," & $g_aiDonatePixel[1] & ")", $COLOR_DEBUG)
			; samm0d
			SetLog(_PadStringCenter(" CC Request ", 54, "="), $COLOR_INFO)

			; collect donate users images
			$donateCCfilter = donateCCWBLUserImageCollect($g_aiDonatePixel[0], $g_aiDonatePixel[1])

			;reset every run
			$bDonate = False
			$g_bSkipDonTroops = False
			$g_bSkipDonSpells = False

			;Read chat request for DonateTroop and DonateSpell
			If $bDonateTroop Or $bDonateSpell And $donateCCfilter Then
				If $g_bChkExtraAlphabets Then
					; Chat Request using "coc-latin-cyr" xml: Latin + Cyrillic derived alphabets / three paragraphs
					SetLog("Using OCR to read Latin and Cyrillic derived alphabets..", $COLOR_ACTION)
					$ClanString = ""
					$ClanString = getChatString(30, $g_aiDonatePixel[1] - 50, "coc-latin-cyr")
					If $ClanString = "" Then
						$ClanString = getChatString(30, $g_aiDonatePixel[1] - 36, "coc-latin-cyr")
					Else
						$ClanString &= " " & getChatString(30, $g_aiDonatePixel[1] - 36, "coc-latin-cyr")
					EndIf
					If $ClanString = "" Or $ClanString = " " Then
						$ClanString = getChatString(30, $g_aiDonatePixel[1] - 23, "coc-latin-cyr")
					Else
						$ClanString &= " " & getChatString(30, $g_aiDonatePixel[1] - 23, "coc-latin-cyr")
					EndIf
					If _Sleep($DELAYDONATECC2) Then ExitLoop
				Else ; default
					; Chat Request using "coc-latinA" xml: only Latin derived alphabets / three paragraphs
					SetLog("Using OCR to read Latin derived alphabets..", $COLOR_ACTION)
					$ClanString = ""
					$ClanString = getChatString(30, $g_aiDonatePixel[1] - 50, "coc-latinA")
					If $ClanString = "" Then
						$ClanString = getChatString(30, $g_aiDonatePixel[1] - 36, "coc-latinA")
					Else
						$ClanString &= " " & getChatString(30, $g_aiDonatePixel[1] - 36, "coc-latinA")
					EndIf
					If $ClanString = "" Or $ClanString = " " Then
						$ClanString = getChatString(30, $g_aiDonatePixel[1] - 23, "coc-latinA")
					Else
						$ClanString &= " " & getChatString(30, $g_aiDonatePixel[1] - 23, "coc-latinA")
					EndIf
					If _Sleep($DELAYDONATECC2) Then ExitLoop
				EndIf
				; Chat Request using IMGLOC: Chinese alphabet / one paragraph
				If $g_bChkExtraChinese Then
					SetLog("Using OCR to read the Chinese alphabet..", $COLOR_ACTION)
					If $ClanString = "" Then
						$ClanString = getChatStringChinese(30, $g_aiDonatePixel[1] - 26)
					Else
						$ClanString &= " " & getChatStringChinese(30, $g_aiDonatePixel[1] - 26)
					EndIf
					If _Sleep($DELAYDONATECC2) Then ExitLoop
				EndIf
				; Chat Request using IMGLOC: Korean alphabet / one paragraph
				If $g_bChkExtraKorean Then
					SetLog("Using OCR to read the Korean alphabet..", $COLOR_ACTION)
					If $ClanString = "" Then
						$ClanString = getChatStringKorean(30, $g_aiDonatePixel[1] - 24)
					Else
						$ClanString &= " " & getChatStringKorean(30, $g_aiDonatePixel[1] - 24)
					EndIf
					If _Sleep($DELAYDONATECC2) Then ExitLoop
				EndIf
				; Chat Request using IMGLOC: Persian alphabet / one paragraph
				If $g_bChkExtraPersian Then
					SetLog("Using OCR to read the Persian alphabet..", $COLOR_ACTION)
					If $ClanString = "" Then
						$ClanString = getChatStringPersian(30, $g_aiDonatePixel[1] - 31)
					Else
						$ClanString &= " " & getChatStringPersian(30, $g_aiDonatePixel[1] - 31)
					EndIf
					If _Sleep($DELAYDONATECC2) Then ExitLoop
				EndIf
				; samm0d
				If $ichkEnableCustomOCR4CCRequest = 1 Then
					Setlog("Using custom OCR to read cc request message..", $COLOR_ACTION)
					If $ClanString = "" Then
						$ClanString = getMyOcr(0,30, $g_aiDonatePixel[1] - 26,160,14,"ccrequest",False,True)
					Else
						$ClanString &= " " & getMyOcr(0,30, $g_aiDonatePixel[1] - 26,160,14,"ccrequest",False,True)
					EndIf
					If _Sleep($DELAYRESPOND) Then ExitLoop
				EndIf

				If $ClanString = "" Or $ClanString = " " Then
					SetLog("Unable to read Chat Request!", $COLOR_ERROR)
					$bDonate = True
					$y = $g_aiDonatePixel[1] + 50
					ContinueLoop
				Else
					If $g_bChkExtraAlphabets Then
						ClipPut($ClanString)
						Local $tempClip = ClipGet()
						SetLog("Chat Request: " & $tempClip)
					Else
						SetLog("Chat Request: " & $ClanString)
					EndIf
				EndIf
			ElseIf (($bDonateAllTroop And $bDonateAllSpell) Or ($bDonateAllTroop And Not $bDonateSpell) Or (Not $bDonateTroop And $bDonateAllSpell)) And $donateCCfilter Then
				SetLog("Skip reading chat requests. Donate all is enabled!", $COLOR_ACTION)
			EndIf

			; Get remaining CC capacity of requested troops from your ClanMates
			RemainingCCcapacity()

			If Not $donateCCfilter Then
				SetLog("Skip Donation at this Clan Mate...", $COLOR_ACTION)
				$g_bSkipDonTroops = True
				$g_bSkipDonSpells = True
			Else
				If $g_iTotalDonateTroopCapacity <= 0 Then
					SetLog("Clan Castle troops are full, skip troop donation...", $COLOR_ACTION)
					$g_bSkipDonTroops = True
				EndIf
				If $g_iTotalDonateSpellCapacity = 0 Then
					SetLog("Clan Castle spells are full, skip spell donation...", $COLOR_ACTION)
					$g_bSkipDonSpells = True
				ElseIf $g_iTotalDonateSpellCapacity = -1 Then
					; no message, this CC has no Spell capability
					If $g_bDebugSetlog Then SetDebugLog("This CC cannot accept spells, skip spell donation...", $COLOR_DEBUG)
					$g_bSkipDonSpells = True
				ElseIf $g_iCurrentSpells = 0 Then
					If $g_bDebugSetlog Then SetDebugLog("No spells available, skip spell donation...", $COLOR_DEBUG) ;Debug
					SetLog("No spells available, skip spell donation...", $COLOR_ORANGE)
					$g_bSkipDonSpells = True
				EndIf
				; samm0d
				If $ichkEnableLimitDonateUnit Then
					If $iDonatedUnit >= $itxtLimitDonateUnit Then
						Setlog("Reach donate unit limit, skip troop donation...", $COLOR_ACTION)
						$g_bSkipDonTroops = True
					EndIf
				EndIf
			EndIf

			If $g_bSkipDonTroops And $g_bSkipDonSpells Then
				$bDonate = True
				$y = $g_aiDonatePixel[1] + 50
				ContinueLoop ; go to next button if cant read Castle Troops and Spells before the donate window opens
			EndIf

			; ==== samm0d
			; compare
			If $bDonateTroop And $g_bSkipDonTroops = False Then
				For $i = 0 To UBound($g_aiDonateTroopPriority) - 1
					Local $iTroopIndex = $g_aiDonateTroopPriority[$i]
					If $g_abChkDonateTroop[$iTroopIndex] Then
						Assign("canDon" & $g_asTroopShortNames[$iTroopIndex], CheckDonate($iTroopIndex, $g_asTxtDonateTroop[$iTroopIndex], $g_asTxtBlacklistTroop[$iTroopIndex], $ClanString, True))
						If Eval("canDon" & $g_asTroopShortNames[$iTroopIndex]) Then $bDonateFlag = True
						;SetLog($g_asTroopShortNames[$iTroopIndex] & " $bDonateFlag: " & $bDonateFlag)
					EndIf
				Next

				If $g_abChkDonateTroop[$eCustomA] Then
					$canDonCustomA = CheckDonate(99, $g_asTxtDonateTroop[$eCustomA], $g_asTxtBlacklistTroop[$eCustomA], $ClanString, True)
					If $canDonCustomA Then
						If $ichkEnableDonateWhenReady = 1 Then
							For $i = 0 To 2
								If $g_aiDonateCustomTrpNumA[$i][0] < $eBarb Then
									$g_aiDonateCustomTrpNumA[$i][0] = $eArch ; Change strange small numbers to archer
								ElseIf $g_aiDonateCustomTrpNumA[$i][0] > $eBowl Then
									ContinueLoop ; If "Nothing" is selected then continue
								EndIf
								If $g_aiDonateCustomTrpNumA[$i][1] < 1 Then
									ContinueLoop ; If donate number is smaller than 1 then continue
								ElseIf $g_aiDonateCustomTrpNumA[$i][1] > 8 Then
									$g_aiDonateCustomTrpNumA[$i][1] = 8 ; Number larger than 8 is unnecessary
								EndIf
								If Eval("Ready" & $g_asTroopShortNames[$g_aiDonateCustomTrpNumA[$i][0]]) < $g_aiDonateCustomTrpNumA[$i][1] Then
									SetLog("Pre-Train not ready, skip donate " & $g_asTroopNames[$g_aiDonateCustomTrpNumA[$i][0]], $COLOR_RED)
									$canDonCustomA = False
								EndIf
							Next
						EndIf
					EndIf
					If $canDonCustomA Then $bDonateFlag = True
				EndIf
				If $g_abChkDonateTroop[$eCustomB] Then
					$canDonCustomB = CheckDonate(99, $g_asTxtDonateTroop[$eCustomB], $g_asTxtBlacklistTroop[$eCustomB], $ClanString, True)
					If $canDonCustomB Then
						If $ichkEnableDonateWhenReady = 1 Then
							For $i = 0 To 2
								If $g_aiDonateCustomTrpNumB[$i][0] < $eBarb Then
									$g_aiDonateCustomTrpNumB[$i][0] = $eArch ; Change strange small numbers to archer
								ElseIf $g_aiDonateCustomTrpNumB[$i][0] > $eBowl Then
									ContinueLoop ; If "Nothing" is selected then continue
								EndIf
								If $g_aiDonateCustomTrpNumB[$i][1] < 1 Then
									ContinueLoop ; If donate number is smaller than 1 then continue
								ElseIf $g_aiDonateCustomTrpNumB[$i][1] > 8 Then
									$g_aiDonateCustomTrpNumB[$i][1] = 8 ; Number larger than 8 is unnecessary
								EndIf
								If Eval("Ready" & $g_asTroopShortNames[$g_aiDonateCustomTrpNumB[$i][0]]) < $g_aiDonateCustomTrpNumB[$i][1] Then
									SetLog("Pre-Train not ready, skip donate " & $g_asTroopNames[$g_aiDonateCustomTrpNumB[$i][0]], $COLOR_RED)
									$canDonCustomB = False
								EndIf
							Next
						EndIf
					EndIf
					If $canDonCustomB Then $bDonateFlag = True
				EndIf

				If $g_abChkDonateTroop[$eCustomC] Then
					$canDonCustomC = CheckDonate(99, $g_asTxtDonateTroop[$eCustomC], $g_asTxtBlacklistTroop[$eCustomC], $ClanString, True)
					If $canDonCustomC Then
						If $ichkEnableDonateWhenReady = 1 Then
							For $i = 0 To 2
								If $g_aiDonateCustomTrpNumC[$i][0] < $eBarb Then
									$g_aiDonateCustomTrpNumC[$i][0] = $eArch ; Change strange small numbers to archer
								ElseIf $g_aiDonateCustomTrpNumC[$i][0] > $eBowl Then
									ContinueLoop ; If "Nothing" is selected then continue
								EndIf
								If $g_aiDonateCustomTrpNumC[$i][1] < 1 Then
									ContinueLoop ; If donate number is smaller than 1 then continue
								ElseIf $g_aiDonateCustomTrpNumC[$i][1] > 8 Then
									$g_aiDonateCustomTrpNumC[$i][1] = 8 ; Number larger than 8 is unnecessary
								EndIf
								If Eval("Ready" & $g_asTroopShortNames[$g_aiDonateCustomTrpNumC[$i][0]]) < $g_aiDonateCustomTrpNumC[$i][1] Then
									SetLog("Pre-Train not ready, skip donate " & $g_asTroopNames[$g_aiDonateCustomTrpNumC[$i][0]], $COLOR_RED)
									$canDonCustomC = False
								EndIf
							Next
						EndIf
					EndIf
					If $canDonCustomC Then $bDonateFlag = True
				EndIf

				If $g_abChkDonateTroop[$eCustomD] Then
					$canDonCustomD = CheckDonate(99, $g_asTxtDonateTroop[$eCustomD], $g_asTxtBlacklistTroop[$eCustomD], $ClanString, True)
					If $canDonCustomD Then
						If $ichkEnableDonateWhenReady = 1 Then
							For $i = 0 To 2
								If $g_aiDonateCustomTrpNumD[$i][0] < $eBarb Then
									$g_aiDonateCustomTrpNumD[$i][0] = $eArch ; Change strange small numbers to archer
								ElseIf $g_aiDonateCustomTrpNumD[$i][0] > $eBowl Then
									ContinueLoop ; If "Nothing" is selected then continue
								EndIf
								If $g_aiDonateCustomTrpNumD[$i][1] < 1 Then
									ContinueLoop ; If donate number is smaller than 1 then continue
								ElseIf $g_aiDonateCustomTrpNumD[$i][1] > 8 Then
									$g_aiDonateCustomTrpNumD[$i][1] = 8 ; Number larger than 8 is unnecessary
								EndIf
								If Eval("Ready" & $g_asTroopShortNames[$g_aiDonateCustomTrpNumD[$i][0]]) < $g_aiDonateCustomTrpNumD[$i][1] Then
									SetLog("Pre-Train not ready, skip donate " & $g_asTroopNames[$g_aiDonateCustomTrpNumD[$i][0]], $COLOR_RED)
									$canDonCustomD = False
								EndIf
							Next
						EndIf
					EndIf
					If $canDonCustomD Then $bDonateFlag = True
				EndIf

			EndIf

			If $bDonateSpell And Not $g_bSkipDonSpells Then
				If $g_bDebugSetlog Then Setlog("Spell checkpoint.", $COLOR_DEBUG)
				For $i = 0 To UBound($g_aiDonateSpellPriority) - 1
					Local $iSpellIndex = $g_aiDonateSpellPriority[$i]
					If $g_abChkDonateSpell[$iSpellIndex] Then
						Assign("canDon" & $g_asSpellNames[$iSpellIndex], CheckDonate($iSpellIndex, $g_asTxtDonateSpell[$iSpellIndex], $g_asTxtBlacklistSpell[$iSpellIndex], $ClanString, False))
						If Eval("canDon" & $g_asSpellNames[$iSpellIndex]) Then $bDonateFlag = True
					EndIf
				Next
			EndIf

			If $bDonateFlag Then
				If $bDonateTroop Or $bDonateSpell Then
					; open Donate Window
					;If _Sleep(1000) Then Return
					If ($g_bSkipDonTroops And $g_bSkipDonSpells) Or Not DonateWindow($bOpen) Then
						$bDonate = True
						$y = $g_aiDonatePixel[1] + 50
						SetLog("Donate Window did not open - Exiting Donate", $COLOR_ERROR)
						ExitLoop ; Leave donate to prevent a bot hang condition
					EndIf
					$bDonateWindowOpen = True
					If $g_bDebugSetlog Then Setlog("Troop/Spell checkpoint.", $COLOR_DEBUG)

					; read available donate cap, and ByRef set the $g_bSkipDonTroops and $g_bSkipDonSpells flags
					DonateWindowCap($g_bSkipDonTroops, $g_bSkipDonSpells)
					If $g_bSkipDonTroops And $g_bSkipDonSpells Then
						DonateWindow($bClose)
						$bDonateWindowOpen = False
						$bDonate = True
						$y = $g_aiDonatePixel[1] + 50
						;If _Sleep($DELAYDONATECC2) Then ExitLoop
						ContinueLoop ; go to next button if already donated, maybe this is an impossible case..
					EndIf

					If $g_bDebugSetlog Then Setlog("Troop checkpoint.", $COLOR_DEBUG)

					If $bDonateTroop And $g_bSkipDonTroops = False Then
						;;; Custom Combination Donate by ChiefM3, edited by MonkeyHunter
						If $canDonCustomA Then
							For $i = 0 To 2
								If $g_aiDonateCustomTrpNumA[$i][0] < $eBarb Then
									$g_aiDonateCustomTrpNumA[$i][0] = $eArch ; Change strange small numbers to archer
								ElseIf $g_aiDonateCustomTrpNumA[$i][0] > $eBowl Then
									ContinueLoop ; If "Nothing" is selected then continue
								EndIf
								If $g_aiDonateCustomTrpNumA[$i][1] < 1 Then
									ContinueLoop ; If donate number is smaller than 1 then continue
								ElseIf $g_aiDonateCustomTrpNumA[$i][1] > 8 Then
									$g_aiDonateCustomTrpNumA[$i][1] = 8 ; Number larger than 8 is unnecessary
								EndIf
								If $ichkEnableDonateWhenReady = 1 Then
									If Eval("Ready" & $g_asTroopShortNames[$g_aiDonateCustomTrpNumA[$i][0]]) < $g_aiDonateCustomTrpNumA[$i][1] Then
										SetLog("Pre-Train not ready, skip donate " & $g_asTroopNames[$g_aiDonateCustomTrpNumA[$i][0]], $COLOR_RED)
										$canDonCustomA = False
									EndIf
								EndIf
								If $canDonCustomA Then DonateTroopType($g_aiDonateCustomTrpNumA[$i][0], $g_aiDonateCustomTrpNumA[$i][1], $g_abChkDonateTroop[$eCustomA]) ;;; Donate Custom Troop using DonateTroopType2
							Next
						EndIf
						If $canDonCustomB Then
							For $i = 0 To 2
								If $g_aiDonateCustomTrpNumB[$i][0] < $eBarb Then
									$g_aiDonateCustomTrpNumB[$i][0] = $eArch ; Change strange small numbers to archer
								ElseIf $g_aiDonateCustomTrpNumB[$i][0] > $eBowl Then
									ContinueLoop ; If "Nothing" is selected then continue
								EndIf
								If $g_aiDonateCustomTrpNumB[$i][1] < 1 Then
									ContinueLoop ; If donate number is smaller than 1 then continue
								ElseIf $g_aiDonateCustomTrpNumB[$i][1] > 8 Then
									$g_aiDonateCustomTrpNumB[$i][1] = 8 ; Number larger than 8 is unnecessary
								EndIf
								If $ichkEnableDonateWhenReady = 1 Then
									If Eval("Ready" & $g_asTroopShortNames[$g_aiDonateCustomTrpNumB[$i][0]]) < $g_aiDonateCustomTrpNumB[$i][1] Then
										SetLog("Pre-Train not ready, skip donate " & $g_asTroopNames[$g_aiDonateCustomTrpNumB[$i][0]], $COLOR_RED)
										$canDonCustomB = False
									EndIf
								EndIf
								If $canDonCustomB Then DonateTroopType($g_aiDonateCustomTrpNumB[$i][0], $g_aiDonateCustomTrpNumB[$i][1], $g_abChkDonateTroop[$eCustomB]) ;;; Donate Custom Troop using DonateTroopType2
							Next
						EndIf
						If $canDonCustomC Then
							For $i = 0 To 2
								If $g_aiDonateCustomTrpNumC[$i][0] < $eBarb Then
									$g_aiDonateCustomTrpNumC[$i][0] = $eArch ; Change strange small numbers to archer
								ElseIf $g_aiDonateCustomTrpNumC[$i][0] > $eBowl Then
									ContinueLoop ; If "Nothing" is selected then continue
								EndIf
								If $g_aiDonateCustomTrpNumC[$i][1] < 1 Then
									ContinueLoop ; If donate number is smaller than 1 then continue
								ElseIf $g_aiDonateCustomTrpNumC[$i][1] > 8 Then
									$g_aiDonateCustomTrpNumC[$i][1] = 8 ; Number larger than 8 is unnecessary
								EndIf
								If $ichkEnableDonateWhenReady = 1 Then
									If Eval("Ready" & $g_asTroopShortNames[$g_aiDonateCustomTrpNumC[$i][0]]) < $g_aiDonateCustomTrpNumC[$i][1] Then
										SetLog("Pre-Train not ready, skip donate " & $g_asTroopNames[$g_aiDonateCustomTrpNumC[$i][0]], $COLOR_RED)
										$canDonCustomC = False
									EndIf
								EndIf
								If $canDonCustomC Then DonateTroopType($g_aiDonateCustomTrpNumC[$i][0], $g_aiDonateCustomTrpNumC[$i][1], $g_abChkDonateTroop[$eCustomC]) ;;; Donate Custom Troop using DonateTroopType2
							Next
						EndIf
						If $canDonCustomD Then
							For $i = 0 To 2
								If $g_aiDonateCustomTrpNumD[$i][0] < $eBarb Then
									$g_aiDonateCustomTrpNumD[$i][0] = $eArch ; Change strange small numbers to archer
								ElseIf $g_aiDonateCustomTrpNumD[$i][0] > $eBowl Then
									ContinueLoop ; If "Nothing" is selected then continue
								EndIf
								If $g_aiDonateCustomTrpNumD[$i][1] < 1 Then
									ContinueLoop ; If donate number is smaller than 1 then continue
								ElseIf $g_aiDonateCustomTrpNumD[$i][1] > 8 Then
									$g_aiDonateCustomTrpNumD[$i][1] = 8 ; Number larger than 8 is unnecessary
								EndIf
								If $ichkEnableDonateWhenReady = 1 Then
									If Eval("Ready" & $g_asTroopShortNames[$g_aiDonateCustomTrpNumD[$i][0]]) < $g_aiDonateCustomTrpNumD[$i][1] Then
										SetLog("Pre-Train not ready, skip donate " & $g_asTroopNames[$g_aiDonateCustomTrpNumD[$i][0]], $COLOR_RED)
										$canDonCustomD = False
									EndIf
								EndIf
								If $canDonCustomD Then DonateTroopType($g_aiDonateCustomTrpNumD[$i][0], $g_aiDonateCustomTrpNumD[$i][1], $g_abChkDonateTroop[$eCustomD]) ;;; Donate Custom Troop using DonateTroopType2
							Next
						EndIf

						For $i = 0 To UBound($g_aiDonateTroopPriority) - 1
							Local $iTroopIndex = $g_aiDonateTroopPriority[$i]
							If Eval("canDon" & $g_asTroopShortNames[$iTroopIndex]) = True Then
								DonateTroopType($iTroopIndex)
							EndIf
						Next
					EndIf

					If $g_bDebugSetlog Then Setlog("Spell checkpoint.", $COLOR_DEBUG)
					If $bDonateSpell And Not $g_bSkipDonSpells Then
						For $i = 0 To UBound($g_aiDonateSpellPriority) - 1
							Local $iSpellIndex = $g_aiDonateSpellPriority[$i]
							If Eval("canDon" & $g_asSpellNames[$iSpellIndex]) = True Then
								DonateSpellType($iSpellIndex)
							EndIf
						Next
					EndIf
				EndIf

			Else
				If $donateCCfilter And (($bDonateTroop And $g_bSkipDonTroops = False) Or ($bDonateSpell And $g_bSkipDonSpells = False)) Then
					SetLog("Skip: Keyword or space not match with this request.",$COLOR_RED)
				EndIf
			EndIf

			If $bDonateAllTroop Or $bDonateAllSpell Then
				If $g_bDebugSetlog Then Setlog("Troop/Spell All checkpoint.", $COLOR_DEBUG) ;Debug
				$g_bDonateAllRespectBlk = True
				If $bDonateWindowOpen = False Then
					; open Donate Window
					;If _Sleep(1000) Then Return
					If ($g_bSkipDonTroops And $g_bSkipDonSpells) Or Not DonateWindow($bOpen) Then
						$bDonate = True
						$y = $g_aiDonatePixel[1] + 50
						SetLog("Donate Window did not open - Exiting Donate", $COLOR_ERROR)
						ExitLoop ; Leave donate to prevent a bot hang condition
					EndIf
					$bDonateWindowOpen = True
				EndIf

				; read available donate cap, and ByRef set the $g_bSkipDonTroops and $g_bSkipDonSpells flags
				DonateWindowCap($g_bSkipDonTroops, $g_bSkipDonSpells)
				If $g_bSkipDonTroops And $g_bSkipDonSpells Then
					DonateWindow($bClose)
					$bDonateWindowOpen = False
					$bDonate = True
					$y = $g_aiDonatePixel[1] + 50
					;If _Sleep($DELAYDONATECC2) Then ExitLoop
					ContinueLoop ; go to next button if already donated, maybe this is an impossible case..
				EndIf

				If $bDonateAllTroop And Not $g_bSkipDonTroops Then

					;$bDonateAllRespectBlk = True
					If $g_bDebugSetlog Then Setlog("Troop All checkpoint.", $COLOR_DEBUG)
					Select
						Case $g_abChkDonateAllTroop[$eCustomA]
							For $i = 0 To 2
								If $g_aiDonateCustomTrpNumA[$i][0] < $eBarb Then
									$g_aiDonateCustomTrpNumA[$i][0] = $eArch ; Change strange small numbers to archer
								ElseIf $g_aiDonateCustomTrpNumA[$i][0] > $eBowl Then
									DonateWindow($bClose)
									$bDonate = True
									$y = $g_aiDonatePixel[1] + 50
									;If _Sleep($DELAYDONATECC2) Then ExitLoop
									ContinueLoop ; If "Nothing" is selected then continue
								EndIf
								If $g_aiDonateCustomTrpNumA[$i][1] < 1 Then
									DonateWindow($bClose)
									$bDonate = True
									$y = $g_aiDonatePixel[1] + 50
									;If _Sleep($DELAYDONATECC2) Then ExitLoop
									ContinueLoop ; If donate number is smaller than 1 then continue
								ElseIf $g_aiDonateCustomTrpNumA[$i][1] > 8 Then
									$g_aiDonateCustomTrpNumA[$i][1] = 8 ; Number larger than 8 is unnecessary
								EndIf
								DonateTroopType($g_aiDonateCustomTrpNumA[$i][0], $g_aiDonateCustomTrpNumA[$i][1], $g_abChkDonateAllTroop[$eCustomA], $bDonateAllTroop) ;;; Donate Custom Troop using DonateTroopType2
							Next

						Case $g_abChkDonateAllTroop[$eCustomB]
							For $i = 0 To 2
								If $g_aiDonateCustomTrpNumB[$i][0] < $eBarb Then
									$g_aiDonateCustomTrpNumB[$i][0] = $eArch ; Change strange small numbers to archer
								ElseIf $g_aiDonateCustomTrpNumB[$i][0] > $eBowl Then
									DonateWindow($bClose)
									$bDonate = True
									$y = $g_aiDonatePixel[1] + 50
									;If _Sleep($DELAYDONATECC2) Then ExitLoop
									ContinueLoop ; If "Nothing" is selected then continue
								EndIf
								If $g_aiDonateCustomTrpNumB[$i][1] < 1 Then
									DonateWindow($bClose)
									$bDonate = True
									$y = $g_aiDonatePixel[1] + 50
									;If _Sleep($DELAYDONATECC2) Then ExitLoop
									ContinueLoop ; If donate number is smaller than 1 then continue
								ElseIf $g_aiDonateCustomTrpNumB[$i][1] > 8 Then
									$g_aiDonateCustomTrpNumB[$i][1] = 8 ; Number larger than 8 is unnecessary
								EndIf
								DonateTroopType($g_aiDonateCustomTrpNumB[$i][0], $g_aiDonateCustomTrpNumB[$i][1], $g_abChkDonateAllTroop[$eCustomB], $bDonateAllTroop) ;;; Donate Custom Troop using DonateTroopType2
							Next

						Case $g_abChkDonateAllTroop[$eCustomC]
							For $i = 0 To 2
								If $g_aiDonateCustomTrpNumC[$i][0] < $eBarb Then
									$g_aiDonateCustomTrpNumC[$i][0] = $eArch ; Change strange small numbers to archer
								ElseIf $g_aiDonateCustomTrpNumC[$i][0] > $eBowl Then
									DonateWindow($bClose)
									$bDonate = True
									$y = $g_aiDonatePixel[1] + 50
									;If _Sleep($DELAYDONATECC2) Then ExitLoop
									ContinueLoop ; If "Nothing" is selected then continue
								EndIf
								If $g_aiDonateCustomTrpNumC[$i][1] < 1 Then
									DonateWindow($bClose)
									$bDonate = True
									$y = $g_aiDonatePixel[1] + 50
									;If _Sleep($DELAYDONATECC2) Then ExitLoop
									ContinueLoop ; If donate number is smaller than 1 then continue
								ElseIf $g_aiDonateCustomTrpNumC[$i][1] > 8 Then
									$g_aiDonateCustomTrpNumC[$i][1] = 8 ; Number larger than 8 is unnecessary
								EndIf
								DonateTroopType($g_aiDonateCustomTrpNumC[$i][0], $g_aiDonateCustomTrpNumC[$i][1], $g_abChkDonateAllTroop[$eCustomC], $bDonateAllTroop) ;;; Donate Custom Troop using DonateTroopType2
							Next

						Case $g_abChkDonateAllTroop[$eCustomD]
							For $i = 0 To 2
								If $g_aiDonateCustomTrpNumD[$i][0] < $eBarb Then
									$g_aiDonateCustomTrpNumD[$i][0] = $eArch ; Change strange small numbers to archer
								ElseIf $g_aiDonateCustomTrpNumD[$i][0] > $eBowl Then
									DonateWindow($bClose)
									$bDonate = True
									$y = $g_aiDonatePixel[1] + 50
									;If _Sleep($DELAYDONATECC2) Then ExitLoop
									ContinueLoop ; If "Nothing" is selected then continue
								EndIf
								If $g_aiDonateCustomTrpNumD[$i][1] < 1 Then
									DonateWindow($bClose)
									$bDonate = True
									$y = $g_aiDonatePixel[1] + 50
									;If _Sleep($DELAYDONATECC2) Then ExitLoop
									ContinueLoop ; If donate number is smaller than 1 then continue
								ElseIf $g_aiDonateCustomTrpNumD[$i][1] > 8 Then
									$g_aiDonateCustomTrpNumD[$i][1] = 8 ; Number larger than 8 is unnecessary
								EndIf
								DonateTroopType($g_aiDonateCustomTrpNumD[$i][0], $g_aiDonateCustomTrpNumD[$i][1], $g_abChkDonateAllTroop[$eCustomD], $bDonateAllTroop) ;;; Donate Custom Troop using DonateTroopType2
							Next

						Case Else
							For $i = 0 To UBound($g_aiDonateTroopPriority) - 1
								Local $iTroopIndex = $g_aiDonateTroopPriority[$i]
								If $g_abChkDonateAllTroop[$iTroopIndex] Then
									If CheckDonate($iTroopIndex, $g_asTxtDonateTroop[$iTroopIndex], $g_asTxtBlacklistTroop[$iTroopIndex], $ClanString, True) Then
										DonateTroopType($iTroopIndex, 0, False, $bDonateAllTroop)
									EndIf
									ExitLoop
								EndIf
							Next

					EndSelect
				EndIf

				If $bDonateAllSpell And Not $g_bSkipDonSpells Then
					If $g_bDebugSetlog Then Setlog("Spell All checkpoint.", $COLOR_DEBUG)

					For $i = 0 To UBound($g_aiDonateSpellPriority) - 1
						Local $iSpellIndex = $g_aiDonateSpellPriority[$i]
						If $g_abChkDonateAllSpell[$iSpellIndex] Then
							If CheckDonate($iSpellIndex, $g_asTxtDonateSpell[$iSpellIndex], $g_asTxtBlacklistSpell[$iSpellIndex], $ClanString, False) Then
								DonateSpellType($iSpellIndex, 0, False, $bDonateAllSpell)
							EndIf
							ExitLoop
						EndIf
					Next
				EndIf
				$g_bDonateAllRespectBlk = False
			EndIf

			;close Donate Window
			DonateWindow($bClose)

			$bDonate = True
			$y = $g_aiDonatePixel[1] + 50
			ClickP($aAway, 1, 0, "#0171")
			; samm0d
			;If _Sleep($DELAYDONATECC2) Then ExitLoop
		EndIf
		;ck for more donate buttons
		ForceCaptureRegion()
		; samm0d
		If _Wait4Pixel($aButtonClanWindowClose[4],$aButtonClanWindowClose[5],$aButtonClanWindowClose[6],$aButtonClanWindowClose[7],1000,100,"aButtonClanWindowClose") = False Then
			SetLog("Close Chat button not found - Abandon Donate", $COLOR_RED)
			ExitLoop
		EndIf

		;$g_aiDonatePixel = _MultiPixelSearch(202, $y, 224, 660 + $g_iBottomOffsetY, 50, 1, Hex(0x98D057, 6), $aChatDonateBtnColors, 20)
		$g_aiDonatePixel = _MultiPixelSearch(200, $y, 230, 660 + $g_iBottomOffsetY, -2, 1, Hex(0x6da725, 6), $aChatDonateBtnColors, 20)
		If IsArray($g_aiDonatePixel) Then
			If $g_bDebugSetlog Then SetDebugLog("More Donate buttons found, new $g_aiDonatePixel: (" & $g_aiDonatePixel[0] & "," & $g_aiDonatePixel[1] & ")", $COLOR_DEBUG)
			ContinueLoop
		Else
			If $g_bDebugSetlog Then SetDebugLog("No more Donate buttons found, closing chat ($y=" & $y & ")", $COLOR_DEBUG)
		EndIf
		; Scroll Down

		ForceCaptureRegion()

		If _CheckColorPixel(295,655,0xFFFFFF,10) And _CheckColorPixel(301,662,0x5DA515,20) Then
			$bDonate = True
			Click($aButtonClanDonateScrollDown[0], $aButtonClanDonateScrollDown[1], 1, 0, "#0172")
			$y = 600
			If _Sleep($DELAYDONATECC2) Then ExitLoop
			ContinueLoop
		EndIf
		$bDonate = False
		; samm0d
		SetLog(_PadStringCenter(" Donate End ", 54, "="), $COLOR_INFO)
	WEnd

	ClickP($aAway, 1, 0, "#0176") ; click away any possible open window
	If _Sleep($DELAYDONATECC2) Then Return

	$i = 0
	While 1
		If _Sleep(100) Then Return
		If _ColorCheck(_GetPixelColor($aCloseChat[0], $aCloseChat[1], True), Hex($aCloseChat[2], 6), $aCloseChat[3]) Then
			; Clicks chat thing
			Click($aCloseChat[0], $aCloseChat[1], 1, 0, "#0173") ;Clicks chat thing
			ExitLoop
		Else
			If _Sleep(100) Then Return
			$i += 1
			If $i > 30 Then
				SetLog("Error finding Clan Tab to close...", $COLOR_ERROR)
				AndroidPageError("DonateCC")
				ExitLoop
			EndIf
		EndIf
	WEnd

	UpdateStats()

	If _Sleep($DELAYDONATECC2) Then Return

EndFunc   ;==>DonateCC

Func CheckDonate(Const $iTroopIndex, Const $sDonateTroopString, Const $sBlacklistTroopString, Const $sClanString, Const $bTroop)
	Local $sName
	If  $bTroop Then
		$sName = ($iTroopIndex = 99 ? "Custom" : $g_asTroopNames[$iTroopIndex])
	Else
		$sName = $g_asSpellNames[$iTroopIndex]
	EndIf

	; samm0d
	Local $bKeywordFound = False

	Local $asSplitDonate = StringSplit($sDonateTroopString, @CRLF, $STR_ENTIRESPLIT)
	Local $asSplitBlacklist = StringSplit($sBlacklistTroopString, @CRLF, $STR_ENTIRESPLIT)
	Local $asSplitGeneralBlacklist = StringSplit($g_sTxtGeneralBlacklist, @CRLF, $STR_ENTIRESPLIT)

	If $g_bDebugSetlog Then Setlog("$g_bDonateAllRespectBlk: " & $g_bDonateAllRespectBlk, $COLOR_DEBUG)

	If $g_bDonateAllRespectBlk Then
		$bKeywordFound = True
	Else
		For $i = 1 To UBound($asSplitDonate) - 1
			If CheckDonateString($asSplitDonate[$i], $sClanString) Then
				Setlog($sName & " Keyword found: " & $asSplitDonate[$i], $COLOR_SUCCESS)
				$bKeywordFound = True
			EndIf
		Next
	EndIf


	If $bKeywordFound Then ; samm0d - If donate keyword found then we check the blacklist keyword
		For $i = 1 To UBound($asSplitGeneralBlacklist) - 1
			If CheckDonateString($asSplitGeneralBlacklist[$i], $sClanString) Then
				SetLog("General Blacklist Keyword found: " & $asSplitGeneralBlacklist[$i], $COLOR_ERROR)
				SetLog("Skip: ...", $COLOR_ERROR)
				Return False
			EndIf
		Next

		For $i = 1 To UBound($asSplitBlacklist) - 1
			If CheckDonateString($asSplitBlacklist[$i], $sClanString) Then
				SetLog($sName & " Blacklist Keyword found: " & $asSplitBlacklist[$i], $COLOR_ERROR)
				SetLog("Skip: ...", $COLOR_ERROR)
				Return False
			EndIf
		Next

		If $bTroop Then
			If $iTroopIndex <> 99 Then
				If $g_iTotalDonateTroopCapacity = 0 Then Return False

				If $g_bDebugSetlog Then Setlog("$DonateTroopType Start: " & $g_asTroopNames[$iTroopIndex], $COLOR_DEBUG)

				; Space to donate troop?
				$g_iDonTroopsQuantityAv = Floor($g_iTotalDonateTroopCapacity / $g_aiTroopSpace[$iTroopIndex])
				If $g_iDonTroopsQuantityAv < 1 Then
					Setlog("Sorry Chief! " & $g_asTroopNamesPlural[$iTroopIndex] & " don't fit in the remaining space!")
					Return False
				EndIf
			EndIf
		Else
			If $g_iTotalDonateSpellCapacity = 0 Then Return False
			If $g_bDebugSetlog Then Setlog("DonateSpellType Start: " & $g_asSpellNames[$iTroopIndex], $COLOR_DEBUG)

			; Space to donate spell?
			$g_iDonSpellsQuantityAv = Floor($g_iTotalDonateSpellCapacity / $g_aiSpellSpace[$iTroopIndex])
			If $g_iDonSpellsQuantityAv < 1 Then
				Setlog("Sorry Chief! " & $g_asSpellNames[$iTroopIndex] & " spells don't fit in the remaining space!")
				Return
			EndIf
		EndIf
		If $ichkEnableDonateWhenReady = 1 Then
			If $iTroopIndex <> 99 Then
				If  $bTroop Then
					If $g_iSamM0dDebug = 1 Then SetLog($sName & ": " & Eval("Ready" & $g_asTroopShortNames[$iTroopIndex]))
					If Eval("Ready" & $g_asTroopShortNames[$iTroopIndex]) = 0 Then
						SetLog("Pre-Train not ready, skip donate " & $sName, $COLOR_RED)
						Return False
					EndIf
				Else
					If $g_iSamM0dDebug = 1 Then SetLog($sName & ": " & Eval("Ready" & $MySpellsButton[$iTroopIndex][0] & "Spell"))
					If Eval("Ready" & $MySpellsButton[$iTroopIndex][0] & "Spell") = 0 Then
						SetLog("Pre-Brew not ready, skip donate " & $sName, $COLOR_RED)
						Return False
					EndIf
				EndIf
			EndIf
		EndIf
		Return $bKeywordFound
	Else
		If $g_bDebugSetlog Then Setlog("Keyword for " & $sName & " not found.", $COLOR_DEBUG)
		Return False
	EndIf
EndFunc   ;==>CheckDonate

Func CheckDonateString($String, $ClanString) ;Checks if exact
	Local $Contains = StringMid($String, 1, 1) & StringMid($String, StringLen($String), 1)

	If $Contains = "[]" Then
		If $ClanString = StringMid($String, 2, StringLen($String) - 2) Then
			Return True
		Else
			Return False
		EndIf
	Else
		If StringInStr($ClanString, $String, 2) Then
			Return True
		Else
			Return False
		EndIf
	EndIf
EndFunc   ;==>CheckDonateString

Func DonateTroopType(Const $iTroopIndex, $Quant = 0, Const $Custom = False, Const $bDonateAll = False)
	Local $Slot = -1, $detectedSlot = -1
	Local $YComp = 0, $donaterow = -1
	Local $donateposinrow = -1
	Local $sTextToAll = ""

	If $g_iTotalDonateTroopCapacity = 0 Then Return
	If $g_bDebugSetlog Then SetDebugLog("$DonateTroopType Start: " & $g_asTroopNames[$iTroopIndex], $COLOR_DEBUG)

	; Space to donate troop?
	$g_iDonTroopsQuantityAv = Floor($g_iTotalDonateTroopCapacity / $g_aiTroopSpace[$iTroopIndex])
	If $g_iDonTroopsQuantityAv < 1 Then
		SetLog("Sorry Chief! " & $g_asTroopNamesPlural[$iTroopIndex] & " don't fit in the remaining space!")
		Return
	EndIf

	If $g_iDonTroopsQuantityAv >= $g_iDonTroopsLimit Then
		$g_iDonTroopsQuantity = $g_iDonTroopsLimit
	Else
		$g_iDonTroopsQuantity = $g_iDonTroopsQuantityAv
	EndIf

	; samm0d
	If $ichkEnableDonateWhenReady = 1 Then
		If $Custom = False Then
			If Eval("Ready" & $g_asTroopShortNames[$iTroopIndex]) < $g_iDonTroopsQuantity Then
				SetLog("Unit pre-train for " & $g_asTroopNames[$iTroopIndex] & " : " & Eval("Ready" & $g_asTroopShortNames[$iTroopIndex]), $COLOR_RED)
				SetLog("Reduce donate unit to " & Eval("Ready" & $g_asTroopShortNames[$iTroopIndex]), $COLOR_RED)
				$g_iDonTroopsQuantity = Eval("Ready" & $g_asTroopShortNames[$iTroopIndex])
			EndIf
		EndIf
	EndIf

	; Detect the Troops Slot
	If $g_bDebugOCRdonate Then
		Local $oldDebugOcr = $g_bDebugOcr
		$g_bDebugOcr = True
	EndIf

	$Slot = DetectSlotTroop($iTroopIndex)
	$detectedSlot = $Slot
	If $g_bDebugOCRdonate Then $g_bDebugOcr = $oldDebugOcr

	If $Slot = -1 Then Return

	; figure out row/position
	If $Slot < 0 Or $Slot > 11 Then
		setlog("Invalid slot # found = " & $Slot & " for " & $g_asTroopNames[$iTroopIndex], $COLOR_ERROR)
		Return
	EndIf
	If $g_bDebugSetlog Then SetDebugLog("slot found = " & $Slot & ", " & $g_asTroopNames[$Slot], $COLOR_DEBUG)
	$donaterow = 1 ;first row of troops
	$donateposinrow = $Slot
	If $Slot >= 6 And $Slot <= 11 Then
		$donaterow = 2 ;second row of troops
		$Slot = $Slot - 6
		$donateposinrow = $Slot
		$YComp = 88 ; correct 860x780
	EndIf

	; Verify if the type of troop to donate exists
	SetLog("Troops Condition Matched", $COLOR_ORANGE)
	If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $g_iDonationWindowY + 105 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
			_ColorCheck(_GetPixelColor(355 + ($Slot * 68), $g_iDonationWindowY + 106 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
			_ColorCheck(_GetPixelColor(360 + ($Slot * 68), $g_iDonationWindowY + 107 + $YComp, True), Hex(0x306ca8, 6), 20) Then ; check for 'blue'

		If $Custom Then
			; samm0d
			If $ichkEnableLimitDonateUnit Then
				If $iDonatedUnit + $Quant > $itxtLimitDonateUnit Then
					SetLog("Reach donate limit, reduce donate unit " & $Quant & " to " & $itxtLimitDonateUnit - $iDonatedUnit)
					$Quant = $itxtLimitDonateUnit - $iDonatedUnit
				EndIf
			EndIf

			If $bDonateAll Then $sTextToAll = " (to all requests)"
			SetLog("Donating " & $Quant & " " & ($Quant > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex]) & $sTextToAll, $COLOR_SUCCESS)

			If $g_bDebugOCRdonate Then
				SetLog("donate", $COLOR_ERROR)
				SetLog("row: " & $donaterow, $COLOR_ERROR)
				SetLog("pos in row: " & $donateposinrow, $COLOR_ERROR)
				setlog("coordinate: " & 365 + ($Slot * 68) & "," & $g_iDonationWindowY + 100 + $YComp, $COLOR_ERROR)
				debugimagesave("LiveDonateCC-r" & $donaterow & "-c" & $donateposinrow & "-" & $g_asTroopNames[$iTroopIndex] & "_")
			EndIf

				; Use slow click when the Train system is Quicktrain
				If $g_bQuickTrainEnable Then
					Local $icount = 0
					For $x = 0 To $Quant
						If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $g_iDonationWindowY + 105 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
								_ColorCheck(_GetPixelColor(355 + ($Slot * 68), $g_iDonationWindowY + 106 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
								_ColorCheck(_GetPixelColor(360 + ($Slot * 68), $g_iDonationWindowY + 107 + $YComp, True), Hex(0x306ca8, 6), 20) Then ; check for 'blue'

							Click(365 + ($Slot * 68), $g_iDonationWindowY + 100 + $YComp, 1, $DELAYDONATECC3, "#0175")
							If $g_iCommandStop = 3 Then
								$g_iCommandStop = 0
								$g_bFullArmy = False
							EndIf
							; samm0d
							$bJustMakeDonate = True
							$tempDisableTrain = False
							$iDonatedUnit += 1

							If $ichkEnableDonateWhenReady = 1 Then
								Assign("Ready" & $g_asTroopShortNames[$iTroopIndex], Eval("Ready" & $g_asTroopShortNames[$iTroopIndex]) - 1)
							EndIf
							If _Sleep(1000) Then Return
							$icount += 1
						EndIf
					Next
					$Quant = $icount ; Count Troops Donated Clicks
					$g_aiDonateStatsTroops[$iTroopIndex][0] += $Quant
				Else
					If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $g_iDonationWindowY + 105 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
							_ColorCheck(_GetPixelColor(355 + ($Slot * 68), $g_iDonationWindowY + 106 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
							_ColorCheck(_GetPixelColor(360 + ($Slot * 68), $g_iDonationWindowY + 107 + $YComp, True), Hex(0x306ca8, 6), 20) Then ; check for 'blue'

						Click(365 + ($Slot * 68), $g_iDonationWindowY + 100 + $YComp, $Quant, $DELAYDONATECC3, "#0175")
						$g_aiDonateStatsTroops[$iTroopIndex][0] += $Quant
						If $g_iCommandStop = 3 Then
							$g_iCommandStop = 0
							$g_bFullArmy = False
						EndIf
						; samm0d
						$iDonatedUnit += $Quant
						$bJustMakeDonate = True
						$tempDisableTrain = False
						If $ichkEnableDonateWhenReady = 1 Then
							Assign("Ready" & $g_asTroopShortNames[$iTroopIndex], Eval("Ready" & $g_asTroopShortNames[$iTroopIndex]) - $Quant)
						EndIf
					EndIf
				EndIf

				; Adjust Values for donated troops to prevent a Double ghost donate to stats and train
				If $iTroopIndex >= $eTroopBarbarian And $iTroopIndex <= $eTroopBowler Then
					;Reduce iTotalDonateCapacity by troops donated
					$g_iTotalDonateTroopCapacity -= ($Quant * $g_aiTroopSpace[$iTroopIndex])
					;If donated max allowed troop qty set $g_bSkipDonTroops = True
					If $g_iDonTroopsLimit = $Quant Then
						$g_bSkipDonTroops = True
					EndIf
				EndIf

		Else
			If $g_bDebugOCRdonate Then
				SetLog("donate", $color_RED)
				SetLog("row: " & $donaterow, $color_RED)
				SetLog("pos in row: " & $donateposinrow, $color_red)
				setlog("coordinate: " & 365 + ($Slot * 68) & "," & $g_iDonationWindowY + 100 + $YComp, $color_red)
				debugimagesave("LiveDonateCC-r" & $donaterow & "-c" & $donateposinrow & "-" & $g_asTroopNames[$iTroopIndex] & "_")
			EndIf

				; samm0d
				If $ichkEnableLimitDonateUnit Then
					If $iDonatedUnit + $g_iDonTroopsQuantity > $itxtLimitDonateUnit Then
						SetLog("Reach donate limit, reduce donate unit " & $g_iDonTroopsQuantity & " to " & $itxtLimitDonateUnit - $iDonatedUnit)
						$g_iDonTroopsQuantity = $itxtLimitDonateUnit - $iDonatedUnit
					EndIf
				EndIf

			; Use slow click when the Train system is Quicktrain
			If $g_bQuickTrainEnable = True Then
				Local $icount = 0
				For $x = 0 To $g_iDonTroopsQuantity
					If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $g_iDonationWindowY + 105 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
							_ColorCheck(_GetPixelColor(355 + ($Slot * 68), $g_iDonationWindowY + 106 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
							_ColorCheck(_GetPixelColor(360 + ($Slot * 68), $g_iDonationWindowY + 107 + $YComp, True), Hex(0x306ca8, 6), 20) Then ; check for 'blue'

						Click(365 + ($Slot * 68), $g_iDonationWindowY + 100 + $YComp, 1, $DELAYDONATECC3, "#0175")
						$icount += 1
						If $g_iCommandStop = 3 Then
							$g_iCommandStop = 0
							$g_bFullArmy = False
						EndIf
							; samm0d
							$bJustMakeDonate = True
							$tempDisableTrain = False
							$iDonatedUnit += 1
							If $ichkEnableDonateWhenReady = 1 Then
								Assign("Ready" & $g_asTroopShortNames[$iTroopIndex], Eval("Ready" & $g_asTroopShortNames[$iTroopIndex]) - 1)
							EndIf
						If _Sleep(1000) Then Return
					EndIf
				Next
				$g_iDonTroopsQuantity = $icount ; Count Troops Donated Clicks
				$g_aiDonateStatsTroops[$iTroopIndex][0] += $g_iDonTroopsQuantity
			Else
				If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $g_iDonationWindowY + 105 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
						_ColorCheck(_GetPixelColor(355 + ($Slot * 68), $g_iDonationWindowY + 106 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
						_ColorCheck(_GetPixelColor(360 + ($Slot * 68), $g_iDonationWindowY + 107 + $YComp, True), Hex(0x306ca8, 6), 20) Then ; check for 'blue'

					Click(365 + ($Slot * 68), $g_iDonationWindowY + 100 + $YComp, $g_iDonTroopsQuantity, $DELAYDONATECC3, "#0175")
					$g_aiDonateStatsTroops[$iTroopIndex][0] += $g_iDonTroopsQuantity
					If $g_iCommandStop = 3 Then
						$g_iCommandStop = 0
						$g_bFullArmy = False
					EndIf
						; samm0d
						$bJustMakeDonate = True
						$tempDisableTrain = False
						$iDonatedUnit += $g_iDonTroopsQuantity
						If $ichkEnableDonateWhenReady = 1 Then
							Assign("Ready" & $g_asTroopShortNames[$iTroopIndex], Eval("Ready" & $g_asTroopShortNames[$iTroopIndex]) - $g_iDonTroopsQuantity)
						EndIf
				EndIf
			EndIf

			If $bDonateAll Then $sTextToAll = " (to all requests)"
			SetLog("Donating " & $g_iDonTroopsQuantity & " " & ($g_iDonTroopsQuantity > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex]) & _
					$sTextToAll, $COLOR_GREEN)

			; Adjust Values for donated troops to prevent a Double ghost donate to stats and train
			If $iTroopIndex >= $eTroopBarbarian And $iTroopIndex <= $eTroopBowler Then
				;Reduce iTotalDonateCapacity by troops donated
				$g_iTotalDonateTroopCapacity -= ($g_iDonTroopsQuantity * $g_aiTroopSpace[$iTroopIndex])
				;If donated max allowed troop qty set $g_bSkipDonTroops = True
				If $g_iDonTroopsLimit = $g_iDonTroopsQuantity Then
					$g_bSkipDonTroops = True
				EndIf

			EndIf
		EndIf

		; Assign the donated quantity troops to train : $Don $g_asTroopName

		If $Custom Then
			$g_aiDonateTroops[$iTroopIndex] += $Quant
		Else
			$g_aiDonateTroops[$iTroopIndex] += $g_iDonTroopsQuantity
		EndIf

	ElseIf $g_aiDonatePixel[1] - 5 + $YComp > 675 Then
		SetLog("Unable to donate " & $g_asTroopNames[$iTroopIndex] & ". Donate screen not visible, will retry next run.", $COLOR_ERROR)
	Else
		SetLog("No " & $g_asTroopNames[$iTroopIndex] & " available to donate..", $COLOR_ERROR)
	EndIf

EndFunc   ;==>DonateTroopType

Func DonateSpellType(Const $iSpellIndex, $Quant = 0, Const $Custom = False, Const $bDonateAll = False)
	Local $Slot = -1, $detectedSlot = -1
	Local $YComp = 0, $donaterow = -1
	Local $donateposinrow = -1
	;Local $sTextToAll = ""

	If $g_iTotalDonateSpellCapacity = 0 Then Return
	If $g_bDebugSetlog Then SetDebugLog("DonateSpellType Start: " & $g_asSpellNames[$iSpellIndex], $COLOR_DEBUG)

	; Space to donate spell?
	$g_iDonSpellsQuantityAv = Floor($g_iTotalDonateSpellCapacity / $g_aiSpellSpace[$iSpellIndex])
	If $g_iDonSpellsQuantityAv < 1 Then
		SetLog("Sorry Chief! " & $g_asSpellNames[$iSpellIndex] & " spells don't fit in the remaining space!")
		Return
	EndIf

	If $g_iDonSpellsQuantityAv >= $iDonSpellsLimit Then
		$g_iDonSpellsQuantity = $iDonSpellsLimit
	Else
		$g_iDonSpellsQuantity = $g_iDonSpellsQuantityAv
	EndIf

	; samm0d
	If $ichkEnableDonateWhenReady = 1 Then
		If $Custom = False Then
			If Eval("Ready" & $MySpellsButton[$iSpellIndex][0] & "Spell") < $g_iDonSpellsQuantity Then
				SetLog("Unit pre-brew for " & $g_asSpellNames[$iSpellIndex] & " : " & Eval("Ready" & $MySpellsButton[$iSpellIndex][0] & "Spell"), $COLOR_RED)
				SetLog("Reduce donate unit to " & Eval("Ready" & $MySpellsButton[$iSpellIndex][0] & "Spell"), $COLOR_RED)
				$g_iDonSpellsQuantity = Eval("Ready" & $MySpellsButton[$iSpellIndex][0] & "Spell")
			EndIf
		EndIf
	EndIf

	; Detect the Spells Slot
	If $g_bDebugOCRdonate Then
		Local $oldDebugOcr = $g_bDebugOcr
		$g_bDebugOcr = True
	EndIf

	$Slot = DetectSlotSpell($iSpellIndex)
	$detectedSlot = $Slot
	If $g_bDebugSetlog Then SetDebugLog("slot found = " & $Slot, $COLOR_DEBUG)
	If $g_bDebugOCRdonate Then $g_bDebugOcr = $oldDebugOcr

	If $Slot = -1 Then Return

	; figure out row/position
	If $Slot < 12 Or $Slot > 17 Then
		setlog("Invalid slot # found = " & $Slot & " for " & $g_asSpellNames[$iSpellIndex], $COLOR_ERROR)
		Return
	EndIf
	$donaterow = 3 ;row of spells
	$Slot = $Slot - 12
	$donateposinrow = $Slot
	$YComp = 203 ; correct 860x780

	SetLog("Spells Condition Matched", $COLOR_ORANGE)
	If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $g_iDonationWindowY + 105 + $YComp, True), Hex(0x6038B0, 6), 20) Or _
			_ColorCheck(_GetPixelColor(355 + ($Slot * 68), $g_iDonationWindowY + 106 + $YComp, True), Hex(0x6038B0, 6), 20) Or _
			_ColorCheck(_GetPixelColor(360 + ($Slot * 68), $g_iDonationWindowY + 107 + $YComp, True), Hex(0x6038B0, 6), 20) Then ; check for 'purple'

		;If $bDonateAll Then $sTextToAll = " (to all requests)"
		;SetLog("Else Spell Colors Conditions Matched ALSO", $COLOR_ORANGE)
		;SetLog("Donating " & $g_iDonSpellsQuantity & " " & $g_asSpellNames[$iSpellIndex] & $sTextToAll, $COLOR_GREEN)
		;SetLog("click donate")
		If $g_bDebugOCRdonate Then
			SetLog("donate", $COLOR_ERROR)
			SetLog("row: " & $donaterow, $COLOR_ERROR)
			SetLog("pos in row: " & $donateposinrow, $COLOR_ERROR)
			setlog("coordinate: " & 365 + ($Slot * 68) & "," & $g_iDonationWindowY + 100 + $YComp, $COLOR_ERROR)
			debugimagesave("LiveDonateCC-r" & $donaterow & "-c" & $donateposinrow & "-" & $g_asSpellNames[$iSpellIndex] & "_")
		EndIf
		If Not $g_bDebugOCRdonate Then
			Click(365 + ($Slot * 68), $g_iDonationWindowY + 100 + $YComp, $g_iDonSpellsQuantity, $DELAYDONATECC3, "#0600")

			$g_bFullArmySpells = False
			$g_bFullArmy = False
			$g_aiDonateSpells[$iSpellIndex] += 1

			If $g_iCommandStop = 3 Then
				$g_iCommandStop = 0
				$g_bFullArmySpells = False
			EndIf
			; samm0d
			$bJustMakeDonate = True
			$tempDisableBrewSpell = False
			If $ichkEnableDonateWhenReady = 1 Then
				Assign("Ready" & $MySpellsButton[$iSpellIndex][0] & "Spell", Eval("Ready" & $MySpellsButton[$iSpellIndex][0] & "Spell") - $g_iDonSpellsQuantity)
			EndIf
			; DonatedSpell($iSpellIndex, $g_iDonSpellsQuantity)
			$g_aiDonateStatsSpells[$iSpellIndex][0] += $g_iDonSpellsQuantity
		EndIf

		; Assign the donated quantity Spells to train : $Don $g_asSpellName
		; need to implement assign $DonPoison etc later

	ElseIf $g_aiDonatePixel[1] - 5 + $YComp > 675 Then
		SetLog("Unable to donate " & $g_asSpellNames[$iSpellIndex] & ". Donate screen not visible, will retry next run.", $COLOR_ERROR)
	Else
		SetLog("No " & $g_asSpellNames[$iSpellIndex] & " available to donate..", $COLOR_ERROR)
	EndIf

EndFunc   ;==>DonateSpellType

Func DonateWindow($bOpen = True)
	If $g_bDebugSetlog And $bOpen Then SetLog("DonateWindow Open Start", $COLOR_DEBUG)
	If $g_bDebugSetlog And Not $bOpen Then SetLog("DonateWindow Close Start", $COLOR_DEBUG)

	If Not $bOpen Then ; close window and exit
		ClickP($aAway, 1, 0, "#0176")
		If _Sleep($DELAYDONATEWINDOW1) Then Return
		If $g_bDebugSetlog Then SetDebugLog("DonateWindow Close Exit", $COLOR_DEBUG)
		Return
	EndIf

	; Click on Donate Button and wait for the window
	Local $iLeft = 0, $iTop = 0, $iRight = 0, $iBottom = 0, $i
	For $i = 0 To UBound($aChatDonateBtnColors) - 1
		If $aChatDonateBtnColors[$i][1] < $iLeft Then $iLeft = $aChatDonateBtnColors[$i][1]
		If $aChatDonateBtnColors[$i][1] > $iRight Then $iRight = $aChatDonateBtnColors[$i][1]
		If $aChatDonateBtnColors[$i][2] < $iTop Then $iTop = $aChatDonateBtnColors[$i][2]
		If $aChatDonateBtnColors[$i][2] > $iBottom Then $iBottom = $aChatDonateBtnColors[$i][2]
	Next
	$iLeft += $g_aiDonatePixel[0]
	$iTop += $g_aiDonatePixel[1]
	$iRight += $g_aiDonatePixel[0] + 1
	$iBottom += $g_aiDonatePixel[1] + 1


	; samm0d
	Local $icount = 0
	While $icount < 8
		If $g_bDebugSetlog Then SetLog("$iLeft: " & $iLeft & ",   $iTop: " & $iTop & ",   $iRight: " & $iRight & ",   $iBottom: " & $iBottom)
		ForceCaptureRegion()
		;Local $g_aiDonatePixelCheck = _MultiPixelSearch($iLeft, $iTop, $iRight, $iBottom, 50, 1, Hex(0x98D057, 6), $aChatDonateBtnColors, 15)
		Local $g_aiDonatePixelCheck = _MultiPixelSearch($iLeft, $iTop, $iRight, $iBottom, -2, 1, Hex(0x6da725, 6), $aChatDonateBtnColors, 15)
		If IsArray($g_aiDonatePixelCheck) Then
			Click($g_aiDonatePixel[0] + 50, $g_aiDonatePixel[1] + 10, 1, 0, "#0174")
			If _Wait4Pixel(331, $g_aiDonatePixel[1], 0xFFFFFF, 6, 1500) Then
				ExitLoop
			EndIf
		Else
			If $g_bDebugSetlog Then SetLog("Could not find the Donate Button!", $COLOR_DEBUG)
		EndIf

		ClickP($aAway, 1, 0, "#D05")
		If _Sleep($DELAYDONATEWINDOW1) Then Return
		$icount += 1
	WEnd
	If $icount >= 8 Then
		SetLog("Could not find the Donate Button!", $COLOR_ERROR)
		Return False
	EndIf
	If _Sleep($DELAYDONATEWINDOW1) Then Return

	; Determinate the right position of the new Donation Window
	; Will search in $Y column = 410 for the first pure white color and determinate that position the $DonationWindowTemp
	$g_iDonationWindowY = 0

	ForceCaptureRegion()
	Local $aDonWinOffColors[1][3] = [[0xFFFFFF, 0, 2]]
	Local $aDonationWindow = _MultiPixelSearch(628, 0, 630, $g_iDEFAULT_HEIGHT, 1, 1, Hex(0xFFFFFF, 6), $aDonWinOffColors, 10)

	If IsArray($aDonationWindow) Then
		$g_iDonationWindowY = $aDonationWindow[1]
		If $g_bDebugSetlog Then SetDebugLog("$g_iDonationWindowY: " & $g_iDonationWindowY, $COLOR_DEBUG)
	Else
		SetLog("Could not find the Donate Window!", $COLOR_ERROR)
		Return False
	EndIf

	If $g_bDebugSetlog Then SetDebugLog("DonateWindow Open Exit", $COLOR_DEBUG)
	Return True
EndFunc   ;==>DonateWindow

Func DonateWindowCap(ByRef $g_bSkipDonTroops, ByRef $g_bSkipDonSpells)
	If $g_bDebugSetlog Then SetDebugLog("DonateCapWindow Start", $COLOR_DEBUG)
	;read troops capacity
	If Not $g_bSkipDonTroops Then
		Local $sReadCCTroopsCap = getCastleDonateCap(427, $g_iDonationWindowY + 12) ; use OCR to get donated/total capacity
		If $g_bDebugSetlog Then SetDebugLog("$sReadCCTroopsCap: " & $sReadCCTroopsCap, $COLOR_DEBUG)

		Local $aTempReadCCTroopsCap = StringSplit($sReadCCTroopsCap, "#")
		If $aTempReadCCTroopsCap[0] >= 2 Then
			;  Note - stringsplit always returns an array even if no values split!
			If $g_bDebugSetlog Then SetDebugLog("$aTempReadCCTroopsCap splitted :" & $aTempReadCCTroopsCap[1] & "/" & $aTempReadCCTroopsCap[2], $COLOR_DEBUG)
			If $aTempReadCCTroopsCap[2] > 0 Then
				$g_iDonTroopsAv = $aTempReadCCTroopsCap[1]
				$g_iDonTroopsLimit = $aTempReadCCTroopsCap[2]
				;SetLog("Donate Troops: " & $g_iDonTroopsAv & "/" & $g_iDonTroopsLimit)
			EndIf
		Else
			SetLog("Error reading the Castle Troop Capacity", $COLOR_ERROR) ; log if there is read error
			$g_iDonTroopsAv = 0
			$g_iDonTroopsLimit = 0
		EndIf
	EndIf

	If Not $g_bSkipDonSpells Then
		Local $sReadCCSpellsCap = getCastleDonateCap(420, $g_iDonationWindowY + 218) ; use OCR to get donated/total capacity
		If $g_bDebugSetlog Then SetDebugLog("$sReadCCSpellsCap: " & $sReadCCSpellsCap, $COLOR_DEBUG)
		Local $aTempReadCCSpellsCap = StringSplit($sReadCCSpellsCap, "#")
		If $aTempReadCCSpellsCap[0] >= 2 Then
			;  Note - stringsplit always returns an array even if no values split!
			If $g_bDebugSetlog Then SetDebugLog("$aTempReadCCSpellsCap splitted :" & $aTempReadCCSpellsCap[1] & "/" & $aTempReadCCSpellsCap[2], $COLOR_DEBUG)
			If $aTempReadCCSpellsCap[2] > 0 Then
				$g_iDonSpellsAv = $aTempReadCCSpellsCap[1]
				$iDonSpellsLimit = $aTempReadCCSpellsCap[2]
			EndIf
		Else
			SetLog("Error reading the Castle Spells Capacity", $COLOR_ERROR) ; log if there is read error
			$g_iDonSpellsAv = 0
			$iDonSpellsLimit = 0
		EndIf
	EndIf

	If $g_iDonTroopsAv = $g_iDonTroopsLimit Then
		$g_bSkipDonTroops = True
		SetLog("Donate Troop Limit Reached")
	EndIf
	If $g_iDonSpellsAv = $iDonSpellsLimit Then
		$g_bSkipDonSpells = True
		SetLog("Donate Spell Limit Reached")
	EndIf

	If $g_bSkipDonTroops = True And $g_bSkipDonSpells = True And $g_iDonTroopsAv < $g_iDonTroopsLimit And $g_iDonSpellsAv < $iDonSpellsLimit Then
		SetLog("Donate Troops: " & $g_iDonTroopsAv & "/" & $g_iDonTroopsLimit & ", Spells: " & $g_iDonSpellsAv & "/" & $iDonSpellsLimit)
	EndIf
	If Not $g_bSkipDonSpells And $g_iDonTroopsAv < $g_iDonTroopsLimit And $g_iDonSpellsAv = $iDonSpellsLimit Then SetLog("Donate Troops: " & $g_iDonTroopsAv & "/" & $g_iDonTroopsLimit)
	If Not $g_bSkipDonTroops And $g_iDonTroopsAv = $g_iDonTroopsLimit And $g_iDonSpellsAv < $iDonSpellsLimit Then SetLog("Donate Spells: " & $g_iDonSpellsAv & "/" & $iDonSpellsLimit)

	If $g_bDebugSetlog Then
		SetDebugLog("$g_bSkipDonTroops: " & $g_bSkipDonTroops, $COLOR_DEBUG)
		SetDebugLog("$g_bSkipDonSpells: " & $g_bSkipDonSpells, $COLOR_DEBUG)
		SetDebugLog("DonateCapWindow End", $COLOR_DEBUG)
	EndIf

EndFunc   ;==>DonateWindowCap

Func RemainingCCcapacity()
	; Remaining CC capacity of requested troops from your ClanMates
	; Will return the $g_iTotalDonateTroopCapacity with that capacity for use in donation logic.

	Local $sCapTroops = "", $aTempCapTroops, $sCapSpells = "", $aTempCapSpells, $sCapSiegeMachine = "", $aTempCapSiegeMachine
	Local $iDonatedTroops = 0, $iDonatedSpells = 0, $iDonatedSiegeMachine = 0
	Local $iCapTroopsTotal = 0, $iCapSpellsTotal = 0, $iCapSiegeMachineTotal = 0

	$g_iTotalDonateTroopCapacity = -1
	$g_iTotalDonateSpellCapacity = -1

	; Verify with OCR the Donation Clan Castle capacity
	If $g_bDebugSetLog Then SetDebugLog("Start dual getOcrSpaceCastleDonate", $COLOR_DEBUG)

	$sCapTroops = getOcrSpaceCastleDonate(27, $g_aiDonatePixel[1])
	If StringInStr($sCapTroops, "#") Then ;CC got Troops & Spells & Siege Machine
		$sCapSpells = getOcrSpaceCastleDonate(110, $g_aiDonatePixel[1])
		$sCapSiegeMachine = getOcrSpaceCastleDonate(170, $g_aiDonatePixel[1])
	Else
		$sCapTroops = getOcrSpaceCastleDonate(60, $g_aiDonatePixel[1])
		If StringRegExp($sCapTroops, "#([0-9]{2})") = 1 Then ; CC got Troops & Spells
			$sCapSpells = getOcrSpaceCastleDonate(160, $g_aiDonatePixel[1])
			$sCapSiegeMachine = -1
		Else
			$sCapTroops = getOcrSpaceCastleDonate(82, $g_aiDonatePixel[1])
			$sCapSpells = -1
			$sCapSiegeMachine = -1
		EndIf
	EndIf

	If $g_bDebugSetLog Then
		SetDebugLog("$sCapTroops :" & $sCapTroops, $COLOR_DEBUG)
		SetDebugLog("$sCapSpells :" & $sCapSpells, $COLOR_DEBUG)
		SetDebugLog("$sCapSiegeMachine :" & $sCapSiegeMachine, $COLOR_DEBUG)
	EndIf

	If $sCapTroops <> "" And StringInStr($sCapTroops, "#") Then
		; Splitting the XX/XX
		$aTempCapTroops = StringSplit($sCapTroops, "#")

		; Local Variables to use
		If $aTempCapTroops[0] >= 2 Then
			;  Note - stringsplit always returns an array even if no values split!
			If $g_bDebugSetlog Then SetDebugLog("$aTempCapTroops splitted :" & $aTempCapTroops[1] & "/" & $aTempCapTroops[2], $COLOR_DEBUG)
			If $aTempCapTroops[2] > 0 Then
				$iDonatedTroops = $aTempCapTroops[1]
				$iCapTroopsTotal = $aTempCapTroops[2]
				If $iCapTroopsTotal = 0 Then
					$iCapTroopsTotal = 30
				EndIf
				If $iCapTroopsTotal = 5 Then
					$iCapTroopsTotal = 35
				EndIf
			EndIf
		Else
			SetLog("Error reading the Castle Troop Capacity[1]...", $COLOR_ERROR) ; log if there is read error
			$iDonatedTroops = 0
			$iCapTroopsTotal = 0
		EndIf
	Else
		SetLog("Error reading the Castle Troop Capacity[2]...", $COLOR_ERROR) ; log if there is read error
		$iDonatedTroops = 0
		$iCapTroopsTotal = 0
	EndIf

	If $sCapSpells <> -1 Then
		If $sCapSpells <> "" Then
			; Splitting the XX/XX
			$aTempCapSpells = StringSplit($sCapSpells, "#")

			; Local Variables to use
			If $aTempCapSpells[0] >= 2 Then
				; Note - stringsplit always returns an array even if no values split!
				If $g_bDebugSetlog Then SetDebugLog("$aTempCapSpells splitted :" & $aTempCapSpells[1] & "/" & $aTempCapSpells[2], $COLOR_DEBUG)
				If $aTempCapSpells[2] > 0 Then
					$iDonatedSpells = $aTempCapSpells[1]
					$iCapSpellsTotal = $aTempCapSpells[2]
				EndIf
			Else
				SetLog("Error reading the Castle Spell Capacity[1]...", $COLOR_ERROR) ; log if there is read error
				$iDonatedSpells = 0
				$iCapSpellsTotal = 0
			EndIf
		Else
			SetLog("Error reading the Castle Spell Capacity[2]...", $COLOR_ERROR) ; log if there is read error
			$iDonatedSpells = 0
			$iCapSpellsTotal = 0
		EndIf
	EndIf


	If $sCapSiegeMachine <> -1 Then
		If $sCapSiegeMachine <> "" Then
			; Splitting the XX/XX
			$aTempCapSiegeMachine = StringSplit($sCapSiegeMachine, "#")

			; Local Variables to use
			If $aTempCapSiegeMachine[0] >= 2 Then
				; Note - stringsplit always returns an array even if no values split!
				If $g_bDebugSetlog Then SetDebugLog("$aTempCapSiegeMachine splitted :" & $aTempCapSiegeMachine[1] & "/" & $aTempCapSiegeMachine[2], $COLOR_DEBUG)
				If $aTempCapSiegeMachine[2] > 0 Then
					$iDonatedSiegeMachine = $aTempCapSiegeMachine[1]
					$iCapSiegeMachineTotal = $aTempCapSiegeMachine[2]
				EndIf
			Else
				SetLog("Error reading the Castle Siege Machine Capacity[1]...", $COLOR_ERROR) ; log if there is read error
				$iDonatedSiegeMachine = 0
				$iCapSiegeMachineTotal = 0
			EndIf
		Else
			SetLog("Error reading the Castle Siege Machine Capacity[2]...", $COLOR_ERROR) ; log if there is read error
			$iDonatedSiegeMachine = 0
			$iCapSiegeMachineTotal = 0
		EndIf
	EndIf

	; $g_iTotalDonateTroopCapacity it will be use to determinate the quantity of kind troop to donate
	$g_iTotalDonateTroopCapacity = ($iCapTroopsTotal - $iDonatedTroops)
	If $sCapSpells <> -1 Then $g_iTotalDonateSpellCapacity = ($iCapSpellsTotal - $iDonatedSpells)
	If $sCapSiegeMachine <> -1 Then $g_iTotalDonateSiegeMachineCapacity = ($iCapSiegeMachineTotal - $iDonatedSiegeMachine)

	If $g_iTotalDonateTroopCapacity < 0 Then
		SetLog("Unable to read Clan Castle Capacity!", $COLOR_ERROR)
	Else
		Local $sSpellText = $sCapSpells <> -1 ? ", Spells: " & $iDonatedSpells & "/" & $iCapSpellsTotal : ""
		Local $sSiegeMachineText = $sCapSiegeMachine <> -1 ? ", Siege Machine: " & $iDonatedSiegeMachine & "/" & $iCapSiegeMachineTotal : ""

		SetLog("Chat Troops: " & $iDonatedTroops & "/" & $iCapTroopsTotal & $sSpellText & $sSiegeMachineText)
	EndIf
EndFunc   ;==>RemainingCCcapacity

Func DetectSlotTroop(Const $iTroopIndex)
	Local $FullTemp

	For $Slot = 0 To 5
		Local $x = 343 + (68 * $Slot)
		Local $y = $g_iDonationWindowY + 37
		Local $x1 = $x + 75
		Local $y1 = $y + 43

		$FullTemp = SearchImgloc($g_sImgDonateTroops, $x, $y, $x1, $y1)
		If $g_bDebugSetlog Then SetDebugLog("Troop Slot: " & $Slot & " SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)

		If StringInStr($FullTemp[0] & " ", "empty") > 0 Then ExitLoop

		If $FullTemp[0] <> "" Then
			For $i = $eTroopBarbarian To $eTroopBowler
				Local $sTmp = StringStripWS(StringLeft($g_asTroopNames[$i], 4), $STR_STRIPTRAILING)
				If StringInStr($FullTemp[0] & " ", $sTmp) > 0 Then
					If $g_bDebugSetlog Then SetDebugLog("Detected " & $g_asTroopNames[$i], $COLOR_DEBUG)
					If $iTroopIndex = $i Then Return $Slot
					ExitLoop
				EndIf
				If $i = $eTroopBowler Then ; detection failed
					If $g_bDebugSetlog Then SetDebugLog("Slot: " & $Slot & "Troop Detection Failed", $COLOR_DEBUG)
				EndIf
			Next
		EndIf
	Next

	For $Slot = 6 To 11
		Local $x = 343 + (68 * ($Slot - 6))
		Local $y = $g_iDonationWindowY + 124
		Local $x1 = $x + 75
		Local $y1 = $y + 43

		$FullTemp = SearchImgloc($g_sImgDonateTroops, $x, $y, $x1, $y1)
		If $g_bDebugSetlog Then SetDebugLog("Troop Slot: " & $Slot & " SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)

		If StringInStr($FullTemp[0] & " ", "empty") > 0 Then ExitLoop

		If $FullTemp[0] <> "" Then
			For $i = $eTroopBalloon To $eTroopBowler
				Local $sTmp = StringStripWS(StringLeft($g_asTroopNames[$i], 4), $STR_STRIPTRAILING)
				If StringInStr($FullTemp[0] & " ", $sTmp) > 0 Then
					If $g_bDebugSetlog Then SetDebugLog("Detected " & $g_asTroopNames[$i], $COLOR_DEBUG)
					If $iTroopIndex = $i Then Return $Slot
					ExitLoop
				EndIf
				If $i = $eTroopBowler Then ; detection failed
					If $g_bDebugSetlog Then SetDebugLog("Slot: " & $Slot & "Troop Detection Failed", $COLOR_DEBUG)
				EndIf
			Next
		EndIf
	Next

	Return -1

EndFunc   ;==>DetectSlotTroop

Func DetectSlotSpell(Const $iSpellIndex)
	Local $FullTemp

	For $Slot = 12 To 17
		Local $x = 343 + (68 * ($Slot - 12))
		Local $y = $g_iDonationWindowY + 241
		Local $x1 = $x + 75
		Local $y1 = $y + 43

		$FullTemp = SearchImgloc($g_sImgDonateSpells, $x, $y, $x1, $y1)
		If $g_bDebugSetlog Then SetDebugLog("Spell Slot: " & $Slot & " SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)

		If StringInStr($FullTemp[0] & " ", "empty") > 0 Then ExitLoop

		If $FullTemp[0] <> "" Then
			For $i = $eSpellLightning To $eSpellSkeleton
				Local $sTmp = StringLeft($g_asSpellNames[$i], 4)
				If StringInStr($FullTemp[0] & " ", $sTmp) > 0 Then
					If $g_bDebugSetlog Then SetDebugLog("Detected " & $g_asSpellNames[$i], $COLOR_DEBUG)
					If $iSpellIndex = $i Then Return $Slot
					ExitLoop
				EndIf
				If $i = $eSpellSkeleton Then ; detection failed
					If $g_bDebugSetlog Then SetDebugLog("Slot: " & $Slot & "Spell Detection Failed", $COLOR_DEBUG)
				EndIf
			Next
		EndIf
	Next

	Return -1

EndFunc   ;==>DetectSlotSpell

Func SkipDonateNearFullTroops($bSetLog = False, $aHeroResult = Default)

	If Not $g_bDonationEnabled Then Return True ; will disable the donation

	If Not $g_bDonateSkipNearFullEnable Then Return False ; will enable the donation

	If $g_iCommandStop = 0 And $g_bTrainEnabled Then Return False ; IF is halt Attack and Train/Donate ....Enable the donation

	Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)

	If Not $g_abDonateHours[$hour[0]] And $g_bDonateHoursEnable Then Return True ; will disable the donation

	If $g_bDonateSkipNearFullEnable Then
		If $g_iArmyCapacity > $g_iDonateSkipNearFullPercent Then
			Local $rIsWaitforHeroesActive = IsWaitforHeroesActive()
			If $rIsWaitforHeroesActive Then
				If $aHeroResult = Default Or Not IsArray($aHeroResult) Then
					If Not OpenArmyOverview(True, "SkipDonateNearFullTroops()") Then Return False ; Return False if failed to Open Army Window
					$aHeroResult = getArmyHeroTime("all")
				EndIf
				If @error Or UBound($aHeroResult) < 3 Then
					SetLog("getArmyHeroTime return error: #" & @error & "|IA:" & IsArray($aHeroResult) & "," & UBound($aHeroResult) & ", exit SkipDonateNearFullTroops!", $COLOR_ERROR)
					Return False ; if error, then quit SkipDonateNearFullTroops enable the donation
				EndIf
				If $g_bDebugSetlog Then SetDebugLog("getArmyHeroTime returned: " & $aHeroResult[0] & ":" & $aHeroResult[1] & ":" & $aHeroResult[2], $COLOR_DEBUG)
				Local $iActiveHero = 0
				Local $iHighestTime = -1
				For $pTroopType = $eKing To $eWarden ; check all 3 hero
					For $pMatchMode = $DB To $g_iModeCount - 1 ; check all attack modes
						$iActiveHero = -1
						If IsSearchModeActiveMini($pMatchMode) And IsSpecialTroopToBeUsed($pMatchMode, $pTroopType) And $g_iHeroUpgrading[$pTroopType - $eKing] <> 1 And $g_iHeroWaitAttackNoBit[$pMatchMode][$pTroopType - $eKing] = 1 Then
							$iActiveHero = $pTroopType - $eKing ; compute array offset to active hero
						EndIf
						;SetLog("$iActiveHero = " & $iActiveHero, $COLOR_DEBUG)
						If $iActiveHero <> -1 And $aHeroResult[$iActiveHero] > 0 Then ; valid time?
							If $aHeroResult[$iActiveHero] > $iHighestTime Then ; Is the time higher than indexed time?
								$iHighestTime = $aHeroResult[$iActiveHero]
							EndIf
						EndIf
					Next
					If _Sleep($DELAYRESPOND) Then Return
				Next
				If $g_bDebugSetlog Then SetDebugLog("$iHighestTime = " & $iHighestTime & "|" & String($iHighestTime > 5), $COLOR_DEBUG)
				If $iHighestTime > 5 Then
					If $bSetLog Then SetLog("Donations enabled, Heroes recover time is long", $COLOR_INFO)
					Return False
				Else
					If $bSetLog Then SetLog("Donation disabled, available troops " & $g_iArmyCapacity & "%, limit " & $g_iDonateSkipNearFullPercent & "%", $COLOR_INFO)
					Return True ; troops camps% > limit
				EndIf
			Else
				If $bSetLog Then SetLog("Donation disabled, available troops " & $g_iArmyCapacity & "%, limit " & $g_iDonateSkipNearFullPercent & "%", $COLOR_INFO)
				Return True ; troops camps% > limit
			EndIf
		Else
			If $bSetLog Then SetLog("Donations enabled, available troops " & $g_iArmyCapacity & "%, limit " & $g_iDonateSkipNearFullPercent & "%", $COLOR_INFO)
			Return False ; troops camps% into limits
		EndIf
	Else
		Return False ; feature disabled
	EndIf
EndFunc   ;==>SkipDonateNearFullTroops

Func BalanceDonRec($bSetlog = False)

	If Not $g_bDonationEnabled Then Return False ; Will disable donation
	If Not $g_bUseCCBalanced Then Return True ; will enable the donation
	If $g_iCommandStop = 0 And $g_bTrainEnabled Then Return True ; IF is halt Attack and Train/Donate ....Enable the donation

	Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)

	If Not $g_abDonateHours[$hour[0]] And $g_bDonateHoursEnable Then Return False ; will disable the donation


	If $g_bUseCCBalanced Then
		If $g_iTroopsDonated = 0 And $g_iTroopsReceived = 0 Then ProfileReport()
		If Number($g_iTroopsReceived) <> 0 Then
			If Number(Number($g_iTroopsDonated) / Number($g_iTroopsReceived)) >= (Number($g_iCCDonated) / Number($g_iCCReceived)) Then
				;Stop Donating
				If $bSetlog Then SetLog("Skipping Donation because Donate/Recieve Ratio is wrong", $COLOR_INFO)
				Return False
			Else
				; Continue
				Return True
			EndIf
		EndIf
	Else
		Return True
	EndIf
EndFunc   ;==>BalanceDonRec

Func SearchImgloc($directory = "", $x = 0, $y = 0, $x1 = 0, $y1 = 0)

	; Setup arrays, including default return values for $return
	Local $aResult[1], $aCoordArray[1][2], $aCoords, $aCoordsSplit, $aValue
	Local $Redlines = "FV"
	; Capture the screen for comparison
	_CaptureRegion2($x, $y, $x1, $y1)
	Local $res = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $directory, "str", "FV", "Int", 0, "str", $Redlines, "Int", 0, "Int", 1000)

	If $res[0] <> "" Then
		; Get the keys for the dictionary item.
		Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)

		; Redimension the result array to allow for the new entries
		ReDim $aResult[UBound($aKeys)]

		; Loop through the array
		For $i = 0 To UBound($aKeys) - 1
			; Get the property values
			$aResult[$i] = RetrieveImglocProperty($aKeys[$i], "objectname")
		Next
		Return $aResult
	EndIf
	$aResult[0] = "queued"
	Return $aResult
EndFunc   ;==>SearchImgloc
