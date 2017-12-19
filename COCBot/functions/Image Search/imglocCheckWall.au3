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
		If $aBaseNode[0] = -1 Then
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
				GemClick($aCoord[0],$aCoord[1])
				If _Sleep($itxtClickWallDelay) Then Return True; delay
				$aResult = BuildingInfo(245, 520 + $g_iBottomOffsetY) ; Get building name and level with OCR
				If $aResult[0] = 2 Then ; We found a valid building name
					If (StringInStr($aResult[1], "wall") = True Or StringInStr($aResult[1], "W ll") = True) And Number($aResult[2]) = ($g_iCmbUpgradeWallsLevel + 4) Then ; we found a wall
						Setlog("Position : " &  $WallCoordsArray[$fc] & " is a Wall Level: " & $g_iCmbUpgradeWallsLevel + 4  & ".")
						; so far i only test on wall level 10 update to 11, and i not sure the x,y result for other level of wall need adjust offset or not.
						If $ichkSmartUpdateWall = 1 Then
							Switch $g_iCmbUpgradeWallsLevel + 4
								Case 8
									$aBaseNode[0] = $aCoord[0] + 1
									$aBaseNode[1] = $aCoord[1] - 1
								Case Else
									$aBaseNode[0] = $aCoord[0] ;reserved for maybe need adjust some offset
									$aBaseNode[1] = $aCoord[1] ;reserved for maybe need adjust some offset
							EndSwitch
							ConvertToVillagePos($aBaseNode[0],$aBaseNode[1])
							If $g_bDebugSetlog Then Setlog("BaseNode1: " & $aBaseNode[0] & "," & $aBaseNode[1])
							SetLog("=-=-=-=-=-Advanced update for wall-=-=-=-=-=")
							SetLog("Base Node X,Y: " & $aBaseNode[0] & "," & $aBaseNode[1])
							SetLog("Last Update Wall X,Y: " & $aLastWall[0] & "," & $aLastWall[1])
							SetLog("Face Direction: " & $iFaceDirection)
						EndIf
						Return True
					Else
						If $g_bDebugSetlog Then
							ClickP($aAway, 1, 0, "#0931") ;Click Away
							Setlog("Position : " &  $WallCoordsArray[$fc] & " is not a Wall Level: " & $g_iCmbUpgradeWallsLevel + 4 & ". It was: " & $aResult[1] & ", " & $aResult[2] & " !", $COLOR_DEBUG) ;debug
						Else
							ClickP($aAway, 1, 0, "#0932") ;Click Away
							Setlog("Position : " &  $WallCoordsArray[$fc] & " is not a Wall Level: " & $g_iCmbUpgradeWallsLevel + 4 & ".", $COLOR_ERROR)
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

	Local $directory = @ScriptDir & "\imgxml\Walls"
	Local $redLines = $redline
	Local $minLevel = $walllevel
	Local $maxLevel = $walllevel
	Local $maxReturnPoints = $maxreturn

	; Capture the screen for comparison
	_CaptureRegion2()

	; Perform the search
	Local $result = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $directory, "str", $searcharea, "Int", $maxReturnPoints, "str", $redLines, "Int", $minLevel, "Int", $maxLevel)
	Local $error = @error ; Store error values as they reset at next function call
	Local $extError = @extended

	If $error Then
		_logErrorDLLCall($g_sLibImgLocPath, $error)
		SetLog(" imgloc DLL Error imgloc " & $error & " --- " & $extError, $COLOR_RED)
		SetError(2, $extError, $error) ; Set external error code = 2 for DLL error
		Return
	EndIf

	If checkImglocError($result, "imglocFindWalls") = True Then
		Return $FoundWalls
	EndIf

	; Process results
	If $result[0] <> "" Then
		; Get the keys for the dictionary item.
		If $g_bDebugSetlog Then SetLog(" imglocFindMyWall search returned : " & $result[0])
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
EndFunc   ;==>

Func GetWallPositionForUpdate()
	If $aLastWall[0] = -1 Then ; if last wall position x is -1, mean this is just after image search of wall, initialize direction and wall position for click later.
		$iFaceDirection = 1
		$aLastWall[0] = $aBaseNode[0] + 8
		$aLastWall[1] = $aBaseNode[1] - 6
	EndIf
	Local $iCount = 0
	While 1
		If $g_bDebugSetlog Then SetLog($iFaceDirection & " click and check x,y:" & $aLastWall[0] & "," & $aLastWall[1])
		BuildingClick($aLastWall[0], $aLastWall[1]) ; click the wall
		If _Sleep($itxtClickWallDelay) Then Return True; delay
		Local $iCheckWallReturn = CheckWallLevel() ; check the ocr after click, is that a wall and the level we need to update?
		Local $aWallOffset[2] = [8,6]
		ConvertToVillagePos($aWallOffset[0], $aWallOffset[1])
		Switch $iFaceDirection ; after check wall, prepare the click for next click use
			Case 1
				$aLastWall[0] += $aWallOffset[0]
				$aLastWall[1] -= $aWallOffset[1]
			Case 2
				$aLastWall[0] += $aWallOffset[0]
				$aLastWall[1] += $aWallOffset[1]
			Case 3
				$aLastWall[0] -= $aWallOffset[0]
				$aLastWall[1] += $aWallOffset[1]
			Case 4
				$aLastWall[0] -= $aWallOffset[0]
				$aLastWall[1] -= $aWallOffset[1]
		EndSwitch
		If $iCheckWallReturn = 1 Then ; return of CheckWallLevel(), if 1 mean we found the wall need to update
			If $g_bDebugSetlog Then SetLog($iFaceDirection & " wall need update")
			SetLog("=-=-=-=-=-Advanced update for wall-=-=-=-=-=")
			SetLog("Base Node X,Y: " & $aBaseNode[0] & "," & $aBaseNode[1])
			SetLog("Last Update Wall X,Y: " & $aLastWall[0] & "," & $aLastWall[1])
			SetLog("Face Direction: " & $iFaceDirection)
			Return False ; return false for no need use the DllCall to find wall again. and let the process continue update wall with gold or elixir
		ElseIf $iCheckWallReturn = 0 Then ; return of CheckWallLevel(), if 0 mean we found nothing related about wall.
			; change another direction start again at node
			$aLastWall[0] = $aBaseNode[0]
			$aLastWall[1] = $aBaseNode[1]
			If $iFaceDirection = 4 Then ; if 4 directions process finish, reset all data, and let the image search engine find wall again.
				$aLastWall[0] = -1
				$aLastWall[1] = -1
				$aBaseNode[0] = -1
				$aBaseNode[1] = -1
				$iFaceDirection = 1
				If $g_bDebugSetlog Then SetLog("RESET Node and let the DllCall for find wall again")
				ExitLoop
			Else
				$iFaceDirection += 1
			EndIf
		EndIf
		; else we continue looping and looking for next click

		; some prevention for Endless loop
		$iCount+=1
		If $iCount > 100 Then
			ExitLoop
		EndIf
	WEnd
	Return True
EndFunc

Func CheckWallLevel()
	Local $aResult = BuildingInfo(245, 520 + $g_iBottomOffsetY)
	If $aResult[0] = 2 Then ; We found a valid building name
		If StringInStr($aResult[1], "wall") = True Or StringInStr($aResult[1], "W ll") = True Then
			If Number($aResult[2]) = ($g_iCmbUpgradeWallsLevel + 4) Then ; we found a wall
				Return 1 ; return 1 the wall level we need update
			Else
				Return 2 ; return 2 is wall but the level not is we need for update
			EndIf
		EndIf
	EndIf
	Return 0
EndFunc