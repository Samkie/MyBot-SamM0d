; #FUNCTION# ====================================================================================================================
; Name ..........: Functions(AltuFaltu_Mod)
; Description ...: This functions will create the basic GUI user interface.
; Syntax ........: #include
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

;#include <StaticConstants.au3>


;Global $g_hGUI_MOD_AF = 0
;Local $sTxtTip
;
;$g_hGUI_MOD_AF = GUICreate("", $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, $WS_CHILD, -1, $g_hFrmBotEx)
;
;;GUISetBkColor($COLOR_WHITE, $hGUI_BOT)
;
;GUISwitch($g_hGUI_MOD_AF)
;
;;================================= Tab1 ===============================================
;SplashStep("Loading M0d - Tab1...")
;GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, $TCS_FLATBUTTONS)
;GUICtrlCreateTabItem(GetTranslatedFileIni("AF_Mod", 11, "Tab1"))
;
;Local $x = 10, $y = 30 ;Start location
;
;Local $grpSwithAccAF = GUICtrlCreateGroup(GetTranslatedFileIni("AF_Mod", 12, "AltuFaltu Switch Account"), $x, $y, 430, 250)
;$y += 20
;Local const $LogoSCID = @ScriptDir & "\COCBot\AltuFaltu_Mod\Pics\LogoSCID.bmp"
;	GUICtrlCreatePic($LogoSCID, $x + 120, $y , 200, 41,-1 ,-1)
;$g_chkSCIDSwitchAccAF = GUICtrlCreateCheckbox(GetTranslatedFileIni("AF_Mod", 14, "ALtuFaltu SuperCellID Switch Account"), $x + 120, $y+45, -1, -1)
;	$sTxtTip = "This is a simple click process to switch between SCID Account." & @CRLF & _
;	"Need to do necessary multi account setup on Bot's Main Profile Tab."
;	_GUICtrlSetTip(-1, $sTxtTip)
;	GUICtrlSetOnEvent(-1, "chkSCIDSwitchAccAF")
;	GUICtrlSetState(-1, $GUI_UNCHECKED)