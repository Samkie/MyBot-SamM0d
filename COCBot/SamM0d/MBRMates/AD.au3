
Global $AdAberration = 10 ;AD颜色容差值
Global $AdInformation
Global $g_hADButton, $g_hADButtonReset
Global $AdLimitCount = 10 ;记录AD数据的最大数量
Global $BaiduoIcon1[4] = [19,365,0xd8d5dd,10]
Global $BaiduoIcon2[4] = [7,365,0xb3acbc,10]

Global $ZhaoLeIcon1[4] = [6,348,0xF5B69C,10]
Global $ZhaoLeIcon2[4] = [60,348,0xFADAC1,10]


Func CreatLocateAdBtn($x = 0,$y = 0)
	$g_hADButton = GUICtrlCreateButton("定位广告",$x,$y)
	GUICtrlSetOnEvent(-1,"btnLocateAD")

	$g_hADButtonReset = GUICtrlCreateButton("清除广告信息",$x + 60,$y)
	GUICtrlSetOnEvent(-1,"btnCleanAD")
EndFunc


Func  btnCleanAD()
	If _ExtMsgBox(0, GetTranslated(640,1,"Ok|Cancel"), "清除广告信息", "确定清除COC版本:   "& GetCOCTranslated($g_sAndroidGameDistributor) & "   的广告定位记录吗?", 30, $g_hFrmBot) = 1 Then
		IniWrite(@ScriptDir & "\Profiles\AD.ini", $g_sAndroidGameDistributor, "AD","")
		MsgBox(0,"","清除广告定位记录已完成！！")
	EndIf
EndFunc


;checkObstacles.au3 checkObstacles() 首行插入 CloseAd()

Func CloseAd()
	If Not IsArray($AdInformation) Then Return
		For $i = 0 To UBound($AdInformation)-1
			If Not IsArray($AdInformation[$i]) Then ContinueLoop
			Local $at = $AdInformation[$i]
			;_ArrayDisplay($AdInformation[$i],"$AdInformation")
			If _CheckPixel($AdInformation[$i], $g_bNoCapturePixel) Then
				SetLog("广告对比成功,关闭广告", $COLOR_BLUE)
				PureClickP($AdInformation[$i])
				ExitLoop
			EndIf
		Next
EndFunc

Func MoveIcon()
	;setlog("MoveIcon",$COLOR_BLUE)
	Select
		Case ($g_sAndroidGamePackage = "com.supercell.clashofclans.baidu" And $g_sAndroidGameClass = "com.supercell.clashofclans.GameAppKunlun")
		;Case ($g_sAndroidGamePackage = "com.supercell.clashofclans.baidu")
			MoveBaiduIcon()
		Case ($g_sAndroidGamePackage = "com.supercell.clashofclans.wdj" And $g_sAndroidGameClass = "com.inwin8.package.SplashActivity")
		;Case ($g_sAndroidGamePackage = "com.supercell.clashofclans.wdj")
			MoveZhaoleIcon()
	EndSelect
EndFunc

Func MoveBaiduIcon()
		Local $i = 0
		While $i < 5
		_CaptureRegion()
			If	_CheckPixel($BaiduoIcon1, $g_bNoCapturePixel) Then
				setlog("Move Baidu Icon",$COLOR_BLUE)
				ClickDrag($BaiduoIcon1[0], $BaiduoIcon1[1], $aBottomRightClient[0], $aBottomRightClient[1],20)
				ExitLoop
			ElseIf _CheckPixel($BaiduoIcon2, $g_bNoCapturePixel) Then
				setlog("Move Baidu Icon",$COLOR_BLUE)
				ClickDrag($BaiduoIcon2[0], $BaiduoIcon2[1], $aBottomRightClient[0], $aBottomRightClient[1],20)
				ExitLoop
			EndIf
		$i = $i +1
		WEnd
EndFunc

Func MoveZhaoleIcon()
		Local $i = 0
		While $i < 5
		_CaptureRegion()
			If	_CheckPixel($ZhaoLeIcon1, $g_bNoCapturePixel) Then
				setlog("Click ZhaoLe Icon",$COLOR_BLUE)
				PureClickP($ZhaoLeIcon1)
				Sleep(500)
				ClickP($aAway, 1, 0)
			ElseIf _CheckPixel($ZhaoLeIcon2, $g_bNoCapturePixel) Then
				ClickP($aAway, 1, 0)
				setlog("Move ZhaoLe Icon",$COLOR_BLUE)
				ClickDrag($ZhaoLeIcon2[0], $ZhaoLeIcon2[1], $aBottomRightClient[0], $aBottomRightClient[1],20)
				ExitLoop
			EndIf
		$i = $i +1
		WEnd
EndFunc

Func readADConfig()
	If $g_sAndroidGameDistributor <> $g_sGoogle Then
		GUICtrlSetState($g_hADButton, $GUI_SHOW)
		GUICtrlSetState($g_hADButtonReset, $GUI_SHOW)
		Local $str = IniRead(@ScriptDir & "\Profiles\AD.ini",$g_sAndroidGameDistributor,"AD","")
		If $str <> "" then
			$AdInformation = GetAdInformation($str)
		Else
			$AdInformation = ""
		EndIf
	Else
		GUICtrlSetState($g_hADButton, $GUI_HIDE)
		GUICtrlSetState($g_hADButtonReset, $GUI_HIDE)
	EndIf
EndFunc

Func btnLocateAD()
	$g_bRunState = False
	Local $HWnD = GetAndroidPid()
	_WinAPI_EmptyWorkingSet(WinGetProcess($HWnD)) ; Reduce Android Memory Usage
	If WinGetAndroidHandle() = 0 Then
		If $HWnD = 0 Then
			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
			Local $str = "请手动打开 模拟器 和 COC" & @CRLF & @CRLF & "进入COC后,确认有广告,再进行定位" & @CRLF & @CRLF & _
			"定位广告时,确认启动的COC版本与所选游戏版本一致" & @CRLF & @CRLF & "若版本不一致,将无法关闭广告"
			_ExtMsgBox(0, "确定", "定位AD广告", $str, 20, $g_hFrmBot)
			$g_bRunState = False
			Return
	    EndIf
    EndIf
	AndroidBotStartEvent()
	LocateAD()
	AndroidBotStopEvent()
	$g_bRunState = False
EndFunc


Func GetAdInformation($sList)
	Local $aTempList = StringSplit($sList,"|",2)
	Local $aList[$AdLimitCount]
	;_ArrayDisplay($aTempList,"$aTempList")
	If UBound($aTempList) > $AdLimitCount Then
		Local $icount = UBound($aTempList)
		For $i = $AdLimitCount to $icount
			_ArrayDelete($aTempList,$AdLimitCount)
		Next
	EndIf
	;_ArrayDisplay($aTempList,"$aTempList")
	For $i = 0 To UBound($aTempList)-1
		$aList[$i]= StringSplit($aTempList[$i],",",2)
	Next
		;_ArrayDisplay($aList,"$aList")
	Return $aList
EndFunc

Func GetAdLocInf()
	getBSPos()
	Local $Pos[4]
	Local $AdPos = FindADPos()
	$Pos[0] = $AdPos[0]
	$Pos[1] = $AdPos[1]
	$Pos[2] = "0x" & _GetPixelColor($Pos[0], $Pos[1])
	$Pos[3] = $AdAberration
	Return $Pos
EndFunc


Func FindADPos()
	getBSPos()
	Local $wasDown = AndroidShieldForceDown(True, True)
	While 1
		If _IsPressed("01") Or _IsPressed("02") Then
			Local $Pos = MouseGetPos()
			$Pos[0] -= $g_aiBSpos[0]
			$Pos[1] -= $g_aiBSpos[1]
			; wait till released
			While _IsPressed("01") Or _IsPressed("02")
				Sleep(10)
			WEnd
			AndroidShieldForceDown($wasDown, True)
			Return $Pos
		EndIf
		Sleep(10)
	WEnd
EndFunc


Func LocateAD()
	Local $stext, $MsgBox
	$g_bRunState = True
	Local $HWnD = WinGetAndroidHandle()
	WinActivate($HWnD)

	SetLog("定位广告中...", $COLOR_BLUE)
	ClickP($aTopLeftClient)
	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
	$stext = @CRLF & "点击 确定 后,移动至关闭广告的位置上" & @CRLF & @CRLF & _
	"尽量选取颜色比较特殊的位置上" & @CRLF & @CRLF & "然后 点击 一下" & @CRLF & @CRLF & "请确认游戏版本一致" & @CRLF & @CRLF & "若不进行操作,本窗口将在30秒后关闭,取消广告定位"
	$MsgBox = _ExtMsgBox(0, GetTranslated(640,1,"Ok|Cancel"), "定位AD广告", $stext, 30, $g_hFrmBot)
	If $MsgBox = 1 Then
		WinGetAndroidHandle()
		WinActivate($HWnD)
		_CaptureRegion()
		Local $AdInf = GetAdLocInf()
		;_ArrayDisplay($AdInf,"$AdInf")
		Local $AdIniTxt = IniRead(@ScriptDir & "\Profiles\AD.ini", $g_sAndroidGameDistributor, "AD","")
		If _ExtMsgBox(0, GetTranslated(640,1,"Ok|Cancel"), "添加广告信息", "确定添加广告位置信息吗?", 30, $g_hFrmBot) = 1 Then
			If  $AdIniTxt <> "" Then
				IniWrite(@ScriptDir & "\Profiles\AD.ini", $g_sAndroidGameDistributor, "AD",_ArrayToString($AdInf,",") & "|" & $AdIniTxt )
			Else
				IniWrite(@ScriptDir & "\Profiles\AD.ini", $g_sAndroidGameDistributor, "AD",_ArrayToString($AdInf,","))
			EndIf
			SetLog("广告位置: " & "(" & $AdInf[0] & "," & $AdInf[1] & ")," & "颜色:" & $AdInf[2], $COLOR_GREEN)
			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
			$stext = GetTranslated(640,38,"Now you can remove mouse out of Android Emulator, Thanks!!")
			$MsgBox = _ExtMsgBox(48, GetTranslated(640,36,"OK"), GetTranslated(640,37,"Notice!"), $stext, 15, $g_hFrmBot)
			ClickP($aTopLeftClient)
		Else
			SetLog("取消广告定位", $COLOR_BLUE)
		EndIf
	Else
		SetLog("取消广告定位", $COLOR_BLUE)
		ClickP($aTopLeftClient)
		Return
	EndIf
EndFunc   ;==> LocateAD