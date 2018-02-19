; #FUNCTION# ====================================================================================================================
; Name ..........: imglocCheckWall
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........: Trlopes (06-2016)
; Modified ......: Samkie (30, May 2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; Script Start - Add your code below here
Func imglocCheckWall()

	Local $bProcessFindWall = False
	If $ichkSmartUpdateWall = 1 Then ; Use smart wall update
		If $iFaceDirection = -1 Then
			$bProcessFindWall = True ; check got node or not, if not then process find wall
		Else
			$bProcessFindWall = GetWallPositionForUpdate()
		EndIf
	Else
		$bProcessFindWall = True
	EndIf

	If $bProcessFindWall Then

	If _Sleep(500) Then Return

	Local $levelWall = $g_iCmbUpgradeWallsLevel + 4
	Local $iXClickOffset = 0
	Local $iYClickOffset = 0

	Switch $levelWall
		Case 8
			$iXClickOffset = 1
			$iYClickOffset = -1
		Case 10
			$iXClickOffset = 2
			$iYClickOffset = 2
		Case 11
			$iXClickOffset = 1
			$iYClickOffset = -2
	EndSwitch

	_CaptureRegion2()
	SetLog("Searching for Wall(s) level: " & $levelWall & ". Using imgloc: ", $COLOR_SUCCESS)
	;name , level , coords
	Local $FoundWalls[1]
	$FoundWalls[0] = "" ; empty value to make sure return value filled
	$FoundWalls = imglocFindWalls($levelWall, "ECD", "ECD", 10) ; lets get 10 points just to make sure we discard false positives

	ClickP($aAway, 1, 0, "#0505") ; to prevent bot 'Anyone there ?'

	If ($FoundWalls[0] = "") Then ; nothing found
		SetLog("No wall(s) level: " & $levelWall & " found.", $COLOR_ERROR)
	Else
		Local $iErrorCount = 0
		Local $aResult

		For $i=0 to ubound($FoundWalls)-1
			If $g_bDebugSetlog Then SetLog("$FoundWalls[" & $i & "]: " & $FoundWalls[$i])
			Local $WallCoordsArray = StringSplit($FoundWalls[$i], "|", $STR_NOCOUNT)

			for $fc = 0 to ubound( $WallCoordsArray)-1
				If $g_bDebugSetlog Then SetLog("$WallCoordsArray: " & $WallCoordsArray[$fc])
				If $WallCoordsArray[$fc] <> "" Then
				Local $aCoord = StringSplit($WallCoordsArray[$fc],",",$STR_NOCOUNT )
				SetLog("Found: " & $FoundWalls[$i] & " possible Wall position: " & $WallCoordsArray[$fc], $COLOR_SUCCESS)
				SetLog("Checking if found position is a Wall and of desired level.", $COLOR_SUCCESS)
				;try click
				$aCoord[0] = $aCoord[0] + $iXClickOffset
				$aCoord[1] = $aCoord[1] + $iYClickOffset
				GemClick($aCoord[0],$aCoord[1])
				If _Sleep($itxtClickWallDelay) Then Return True; delay
				$aResult = BuildingInfo(245, 520 + $g_iBottomOffsetY) ; Get building name and level with OCR
				If $aResult[0] = 2 Then ; We found a valid building name
					If (StringInStr($aResult[1], "wall") = True Or StringInStr($aResult[1], "W ll") = True) And Number($aResult[2]) = ($levelWall) Then ; we found a wall
						Setlog("Position : " &  $WallCoordsArray[$fc] & " is a Wall Level: " & $levelWall  & ".")
						; so far i only test on wall level 10 update to 11, and i not sure the x,y result for other level of wall need adjust offset or not.
						If $ichkSmartUpdateWall = 1 Then
							$aBaseNode[0] = $aCoord[0]
							$aBaseNode[1] = $aCoord[1]
							$aLastWall[0] = $aBaseNode[0] + 8
							$aLastWall[1] = $aBaseNode[1] - 6
							$iFaceDirection = 1
;~ 							SetLog("=-=-=-=-=-Advanced update for wall-=-=-=-=-=")
;~ 							SetLog("Base Node android pos X,Y: " & $aBaseNode[0] & "," & $aBaseNode[1])
;~ 							SetLog("Next Update Wall android pos X,Y: " & $aLastWall[0] & "," & $aLastWall[1])
							ConvertFromVillagePos($aBaseNode[0],$aBaseNode[1])
							ConvertFromVillagePos($aLastWall[0],$aLastWall[1])
;~ 							SetLog("--------------------------------------------")
;~ 							SetLog("Base Node village pos X,Y: " & $aBaseNode[0] & "," & $aBaseNode[1])
;~ 							SetLog("Next Update Wall village pos X,Y: " & $aLastWall[0] & "," & $aLastWall[1])
;~ 							SetLog("Face Direction: " & $iFaceDirection)
;~ 							SetLog("=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
						EndIf
						Return True
					Else
						If $g_bDebugSetlog Then
							ClickP($aAway, 1, 0, "#0931") ;Click Away
							Setlog("Position : " &  $WallCoordsArray[$fc] & " is not a Wall Level: " & $levelWall & ". It was: " & $aResult[1] & ", " & $aResult[2] & " !", $COLOR_DEBUG) ;debug
						Else
							ClickP($aAway, 1, 0, "#0932") ;Click Away
							Setlog("Position : " &  $WallCoordsArray[$fc] & " is not a Wall Level: " & $levelWall & ".", $COLOR_ERROR)
						EndIf
					EndIf
				Else
					ClickP($aAway, 1, 0, "#0933") ;Click Away
				EndIf
				$iErrorCount += 1
				If $iErrorCount >= 5 Then
					Return False
				EndIf
				EndIf
			Next
		Next
	EndIf
	Else
		Return True
	EndIf
	Return False
EndFunc   ;==>imglocCheckWall

Func imglocFindWalls($walllevel, $searcharea = "DCD", $redline = "", $maxreturn = 0)
	; Will find maxreturn Wall in specified diamond

	;name , level , coords
	Local $FoundWalls[1] = [""] ;

	Local $redLines = $redline
	Local $minLevel = $walllevel
	Local $maxLevel = $walllevel
	Local $maxReturnPoints = $maxreturn

	; Perform the search
	Local $result = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $g_sImgCheckWallDir, "str", $searcharea, "Int", $maxReturnPoints, "str", $redLines, "Int", $minLevel, "Int", $maxLevel)
	Local $error = @error ; Store error values as they reset at next function call
	Local $extError = @extended

	If $error Then
		_logErrorDLLCall($g_sLibMyBotPath, $error)
		SetLog(" imgloc DLL Error imgloc " & $error & " --- " & $extError, $COLOR_RED)
		SetError(2, $extError, $error) ; Set external error code = 2 for DLL error
		Return
	EndIf

	If checkImglocError($result, "imglocFindWalls", $g_sImgCheckWallDir) = True Then
		Return $FoundWalls
	EndIf

	; Process results
	If $result[0] <> "" Then
		; Get the keys for the dictionary item.
		If $g_bDebugSetlog Then SetDebugLog(" imglocFindMyWall search returned : " & $result[0])
		Local $aKeys = StringSplit($result[0], "|", $STR_NOCOUNT)
		; Loop through the array
		ReDim $FoundWalls[UBound($aKeys)]
		For $i = 0 To UBound($aKeys) - 1
			; Get the property values
			; Loop through the found object names
			Local $aCoords = RetrieveImglocProperty($aKeys[$i], "objectpoints")
			$FoundWalls[$i] = $aCoords
		Next
	EndIf
	Return $FoundWalls
EndFunc   ;==>imglocFindWalls

Func GetWallPositionForUpdate()
	Local $iCount = 0
	Local $iCountRecorrect = 0
	ConvertToVillagePos($aLastWall[0], $aLastWall[1])
	While 1
		If $g_bDebugSetlog Then SetLog($iFaceDirection & " click and check x,y:" & $aLastWall[0] & "," & $aLastWall[1])
		SetLog("Click position " & $aLastWall[0] & "," & $aLastWall[1] & " for check wall", $COLOR_INFO)
		GemClick($aLastWall[0],$aLastWall[1]) ; click the wall
		If _Sleep($itxtClickWallDelay) Then Return True; delay
		Local $iCheckWallReturn = CheckWallLevel() ; check the ocr after click, is that a wall and the level we need to update?

		Switch $iFaceDirection ; after check wall, prepare the click for next click use
			Case 1
				$aLastWall[0] += 8
				$aLastWall[1] -= 6
			Case 2
				$aLastWall[0] += 8
				$aLastWall[1] += 6
			Case 3
				$aLastWall[0] -= 8
				$aLastWall[1] += 6
			Case 4
				$aLastWall[0] -= 8
				$aLastWall[1] -= 6
		EndSwitch

		Switch $iCheckWallReturn
			Case 0
				; change another direction start again at node
				Setlog("Position is not a wall.", $COLOR_INFO)
				If $iCountRecorrect > 1 Then
					$iCountRecorrect = 0
					If $iFaceDirection = 4 Then ; if 4 directions process finish, reset all data, and let the image search engine find wall again.
						$aLastWall[0] = -1
						$aLastWall[1] = -1
						$aBaseNode[0] = -1
						$aBaseNode[1] = -1
						$iFaceDirection = -1
						If $g_bDebugSetlog Then SetLog("RESET Node and let the DllCall for find wall again")
						Return True
					Else
						$iFaceDirection += 1
						Setlog("Change direction: " & $iFaceDirection, $COLOR_INFO)
						$aLastWall[0] = $aBaseNode[0]
						$aLastWall[1] = $aBaseNode[1]
						Switch $iFaceDirection ; after check wall, prepare the click for next click use
							Case 2
								$aLastWall[0] += 8
								$aLastWall[1] += 6
							Case 3
								$aLastWall[0] -= 8
								$aLastWall[1] += 6
							Case 4
								$aLastWall[0] -= 8
								$aLastWall[1] -= 6
						EndSwitch
						ConvertToVillagePos($aLastWall[0], $aLastWall[1])
					EndIf
				Else
					$iCountRecorrect += 1
				EndIf
			Case 1
				Setlog("Position is a Wall Level: " & $g_iCmbUpgradeWallsLevel + 4, $COLOR_INFO)
;~ 				SetLog("=-=-=-=-=-Advanced update for wall-=-=-=-=-=")
;~ 				SetLog("Next Update Wall android pos X,Y: " & $aLastWall[0] & "," & $aLastWall[1])
;~ 				SetLog("--------------------------------------------")
				ConvertFromVillagePos($aLastWall[0],$aLastWall[1])
;~ 				SetLog("Next Update Wall village pos X,Y: " & $aLastWall[0] & "," & $aLastWall[1])
;~ 				SetLog("Face Direction: " & $iFaceDirection)
;~ 				SetLog("=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
				Return False ; return false for no need use the DllCall to find wall again. and let the process continue update wall with gold or elixir
			Case 101 To 115
				Setlog("Position is a wall but Level: " & ($iCheckWallReturn - 100), $COLOR_INFO)
		EndSwitch
		; else we continue looping and looking for next click

		; some prevention for Endless loop
		$iCount+=1
		If $iCount > 100 Then
			ExitLoop
		EndIf
	WEnd

	ConvertFromVillagePos($aLastWall[0], $aLastWall[1])
	Return True
EndFunc

Func CheckWallLevel()
	Local $aResult = BuildingInfo(245, 520 + $g_iBottomOffsetY)
	If $aResult[0] = 2 Then ; We found a valid building name
		If StringInStr($aResult[1], "wall") = True Or StringInStr($aResult[1], "W ll") = True Then
			If Number($aResult[2]) = ($g_iCmbUpgradeWallsLevel + 4) Then ; we found a wall
				Return 1 ; return 1 the wall level we need update
			Else
				Return 100 + Number($aResult[2]) ; return 2 is wall but the level not is we need for update
			EndIf
		EndIf
	EndIf
	Return 0
EndFunc