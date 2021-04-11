image_speed = 0;
image_index = 0;

#region Setting up furnace inventory

furnace = InvCreate(3,3,5);
InvSetName(furnace,"Furnace " + "(" + string(id) + ")");

//InvSetMainSlotSprite(furnace,sFurnaceBack)
//InvSetBackSprite(furnace,sFurnaceBack)

material_slot = 0;
result_slot = 1;
fuel_slot = 2;
fuel_bar_slot = 3;
result_bar_slot = 4;

//result slot
InvSetSlotPos(furnace, result_slot, 2, 1);
InvSetSlotBlockToPlace(furnace, result_slot);

//fuel slot
InvSetSlotPos(furnace, fuel_slot, 0, 2);

//fuel bar slot
InvSetSlotPos(furnace, fuel_bar_slot, 0, 1);
InvSetSlotBar(furnace, fuel_bar_slot);

//result bar slot
InvSetSlotPos(furnace, result_bar_slot, 1, 1);
InvSetSlotBar(furnace, result_bar_slot);

#endregion

#region Example of working furnace

//Furnace parameters
fuel = 0; //Fuel
fuelMAX = 100; //Max fuel
readyResult = 0; //Raw Material progress

//Recipe[raw] = result
for (var i = 0; i < sprite_get_number(global.InvItemsSprite)+1; ++i) {
    recipe[i] = 0;
}
recipe[ITEM.sand] = ITEM.glass_block;
recipe[ITEM.iron_ore] = ITEM.iron_ingot;
recipe[ITEM.gold_ore] = ITEM.gold_ingot;
recipe[ITEM.pork] = ITEM.roast_pork;

#endregion

//Anim caption
anim = 0;