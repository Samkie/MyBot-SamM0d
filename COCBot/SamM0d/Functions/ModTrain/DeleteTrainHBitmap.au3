Func DeleteTrainHBitmap()
	If $g_hHBitmap <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap)
	EndIf
	If $g_hBitmap <> 0 Then
		GdiDeleteBitmap($g_hBitmap)
	EndIf
	If $g_hHBitmap2 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap2)
	EndIf
	; Army overview windows
	;------------------------------------------------
	If $g_hHBitmapArmyTab <> 0 Then
		GdiDeleteHBitmap($g_hHBitmapArmyTab)
	EndIf
	If $g_hHBitmapArmyCap <> 0 Then
		GdiDeleteHBitmap($g_hHBitmapArmyCap)
	EndIf
	If $g_hHBitmapSpellCap <> 0 Then
		GdiDeleteHBitmap($g_hHBitmapSpellCap)
	EndIf
	If $g_hHBitmap_Av_Slot1 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Slot1)
	EndIf
	If $g_hHBitmap_Av_Slot2 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Slot2)
	EndIf
	If $g_hHBitmap_Av_Slot3 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Slot3)
	EndIf
	If $g_hHBitmap_Av_Slot4 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Slot4)
	EndIf
	If $g_hHBitmap_Av_Slot5 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Slot5)
	EndIf
	If $g_hHBitmap_Av_Slot6 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Slot6)
	EndIf
	If $g_hHBitmap_Av_Slot7 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Slot7)
	EndIf
	If $g_hHBitmap_Av_Slot8 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Slot8)
	EndIf
	If $g_hHBitmap_Av_Slot9 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Slot9)
	EndIf
	If $g_hHBitmap_Av_Slot10 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Slot10)
	EndIf
	If $g_hHBitmap_Av_Slot11 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Slot11)
	EndIf
	If $g_hHBitmap_Av_SlotQty1 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_SlotQty1)
	EndIf
	If $g_hHBitmap_Av_SlotQty2 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_SlotQty2)
	EndIf
	If $g_hHBitmap_Av_SlotQty3 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_SlotQty3)
	EndIf
	If $g_hHBitmap_Av_SlotQty4 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_SlotQty4)
	EndIf
	If $g_hHBitmap_Av_SlotQty5 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_SlotQty5)
	EndIf
	If $g_hHBitmap_Av_SlotQty6 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_SlotQty6)
	EndIf
	If $g_hHBitmap_Av_SlotQty7 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_SlotQty7)
	EndIf
	If $g_hHBitmap_Av_SlotQty8 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_SlotQty8)
	EndIf
	If $g_hHBitmap_Av_SlotQty9 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_SlotQty9)
	EndIf
	If $g_hHBitmap_Av_SlotQty10 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_SlotQty10)
	EndIf
	If $g_hHBitmap_Av_SlotQty11 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_SlotQty11)
	EndIf
	If $g_hHBitmap_Capture_Av_Slot1 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_Slot1)
	EndIf
	If $g_hHBitmap_Capture_Av_Slot2 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_Slot2)
	EndIf
	If $g_hHBitmap_Capture_Av_Slot3 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_Slot3)
	EndIf
	If $g_hHBitmap_Capture_Av_Slot4 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_Slot4)
	EndIf
	If $g_hHBitmap_Capture_Av_Slot5 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_Slot5)
	EndIf
	If $g_hHBitmap_Capture_Av_Slot6 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_Slot6)
	EndIf
	If $g_hHBitmap_Capture_Av_Slot7 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_Slot7)
	EndIf
	If $g_hHBitmap_Capture_Av_Slot8 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_Slot8)
	EndIf
	If $g_hHBitmap_Capture_Av_Slot9 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_Slot9)
	EndIf
	If $g_hHBitmap_Capture_Av_Slot10 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_Slot10)
	EndIf
	If $g_hHBitmap_Capture_Av_Slot11 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_Slot11)
	EndIf
	If $g_hHBitmap_Av_Spell_Slot1 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Spell_Slot1)
	EndIf
	If $g_hHBitmap_Av_Spell_Slot2 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Spell_Slot2)
	EndIf
	If $g_hHBitmap_Av_Spell_Slot3 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Spell_Slot3)
	EndIf
	If $g_hHBitmap_Av_Spell_Slot4 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Spell_Slot4)
	EndIf
	If $g_hHBitmap_Av_Spell_Slot5 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Spell_Slot5)
	EndIf
	If $g_hHBitmap_Av_Spell_Slot6 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Spell_Slot6)
	EndIf
	If $g_hHBitmap_Av_Spell_Slot7 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Spell_Slot7)
	EndIf
	If $g_hHBitmap_Av_Spell_SlotQty1 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Spell_SlotQty1)
	EndIf
	If $g_hHBitmap_Av_Spell_SlotQty2 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Spell_SlotQty2)
	EndIf
	If $g_hHBitmap_Av_Spell_SlotQty3 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Spell_SlotQty3)
	EndIf
	If $g_hHBitmap_Av_Spell_SlotQty4 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Spell_SlotQty4)
	EndIf
	If $g_hHBitmap_Av_Spell_SlotQty5 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Spell_SlotQty5)
	EndIf
	If $g_hHBitmap_Av_Spell_SlotQty6 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Spell_SlotQty6)
	EndIf
	If $g_hHBitmap_Av_Spell_SlotQty7 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Av_Spell_SlotQty7)
	EndIf
	If $g_hHBitmap_Capture_Av_Spell_Slot1 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_Spell_Slot1)
	EndIf
	If $g_hHBitmap_Capture_Av_Spell_Slot2 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_Spell_Slot2)
	EndIf
	If $g_hHBitmap_Capture_Av_Spell_Slot3 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_Spell_Slot3)
	EndIf
	If $g_hHBitmap_Capture_Av_Spell_Slot4 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_Spell_Slot4)
	EndIf
	If $g_hHBitmap_Capture_Av_Spell_Slot5 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_Spell_Slot5)
	EndIf
	If $g_hHBitmap_Capture_Av_Spell_Slot6 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_Spell_Slot6)
	EndIf
	If $g_hHBitmap_Capture_Av_Spell_Slot7 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_Av_Spell_Slot7)
	EndIf
	;-------------------------------------------------------

	; Train Troops Tab
	;-------------------------------------------------------
	If $g_hHBitmapTrainTab <> 0 Then
		GdiDeleteHBitmap($g_hHBitmapTrainTab)
	EndIf
	If $g_hHBitmapTrainCap <> 0 Then
		GdiDeleteHBitmap($g_hHBitmapTrainCap)
	EndIf
	If $g_hHBitmap_OT_Slot1 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OT_Slot1)
	EndIf
	If $g_hHBitmap_OT_Slot2 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OT_Slot2)
	EndIf
	If $g_hHBitmap_OT_Slot3 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OT_Slot3)
	EndIf
	If $g_hHBitmap_OT_Slot4 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OT_Slot4)
	EndIf
	If $g_hHBitmap_OT_Slot5 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OT_Slot5)
	EndIf
	If $g_hHBitmap_OT_Slot6 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OT_Slot6)
	EndIf
	If $g_hHBitmap_OT_Slot7 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OT_Slot7)
	EndIf
	If $g_hHBitmap_OT_Slot8 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OT_Slot8)
	EndIf
	If $g_hHBitmap_OT_Slot9 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OT_Slot9)
	EndIf
	If $g_hHBitmap_OT_Slot10 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OT_Slot10)
	EndIf
	If $g_hHBitmap_OT_Slot11 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OT_Slot11)
	EndIf
	If $g_hHBitmap_OT_SlotQty1 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OT_SlotQty1)
	EndIf
	If $g_hHBitmap_OT_SlotQty2 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OT_SlotQty2)
	EndIf
	If $g_hHBitmap_OT_SlotQty3 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OT_SlotQty3)
	EndIf
	If $g_hHBitmap_OT_SlotQty4 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OT_SlotQty4)
	EndIf
	If $g_hHBitmap_OT_SlotQty5 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OT_SlotQty5)
	EndIf
	If $g_hHBitmap_OT_SlotQty6 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OT_SlotQty6)
	EndIf
	If $g_hHBitmap_OT_SlotQty7 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OT_SlotQty7)
	EndIf
	If $g_hHBitmap_OT_SlotQty8 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OT_SlotQty8)
	EndIf
	If $g_hHBitmap_OT_SlotQty9 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OT_SlotQty9)
	EndIf
	If $g_hHBitmap_OT_SlotQty10 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OT_SlotQty10)
	EndIf
	If $g_hHBitmap_OT_SlotQty11 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OT_SlotQty11)
	EndIf
	If $g_hHBitmap_Capture_OT_Slot1 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_OT_Slot1)
	EndIf
	If $g_hHBitmap_Capture_OT_Slot2 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_OT_Slot2)
	EndIf
	If $g_hHBitmap_Capture_OT_Slot3 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_OT_Slot3)
	EndIf
	If $g_hHBitmap_Capture_OT_Slot4 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_OT_Slot4)
	EndIf
	If $g_hHBitmap_Capture_OT_Slot5 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_OT_Slot5)
	EndIf
	If $g_hHBitmap_Capture_OT_Slot6 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_OT_Slot6)
	EndIf
	If $g_hHBitmap_Capture_OT_Slot7 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_OT_Slot7)
	EndIf
	If $g_hHBitmap_Capture_OT_Slot8 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_OT_Slot8)
	EndIf
	If $g_hHBitmap_Capture_OT_Slot9 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_OT_Slot9)
	EndIf
	If $g_hHBitmap_Capture_OT_Slot10 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_OT_Slot10)
	EndIf
	If $g_hHBitmap_Capture_OT_Slot11 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_OT_Slot11)
	EndIf
	;--------------------------------------------------

	; Brew Spell Tab
	;--------------------------------------------------
	If $g_hHBitmapBrewTab <> 0 Then
		GdiDeleteHBitmap($g_hHBitmapBrewTab)
	EndIf
	If $g_hHBitmapBrewCap <> 0 Then
		GdiDeleteHBitmap($g_hHBitmapBrewCap)
	EndIf
	If $g_hHBitmap_OB_Slot1 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OB_Slot1)
	EndIf
	If $g_hHBitmap_OB_Slot2 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OB_Slot2)
	EndIf
	If $g_hHBitmap_OB_Slot3 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OB_Slot3)
	EndIf
	If $g_hHBitmap_OB_Slot4 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OB_Slot4)
	EndIf
	If $g_hHBitmap_OB_Slot5 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OB_Slot5)
	EndIf
	If $g_hHBitmap_OB_Slot6 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OB_Slot6)
	EndIf
	If $g_hHBitmap_OB_Slot7 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OB_Slot7)
	EndIf
	If $g_hHBitmap_OB_Slot8 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OB_Slot8)
	EndIf
	If $g_hHBitmap_OB_Slot9 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OB_Slot9)
	EndIf
	If $g_hHBitmap_OB_Slot10 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OB_Slot10)
	EndIf
	If $g_hHBitmap_OB_Slot11 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OB_Slot11)
	EndIf
	If $g_hHBitmap_OB_SlotQty1 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OB_SlotQty1)
	EndIf
	If $g_hHBitmap_OB_SlotQty2 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OB_SlotQty2)
	EndIf
	If $g_hHBitmap_OB_SlotQty3 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OB_SlotQty3)
	EndIf
	If $g_hHBitmap_OB_SlotQty4 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OB_SlotQty4)
	EndIf
	If $g_hHBitmap_OB_SlotQty5 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OB_SlotQty5)
	EndIf
	If $g_hHBitmap_OB_SlotQty6 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OB_SlotQty6)
	EndIf
	If $g_hHBitmap_OB_SlotQty7 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OB_SlotQty7)
	EndIf
	If $g_hHBitmap_OB_SlotQty8 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OB_SlotQty8)
	EndIf
	If $g_hHBitmap_OB_SlotQty9 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OB_SlotQty9)
	EndIf
	If $g_hHBitmap_OB_SlotQty10 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OB_SlotQty10)
	EndIf
	If $g_hHBitmap_OB_SlotQty11 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_OB_SlotQty11)
	EndIf
	If $g_hHBitmap_Capture_OB_Slot1 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_OB_Slot1)
	EndIf
	If $g_hHBitmap_Capture_OB_Slot2 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_OB_Slot2)
	EndIf
	If $g_hHBitmap_Capture_OB_Slot3 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_OB_Slot3)
	EndIf
	If $g_hHBitmap_Capture_OB_Slot4 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_OB_Slot4)
	EndIf
	If $g_hHBitmap_Capture_OB_Slot5 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_OB_Slot5)
	EndIf
	If $g_hHBitmap_Capture_OB_Slot6 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_OB_Slot6)
	EndIf
	If $g_hHBitmap_Capture_OB_Slot7 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_OB_Slot7)
	EndIf
	If $g_hHBitmap_Capture_OB_Slot8 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_OB_Slot8)
	EndIf
	If $g_hHBitmap_Capture_OB_Slot9 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_OB_Slot9)
	EndIf
	If $g_hHBitmap_Capture_OB_Slot10 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_OB_Slot10)
	EndIf
	If $g_hHBitmap_Capture_OB_Slot11 <> 0 Then
		GdiDeleteHBitmap($g_hHBitmap_Capture_OB_Slot11)
	EndIf
	;----------------------------------------------------------
EndFunc

Func SaveAndDebugTrainImage()
_debugSaveHBitmapToImage($g_hHBitmapArmyTab, "Army_Tab")
_debugSaveHBitmapToImage($g_hHBitmapArmyCap, "Army_Tab_TroopCap")
_debugSaveHBitmapToImage($g_hHBitmapSpellCap, "Army_Tab_SpellCap")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Slot1, "ArmyTab_Troop_Slot1")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Slot2, "ArmyTab_Troop_Slot2")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Slot3, "ArmyTab_Troop_Slot3")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Slot4, "ArmyTab_Troop_Slot4")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Slot5, "ArmyTab_Troop_Slot5")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Slot6, "ArmyTab_Troop_Slot6")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Slot7, "ArmyTab_Troop_Slot7")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Slot8, "ArmyTab_Troop_Slot8")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Slot9, "ArmyTab_Troop_Slot9")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Slot10, "ArmyTab_Troop_Slot10")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Slot11, "ArmyTab_Troop_Slot11")
_debugSaveHBitmapToImage($g_hHBitmap_Av_SlotQty1, "ArmyTab_Troop_NoUnit_Slot1")
_debugSaveHBitmapToImage($g_hHBitmap_Av_SlotQty2, "ArmyTab_Troop_NoUnit_Slot2")
_debugSaveHBitmapToImage($g_hHBitmap_Av_SlotQty3, "ArmyTab_Troop_NoUnit_Slot3")
_debugSaveHBitmapToImage($g_hHBitmap_Av_SlotQty4, "ArmyTab_Troop_NoUnit_Slot4")
_debugSaveHBitmapToImage($g_hHBitmap_Av_SlotQty5, "ArmyTab_Troop_NoUnit_Slot5")
_debugSaveHBitmapToImage($g_hHBitmap_Av_SlotQty6, "ArmyTab_Troop_NoUnit_Slot6")
_debugSaveHBitmapToImage($g_hHBitmap_Av_SlotQty7, "ArmyTab_Troop_NoUnit_Slot7")
_debugSaveHBitmapToImage($g_hHBitmap_Av_SlotQty8, "ArmyTab_Troop_NoUnit_Slot8")
_debugSaveHBitmapToImage($g_hHBitmap_Av_SlotQty9, "ArmyTab_Troop_NoUnit_Slot9")
_debugSaveHBitmapToImage($g_hHBitmap_Av_SlotQty10, "ArmyTab_Troop_NoUnit_Slot10")
_debugSaveHBitmapToImage($g_hHBitmap_Av_SlotQty11, "ArmyTab_Troop_NoUnit_Slot11")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_Slot1, "RenameIt2ImgLocFormat_ArmyTab_Troop_Slot1")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_Slot2, "RenameIt2ImgLocFormat_ArmyTab_Troop_Slot2")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_Slot3, "RenameIt2ImgLocFormat_ArmyTab_Troop_Slot3")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_Slot4, "RenameIt2ImgLocFormat_ArmyTab_Troop_Slot4")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_Slot5, "RenameIt2ImgLocFormat_ArmyTab_Troop_Slot5")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_Slot6, "RenameIt2ImgLocFormat_ArmyTab_Troop_Slot6")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_Slot7, "RenameIt2ImgLocFormat_ArmyTab_Troop_Slot7")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_Slot8, "RenameIt2ImgLocFormat_ArmyTab_Troop_Slot8")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_Slot9, "RenameIt2ImgLocFormat_ArmyTab_Troop_Slot9")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_Slot10, "RenameIt2ImgLocFormat_ArmyTab_Troop_Slot10")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_Slot11, "RenameIt2ImgLocFormat_ArmyTab_Troop_Slot11")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Spell_Slot1, "ArmyTab_Spell_Slot1")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Spell_Slot2, "ArmyTab_Spell_Slot2")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Spell_Slot3, "ArmyTab_Spell_Slot3")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Spell_Slot4, "ArmyTab_Spell_Slot4")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Spell_Slot5, "ArmyTab_Spell_Slot5")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Spell_Slot6, "ArmyTab_Spell_Slot6")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Spell_Slot7, "ArmyTab_Spell_Slot7")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Spell_SlotQty1, "ArmyTab_Spell_NoUnit_Slot1")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Spell_SlotQty2, "ArmyTab_Spell_NoUnit_Slot2")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Spell_SlotQty3, "ArmyTab_Spell_NoUnit_Slot3")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Spell_SlotQty4, "ArmyTab_Spell_NoUnit_Slot4")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Spell_SlotQty5, "ArmyTab_Spell_NoUnit_Slot5")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Spell_SlotQty6, "ArmyTab_Spell_NoUnit_Slot6")
_debugSaveHBitmapToImage($g_hHBitmap_Av_Spell_SlotQty7, "ArmyTab_Spell_NoUnit_Slot7")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_Spell_Slot1, "RenameIt2ImgLocFormat_ArmyTab_Spell_Slot1")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_Spell_Slot2, "RenameIt2ImgLocFormat_ArmyTab_Spell_Slot2")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_Spell_Slot3, "RenameIt2ImgLocFormat_ArmyTab_Spell_Slot3")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_Spell_Slot4, "RenameIt2ImgLocFormat_ArmyTab_Spell_Slot4")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_Spell_Slot5, "RenameIt2ImgLocFormat_ArmyTab_Spell_Slot5")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_Spell_Slot6, "RenameIt2ImgLocFormat_ArmyTab_Spell_Slot6")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_Av_Spell_Slot7, "RenameIt2ImgLocFormat_ArmyTab_Spell_Slot7")

_debugSaveHBitmapToImage($g_hHBitmapTrainTab, "Train_Tab")
_debugSaveHBitmapToImage($g_hHBitmapTrainCap, "Train_Tab_TroopCap")
_debugSaveHBitmapToImage($g_hHBitmap_OT_Slot1, "TrainTab_Troop_Slot1")
_debugSaveHBitmapToImage($g_hHBitmap_OT_Slot2, "TrainTab_Troop_Slot2")
_debugSaveHBitmapToImage($g_hHBitmap_OT_Slot3, "TrainTab_Troop_Slot3")
_debugSaveHBitmapToImage($g_hHBitmap_OT_Slot4, "TrainTab_Troop_Slot4")
_debugSaveHBitmapToImage($g_hHBitmap_OT_Slot5, "TrainTab_Troop_Slot5")
_debugSaveHBitmapToImage($g_hHBitmap_OT_Slot6, "TrainTab_Troop_Slot6")
_debugSaveHBitmapToImage($g_hHBitmap_OT_Slot7, "TrainTab_Troop_Slot7")
_debugSaveHBitmapToImage($g_hHBitmap_OT_Slot8, "TrainTab_Troop_Slot8")
_debugSaveHBitmapToImage($g_hHBitmap_OT_Slot9, "TrainTab_Troop_Slot9")
_debugSaveHBitmapToImage($g_hHBitmap_OT_Slot10, "TrainTab_Troop_Slot10")
_debugSaveHBitmapToImage($g_hHBitmap_OT_Slot11, "TrainTab_Troop_Slot11")
_debugSaveHBitmapToImage($g_hHBitmap_OT_SlotQty1, "TrainTab_Troop_NoUnit_Slot1")
_debugSaveHBitmapToImage($g_hHBitmap_OT_SlotQty2, "TrainTab_Troop_NoUnit_Slot2")
_debugSaveHBitmapToImage($g_hHBitmap_OT_SlotQty3, "TrainTab_Troop_NoUnit_Slot3")
_debugSaveHBitmapToImage($g_hHBitmap_OT_SlotQty4, "TrainTab_Troop_NoUnit_Slot4")
_debugSaveHBitmapToImage($g_hHBitmap_OT_SlotQty5, "TrainTab_Troop_NoUnit_Slot5")
_debugSaveHBitmapToImage($g_hHBitmap_OT_SlotQty6, "TrainTab_Troop_NoUnit_Slot6")
_debugSaveHBitmapToImage($g_hHBitmap_OT_SlotQty7, "TrainTab_Troop_NoUnit_Slot7")
_debugSaveHBitmapToImage($g_hHBitmap_OT_SlotQty8, "TrainTab_Troop_NoUnit_Slot8")
_debugSaveHBitmapToImage($g_hHBitmap_OT_SlotQty9, "TrainTab_Troop_NoUnit_Slot9")
_debugSaveHBitmapToImage($g_hHBitmap_OT_SlotQty10, "TrainTab_Troop_NoUnit_Slot10")
_debugSaveHBitmapToImage($g_hHBitmap_OT_SlotQty11, "TrainTab_Troop_NoUnit_Slot11")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_OT_Slot1, "RenameIt2ImgLocFormat_TrainTab_Troop_Slot1")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_OT_Slot2, "RenameIt2ImgLocFormat_TrainTab_Troop_Slot2")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_OT_Slot3, "RenameIt2ImgLocFormat_TrainTab_Troop_Slot3")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_OT_Slot4, "RenameIt2ImgLocFormat_TrainTab_Troop_Slot4")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_OT_Slot5, "RenameIt2ImgLocFormat_TrainTab_Troop_Slot5")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_OT_Slot6, "RenameIt2ImgLocFormat_TrainTab_Troop_Slot6")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_OT_Slot7, "RenameIt2ImgLocFormat_TrainTab_Troop_Slot7")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_OT_Slot8, "RenameIt2ImgLocFormat_TrainTab_Troop_Slot8")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_OT_Slot9, "RenameIt2ImgLocFormat_TrainTab_Troop_Slot9")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_OT_Slot10, "RenameIt2ImgLocFormat_TrainTab_Troop_Slot10")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_OT_Slot11, "RenameIt2ImgLocFormat_TrainTab_Troop_Slot11")

_debugSaveHBitmapToImage($g_hHBitmapBrewTab, "Spell_Tab")
_debugSaveHBitmapToImage($g_hHBitmapBrewCap, "Spell_Tab_SpellCap")
_debugSaveHBitmapToImage($g_hHBitmap_OB_Slot1, "SpellTab_Spell_Slot1")
_debugSaveHBitmapToImage($g_hHBitmap_OB_Slot2, "SpellTab_Spell_Slot2")
_debugSaveHBitmapToImage($g_hHBitmap_OB_Slot3, "SpellTab_Spell_Slot3")
_debugSaveHBitmapToImage($g_hHBitmap_OB_Slot4, "SpellTab_Spell_Slot4")
_debugSaveHBitmapToImage($g_hHBitmap_OB_Slot5, "SpellTab_Spell_Slot5")
_debugSaveHBitmapToImage($g_hHBitmap_OB_Slot6, "SpellTab_Spell_Slot6")
_debugSaveHBitmapToImage($g_hHBitmap_OB_Slot7, "SpellTab_Spell_Slot7")
_debugSaveHBitmapToImage($g_hHBitmap_OB_Slot8, "SpellTab_Spell_Slot8")
_debugSaveHBitmapToImage($g_hHBitmap_OB_Slot9, "SpellTab_Spell_Slot9")
_debugSaveHBitmapToImage($g_hHBitmap_OB_Slot10, "SpellTab_Spell_Slot10")
_debugSaveHBitmapToImage($g_hHBitmap_OB_Slot11, "SpellTab_Spell_Slot11")
_debugSaveHBitmapToImage($g_hHBitmap_OB_SlotQty1, "SpellTab_Spell_NoUnit_Slot1")
_debugSaveHBitmapToImage($g_hHBitmap_OB_SlotQty2, "SpellTab_Spell_NoUnit_Slot2")
_debugSaveHBitmapToImage($g_hHBitmap_OB_SlotQty3, "SpellTab_Spell_NoUnit_Slot3")
_debugSaveHBitmapToImage($g_hHBitmap_OB_SlotQty4, "SpellTab_Spell_NoUnit_Slot4")
_debugSaveHBitmapToImage($g_hHBitmap_OB_SlotQty5, "SpellTab_Spell_NoUnit_Slot5")
_debugSaveHBitmapToImage($g_hHBitmap_OB_SlotQty6, "SpellTab_Spell_NoUnit_Slot6")
_debugSaveHBitmapToImage($g_hHBitmap_OB_SlotQty7, "SpellTab_Spell_NoUnit_Slot7")
_debugSaveHBitmapToImage($g_hHBitmap_OB_SlotQty8, "SpellTab_Spell_NoUnit_Slot8")
_debugSaveHBitmapToImage($g_hHBitmap_OB_SlotQty9, "SpellTab_Spell_NoUnit_Slot9")
_debugSaveHBitmapToImage($g_hHBitmap_OB_SlotQty10, "SpellTab_Spell_NoUnit_Slot10")
_debugSaveHBitmapToImage($g_hHBitmap_OB_SlotQty11, "SpellTab_Spell_NoUnit_Slot11")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_OB_Slot1, "RenameIt2ImgLocFormat_SpellTab_Spell_Slot1")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_OB_Slot2, "RenameIt2ImgLocFormat_SpellTab_Spell_Slot2")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_OB_Slot3, "RenameIt2ImgLocFormat_SpellTab_Spell_Slot3")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_OB_Slot4, "RenameIt2ImgLocFormat_SpellTab_Spell_Slot4")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_OB_Slot5, "RenameIt2ImgLocFormat_SpellTab_Spell_Slot5")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_OB_Slot6, "RenameIt2ImgLocFormat_SpellTab_Spell_Slot6")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_OB_Slot7, "RenameIt2ImgLocFormat_SpellTab_Spell_Slot7")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_OB_Slot8, "RenameIt2ImgLocFormat_SpellTab_Spell_Slot8")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_OB_Slot9, "RenameIt2ImgLocFormat_SpellTab_Spell_Slot9")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_OB_Slot10, "RenameIt2ImgLocFormat_SpellTab_Spell_Slot10")
_debugSaveHBitmapToImage($g_hHBitmap_Capture_OB_Slot11, "RenameIt2ImgLocFormat_SpellTab_Spell_Slot11")
EndFunc
