; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No

Global $sTxtBarbarians = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBarbarians", "Barbarians")
Global $sTxtArchers = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtArchers", "Archers")
Global $sTxtGiants = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGiants", "Giants")
Global $sTxtGoblins = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGoblins", "Goblins")
Global $sTxtWallBreakers = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWallBreakers", "Wall Breakers")
Global $sTxtBalloons = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBalloons", "Balloons")
Global $sTxtWizards = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWizards", "Wizards")
Global $sTxtHealers = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHealers", "Healers")
Global $sTxtDragons = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtDragons", "Dragons")
Global $sTxtPekkas = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtPekkas", "Pekkas")
Global $sTxtMinions = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMinions", "Minions")
Global $sTxtHogRiders = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHogRiders", "Hog Riders")
Global $sTxtValkyries = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtValkyries", "Valkyries")
Global $sTxtGolems = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGolems", "Golems")
Global $sTxtWitches = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWitches", "Witches")
Global $sTxtLavaHounds = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtLavaHounds", "Lava Hounds")
Global $sTxtBowlers = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBowlers", "Bowlers")
Global $sTxtBabyDragons = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBabyDragons", "Baby Dragons")
Global $sTxtMiners = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMiners", "Miners")
Global $sTxtElectroDragons = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtElectroDragons", "Electro Dragons")
Global $sTxtLightningSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortLightningSpells", "Lightning")
Global $sTxtHealSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortHealSpells", "Heal")
Global $sTxtRageSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortRageSpells", "Rage")
Global $sTxtJumpSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortJumpSpells", "Jump")
Global $sTxtFreezeSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortFreezeSpells", "Freeze")
Global $sTxtCloneSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortCloneSpells", "Clone")
Global $sTxtPoisonSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortPoisonSpells", "Poison")
Global $sTxtEarthquakeSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortEarthquakeSpells", "EarthQuake")
Global $sTxtHasteSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortHasteSpells", "Haste")
Global $sTxtSkeletonSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortSkeletonSpells", "Skeleton")

Global $hGUI_MOD = 0
Local $sTxtTip

$hGUI_MOD = GUICreate("", $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, $WS_CHILD, -1, $g_hFrmBotEx)

;GUISetBkColor($COLOR_WHITE, $hGUI_BOT)

GUISwitch($hGUI_MOD)

;========================Attack=============================
SplashStep("Loading M0d - Attack tab...")
GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, $TCS_FLATBUTTONS)
GUICtrlCreateTabItem(GetTranslatedFileIni("sam m0d", 54, "Attack"))

;======================smartzap================================
Local $x = 10, $y = 30 ;Start location

$grpSmartZap = GUICtrlCreateGroup(GetTranslatedFileIni("sam m0d", 1, "Zap"), $x, $y, 430, 250)
	GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 10, $y + 20, 24, 24)
	GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x + 10, $y + 50, 24, 24)

;$lblZapMethod = GUICtrlCreateLabel(GetTranslatedFileIni("sam m0d", 2, "Zap Style: "), $x + 40, $y + 20, -1, -1)

$y += 20
$chkUseSamM0dZap = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 2, "Use SamM0d Zap "), $x + 40, $y, -1, -1)
	$sTxtTip = "Select this to drop lightning spells on Dark Elixir Drills with SamM0d Method." & @CRLF & @CRLF & _
	"First zap higher level drill first, then second zap the drill that get higher DE from last zap."
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "cmbZapMethod")
	GUICtrlSetState(-1, $GUI_CHECKED)

$y += 25
$lblMinDark2 = GUICtrlCreateLabel(GetTranslatedFileIni("sam m0d", 3, "Min. amount of Dark Elixir:"), $x + 30, $y, 160, -1, $SS_RIGHT)
$txtMinDark2 = GUICtrlCreateInput("400", $x + 195, $y, 35, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	$sTxtTip = "The value here depends a lot on what level your Town Hall is, " & @CRLF & _
			  "and what level drills you most often see."
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetLimit(-1, 4)
	GUICtrlSetOnEvent(-1, "txtMinDark2")

$y += 25
$lblMinDEGetFromDrill = GUICtrlCreateLabel(GetTranslatedFileIni("sam m0d", 9, "Min. DE from each Drill:"), $x + 30, $y, 160, -1, $SS_RIGHT)
$txtMinDEGetFromDrill = GUICtrlCreateInput("120", $x + 195, $y, 35, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	$sTxtTip = "After perform zap will check how many DE gain from this drill," & @CRLF & _
			  "If the value lower than this setting, this drill will be ignore for zap again."
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetLimit(-1, 4)
	GUICtrlSetOnEvent(-1, "txtMinDEGetFromDrill")

$y += 35
$chkSmartZapDB2 = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 4, "Only Zap Drills in Dead Bases"), $x + 40, $y, -1, -1)
	$sTxtTip = "It is recommended you only zap drills in dead bases as most of the " & @CRLF & _
			  "Dark Elixir in a live base will be in the storage."
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkSmartZapDB2")
	GUICtrlSetState(-1, $GUI_CHECKED)

$y += 25
$chkSmartZapSaveHeroes2 = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 5, "TH snipe NoZap if Heroes Deployed"), $x + 40, $y, -1, -1)
	$sTxtTip = "This will stop SmartZap from zapping a base on a Town Hall Snipe " & @CRLF & _
			  "if your heroes were deployed. " & @CRLF & @CRLF & _
			  "This protects their health so they will be ready for battle sooner!"
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkSmartZapSaveHeroes2")
	GUICtrlSetState(-1, $GUI_CHECKED)

$y += 30
$chkSmartZapRnd = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 6, "Random Zap Drills Position"), $x + 40, $y, -1, -1)
	$sTxtTip = "Random Drop On Drill Area, More Human Like."
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkSmartZapRnd")
	GUICtrlSetState(-1, $GUI_CHECKED)

$y += 25
$chkDrillExistBeforeZap = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 7, "Check Drill exist before do second or third zap"), $x + 40, $y, -1, -1)
	$sTxtTip = "Prevent zap on damaged drill."
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkDrillExistBeforeZap")
	GUICtrlSetState(-1, $GUI_CHECKED)

$y += 25
$chkPreventTripleZap = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 8, "Prevent triple zap on same drill"), $x + 40, $y, -1, -1)
	$sTxtTip = "Prevent triple zap on same drill. Normally wouldnot get much DE on third zap."
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkPreventTripleZap")
	GUICtrlSetState(-1, $GUI_CHECKED)

$x += 220
$y = 70
GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 160, $y, 24, 24)
$lblMySmartZap = GUICtrlCreateLabel("0", $x + 60, $y, 80, 30, $SS_RIGHT)
	GUICtrlSetFont(-1, 16, $FW_BOLD, Default, "arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, 0x279B61)
	$sTxtTip = "Number of dark elixir zapped during the attack with lightning."
	_GUICtrlSetTip(-1, $sTxtTip)

$y += 35
GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x + 160, $y, 24, 24)
$lblMyLightningUsed = GUICtrlCreateLabel("0", $x + 60, $y, 80, 30, $SS_RIGHT)
	GUICtrlSetFont(-1, 16, $FW_BOLD, Default, "arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, 0x279B61)
	$sTxtTip = "Amount of used spells."
	_GUICtrlSetTip(-1, $sTxtTip)

GUICtrlCreateGroup("", -99, -99, 1, 1)

;===============END smartZap========================================

Local $x = 0, $y = 290

; CSV Deployment Speed Mod
$grpScriptSpeedDB = GUICtrlCreateGroup(GetTranslatedFileIni("sam m0d", 55, "CSV Deployment Speed - Dead Base"), $x+10, $y, 230, 50)
$lbltxtSelectedSpeedDB = GUICtrlCreateLabel("Normal speed", $x + 20, $y+20, 75, 25)
$sTxtTip = GetTranslatedFileIni("sam m0d", 56, "Increase or decrease the speed at which the CSV attack script deploys troops and waves.")
_GUICtrlSetTip(-1, $sTxtTip)
$sldSelectedSpeedDB = GUICtrlCreateSlider($x + 108, $y + 20, 125, 25, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
_GUICtrlSetTip(-1, $sTxtTip)
_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
_GUICtrlSlider_SetTicFreq(-1, 1)
GUICtrlSetLimit(-1, 18, 0) ; change max/min value
GUICtrlSetData(-1, 5) ; default value
GUICtrlSetOnEvent(-1, "sldSelectedSpeedDB")
GUICtrlCreateGroup("", -99, -99, 1, 1)


		$btnAttNowDB = GUICtrlCreateButton(GetTranslatedFileIni("sam m0d", 58, "Attack Now"), $x+250, $y+15, 91, 25)
				;GUISetState(@SW_SHOW)
				GUICtrlSetOnEvent(-1, "AttackNowDB")

$y += 50
; CSV Deployment Speed Mod
$grpScriptSpeedAB = GUICtrlCreateGroup(GetTranslatedFileIni("sam m0d", 57, "CSV Deployment Speed - Alive Base "), $x+10, $y, 230, 50)
$lbltxtSelectedSpeedAB = GUICtrlCreateLabel("Normal speed", $x + 20, $y+20, 75, 25)
_GUICtrlSetTip(-1, $sTxtTip)
$sldSelectedSpeedAB = GUICtrlCreateSlider($x + 108, $y + 20, 125, 25, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
_GUICtrlSetTip(-1, $sTxtTip)
_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
_GUICtrlSlider_SetTicFreq(-1, 1)
GUICtrlSetLimit(-1, 18, 0) ; change max/min value
GUICtrlSetData(-1, 5) ; default value
GUICtrlSetOnEvent(-1, "sldSelectedSpeedAB")
GUICtrlCreateGroup("", -99, -99, 1, 1)


		$btnAttNowLB = GUICtrlCreateButton(GetTranslatedFileIni("sam m0d", 58, "Attack Now"), $x+250, $y+15, 91, 25)
				;GUISetState(@SW_SHOW)
				GUICtrlSetOnEvent(-1, "AttackNowLB")

SplashStep("Loading M0d - Attack II tab...")
GUICtrlCreateTabItem(GetTranslatedFileIni("sam m0d", 112, "Attack II"))

GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = 10, $y = 30

GUICtrlCreateGroup(GetTranslatedFileIni("sam m0d", 107, "Deploy speed for all standard attack mode."), $x, $y, 430, 100)

$chkUnitFactor = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 108, "Modify Unit Factor"), $x+10, $y + 20, 130, 25)
	$sTxtTip = GetTranslatedFileIni("sam m0d", 109, "Unit deploy delay = Unit setting x Unit Factor (millisecond)")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUnitFactor")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

$txtUnitFactor = GUICtrlCreateInput("10", $x + 180, $y + 20, 31, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	$sTxtTip = GetTranslatedFileIni("sam m0d", 109, "Unit deploy delay = Unit setting x Unit Factor (millisecond)")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetData(-1, 10)
	GUICtrlSetOnEvent(-1, "chkUnitFactor")
$y += 30
$chkWaveFactor = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 110, "Modify Wave Factor"), $x+10, $y + 20, 130, 25)
	$sTxtTip = GetTranslatedFileIni("sam m0d", 111, "Switch troop delay = Wave setting x Wave Factor (millisecond)")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkWaveFactor")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

$txtWaveFactor = GUICtrlCreateInput("100", $x + 180, $y + 20, 31, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	$sTxtTip = GetTranslatedFileIni("sam m0d", 111, "Switch troop delay = Wave setting x Wave Factor (millisecond)")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetData(-1, 100)
	GUICtrlSetOnEvent(-1, "chkWaveFactor")


GUICtrlCreateGroup("", -99, -99, 1, 1)

$y = 140
$chkDropCCFirst = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 105, "Enable deploy cc troops first"), $x+10, $y, -1, -1)
	$sTxtTip = GetTranslatedFileIni("sam m0d", 106, "Deploy cc troops first, only support for standard attack mode")
	GUICtrlSetOnEvent(-1, "chkDropCCFirst")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_UNCHECKED)

$y += 5

$chkDBNoLeague = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 15, "No League"), $x+10, $y+20, -1, -1)
	$sTxtTip ="Search for a Dead bases that has no league."
	_GUICtrlSetTip(-1, $sTxtTip)

$chkDBMeetCollOutside = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 16, "Collectors outside"), $x+10, $y+45, -1, -1)
	$sTxtTip = "Search for Dead bases that has their collectors outside."
	GUICtrlSetOnEvent(-1, "chkDBMeetCollOutside")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlCreateLabel("Min: ", $x + 120, $y +49, -1, -1)
$txtDBMinCollOutsidePercent = GUICtrlCreateInput("80", $x + 145, $y+45, 31, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	$sTxtTip = "Set the Min. % of collectors outside to search for on a village to attack."
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetData(-1, 50)
	GUICtrlCreateLabel("%", $x + 176, $y+49, -1, -1)
	_GUICtrlSetTip(-1, $sTxtTip)


$chkDBCollectorsNearRedline = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 113, "Collectors near redline, Distance between redline to collectors - Tiles: "), $x+30, $y+70, -1, -1)
	$sTxtTip = GetTranslatedFileIni("sam m0d", 114, "Check how many collectors are near redline. If more than % you set then attack.")
	GUICtrlSetOnEvent(-1, "chkDBCollectorsNearRedline")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_UNCHECKED)

$cmbRedlineTiles = GUICtrlCreateCombo("", $x+380, $y+70, 30, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "0|1|2|3|4|5","1")
		$sTxtTip = GetTranslatedFileIni("sam m0d", 115, "Distance between redline to collectors. Use Tiles as measure.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlSetOnEvent(-1, "cmbRedlineTiles")

$y += 25

$chkSkipCollectorCheckIF = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 17, "Skip outside collectors check IF Target Resource Over"), $x+30, $y+70, -1, -1)
	$sTxtTip = "If you don't want compare one of the resource below, just set to 0"
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$y += 95
	$x += 30
		$lblSkipCollectorGold = GUICtrlCreateLabel(ChrW(8805), $x + 22, $y + 2, -1, -1)
		GUICtrlCreateIcon ($g_sLibIconPath, $eIcnGold, $x + 82, $y, 16, 16)
		$txtSkipCollectorGold = GUICtrlCreateInput("400000", $x + 30, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = "Skip outside collectors check IF target Gold value over"
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 7)
	$x += 90
		$lblSkipCollectorElixir = GUICtrlCreateLabel(ChrW(8805), $x + 22, $y + 2, -1, -1)
		GUICtrlCreateIcon ($g_sLibIconPath, $eIcnElixir, $x + 82, $y, 16, 16)
		$txtSkipCollectorElixir = GUICtrlCreateInput("400000", $x + 30, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = "Skip outside collectors check IF target Elixir value over"
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 7)
	$x += 90
		$lblSkipCollectorDark = GUICtrlCreateLabel(ChrW(8805), $x + 22, $y + 2, -1, -1)
		GUICtrlCreateIcon ($g_sLibIconPath, $eIcnDark, $x + 82, $y, 16, 16)
		$txtSkipCollectorDark = GUICtrlCreateInput("0", $x + 30, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = "Skip outside collectors check IF target Dark Elixir value over"
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 6)
$x = 10
$y += 25
	$chkSkipCollectorCheckIFTHLevel = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 22, "Skip outside collectors check IF Target Townhall Level is lower than or equal: "), $x+30, $y, -1, -1)
	$sTxtTip = "Compare the level if is lower than or equal my setting, just attack!"
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$txtIFTHLevel = GUICtrlCreateCombo("", $x+30, $y+25, 100, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "7|8|9|10","7")


Local $x = 10, $y = 30
SplashStep("Loading M0d - Advanced Random Click tab...")
GUICtrlCreateTabItem(GetTranslatedFileIni("sam m0d", 10, "Random Click"))
$grpHLFClick = GUICtrlCreateGroup(GetTranslatedFileIni("sam m0d", 11, "Advanced Random Click On Button"), $x, $y, 430, 180)
	; More Human Like When Train Click By Sam
	$chkEnableHLFClick = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 12, "Enable Random Click On Button Area =-= Train/Remove Troops And Etc."),$x+10, $y+20)
		$sTxtTip = "More human like if random click 5-10 clicks per wave at around the same pixel then delay awhile" & @CRLF & _
		   	      "Click Tempo is random -10% and + 10% between each click base on Train Click Timing" & @CRLF & _
			      "As human like, we tapping on the screen with fast tempo, we almost hit on the same pixel, just -3+3 pixels different."
		GUICtrlSetState(-1, $GUI_CHECKED)
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlSetOnEvent(-1, "chkEnableHLFClick")

	$lblHLFClickDelay = GUICtrlCreateLabel(GetTranslatedFileIni("sam m0d", "txtDelay", "Delay"), $x+28, $y+42, 40, 30)
		$sTxtTip = "Delay awhile after each wave, for chance to detect is that barrack full, if not will keep click train button until loop finish, even you need create 1 unit only."
		_GUICtrlSetTip(-1, $sTxtTip)
	$lblHLFClickDelayTime = GUICtrlCreateLabel("400 ms", $x+28, $y+58, 40, 30)
		_GUICtrlSetTip(-1, $sTxtTip)
	$sldHLFClickDelayTime = GUICtrlCreateSlider($x + 73, $y+45, 90, 25, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
		_GUICtrlSetTip(-1, "Increase the delay if your PC is slow or set the timer for your train button take how long to stop animate."  & @CRLF & "Random Delay +- 10% base on this value.")
		_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
		_GUICtrlSlider_SetTicFreq(-100, 100)
		GUICtrlSetLimit(-1, 1000, 300) ; change max/min value
		GUICtrlSetData(-1, 400) ; default value
		GUICtrlSetOnEvent(-1, "sldHLFClickDelayTime")

	$y += 80

	$lblDesc1 = GUICtrlCreateLabel("Feature: Army Train page fully random click, Surrender Button," & @CRLF & "Return Home Button, PB Page Close Button, Random Away Click," & @CRLF & "RequestCC Button, Open Profile, And Etc." , $x+28, $y)

	$y += 30
	$chkEnableHLFClickSetlog = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 13, "Enable Setlog for Advanced Random Click."),$x+10, $y+20)
		$sTxtTip = "Attention: after enable Advanced Random Click, normal debug click only show the click that haven't process randomize."
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlSetState(-1, $GUI_UNCHECKED)
		GUICtrlSetOnEvent(-1, "chkEnableHLFClickSetlog")

SplashStep("Loading M0d - My Switch tab...")
GUICtrlCreateTabItem(GetTranslatedFileIni("sam m0d", "My Switch", "My Switch"))
; samm0d
Local $x = 10, $y = 25
GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Group_01", "Switch Profiles"), $x, $y, 430, 60)
		$y += 25
		$g_hCmbProfile2 = GUICtrlCreateCombo("", $x + 10, $y, 200, 24, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "CmbProfile_Info_01", "Use this to switch to a different profile")& @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "CmbProfile_Info_02", "Your profiles can be found in") & ": " & @CRLF & $g_sProfilePath)
			GUICtrlSetState(-1, $GUI_SHOW)
			GUICtrlSetOnEvent(-1, "cmbProfile2")

		$btnMakeSwitchADBFolder = GUICtrlCreateButton(GetTranslatedFileIni("sam m0d", 36, "Get shared_prefs"), $x + 230, $y-1, 100, 23)
			GUICtrlSetOnEvent(-1, "btnMakeSwitchADBFolder")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d",37, "Copy Village save files from Emulator to current profile. Make village name image from profile."))

		$btnPushshared_prefs = GUICtrlCreateButton(GetTranslatedFileIni("sam m0d", "Switch Acc", "Switch Acc."), $x + 335, $y-1, 80, 23)
			GUICtrlSetOnEvent(-1, "btnPushshared_prefs")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d","Switch Acc Tip", "Select profile from left side combo list, then click here for switch to the account with selected switch method."))

; samm0d - my switch
$y += 35
$x = 15
#include "GUI Design MySwitch Setting.au3"

GUICtrlCreateGroup("", -99, -99, 1, 1)


SplashStep("Loading M0d - My Troops tab...")
GUICtrlCreateTabItem(GetTranslatedFileIni("sam m0d", 64, "My Troops"))

Local $xStart, $yStart

$xStart = 10
$yStart = 10

Local $x = $xStart, $y = $yStart

	$chkModTrain = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 66, "Enable Custom Train and spell"),$x+10, $y+20)
		_GUICtrlSetTip(-1, "Use Custom Train and Spell replace for official train system.")
		GUICtrlSetState(-1, $GUI_UNCHECKED)
		GUICtrlSetOnEvent(-1, "chkCustomTrain")

$lblMyQuickTrain = GUICtrlCreateLabel(GetTranslatedFileIni("sam m0d", 98, "Train Combo: "), $x + 220, $y + 25, -1, -1,$SS_RIGHT)
$cmbMyQuickTrain = GUICtrlCreateCombo("", $x+300, $y+20, 130, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, GetTranslatedFileIni("sam m0d", 99, "Custom Mode Only") & "|" & GetTranslatedFileIni("sam m0d", 100, "Custom + Army 1") & "|" & GetTranslatedFileIni("sam m0d", 101, "Custom + Army 2") & "|" & GetTranslatedFileIni("sam m0d", 102, "Custom + Army 3") & "|" & GetTranslatedFileIni("sam m0d", "Custom And Army 1,2,3", "Custom + Army 1,2,3"),GetTranslatedFileIni("sam m0d", 99, "Custom Mode Only"))
		$sTxtTip = GetTranslatedFileIni("sam m0d", 103, "Use quick train to train army, custom train setting to revamp donated troops.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlSetOnEvent(-1, "cmbMyQuickTrain")


Local $sComboData= ""
Local $aTroopOrderList[20] = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
For $j = 0 To 19
	$sComboData &= $aTroopOrderList[$j] & "|"
Next


$xStart = 10
$yStart = 55

Local $x = $xStart, $y = $yStart

$grpOtherTroops = GUICtrlCreateGroup(GetTranslatedFileIni("sam m0d", 64, "My Troops"), $x, $y, 430, 375)
$chkMyTroopsOrder = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 67, "By Order"), $x+136, $y+15, -1, -1)
_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", 68, "ReVamp or Train will be follow the order you had set."))
GUICtrlSetOnEvent(-1, "chkMyTroopOrder")
$cmbTroopSetting = GUICtrlCreateCombo("", $x+10, $y + 15, 124, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("sam m0d", 71, "Composition Army 1") & "|" & GetTranslatedFileIni("sam m0d", 72, "Composition Army 2") & "|" & GetTranslatedFileIni("sam m0d", 73, "Composition Army 3"), GetTranslatedFileIni("sam m0d", 71, "Composition Army 1"))
	GUICtrlSetOnEvent(-1, "cmbTroopSetting")

$x += 10
$y += 40
For $i = 0 To UBound($MyTroops) - 1
	Assign("icnMy" & $MyTroops[$i][0], GUICtrlCreateIcon ($g_sLibIconPath, $MyTroopsIcon[$i], $x, $y, 23, 23))
	Assign("lblMy" & $MyTroops[$i][0], GUICtrlCreateLabel(Eval("sTxt" & StringReplace(MyNameOfTroop($i,2)," ","")), $x + 26, $y, -1, -1))
	Assign("txtMy" & $MyTroops[$i][0], GUICtrlCreateInput("0", $x + 94, $y, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER)))
		_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "txtNoOf", "Enter the No. of") & " " & Eval("sTxt" & StringReplace(MyNameOfTroop($i,2)," ","")))
		GUICtrlSetLimit(-1, 3)
		GUICtrlSetOnEvent(-1, "UpdateTroopSetting")
	Assign("cmbMy"& $MyTroops[$i][0] & "Order", GUICtrlCreateCombo("", $x+126, $y, 36, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL)))
		GUICtrlSetData(-1, $sComboData, $i + 1)
		GUICtrlSetOnEvent(-1, "cmbMyTroopOrder")
	$y +=24
	If $i = 12 Then
		$x = 205
		$y = $yStart + 40
	EndIf
Next

$y = $yStart + 80
$btnResetTroops= GUICtrlCreateButton(GetTranslatedFileIni("sam m0d", 74, "Reset Troops"), $x+167, $y, 40, 47,$BS_MULTILINE)
GUICtrlSetOnEvent(-1, "btnResetTroops")
$y = $yStart + 128
$btnResetOrder= GUICtrlCreateButton(GetTranslatedFileIni("sam m0d", 75, "Reset Order"), $x + 167, $y, 40, 47,$BS_MULTILINE)
GUICtrlSetOnEvent(-1, "btnResetOrder")
$y = $yStart + 20
$lblTotalCapacityOfMyTroops = GUICtrlCreateLabel(GetTranslatedFileIni("sam m0d", 76, "Total") & ": 0/0", $x+125, $y, 100, -1,$SS_RIGHT)
GUICtrlSetFont(-1,10,$FW_BOLD)
$idProgressbar = GUICtrlCreateProgress($x+210, $y+20,15, 165,$PBS_VERTICAL)


$y = $yStart + 220

$chkDisablePretrainTroops = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 69, "Disable pre-train troops"), $x, $y, -1, -1)
_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", 70, "Disable pre-train troops, normally use by donate and train setting together."))
GUICtrlSetOnEvent(-1, "chkDisablePretrainTroops")

$y += 25
$chkEnableDeleteExcessTroops = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 62, "Enable delete excess troops"), $x, $y, -1, -1)
	$sTxtTip = GetTranslatedFileIni("sam m0d", 63, "Check is that troops excess your custom army quantity setting, if yes then delete excess value.")
	GUICtrlSetOnEvent(-1, "chkEnableDeleteExcessTroops")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_UNCHECKED)

$y += 40
$lblStickToTrainWindow = GUICtrlCreateLabel(GetTranslatedFileIni("sam m0d", 59, "Stick to army train page when train/spell time left") , $x, $y)
$y += 20
$txtStickToTrainWindow = GUICtrlCreateInput("2", $x, $y-2, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	$sTxtTip = GetTranslatedFileIni("sam m0d", 60, "Will stick to army train page until troops or spells train finish. (Max 5 minutes)(Spell only available if wait for spell enable)")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetLimit(-1, 1)
	GUICtrlSetData(-1, 2)
	GUICtrlSetOnEvent(-1, "txtStickToTrainWindow")
	GUICtrlCreateLabel(GetTranslatedFileIni("sam m0d", 61, "minute(s)"), $x+35, $y, -1, -1)
	_GUICtrlSetTip(-1, $sTxtTip)

$y += 45
$x = 10
$chkForcePreTrainTroops = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "ForcePreTrainTroops", "Force pre-train troops when army strength over percentage: "), $x+10, $y, -1, -1)
GUICtrlSetOnEvent(-1, "ForcePretrainTroops")
$txtForcePreTrainStrength = GUICtrlCreateInput("0", $x + 340, $y, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
GUICtrlSetLimit(-1, 3)
GUICtrlSetOnEvent(-1, "ForcePretrainTroops")

;~ $y += 20
;~ $chkEnableCacheTroopImageFirst = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "CacheTroopAndSpellFirst", "Cache Troops and Spells image at start."), $x+10, $y, -1, -1)
;~ GUICtrlSetOnEvent(-1, "chkEnableCacheTroopImageFirst")


GUICtrlCreateGroup("", -99, -99, 1, 1)
SplashStep("Loading M0d - My Spells tab...")
GUICtrlCreateTabItem(GetTranslatedFileIni("sam m0d", 65, "My Spells"))

Local $xStart, $yStart

$xStart = 10
$yStart = 55

Local $x = $xStart, $y = $yStart

	$grpSpells = GUICtrlCreateGroup(GetTranslatedFileIni("sam m0d", 65, "My Spells"), $x, $y, 430, 365)
		$lblTotalSpell = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "SpellCapacity", "Spell Capacity"), $x+3 , $y + 24, -1, -1, $SS_RIGHT)
		$txtTotalCountSpell2 = GUICtrlCreateCombo("", $x + 125, $y+20 , 35, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "TxtTotalCountSpell_Info_01", "Enter the No. of Spells Capacity. Set to ZERO if you don't want any Spells"))
			GUICtrlSetBkColor (-1, $COLOR_MONEYGREEN) ;lime, moneygreen
			GUICtrlSetData(-1, "0|2|4|6|7|8|9|10|11", "0")
			GUICtrlSetOnEvent(-1, "lblMyTotalCountSpell")
		$y += 55
		$lblLightningIcon = GUICtrlCreateIcon ($g_sLibIconPath, $eIcnLightSpell, $x + 10, $y, 24, 24)
		$lblLightningSpell = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtLightningSpells", "Lightning Spell"), $x + 38, $y+3, -1, -1)
		$txtNumLightningSpell = GUICtrlCreateInput("0", $x + 125, $y, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "txtNoOf", "Enter the No. of") & " " & GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtLightningSpells", "Lightning Spell") & " " & GetTranslatedFileIni("sam m0d", "txtQty", "Spells to make."))
			GUICtrlSetLimit(-1, 2)
			;GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "UpdateSpellSetting")
		$lblTimesLightS = GUICtrlCreateLabel("x", $x + 157, $y+3, -1, -1)

		$y +=25
		$lblHealIcon=GUICtrlCreateIcon ($g_sLibIconPath, $eIcnHealSpell, $x + 10, $y, 24, 24)
		$lblHealSpell = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtHealingSpells", "Healing Spell"), $x + 38, $y+3, -1, -1)
		$txtNumHealSpell = GUICtrlCreateInput("0", $x + 125, $y, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "txtNoOf", "Enter the No. of") & " " & GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtHealingSpells", "Healing Spell") & " " & GetTranslatedFileIni("sam m0d", "txtQty", "Spells to make."))
			GUICtrlSetLimit(-1, 2)
			;GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "UpdateSpellSetting")
		$lblTimesHealS = GUICtrlCreateLabel("x", $x + 157, $y+3, -1, -1)
		$y +=25
		$lblRageIcon=GUICtrlCreateIcon ($g_sLibIconPath, $eIcnRageSpell, $x + 10, $y, 24, 24)
		$lblRageSpell = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtRageSpells", "Rage Spell"), $x + 38, $y+3, -1, -1)
		$txtNumRageSpell = GUICtrlCreateInput("0", $x + 125, $y, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "txtNoOf", "Enter the No. of") & " " & GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtRageSpells", "Rage Spell") & " " & GetTranslatedFileIni("sam m0d", "txtQty", "Spells to make."))
			GUICtrlSetLimit(-1, 2)
			;GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "UpdateSpellSetting")
		$lblTimesRageS = GUICtrlCreateLabel("x", $x + 157, $y+3, -1, -1)
		$y +=25
		$lblJumpSpellIcon=GUICtrlCreateIcon ($g_sLibIconPath, $eIcnJumpSpell, $x + 10, $y, 24, 24)
		$lblJumpSpell = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtJumpSpells", "Jump Spell"), $x + 38, $y+3, -1, -1)
		$txtNumJumpSpell = GUICtrlCreateInput("0", $x + 125, $y, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "txtNoOf", "Enter the No. of") & " " & GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtJumpSpells", "Jump Spell") & " " & GetTranslatedFileIni("sam m0d", "txtQty", "Spells to make."))
			GUICtrlSetLimit(-1, 2)
			;GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "UpdateSpellSetting")
		$lblTimesJumpS = GUICtrlCreateLabel("x", $x + 157, $y+3, -1, -1)
		$y +=25
		$lblFreezeIcon=GUICtrlCreateIcon ($g_sLibIconPath, $eIcnFreezeSpell, $x + 10, $y, 24, 24)
		$lblFreezeSpell = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtFreezeSpells", "Freeze Spell"), $x + 38, $y+3, -1, -1)
		$txtNumFreezeSpell = GUICtrlCreateInput("0", $x + 125, $y, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "txtNoOf", "Enter the No. of") & " " & GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtFreezeSpells", "Freeze Spell") & " " & GetTranslatedFileIni("sam m0d", "txtQty", "Spells to make."))
			GUICtrlSetLimit(-1, 2)
			;GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "UpdateSpellSetting")
		$lblFreezeS = GUICtrlCreateLabel("x", $x + 157, $y+3, -1, -1)
		$y +=25
		$lblCloneIcon=GUICtrlCreateIcon ($g_sLibIconPath, $eIcnCloneSpell, $x + 10, $y, 24, 24)
		$lblCloneSpell = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtCloneSpells", "Clone Spell"), $x + 38, $y+3, -1, -1)
		$txtNumCloneSpell = GUICtrlCreateInput("0", $x + 125, $y, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "txtNoOf", "Enter the No. of") & " " & GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtCloneSpells", "Clone Spell") & " " & GetTranslatedFileIni("sam m0d", "txtQty", "Spells to make."))
			GUICtrlSetLimit(-1, 2)
			;GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "UpdateSpellSetting")
		$lblCloneS = GUICtrlCreateLabel("x", $x + 157, $y+3, -1, -1)
		$y +=25
		$lblPoisonIcon = GUICtrlCreateIcon ($g_sLibIconPath, $eIcnPoisonSpell, $x + 10, $y, 24, 24)
		$lblPoisonSpell = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtPoisonSpells", "Poison Spell"), $x + 38, $y+3, -1, -1)
		$txtNumPoisonSpell = GUICtrlCreateInput("0", $x + 125, $y, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "txtNoOf", "Enter the No. of") & " " & GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtPoisonSpells", "Poison Spell") & " " & GetTranslatedFileIni("sam m0d", "txtQty", "Spells to make."))
			GUICtrlSetLimit(-1, 2)
			;GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "UpdateSpellSetting")
		$lblTimesPoisonS = GUICtrlCreateLabel("x", $x + 157, $y+3, -1, -1)
		$y +=25
		$lblEarthquakeIcon = GUICtrlCreateIcon ($g_sLibIconPath, $eIcnEarthquakeSpell, $x + 10, $y, 24, 24)
		$lblEarthquakeSpell = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtEarthQuakeSpells", "EarthQuake Spell"), $x + 38, $y+3, -1, -1)
		$txtNumEarthSpell = GUICtrlCreateInput("0", $x + 125, $y, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "txtNoOf", "Enter the No. of") & " " & GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtEarthQuakeSpells", "EarthQuake Spell") & " " & GetTranslatedFileIni("sam m0d", "txtQty", "Spells to make."))
			GUICtrlSetLimit(-1, 2)
			;GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "UpdateSpellSetting")
		$lblTimesEarthquakeS = GUICtrlCreateLabel("x", $x + 157, $y+3, -1, -1)
		$y +=25
		$lblHasteIcon = GUICtrlCreateIcon ($g_sLibIconPath, $eIcnHasteSpell, $x + 10, $y, 24, 24)
		$lblHasteSpell = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtHasteSpells", "Haste Spell"), $x + 38, $y+3, -1, -1)
		$txtNumHasteSpell = GUICtrlCreateInput("0", $x + 125, $y, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "txtNoOf", "Enter the No. of") & " " & GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtHasteSpells", "Haste Spell") & " " & GetTranslatedFileIni("sam m0d", "txtQty", "Spells to make."))
			GUICtrlSetLimit(-1, 2)
			;GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "UpdateSpellSetting")
		$lblTimesHasteS = GUICtrlCreateLabel("x", $x + 157, $y+3, -1, -1)
		$y +=25
		$lblSkeletonIcon = GUICtrlCreateIcon ($g_sLibIconPath, $eIcnSkeletonSpell, $x + 10, $y, 24, 24)
		$lblSkeletonSpell = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtSkeletonSpells", "Skeleton Spell"), $x + 38, $y+3, -1, -1)
		$txtNumSkeletonSpell = GUICtrlCreateInput("0", $x + 125, $y, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "txtNoOf", "Enter the No. of") & " " & GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtSkeletonSpells", "Skeleton Spell") & " " & GetTranslatedFileIni("sam m0d", "txtQty", "Spells to make."))
			GUICtrlSetLimit(-1, 2)
			;GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "UpdateSpellSetting")
		$lblTimesSkeletonS = GUICtrlCreateLabel("x", $x + 157, $y+3, -1, -1)


$y = 110
$btnResetSpells= GUICtrlCreateButton(GetTranslatedFileIni("sam m0d", "Reset Spells", "Reset Spells"), $x+360, $y, 40, 47,$BS_MULTILINE)
GUICtrlSetOnEvent(-1, "btnResetSpells")
$y = 158
$btnResetSpellOrder= GUICtrlCreateButton(GetTranslatedFileIni("sam m0d", 75, "Reset Order"), $x + 360, $y, 40, 47,$BS_MULTILINE)
GUICtrlSetOnEvent(-1, "btnResetSpellOrder")


Local $x = 190, $y = 110
$chkMySpellsOrder = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "Order", "Order"), $x, $y - 25 , -1, -1)

Local $sComboSpellData= ""
Local $aSpellOrderList[11] = ["","1","2","3","4","5","6","7","8","9","10"]
For $j = 0 To 10
	$sComboSpellData &= $aSpellOrderList[$j] & "|"
Next


	For $i = 0 To UBound($MySpells) - 1
		Assign("chkPre" & $MySpells[$i][0], GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 77 + $i, "Pre-Brew " & $MySpells[$i][0]) , $x + 40, $y, -1, -1))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", 87 + $i, "Pre-Brew " & $MySpells[$i][0] & " after available spell prepare finish."))
			GUICtrlSetOnEvent(-1, "UpdatePreSpellSetting")

		Assign("cmbMy"& $MySpells[$i][0] & "SpellOrder", GUICtrlCreateCombo("", $x, $y, 36, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL)))
			GUICtrlSetData(-1, $sComboSpellData, $i + 1)
			GUICtrlSetOnEvent(-1, "cmbMySpellOrder")
		$y +=25
	Next

$y += 10
$chkEnableDeleteExcessSpells = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "DeleteExcessSpells", "Enable delete excess Spells"), 20, $y, -1, -1)
	$sTxtTip = GetTranslatedFileIni("sam m0d", "DeleteExcessSpellsTip", "Check is that spells excess your quantity setting, if yes then delete excess value.")
	GUICtrlSetOnEvent(-1, "chkEnableDeleteExcessSpells")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_UNCHECKED)

$y += 25
$chkForcePreBrewSpell = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "ForcePreBrewSpell", "Force Pre-Brew Spell"), 20, $y, -1, -1)
	$sTxtTip = GetTranslatedFileIni("sam m0d", "ForcePreBrewSpellTip", "Force Pre-Brew Spell to queue. ONLY Enable if you only brew 1 type of spell.")
	GUICtrlSetOnEvent(-1, "chkForcePreBrewSpell")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_UNCHECKED)


	GUICtrlCreateGroup("", -99, -99, 1, 1)

SplashStep("Loading M0d - My Clan Castle tab...")
GUICtrlCreateTabItem(GetTranslatedFileIni("sam m0d", "My Clan Castle", "My Clan Castle"))

Local $xStart, $yStart

$xStart = 10
$yStart = 35

Local $x = $xStart, $y = $yStart

	$grpClanCastle = GUICtrlCreateGroup(GetTranslatedFileIni("sam m0d", "My Clan Castle" , "My Clan Castle"), $x, $y, 430, 385)

$x = 10
$y += 30
$chkWait4CC = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 35, "Wait CC Troops for all mode. Troops Strength:"), $x+10, $y, 240, 25)
	GUICtrlSetOnEvent(-1, "chkWait4CC")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

$txtCCStrength = GUICtrlCreateInput("100", $x + 255, $y+2, 31, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	$sTxtTip = "CC Troops Strength"
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetData(-1, 100)
	GUICtrlSetOnEvent(-1, "chkWait4CC")
	GUICtrlCreateLabel("%", $x + 286, $y+6, -1, -1)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 35
	GUICtrlCreateLabel(GetTranslatedFileIni("sam m0d", "RemoveClanCastleTroops", "Remove Clan Castle Troops If not is follow type or over quantity:"), $x + 10, $y, -1, -1)


	Local $asTroopsList[20]
	Local $sComboData= GetTranslatedFileIni("sam m0d", "Un specify","Un specify")
	For $i = 1 To UBound($MyTroops)
		$sComboData =  $sComboData & "|" & Eval("sTxt" & StringReplace(MyNameOfTroop($i - 1,2)," ",""))
	Next

	$y += 20
	$cmbCCTroopSlot1 = GUICtrlCreateCombo("", $x+30, $y, 124, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $sComboData, GetTranslatedFileIni("sam m0d", "Un specify","Un specify"))
	GUICtrlSetOnEvent(-1, "chkWait4CC")

	$txtCCTroopSlotQty1 = GUICtrlCreateInput("0", $x + 160, $y+1, 31, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "Unit Quantity", "Unit Quantity"))
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "chkWait4CC")

	$y += 20
	$cmbCCTroopSlot2 = GUICtrlCreateCombo("", $x+30, $y, 124, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $sComboData, GetTranslatedFileIni("sam m0d", "Un specify","Un specify"))
	GUICtrlSetOnEvent(-1, "chkWait4CC")

	$txtCCTroopSlotQty2 = GUICtrlCreateInput("0", $x + 160, $y+1, 31, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "Unit Quantity", "Unit Quantity"))
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "chkWait4CC")

	$y += 20
	$cmbCCTroopSlot3 = GUICtrlCreateCombo("", $x+30, $y, 124, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $sComboData, GetTranslatedFileIni("sam m0d", "Un specify","Un specify"))
	GUICtrlSetOnEvent(-1, "chkWait4CC")

	$txtCCTroopSlotQty3 = GUICtrlCreateInput("0", $x + 160, $y+1, 31, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "Unit Quantity", "Unit Quantity"))
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "chkWait4CC")


	Local $asTroopsList[11]
	Local $sComboData= GetTranslatedFileIni("sam m0d", "Un specify","Un specify")
	For $i = 1 To UBound($MySpells)
		$sComboData =  $sComboData & "|" & Eval("sTxt" & StringReplace(MyNameOfTroop($i - 1 + $eLSpell,2)," ",""))
	Next

	$y += 50
	$chkWait4CCSpell = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "WaitForCCSpell", "Wait For Clan Castle Spells."), $x+10, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkWait4CCSpell")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

	$y += 20
	GUICtrlCreateLabel(GetTranslatedFileIni("sam m0d", "RemoveClanCastleSpells", "Remove Clan Castle Spells If not is follow type or over quantity:"), $x + 10, $y, -1, -1)

	$y += 20
	$cmbCCSpellSlot1 = GUICtrlCreateCombo("", $x+30, $y, 124, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $sComboData, GetTranslatedFileIni("sam m0d", "Un specify","Un specify"))
	GUICtrlSetOnEvent(-1, "chkWait4CCSpell")

	$txtCCSpellSlotQty1 = GUICtrlCreateInput("0", $x + 160, $y+1, 31, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "Unit Quantity", "Unit Quantity"))
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "chkWait4CCSpell")

	$y += 20
	$cmbCCSpellSlot2 = GUICtrlCreateCombo("", $x+30, $y, 124, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $sComboData, GetTranslatedFileIni("sam m0d", "Un specify","Un specify"))
	GUICtrlSetOnEvent(-1, "chkWait4CCSpell")

	$txtCCSpellSlotQty2 = GUICtrlCreateInput("0", $x + 160, $y+1, 31, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "Unit Quantity", "Unit Quantity"))
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "chkWait4CCSpell")


	$y += 50

$chkRequestCC4Troop = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "Request CC for troop", "Only Request CC Troops when CC Troops Strength less than:"), $x+10, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkRequestCC4Troop")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

$txtRequestCC4Troop = GUICtrlCreateInput("100", $x + 335, $y+2, 31, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	$sTxtTip = "CC Troops Strength"
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetData(-1, 100)
	GUICtrlSetOnEvent(-1, "chkRequestCC4Troop")
	GUICtrlCreateLabel("%", $x + 366, $y+6, -1, -1)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 25

$chkRequestCC4Spell = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "Request CC for spell", "Only Request CC Spell when housing space less than:"), $x+10, $y,  -1, -1)
	GUICtrlSetOnEvent(-1, "chkRequestCC4Troop")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

$txtRequestCC4Spell = GUICtrlCreateInput("2", $x + 335, $y+2, 31, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	$sTxtTip = "CC Spells Housing Space"
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetData(-1, 2)
	GUICtrlSetOnEvent(-1, "chkRequestCC4Troop")


	$y += 25

$chkRequestCC4SeigeMachine = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "Request CC for seige machine", "Only Request CC Seige Machine when housing space less than:"), $x+10, $y,  -1, -1)
	GUICtrlSetOnEvent(-1, "chkRequestCC4Troop")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

$txtRequestCC4SeigeMachine = GUICtrlCreateInput("1", $x + 335, $y+2, 31, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	$sTxtTip = "Seige Machine Housing Space"
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetLimit(-1, 1)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetData(-1, 1)
	GUICtrlSetOnEvent(-1, "chkRequestCC4Troop")



	GUICtrlCreateGroup("", -99, -99, 1, 1)
SplashStep("Loading M0d - Friend Challenge tab...")
GUICtrlCreateTabItem(GetTranslatedFileIni("sam m0d","Friendly Challenge", "Friend Challenge"))

Local $x = 10, $y = 30

SetupFriendlyChallengeGUI($x, $y)

GUICtrlCreateTabItem(GetTranslatedFileIni("sam m0d", 14, "Other"))

Local $x = 10, $y = 30
SplashStep("Loading M0d - Other tab...")
$grpStatsMisc = GUICtrlCreateGroup(GetTranslatedFileIni("sam m0d", 14, "Other"), $x, $y, 430, 360)

;~ $y += 20

;~ $chkSmartUpdateWall = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 18, "Enable advanced update for wall"), $x+10, $y, -1, -1)
;~ 	$sTxtTip = "Save the last position, then next update will start at last position and checking around if got wall match for update."
;~ 	GUICtrlSetOnEvent(-1, "chkSmartUpdateWall")
;~ 	_GUICtrlSetTip(-1, $sTxtTip)
;~ 	GUICtrlSetState(-1, $GUI_CHECKED)


;~ $y += 20
;~ GUICtrlCreateLabel(GetTranslatedFileIni("sam m0d", 19, "Delay: "), $x + 30, $y, -1, -1)
;~ $sTxtTip = "Set the delay between each click of wall. Increase the delay if your PC is slow."
;~ _GUICtrlSetTip(-1, $sTxtTip)
;~ $txtClickWallDelay = GUICtrlCreateInput("500", $x + 60, $y, 31, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
;~ 	_GUICtrlSetTip(-1, $sTxtTip)
;~ 	GUICtrlSetLimit(-1, 3)
;~ 	GUICtrlSetData(-1, 500)

$x = 10
$y += 20
$chkEnableCustomOCR4CCRequest = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 20, "Enable custom ocr image to read clan castle request."), $x+10, $y, -1, -1)
	$sTxtTip = "Using imgloc detect some non latin derived alphabets that normally we use for request cc."
	GUICtrlSetOnEvent(-1, "chkEnableCustomOCR4CCRequest")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_UNCHECKED)

$x = 10
$y += 20
$chkCheck4CC = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 51, "Custom Donate CC checking time: "), $x+10, $y, 240, 25)
	$sTxtTip = GetTranslatedFileIni("sam m0d", 53, "When waiting for full army, use how many seconds for check the clan chat if got new message.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkCheck4CC")
	GUICtrlSetState(-1, $GUI_UNCHECKED)


$txtCheck4CCWaitTime = GUICtrlCreateInput("7", $x + 255, $y+2, 31, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	;$sTxtTip = GetTranslatedFileIni("sam m0d", 53, "When waiting for full army, use how many seconds for check the clan chat if got new message.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetData(-1, 7)
	GUICtrlSetOnEvent(-1, "chkCheck4CC")
	GUICtrlCreateLabel(GetTranslatedFileIni("sam m0d", 52, "seconds"), $x + 286, $y+6, -1, -1)
	_GUICtrlSetTip(-1, $sTxtTip)

$x = 10
$y += 20
$chkIncreaseGlobalDelay = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 40, "Increase global delay setting: "), $x+10, $y, 240, 25)
	$sTxtTip = "Increase delay for all delay setting, more stabilize for slow pc."
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkIncreaseGlobalDelay")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

$txtIncreaseGlobalDelay = GUICtrlCreateInput("10", $x + 255, $y+2, 31, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetData(-1, 10)
	GUICtrlSetOnEvent(-1, "chkIncreaseGlobalDelay")
	GUICtrlCreateLabel("%", $x + 286, $y+6, -1, -1)
	_GUICtrlSetTip(-1, $sTxtTip)


$x = 10
$y += 20
$chkAutoDock = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", 97, "Auto dock to emulator"), $x+10, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkAutoDock")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

$x = 10
$y += 20
$chkAutoHideEmulator = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "Auto Hide Emulator", "Auto hide emulator after start"), $x+10, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkAutoHideEmulator")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

$x = 10
$y += 20
$chkAutoMinimizeBot = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "Auto Minimize Bot", "Auto minimize bot after start"), $x+10, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkAutoMinimizeBot")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

;~ $x = 10
;~ $y += 25
;~ $chkDisablePauseTrayTip = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "Disable balloon tip while press pause", "Disable balloon tip while press pause."), $x+10, $y, -1, -1)
;~ 	GUICtrlSetOnEvent(-1, "chkDisablePauseTrayTip")
;~ 	GUICtrlSetState(-1, $GUI_UNCHECKED)

;~ $x = 10
;~ $y += 25
;~ $chkEnableADBClick = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "Enable ADB click", "Enable ADB click"), $x+10, $y, -1, -1)
;~ 	GUICtrlSetOnEvent(-1, "chkEnableADBClick")
;~ 	GUICtrlSetState(-1, $GUI_UNCHECKED)

$y += 20
$chkEnableLimitDonateUnit = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "DonateLimit", "Limited units for each round troops donation, Unit(s): "), $x+10, $y, -1, -1)
_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "DonateLimitTips", "Prevent over donate the unit you are train for and mess up the troops queue"))
	GUICtrlSetOnEvent(-1, "chkEnableLimitDonateUnit")

$txtLimitDonateUnit = GUICtrlCreateInput("8", $x + 300, $y+2, 35, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "DonateLimitValue", "Please enter the unit number for limited each round of troops donate."))
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "txtLimitDonateUnit")

$y += 20
$chkEnableDonateWhenReady = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "DonateReady", "Donate pre-train troops or pre-brew spells only"), $x+10, $y, -1, -1)
;_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "DonateReadyTips", "Donate when pre-train troops or pre-brew spells are full ready. If you train 8 giants mean need total 16 giants to trigger donate."))
	GUICtrlSetOnEvent(-1, "chkEnableDonateWhenReady")

$y += 20
$chkEnableLogoutLimit = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "LogoutLimit", "Maximum logout time for smart wait for train, second(s): "), $x+10, $y, -1, -1)
_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "LogoutLimitTips", "Maximum logout time for smart wait for train, prevent attack by other player."))
	GUICtrlSetOnEvent(-1, "chkEnableLogoutLimit")

$txtLogoutLimitTime = GUICtrlCreateInput("240", $x + 300, $y+2, 35, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "LogoutLimitTime", "Please enter how many seconds for maximum logout time."))
	GUICtrlSetLimit(-1, 4)
	GUICtrlSetOnEvent(-1, "txtLogoutLimitTime")

$y += 20
$chkEnableUseEventTroop = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "Enable use Event troops and spells", "Enable use Event troops and spells - All modes"), $x+10, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkEnableUseEventTroop")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

$y += 20
$chkEnableStopBotWhenLowBattery = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "Enable stop bot when battery level critical", "Enable stop bot when battery level critical"), $x+10, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkEnableStopBotWhenLowBattery")
	GUICtrlSetState(-1, $GUI_UNCHECKED)


$y += 20
$chkBotLogLineLimit = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "BotLogLineLimit", "Disable clear bot log, and line limit to: "), $x+10, $y, -1, -1)
_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "BotLogLineLimitTips", "Bot log will never clear after battle, and clear bot log will replace will line limit."))
	GUICtrlSetOnEvent(-1, "chkBotLogLineLimit")

$txtLogLineLimit = GUICtrlCreateInput("240", $x + 300, $y+2, 35, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "BotLogLineLimitValue", "Please enter how many line to limit for the bot log."))
	GUICtrlSetLimit(-1, 4)
	GUICtrlSetOnEvent(-1, "txtLogLineLimit")

;~ $y += 25
;~ $chkRemoveSpecialObstacleBB = GUICtrlCreateCheckbox(GetTranslatedFileIni("sam m0d", "Remove Special Obstacle BB", "Remove Special Obstacle at Builder Base"), $x+10, $y, -1, -1)
;~ 	GUICtrlSetOnEvent(-1, "chkRemoveSpecialObstacleBB")
;~ 	GUICtrlSetState(-1, $GUI_UNCHECKED)

GUICtrlCreateGroup("", -99, -99, 1, 1)


GUICtrlCreateTabItem("") ; end tabitem definition








