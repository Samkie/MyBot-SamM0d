Func MyNameOfTroop($iKind, $iPlural = 0)
	Local $sTroopname
	Switch $iKind
		Case $eBarb
			$sTroopname = "Barbarian"
		Case $eArch
			$sTroopname = "Archer"
		Case $eGobl
			$sTroopname = "Goblin"
		Case $eGiant
			$sTroopname = "Giant"
		Case $eWall
			$sTroopname = "Wall Breaker"
		Case $eWiza
			$sTroopname = "Wizard"
		Case $eBall
			$sTroopname = "Balloon"
		Case $eHeal
			$sTroopname = "Healer"
		Case $eDrag
			$sTroopname = "Dragon"
		Case $ePekk
			$sTroopname = "Pekka"
		Case $eBabyD
			$sTroopname = "Baby Dragon"
		Case $eMine
			$sTroopname = "Miner"
		Case $eEDrag
			$sTroopname = "Electro Dragon"
		Case $eMini
			$sTroopname = "Minion"
		Case $eHogs
			$sTroopname = "Hog Rider"
		Case $eValk
			$sTroopname = "Valkyrie"
		Case $eWitc
			$sTroopname = "Witch"
		Case $eGole
			$sTroopname = "Golem"
		Case $eLava
			$sTroopname = "Lava Hound"
		Case $eBowl
			$sTroopname = "Bowler"
		Case $eKing
			$sTroopname = "King"
			$iPlural = 0 ; safety reset, $sTroopname of $eKing cannot be plural
		Case $eQueen
			$sTroopname = "Queen"
			$iPlural = 0 ; safety reset
		Case $eWarden
			$sTroopname = "Grand Warden"
			$iPlural = 0 ; safety reset
		Case $eCastle
			$sTroopname = "Clan Castle"
			$iPlural = 0 ; safety reset
		Case $eLSpell
			$sTroopname = "Lightning Spell"
		Case $eHSpell
			$sTroopname = "Heal Spell"
		Case $eRSpell
			$sTroopname = "Rage Spell"
		Case $eJSpell
			$sTroopname = "Jump Spell"
		Case $eFSpell
			$sTroopname = "Freeze Spell"
		Case $eCSpell
			$sTroopname = "Clone Spell"
		Case $ePSpell
			$sTroopname = "Poison Spell"
		Case $eESpell
			$sTroopname = "Earthquake Spell"
		Case $eHaSpell
			$sTroopname = "Haste Spell"
		Case $eSkSpell
			$sTroopname = "Skeleton Spell"
		Case 51
			$sTroopname = "Event Troop 1"
		Case 52
			$sTroopname = "Event Troop 2"
		Case 61
			$sTroopname = "Event Spell 1"
		Case 62
			$sTroopname = "Event Spell 2"
		Case Else
			Return "" ; error or unknown case
	EndSwitch
	If $iPlural > 1 And $iKind = $eWitc Then $sTroopname &= "e" ; adding the "e" for "witches"
	If $iPlural > 1 Then $sTroopname &= "s" ; if troop is not $eKing, $eQueen, $eCastle, $eWarden add the plural "s"
	Return $sTroopname
EndFunc   ;==>MyNameOfTroop