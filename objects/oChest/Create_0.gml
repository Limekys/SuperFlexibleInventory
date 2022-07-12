#region Setting up chest inventory

chest = InvCreate(3,3);
InvSetName(chest, global.TEXT[global.language][3] + " (" + string(id) + ")");
InvShowName(chest, false);
InvSetMainSlotSprite(chest,sInvSlotChest);
InvSetColors(chest,$01599C,$014579,$003156,c_ltgray);
InvSetBackSprite(chest,sInvBackChest);
InvSetBordersSize(chest, 4 + 36, 4, 32, 4, 4);
InvSetIndentOfCell(chest, 1);
InvSetCursorSprite(chest, noone);
InvSetSounds(chest, sndInvOpen, sndInvClose);

var ii = 0;
repeat (chest.inv_slots) {
	//fill inventory
	if Chance(0.5) {
		var _item = 1 + irandom(ITEM.enum_lenght-2);
		InvSetSlotItem(chest, ii, _item,
		irandom_range(1,GetProp(_item, ITEM_PROPS.maxstack)), 
		choose(GetProp(_item, ITEM_PROPS.hp),GetProp(_item, ITEM_PROPS.hp)/2,GetProp(_item, ITEM_PROPS.hp)/8), 
		Chance(0.25) && GetProp(_item, ITEM_PROPS.type) == TYPE.tool ? 1: 0);
	}
	//inc
	ii++;
}

#endregion

//Anim caption
anim = 0;