#region //===MAIN===//

///@desc Create a new inventory
function InvCreate(width, height, slot_number = undefined) {
	if !layer_exists("Inventories") layer_create(-100, "Inventories");
	if !layer_exists("layItems") layer_create(0, "layItems");
	if !instance_exists(oInvControl) instance_create_layer(0, 0, "Inventories", oInvControl);
	
	with(instance_create_layer(0, 0, "Inventories", oInventory)) {
		//Main parameters
		self.inv_item = -1;																	//main data structure with items (ds_grid)
		self.inv_shown = false;																//inventory shown or not
		self.inv_states = INV_STATE.close;													//inventory state to open or close with animation
		self.inv_selected = false;															//inventory is selected or not
		self.inv_back_spr = noone;															//background sprite
		self.inv_back_spr_nine_slice = noone;												//nine slice background sprite
		self.inv_slot_spr = global.InvSlotSprite;											//slot sprite
		self.inv_cursor_sprite = global.InvMainCursorSpr;									//slot cursor sprite
		self.inv_name = "Inventory " + string(irandom(1000));								//inventory name
		self.inv_width = width;																//width of inventory in slots
		self.inv_height = height;															//width of inventory in slots
		self.inv_slots = slot_number != undefined ? slot_number : inv_width*inv_height;		//number of slots
		self.cellSize = inv_slot_spr ? sprite_get_width(inv_slot_spr) : global.InvSlotSize;
		self.items_offset = -(sprite_get_width(global.InvItemsSprite)/2)+sprite_get_xoffset(global.InvItemsSprite);
		self.special_offset = global.InvSpecialSlotSprite ? (-(sprite_get_width(global.InvSpecialSlotSprite)/2)+sprite_get_xoffset(global.InvSpecialSlotSprite)) : 16;
		self.selected_slot = -1;
		self.invItemMaxStack = 1;
		self.inv_show_name = true;
		
		//Sounds
		self.inv_sound_open = noone;
		self.inv_sound_close = noone;
		
		//Colors
		self.inv_back_color = $333333;
		self.inv_top_color = $222222;
		self.inv_border_color = inv_top_color;
		self.inv_slot_color = c_ltgray;
		
		//Borders
		self.inv_left_border = 12;
		self.inv_right_border = 12;
		self.inv_bottom_border = 12;
		self.inv_top_border = 12;
		self.inv_head_border = 32;
		self.inv_cell_indent = 0; //indent between cells
		
		//Drag window
		self.isdrag = false;
		self.drag_x = mouse_x;
		self.drag_y = mouse_y;
		self.offsetx = 0;
		self.offsety = 0;
		
		//Surface
		self.inv_surf = -1;
		
		//Cells of items
		self.inv_item = ds_grid_create(inv_slots, items_flags.inv_specs_height);
		
		//Surface size
		self.inv_surf_w = inv_width*(cellSize+inv_cell_indent) + inv_left_border + inv_right_border;
		self.inv_surf_h = inv_height*(cellSize+inv_cell_indent) + inv_head_border + inv_top_border + inv_bottom_border;
		image_alpha = 0;
		image_xscale = 0.9;
		image_yscale = 0.9;
		
		//Init default data
		var ii = 0, ix = 0, iy = 0;
		repeat (inv_slots) {
		    //set slots coordinates
			inv_item[# ii, items_flags.slot_direct_x] = ix;
			inv_item[# ii, items_flags.slot_direct_y] = iy;
			//other vars
			inv_item[# ii, items_flags.blocked_to_place_slot] = false;
			inv_item[# ii, items_flags.slot_is_bar] = false;
			inv_item[# ii, items_flags.slot_sprite] = noone;
			inv_item[# ii, items_flags.special_sprite] = noone;
			inv_item[# ii, items_flags.armor_type] = -1;
			//inc
			ii++;
			//calculate default slots coordinates
			ix = ii mod inv_width;
			iy = ii div inv_width;
		}
		
		//Set position (center of the screen for default)
		self.invPosX = _SINV_GUI_WIDTH div 2 - inv_surf_w div 2; //X position of inventory
		self.invPosY = _SINV_GUI_HEIGHT div 2 - inv_surf_h div 2; //Y position of inventory
		
		InvRedraw();
		
		//Set main inv if it first
		if (global.InvMainID == undefined) global.InvMainID = self;
		
		return self;
	}
}

///@desc Destroy inventory (should be called in the CleanUp event)
function InvDestroy(inventory) {
	if instance_exists(inventory) {
		with(inventory) {
			if ds_exists(inv_item, ds_type_grid) ds_grid_destroy(inv_item);
			if surface_exists(inv_surf) surface_free(inv_surf);
			instance_destroy();
		}
	}
}

///@desc Open or close inventory without animation
function InvToggle(inventory, state = undefined) {
	with(inventory) {
		
		inv_shown = state == undefined ? !inv_shown : state;
		
		if !inv_shown {
			//free memory on close
			if surface_exists(inv_surf) surface_free(inv_surf);
		}
	}
}

///@desc Open or close inventory with smooth animation
function InvToggleAnim(inventory, state = undefined) {
	with(inventory) {
		
		if (state == inv_states) return false;
		
		if state == undefined {
			inv_states = inv_states == INV_STATE.close ? INV_STATE.open : INV_STATE.close;
		} else {
			inv_states = state;
		}
		
		if inv_states == INV_STATE.open {
			with(oInventory) {
				inv_selected = false;
				depth = clamp(depth+1,-99,0);
				if global.InvShowSelected InvRedraw();
			}
			depth = -99;
			inv_selected = true;
			if (self != global.InvMainID) global.InvLastSelectedID = self;
			
			InvRedraw();
		
			//Open sound
			if (inv_sound_open != noone) audio_play_sound(inv_sound_open, 1, false);
			else if (global.InvSndOpen != noone) audio_play_sound(global.InvSndOpen, 1, false);
		} else {
			//Close sound
			if (inv_sound_close != noone) audio_play_sound(inv_sound_close, 1, false);
			else if (global.InvSndClose != noone) audio_play_sound(global.InvSndClose, 1, false);
		}
	}
}

///@desc Clear slot
function InvSlotClear(slot) {
	for (var i = items_flags.item; i < items_flags.inv_specs_height; ++i) {
		inv_item[# slot, i] = 0;
	}
}

///@desc Add one item to slot in inv
function InvItemAdd(inventory, slot, item) {
	with(inventory) {
		if !inv_item[# slot, items_flags.item] {
			inv_item[# slot, items_flags.item] = item;
		}
	
		if inv_item[# slot, items_flags.item] == item
		if inv_item[# slot, items_flags.count] < GetProp(inv_item[# slot, items_flags.item], ALL_PROPS.maxstack) {
			inv_item[# slot, items_flags.count]++;
			return true;
		}
	}
	return false;
}

///@desc subtract one item from slot in inv
function InvItemSub(inventory, slot) {
	with(inventory) {
		if inv_item[# slot, items_flags.item]
		if inv_item[# slot, items_flags.count] > 0 {
			inv_item[# slot, items_flags.count]--;
	
			if inv_item[# slot, items_flags.count] == 0
			InvSlotClear(slot);
		
			return true;
		}
	}
	return false;
}

///@desc Initialize drop data (called in the create event of a drop object)
function InvDropInit() {
	drop_data = array_create(items_flags.inv_specs_height, 0);

	sprite_index = global.InvItemsSprite;
	image_speed = 0;
}

///@desc Drop item from hand (item taken by mouse)
function InvDropHand(_x, _y, _data, _count = undefined) {
	_count = _count != undefined ? _count : _data[@ items_flags.count];
	
	if global.ItemInHand[items_flags.item]
	with (InvDropCreate(_x, _y, 1)) {
		for (var i = items_flags.item; i < items_flags.inv_specs_height; ++i) {
			drop_data[i] = _data[i];
		}
		
		drop_data[items_flags.count] = _count;
		_data[@ items_flags.count] -= _count;
		
		//if moving item is zero clear
		if _data[@ items_flags.count] == 0 {
			for (var i = items_flags.item; i < items_flags.inv_specs_height; ++i) {
				_data[@ i] = 0;
			}
		}
		
		image_index = drop_data[items_flags.item];
		picktimer = 3.0;
		
		return self;
	}
	return undefined;
}

///@desc Drop item from slot of specified inventory
function InvDropSlot(_inventory, _slot, _x, _y, _count = undefined) {
	_count = _count != undefined ? _count : _inventory.inv_item[# _slot, items_flags.count];

	with(_inventory) {
		if !inv_item[# _slot, items_flags.item] return false;
	
		var _drop = InvDropCreate(_x,_y,1);
		for (var i = items_flags.item; i < items_flags.inv_specs_height; ++i) {
			_drop.drop_data[i] = inv_item[# _slot, i];
		}
		
		_drop.drop_data[items_flags.count] = _count;
		inv_item[# _slot, items_flags.count] -= _count;
		
		//if moving item is zero clear
		if inv_item[# _slot, items_flags.count] == 0 {
			InvSlotClear(_slot);
		}
		
		_drop.image_index = _drop.drop_data[items_flags.item];
		_drop.picktimer = 3.0;
		
		return _drop;
	}
}

///@desc Create drop item with specified data at specified position
///@args x,y,item,[type_of_data,value...]
function InvDropCreate() {
	var _x = argument[0];
	var _y = argument[1];
	var _item = argument[2];

	if !_item return false;

	with (instance_create_layer(_x, _y, "layItems", oDropItem)) {
		drop_data[items_flags.count] = 1;
	
		var i = 3;
		repeat((argument_count-3)/2) {
			drop_data[argument[i]] = argument[i+1];
			i+=2;
		}
	
		if drop_data[items_flags.hp] <= 0
		drop_data[items_flags.hp] = GetProp(_item, ALL_PROPS.hp);
	
		drop_data[items_flags.item] = _item;
		image_index = drop_data[items_flags.item];
		
		picktimer = 1.0;
		
		return self;
	}
}

///@desc Add drop to specified inventory
function InvAddDropToInv(inventory, data) {
	//while there is something to transfer and there is free space or the same item
	while(data[@ items_flags.count] > 0 && (InvFindItem(inventory, ITEM.none) > -1 ||
	InvFindItem(inventory, data[items_flags.item]) > -1)) {
		var find_slot = InvFindItem(inventory, data[items_flags.item]);
		var slot_free = InvFindItem(inventory, ITEM.none);
	
		//if find same item
		if find_slot > -1 {
			while (inventory.inv_item[# find_slot,items_flags.count] < GetProp(inventory.inv_item[# find_slot,items_flags.item], ALL_PROPS.maxstack) && data[@ items_flags.count] > 0) {
				inventory.inv_item[# find_slot,items_flags.count]++
				data[@ items_flags.count]--
			}
			find_slot = InvFindItem(inventory, data[items_flags.item]);
			//if all items moved
			if data[@ items_flags.count]==0 {
				for (var i = items_flags.item; i < items_flags.inv_specs_height; ++i) {
					data[@ i] = 0;
				}
				return true;
			}
		} else {
			//if find free slot
			if slot_free >= 0 {
				for (var i = items_flags.item; i < items_flags.inv_specs_height; ++i) {
					inventory.inv_item[# slot_free, i] = data[i];
					data[@ i] = 0;
				}
				return true;
			} else {
				return false;
			}
		}
	}
	InvRedraw(inventory);
}

///@desc Add item to specified inventory
function InvAddItemToInv(_inv, _item, _count = undefined) {
	_count = _count != undefined ? _count : 1;

	//while there is something to transfer and there is free space or the same item
	while(_count > 0 && (InvFindItem(_inv, ITEM.none) >= 0 || InvFindItem(_inv, _item) >= 0)) {
		var find_slot = InvFindItem(_inv, _item);
		var slot_free = InvFindItem(_inv, ITEM.none);
	
		//if find same item
		if find_slot >= 0 {
			while (_inv.inv_item[# find_slot,items_flags.count] < GetProp(_inv.inv_item[# find_slot,items_flags.item], ALL_PROPS.maxstack) && _count > 0) {
				_inv.inv_item[# find_slot,items_flags.count]++
				_count--
			}
			find_slot = InvFindItem(_inv, _item);
			//if all items moved
			if _count == 0 {
				return true;
			}
		} else {
			//if find free slot
			if slot_free >= 0 {
				InvSetSlotExt(_inv,slot_free,items_flags.item,_item,items_flags.count,_count,items_flags.hp,GetProp(_item, ALL_PROPS.hp));
				return true;
			} else {
				return false;
			}
		}
	}
	InvRedraw(_inv);
	return false;
}

///@desc Drop all items from inventory at the specified location and execute action to drop
function InvDropAll(inventory, x, y, action_with_drop = undefined) {
	with(inventory) {
		for (var i = 0; i < inv_slots; ++i) {
			if InvGetSlot(i,items_flags.item) {
				var _drop = InvDropSlot(self, i, x, y);
				if action_with_drop != undefined
				method(_drop, action_with_drop)(); //execute event fucntion for drop items
			}
		}
	}
}

///@desc Close all inventories
function InvCloseAll() {
	with(oInventory) {
		InvToggleAnim(self, INV_STATE.close);
	}
}

#endregion

#region //===SYSTEM===//

function InvRedraw(_inv = self) {
	with(_inv) {
		if surface_exists(inv_surf) surface_free(inv_surf);
	}
}

function GetInvOnTop() {
	///@desc Returns the inventory that is above all
	
	var top_inv = noone;
	var top_depth = 0;

	with(oInventory) {
		if inv_states == INV_STATE.open
		if CheckMouseOnInv()
		if (depth < top_depth) {
			top_depth = depth;
			top_inv = self;
		}
	}
	
	return top_inv;
}

function CheckMouseOnInv() {
	///@desc Check mouse position on inventory
	
	var l_side = invPosX - inv_left_border;
	var r_side = invPosX + inv_surf_w - inv_left_border; //inv_width*cellSize + inv_right_border;
	var t_side = invPosY - inv_head_border - inv_top_border;
	var b_side = invPosY + inv_surf_h - inv_head_border - inv_top_border; //inv_height*cellSize + inv_bottom_border;
	var _mouse_x = device_mouse_x_to_gui(0);
	var _mouse_y = device_mouse_y_to_gui(0);
	return (_mouse_x > l_side && _mouse_x < r_side) && (_mouse_y > t_side && _mouse_y < b_side);
}

function CheckMouseOnInvSlots() {
	///@desc Check if the mouse cursor is on any of the slots of this inventory
	return selected_slot >= 0;
}

function CheckMouseOnEveryInvs() {
	///@desc Check mouse position on all opened inventories
	
	with(oInventory) {
		if InvGetState(self) == INV_STATE.open
		if CheckMouseOnInv()
		return true;
	}
	
	return false;
}

function CheckMouseOnEveryInvsSlots() {
	///@desc Check if the mouse cursor is on any of the slots of any inventory
	
	with(oInventory) {
		if selected_slot>=0 return true;
	}
	return false;
}

function InvFindItem() {
	///@desc Find specific item in specific inventory (return: slot id)
	///@args inventory,item,[armor_parameter]
	
	var armor_parameter = argument_count > 2 ? argument[2] : false;

	with(argument[0]) {
		for (var i = 0; i < inv_slots; ++i) {
		    if inv_item[# i, items_flags.item] == argument[1] &&
				inv_item[# i, items_flags.count] < GetProp(inv_item[# i, items_flags.item], ALL_PROPS.maxstack) &&
				!inv_item[# i, items_flags.blocked_to_place_slot] &&
				(inv_item[# i, items_flags.armor_type] == GetProp(argument[1], ALL_PROPS.cloth_type) ||
				InvGetSlot(i, items_flags.armor_type) == -1 || inv_item[# i, items_flags.armor_type] == armor_parameter)
				{
					return i;
				}
		}
	}
	return -1;
}

function InvSlotToHand(slot) {
	///@desc Move item from slot to hand
	
	for (var i = items_flags.item; i < items_flags.inv_specs_height; ++i) {
		global.ItemInHand[i] = inv_item[# slot, i];
	}
}

function InvHandClear() {
	///@desc Clear item in hand
	
	for (var i = items_flags.item; i < items_flags.inv_specs_height; ++i) {
		global.ItemInHand[i] = 0;
	}
}

function InvHandToSlot(slot) {
	///@desc Move item in hand to slot
	
	for (var i = items_flags.item; i < items_flags.inv_specs_height; ++i) {
		inv_item[# slot, i] = global.ItemInHand[i];
	}
}

function InvSlotHalfToHand(slot) {
	///@desc Move half from slot to hand
	
	global.ItemInHand[items_flags.item] = inv_item[# slot, items_flags.item];				//take item to hand from slot
	global.ItemInHand[items_flags.count] = ceil(inv_item[# slot, items_flags.count] / 2);	//take half of value

	inv_item[# slot, items_flags.count] = floor(inv_item[# slot, items_flags.count] / 2); //divide and round the slot after division

	//clear slot if its quantity is zero
	if (inv_item[# slot, items_flags.count] == 0) InvSlotClear(slot);
}

function InvOneFromHandToSlot(slot) {
	///@desc Move one item from hand to slot
	
	//If slot is empty
	if !inv_item[# slot, items_flags.item] {
		inv_item[# slot, items_flags.item] = global.ItemInHand[items_flags.item];
		inv_item[# slot, items_flags.count]++;
		global.ItemInHand[items_flags.count]--;
	
		if global.ItemInHand[items_flags.count] < 1 InvHandClear();
	
		return true;
	} else {
		//If slot have the same item like in hand and stack is not full
		if inv_item[# slot, items_flags.item] == global.ItemInHand[items_flags.item] 
		&& inv_item[# slot, items_flags.count] < invItemMaxStack {
			
			inv_item[# slot, items_flags.count]++;
			global.ItemInHand[items_flags.count]--;
		
			if global.ItemInHand[items_flags.count] < 1 InvHandClear();
		
			return true;
		} else {
			return false;
		}
	}
}

function InvSwapSlotWithHand(slot) {
	///@desc Swap slot with hand
	
	//Writing cell data to memory
	var temp_inv_item = [0];
	for (var i = items_flags.item; i < items_flags.inv_specs_height; ++i) {
		temp_inv_item[i] = inv_item[# slot, i];
	}

	//Write the item into the slot from the hand
	InvHandToSlot(slot);

	//Take an item in hand from memory
	for (var i = items_flags.item; i < items_flags.inv_specs_height; ++i) {
		global.ItemInHand[i] = temp_inv_item[i];
	}
}

function InvMoveItemToInv(inventory, slot) {
	///@desc Move item to specified inventory
	
	//While there is something to transfer and there is free space or the same item
	while(inv_item[# slot, items_flags.count]>0 && (InvFindItem(inventory, ITEM.none, GetProp(inv_item[# slot, items_flags.item], ALL_PROPS.cloth_type)) > -1 or
	InvFindItem(inventory, inv_item[# slot, items_flags.item]) > -1)) {
		
		var find_slot = InvFindItem(inventory, inv_item[# slot, items_flags.item]);
		var slot_free = InvFindItem(inventory, ITEM.none, GetProp(inv_item[# slot, items_flags.item], ALL_PROPS.cloth_type));
	
		//if find same item
		if find_slot > -1 {
			while (inventory.inv_item[# find_slot,items_flags.count] < GetProp(inventory.inv_item[# find_slot,items_flags.item], ALL_PROPS.maxstack) && inv_item[# slot, items_flags.count] > 0) {
				inventory.inv_item[# find_slot,items_flags.count]++
				inv_item[# slot, items_flags.count]--
			}
			find_slot = InvFindItem(inventory, inv_item[# slot, items_flags.item]);
			//if all items moved
			if inv_item[# slot, items_flags.count]==0 {
				for (var i = items_flags.item; i < items_flags.inv_specs_height; ++i) {
					inv_item[# slot, i] = 0;
				}
				InvRedraw(inventory);
				return true;
			}
		} else {
			//if find free slot
			if slot_free >= 0 {
				for (var i = items_flags.item; i < items_flags.inv_specs_height; ++i) {
					inventory.inv_item[# slot_free, i] = inv_item[# slot, i];
					inv_item[# slot, i] = 0;
				}
				InvRedraw(inventory);
				return true;
			} else {
				return false;
			}
		}
	}
	return false;
}

function InvRecalculateSurfaceSize() {
	///@desc Recalculate inventory surface size

	cellSize = inv_slot_spr ? sprite_get_width(inv_slot_spr) : global.InvSlotSize;
	inv_surf_w = inv_width*(cellSize + inv_cell_indent) - inv_cell_indent + inv_left_border + inv_right_border;
	inv_surf_h = inv_height*(cellSize + inv_cell_indent) - inv_cell_indent + inv_head_border + inv_top_border + inv_bottom_border;
	
	if inv_back_spr != undefined
	if sprite_get_width(inv_back_spr) > inv_surf_w || sprite_get_height(inv_back_spr) > inv_surf_h {
		inv_surf_w = sprite_get_width(inv_back_spr);
		inv_surf_h = sprite_get_height(inv_back_spr);
	}
	
	InvRedraw();
}

#endregion

#region //===GETTERS===//

///@desc return show/open state of inventory
function InvGetState(inventory) {
	return inventory.inv_states;
}

///@desc return name of inventory
function InvGetName(inventory) {
	return inventory.inv_name;
}

///@desc return slot data
function InvGetSlot(slot, type_of_data) {
	return inv_item[# slot, type_of_data];
}

///@desc return slot data from the specified inventory
function InvGetSlotExt(inventory, slot, type_of_data) {
	return inventory.inv_item[# slot, type_of_data];
}

///@desc return slot data from hand
function InvGetHandSlot(type_of_data) {
	return global.ItemInHand[type_of_data];
}

///@desc return drop data
function InvGetDropData(_drop_obj, type_of_data) {
	return _drop_obj.drop_data[type_of_data];
}

#endregion

#region //===SETTERS===//

///@desc Set specified inventory as main
function InvSetMain(inventory) {
	global.InvMainID = inventory;
	return global.InvMainID;
}

///@desc Set name for specified inventory
function InvSetName(inventory, name) {
	inventory.inv_name = name;
}

///@desc Set sprite to all slots in specified inventory (Sprite should be square!)
function InvSetMainSlotSprite(inventory, sprite) {
	with(inventory) {
		inv_slot_spr = sprite;
	
		InvRecalculateSurfaceSize();
	}
}

///@desc Set background sprite for specified inventory
function InvSetBackSprite(inventory, sprite) {
	with(inventory) {
		inv_back_spr = sprite;

		InvRecalculateSurfaceSize();
	}
}

///@desc Set nineslice background sprite for specified inventory
function InvSetBackSpriteNineSlice(inventory, sprite) {
	inventory.inv_back_spr_nine_slice = sprite;
}

///@desc Set cursor sprite for specified inventory
function InvSetCursorSprite(inventory, sprite) {
	inventory.inv_cursor_sprite = sprite;
}

///@desc Set inventory colors
function InvSetColors(inventory, back_color, top_color, border_color, slot_color) {
	inventory.inv_back_color = back_color;
	inventory.inv_top_color = top_color;
	inventory.inv_border_color = border_color;
	inventory.inv_slot_color = slot_color;

	InvRedraw(inventory);
}

///@desc set inventory position on the screen
function InvSetPosition(inventory, x, y) {
	inventory.invPosX = x;
	inventory.invPosY = y;
}

///@desc Set borders size of specified inventory
function InvSetBordersSize(inventory, left, right, head, top, bottom) {
	with(inventory) {
		//set inv borders
		inv_left_border = left;
		inv_right_border = right;
		inv_head_border = head;
		inv_top_border = top;
		inv_bottom_border = bottom;

		InvRecalculateSurfaceSize();
	}
}

///@desc show name of specified inventory or not
function InvShowName(inventory, show) {
	inventory.inv_show_name = show;
}

///@desc set open and close sounds of specified inventory
function InvSetSounds(inventory, open_sound, close_sound) {
	inventory.inv_sound_open = open_sound;
	inventory.inv_sound_close = close_sound;
}

///@desc set indent between cells of specified inventory
function InvSetIndentOfCell(inventory, indent) {
	with(inventory) {
		inv_cell_indent = indent;
		InvRecalculateSurfaceSize();
	}
}

///@desc Set item to slot to specified inventory
///@args inventory,slot,item,[count,hp,enchant]
function InvSetSlotItem() {
	var _inventory = argument[0];
	var _slot = argument[1];
	var _item = argument[2];
	var _count = argument_count > 3 ? argument[3] : GetProp(_item, ALL_PROPS.maxstack);
	var _hp = argument_count > 4 ? argument[4] : GetProp(_item, ALL_PROPS.hp);
	var _enchant = argument_count > 5 ? argument[5] : 0;

	with(_inventory) {
		inv_item[# _slot, items_flags.item] = _item;
		inv_item[# _slot, items_flags.count] = _count;
		inv_item[# _slot, items_flags.hp] = _hp;
		inv_item[# _slot, items_flags.enchant] = _enchant;
	}

	if (InvGetState(_inventory) == INV_STATE.open) InvRedraw(_inventory);
}

///@desc Set position for slot
function InvSetSlotPos(inventory, slot_number, x_position, y_position) {
	with(inventory) {
		inv_item[# slot_number, items_flags.slot_direct_x] = x_position;
		inv_item[# slot_number, items_flags.slot_direct_y] = y_position;
	}
}

///@desc Protect the slot from putting items in it
function InvSetSlotBlockToPlace(inventory, slot) {
	inventory.inv_item[# slot, items_flags.blocked_to_place_slot] = true;
}

///@desc Set sprite to specified slot in specified inventory (Sprite should be square! And the same size like main slot sprite!)
function InvSetSlotSprite(inventory, slot, sprite) {
	inventory.inv_item[# slot, items_flags.slot_sprite] = sprite;
}

///@desc Set special sprite (like silhouette of chestplate)
function InvSetSlotSpecialSprite(inventory, slot, image_number) {
	inventory.inv_item[# slot, items_flags.special_sprite] = image_number;
}

///@desc Set slot access only for one armor type
function InvSetSlotArmorOnlyType(inventory, slot, armor_type) {
	inventory.inv_item[# slot, items_flags.armor_type] = armor_type;
}

///@desc Set selected slot to progressbar
function InvSetSlotBar(inventory, slot) {
	inventory.inv_item[# slot, items_flags.slot_is_bar] = true;
	InvSetSlotBlockToPlace(inventory, slot);
}

///@desc Set various slot data
///@args inventory,slot,[type_of_data,value,...]
function InvSetSlotExt() {
	var _inv = argument[0];
	var _slot = argument[1];
	var i = 2;
	repeat((argument_count-2)/2) {
		_inv.inv_item[# _slot, argument[i]] = argument[i+1];
		i+=2;
	}
}

#endregion

