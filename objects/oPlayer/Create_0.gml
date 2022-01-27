#region Create main inventory

inventory = InvCreate(9,3);
InvSetMain(inventory);
InvSetName(inventory,"Player inventory");
InvSetPosition(inventory, 64, 128);
InvSetCursorSprite(inventory, sInvCursor);
InvSetIndentOfCell(inventory, 1);

var ii = 0;
repeat (inventory.inv_slots) {
	//fill inventory
	if Chance(0.9) {
		var _item = 1+irandom(ITEM.item_number-1);
		InvSetSlotItem(inventory, ii, _item,
		irandom_range(1,GetProp(_item, ALL_PROPS.maxstack)), 
		choose(GetProp(_item, ALL_PROPS.hp),GetProp(_item, ALL_PROPS.hp)/2,GetProp(_item, ALL_PROPS.hp)/8), 
		Chance(0.25) && GetProp(_item, ALL_PROPS.type) == TYPE.tool ? true : false);
	}
	
	if ii < 9
	InvSetSlotSprite(inventory, ii, sInvSlotHot);
	
	//inc
	ii++;
}

InvToggleAnim(inventory, INV_STATE.open);

#endregion

#region Equipment inventory

equipment = InvCreate(2,4,5);
InvSetName(equipment, "Equipment");
InvSetPosition(equipment, inventory.invPosX + inventory.inv_surf_w + 8, inventory.invPosY);

head_slot = 0;
chestplate_slot = 1;
leggings_slot = 2;
boots_slot = 3;
shield_slot = 4;
InvSetSlotPos(equipment, head_slot, 0, 0);
InvSetSlotPos(equipment, chestplate_slot, 0, 1);
InvSetSlotPos(equipment, leggings_slot, 0, 2);
InvSetSlotPos(equipment, boots_slot, 0, 3);
InvSetSlotPos(equipment, shield_slot, 1, 1);

InvSetSlotSpecialSprite(equipment, head_slot, 0);
InvSetSlotSpecialSprite(equipment, chestplate_slot, 1);
InvSetSlotSpecialSprite(equipment, leggings_slot, 2);
InvSetSlotSpecialSprite(equipment, boots_slot, 3);
InvSetSlotSpecialSprite(equipment, shield_slot, 4);

InvSetSlotArmorOnlyType(equipment, head_slot, CLOTH_TYPE.helmet);
InvSetSlotArmorOnlyType(equipment, chestplate_slot, CLOTH_TYPE.chestplate);
InvSetSlotArmorOnlyType(equipment, leggings_slot, CLOTH_TYPE.leggings);
InvSetSlotArmorOnlyType(equipment, boots_slot, CLOTH_TYPE.boots);
InvSetSlotArmorOnlyType(equipment, shield_slot, CLOTH_TYPE.shield);

InvToggleAnim(equipment, INV_STATE.open);

#endregion


/* UNDER CONSTRUCTION
//space inv example
space_inv = InvCreate(6,3);

InvSetBackSpriteNineSlice(space_inv, sSpaceInvBack, true);
InvSetMainSlotSprite(space_inv, sSpaceInvSlot);
InvToggleAnim(space_inv, true);
*/

test = InvCreate(2, 2);
InvSetName(test, "SUPER INVENTORY!");
InvToggleAnim(test, true);
InvSetColors(test, $19957C, $24D4B1, $19957C, $60F2D5);
InvSetIndentOfCell(test, 1);
InvSetPosition(test, test.invPosX - test.inv_surf_w, test.invPosY + test.inv_surf_h);