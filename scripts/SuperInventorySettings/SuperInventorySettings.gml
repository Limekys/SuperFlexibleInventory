#region //================ SETTINGS ================// (You can change it like you want)
	
// -- SPRITES --
	
//Main sprite of all items
global.InvItemsSprite = sItems;		
	
//Main slot sprite of all inventories 
//(if set "noone" and a rectangle with the specified color will be drawn
//instead of the sprite with default size slot)
global.InvSlotSprite = noone;							
	
//Special slot sprite (like silhouette of chestplate/helmet/boots)
global.InvSpecialSlotSprite = sInvSpecialSlotSprite;
	
//Main select slot cursor sprite (by default/you can set "noone" to drawing white rectangle)
global.InvMainCursorSpr = sInvCursor;
	
// -- OTHER --
	
//Slot size (if slot sprite is not setted)
global.InvSlotSize = 64;
	
//Scale of item sprite
global.InvItemScale = 1;
	
//Show border of inventory if selected
global.InvShowSelected = true;
	
//Fonts
global.InvMainFont = fMainInventoryFont;
global.InvDebugFont = fSFDebug;
	
//Move the inventory window with the mouse
global.InvDragAndDrop = true;
	
//Sounds
global.InvClickSounds = true; //Play sounds or not
global.InvSndClick = sndInvClick; //Sound when you pick up item from slot
global.InvSndUnClick = sndInvUnClick; //Sound when you drop item to slot
global.InvSndOpen = noone; //Main sound for all inventories when opening inventory
global.InvSndClose = noone; //Main sound for all inventories when closing inventory
	
//Draw debug
global.InvDrawDebug = false;
	
#endregion

#region //================ MACROS ================// (You can change it like you want)

//Inventory slots enums
enum items_flags {
	slot_direct_x,
	slot_direct_y,
	blocked_to_place_slot,
	slot_is_bar,
	slot_sprite,
	special_sprite,
	armor_type,
	
	item,
	count,
	hp,
	enchant,
	
	inv_specs_height	//don't change this line
}

#endregion

#region //================ SYSTEM ================// (DON'T TOUCH)

//GUI width and height getters for better readability of the code
#macro GUI_WIDTH display_get_gui_width()
#macro GUI_HEIGHT display_get_gui_height()

//Main inventory id
global.InvMainID = -1;
//Last active inventory id
global.InvLastSelectedID = -1;
//Hand data (item in hand, when you picked up it with mouse)
global.ItemInHand = array_create(items_flags.inv_specs_height, 0);
	
#endregion

