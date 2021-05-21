#region //===MAIN===//

function InvCreate() {
	///@desc Create a new inventory
	///@args width,height,[inv_slots]
	
	if !layer_exists("Inventories") layer_create(-100, "Inventories");
	if !layer_exists("items") layer_create(0, "items");
	if !instance_exists(oInvControl) instance_create_layer(0, 0, "Inventories", oInvControl);

	with(instance_create_layer(0, 0, "Inventories", oInventory)) {
		//Main parameters
		inv_item = -1;									//main data structure with items (ds_grid)
		inv_shown = false;								//inventory shown or not
		inv_states = false;								//inventory state to open or close with animation
		inv_selected = false;							//inventory is selected or not
		inv_back_spr = noone;							//background sprite
		inv_back_spr_nine_slice = noone;				//nine slice background sprite
		inv_slot_spr = global.InvSlotSprite;			//slot sprite
		inv_cursor_sprite = global.InvMainCursorSpr;	//slot cursor sprite
		inv_name = "Inventory " + string(id);			//inventory name
		inv_width = 9;									//width of inventory in slots
		inv_height = 3;									//width of inventory in slots
		inv_slots = inv_width*inv_height;				//number of slots
		cellSize = inv_slot_spr ? sprite_get_width(inv_slot_spr) : global.InvSlotSize;
		items_offset = -(sprite_get_width(global.InvItemsSprite)/2)+sprite_get_xoffset(global.InvItemsSprite);
		special_offset = global.InvSpecialSlotSprite ? (-(sprite_get_width(global.InvSpecialSlotSprite)/2)+sprite_get_xoffset(global.InvSpecialSlotSprite)) : 16;
		selected_slot = -1;
		invItemMaxStack = 1;
		inv_nine_slice_stretched = false;
		inv_show_name = true;
	
		//Sounds
		inv_sound_open = noone;
		inv_sound_close = noone;

		//Colors
		inv_back_color = $333333;
		inv_top_color = $222222;
		inv_border_color = inv_top_color;
		inv_slot_color = c_ltgray;

		//Borders
		inv_left_border = 4;
		inv_right_border = 4;
		inv_bottom_border = 4;
		inv_top_border = 4;
		inv_head_border = 32;
		inv_cell_indent = 0; //indent between cells

		//Drag window
		isdrag = false;
		drag_x = mouse_x;
		drag_y = mouse_y;
		offsetx = 0;
		offsety = 0;

		//Surface
		inv_surf = -1;
		last_selected_slot = -1;
	
		//Setup settings
		inv_width = argument[0];
		inv_height = argument[1];
		inv_slots = argument_count > 2 ? argument[2] : inv_width*inv_height;
	
		inv_item = ds_grid_create(inv_slots, items_flags.inv_specs_height);
	
		//Surface size
		inv_surf_w = inv_width*(cellSize+inv_cell_indent) + inv_left_border + inv_right_border;
		inv_surf_h = inv_height*(cellSize+inv_cell_indent) + inv_head_border + inv_top_border + inv_bottom_border;
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
		invPosX = _SINV_GUI_WIDTH div 2 - inv_surf_w div 2; //X position of inventory
		invPosY = _SINV_GUI_HEIGHT div 2 - inv_surf_h div 2; //Y position of inventory
	
		InvRedraw();
	
		//Set main inv if it first
		if global.InvMainID == -1 global.InvMainID = id;
	
		return id;
	}
}

function InvDestroy(inventory) {
	///@desc Destroy inventory
	if instance_exists(inventory) {
		with(inventory) {
			if ds_exists(inv_item, ds_type_grid) ds_grid_destroy(inv_item);
			if surface_exists(inv_surf) surface_free(inv_surf);
			instance_destroy();
		}
	}
}

function InvToggle() {
	///@desc Open or close inventory
	///@args inventory,[show/hide]
	
	with(argument[0]) {
		
		inv_shown = argument_count > 1 ? argument[1] : !inv_shown;
		
		if !inv_shown {
			//free memory on close
			if surface_exists(inv_surf) surface_free(inv_surf);
		}
	}
}

function InvToggleAnim() {
	///@desc Open or close inventory
	///@args inventory,[show/hide]
	
	with(argument[0]) {
		
		inv_states = argument_count > 1 ? argument[1] : !inv_states;
		
		if inv_states {
			with(oInventory) {
				inv_selected = false;
				depth = clamp(depth+1,-99,0);
				if global.InvShowSelected InvRedraw();
			}
			depth = -99;
			inv_selected = true;
			if id!=global.InvMainID global.InvLastSelectedID = id;
			InvRedraw();
		
			//Open sound
			if inv_sound_open != noone audio_play_sound(inv_sound_open, 1, false);
			else if global.InvSndOpen != noone audio_play_sound(global.InvSndOpen, 1, false);
		} else {
			//Close sound
			if inv_sound_close != noone audio_play_sound(inv_sound_close, 1, false);
			else if global.InvSndClose != noone audio_play_sound(global.InvSndClose, 1, false);
		}
	}
}

function InvSlotClear(slot) {
	///@desc Clear slot
	
	for (var i = items_flags.item; i < items_flags.inv_specs_height; ++i) {
		inv_item[# slot, i] = 0;
	}
}

function InvItemAdd(inventory, slot, item) {
	///@desc add one item to slot in inv
	
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

function InvItemSub(inventory, slot) {
	///@desc subtract one item from slot in inv
	
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

function InvDropInit() {
	///@desc Initialize drop data
	
	drop_data = array_create(items_flags.inv_specs_height, 0);

	sprite_index = global.InvItemsSprite;
	image_speed = 0;
}

function InvDropHand() {
	///@desc Drop item from hand (item taken by mouse)
	///@args x,y,data,[count]
	
	var _x = argument[0];
	var _y = argument[1];
	var _data = argument[2];
	var _count = argument_count > 3 ? argument[3] : _data[@ items_flags.count];
	
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
		
		return id;
	}
}

function InvDropSlot() {
	///@desc Drop item from slot of specified inventory
	///@args inventory,slot,x,y,[count]
	
	var _inventory = argument[0];
	var _slot = argument[1];
	var _x = argument[2];
	var _y = argument[3];
	var _count = argument_count > 4 ? argument[4] : _inventory.inv_item[# _slot, items_flags.count];

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
		
		return _drop;
	}
}

function InvDropCreate() {
	///@desc Create drop item with specified data at specified position
	///@args x,y,item,[type_of_data,value...]
	
	var _x = argument[0];
	var _y = argument[1];
	var _item = argument[2];

	if !_item return false;

	with (instance_create_layer(_x, _y, "items", oDropItem)) {
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
	
		return id;
	}
}

function InvAddDropToInv(inventory, data) {
	///@desc Add drop to specified inventory
	
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

function InvAddItemToInv() {
	///@desc Add item to specified inventory
	///@args inventory,item,[count]
	
	var _inv = argument[0];
	var _item = argument[1];
	var _count = argument_count > 2 ? argument[2] : 1;

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

function InvDropAll(inventory, x, y) {
	///@desc drop all items in inventory at the specified location
	
	with(inventory) {
		for (var i = 0; i < inv_slots; ++i) {
			if InvGetSlot(i,items_flags.item) {
				InvDropSlot(id, i, x, y);
			}
		}
	}
}

#endregion

#region //===SYSTEM===//

function AddItemProperty() {
	///@desc Add item property
	///@args item,[prop,value,...]
	
	var item = argument[0];
	var i = 1;
	repeat((argument_count-1)/2) {
		global.item_props[item][argument[i]] = argument[i+1];
		i+=2;
	}
}

function GetProp(item, property) {
	///@desc Get specified property of item
	
	return global.item_props[item][property];
}

function GetInvOnTop() {
	///@desc Returns the inventory that is above all
	
	var top_inv = noone;
	var top_depth = 0;

	with(oInventory) {
		if inv_states
		if CheckMouseOnInv()
		if (depth < top_depth) {
			top_depth = depth;
			top_inv = id;
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
		if InvGetState(id)
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

function InvRedraw() {
	///@desc Draw inventory
	///@args [inventory]
	
	var _inv = argument_count > 0 ? argument[0] : id;
	
	//Redraw only if inventory is open (memory optimization)
	if InvGetState(_inv)
	with(_inv) {
		//Create surface if doesn't exist
		if !surface_exists(inv_surf) inv_surf = surface_create(inv_surf_w, inv_surf_h);
	
		draw_set_alpha(1);
		
		surface_set_target(inv_surf);
		draw_clear_alpha(c_black,0);
		
		//Background
		if !inv_back_spr && !inv_back_spr_nine_slice {
		//Back/Main
		draw_set_color(inv_back_color);
		draw_rectangle(0, 0, inv_left_border + inv_width*(cellSize+inv_cell_indent) + inv_right_border,
							inv_head_border + inv_top_border + inv_height*(cellSize+inv_cell_indent) + inv_bottom_border,
							false);
		//Head
		draw_set_color(inv_top_color);
		draw_rectangle(0, 0, inv_left_border + inv_width*(cellSize+inv_cell_indent) + inv_right_border,
							inv_head_border - 1,
							false);
		} else {
			//Or Nine slice
			if inv_back_spr_nine_slice {
				var _img_w = sprite_get_width(inv_back_spr_nine_slice);
				draw_nine_slice(inv_back_spr_nine_slice, 0, 0, inv_surf_w div _img_w*_img_w, inv_surf_h div _img_w*_img_w, inv_nine_slice_stretched);
			} else
			//Or Background sprite
			draw_sprite(inv_back_spr,0,0,0);
		}
		
		//Draw borders
		if inv_selected && global.InvShowSelected {
			//Selected inventory color
			draw_set_color(c_white);
			draw_rectangle(0, 0, inv_surf_w -1, inv_surf_h -1, true);
		} else {
			if !inv_back_spr && !inv_back_spr_nine_slice {
				//Default color of inventory window
				draw_set_color(inv_border_color);
				draw_rectangle(0, 0, inv_surf_w -1, inv_surf_h -1, true);
			}
		}
		
		gpu_set_colorwriteenable(true,true,true,false);
		
		//SLOTS
		var DSinv = inv_item;
		var ii = 0, ix = 0, iy = 0;
		repeat (inv_slots) {
	
			//Getting coordinates
			ix = DSinv[# ii, items_flags.slot_direct_x];
			iy = DSinv[# ii, items_flags.slot_direct_y];
			var slot_pos_x = inv_left_border + ix*(cellSize + inv_cell_indent);
			var slot_pos_y = inv_head_border + inv_top_border + iy*(cellSize+inv_cell_indent);
	
			//Draw slots
			var slot_spr = inv_slot_spr;							//Set default/custom slot sprite for all slots
			if (inv_item[# ii, items_flags.slot_sprite] != noone) 
			slot_spr = inv_item[# ii, items_flags.slot_sprite];		//Set custom sprite for slot if this slot have custom sprite
			//Draw slot if it's not progressbar
			if !DSinv[# ii, items_flags.slot_is_bar] {
			
				//Draw slot
				if slot_spr != noone {
					if DSinv[# ii, items_flags.enchant] {
						//If enchanted
						draw_sprite_ext(slot_spr, 0, slot_pos_x, slot_pos_y, 1, 1, 0, c_yellow, 1);
					} else {
						//Simple slot
						draw_sprite(slot_spr, 0, slot_pos_x, slot_pos_y);
					}
				} else {
					//Draw colored rectangle if slot sprite is not setted
					var _color = DSinv[# ii, items_flags.enchant] ? c_yellow : inv_slot_color; //yellow slot if enchanted
					draw_rectangle_color(slot_pos_x, slot_pos_y, slot_pos_x + cellSize -1, slot_pos_y + cellSize -1, _color, _color, _color, _color, false);
				}
				
				//Draw special sprite (like silhouette of chestplate)
				var _special_sprite = DSinv[# ii, items_flags.special_sprite];
				if _special_sprite >= 0 {
					if !DSinv[# ii, items_flags.item]
					if global.InvSpecialSlotSprite != noone
					draw_sprite_ext(global.InvSpecialSlotSprite, _special_sprite, slot_pos_x + cellSize div 2 + special_offset, slot_pos_y + cellSize div 2 + special_offset, 1,1,0,c_black,0.25);
				}
			}
	
			//Draw items and info
			if DSinv[# ii, items_flags.item] {
				//Sprite of item
				draw_sprite_ext(global.InvItemsSprite, DSinv[# ii, items_flags.item], slot_pos_x + cellSize div 2 + items_offset, slot_pos_y + cellSize div 2 + items_offset,
								global.InvItemScale, global.InvItemScale, 0, c_white, 1);
	
				//Amount
				DrawSetText(c_white, global.InvMainFont, fa_center, fa_middle, 1);
				if DSinv[# ii, items_flags.count]>1
				draw_text_outline(slot_pos_x + cellSize*0.75, slot_pos_y + cellSize*0.75, 
									string(DSinv[# ii, items_flags.count]),
									1, c_black, 8);
			
				//Strength
				if GetProp(DSinv[# ii, items_flags.item], ALL_PROPS.type) == TYPE.tool
				&& DSinv[# ii, items_flags.hp] < GetProp(DSinv[# ii, items_flags.item], ALL_PROPS.hp)
				draw_healthbar(slot_pos_x + 3, slot_pos_y + cellSize-8,
								slot_pos_x + cellSize - 4, slot_pos_y + cellSize-4, 
								(DSinv[# ii, items_flags.hp] / GetProp(DSinv[# ii, items_flags.item], ALL_PROPS.hp))*100,
								c_gray, c_red, c_green, 0, true, true);
			}
	
			//inc
			ii++;
		}
		
		//Inventory name
		if inv_show_name
		if inv_name != "" {
			DrawSetText(c_white, global.InvMainFont, fa_left, fa_top, 1);
			draw_text_outline(inv_left_border, inv_head_border div 3, inv_name, 1, c_black, 8);
		}
	
		gpu_set_colorwriteenable(true,true,true,true);
		surface_reset_target();
	}
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
				return true;
			}
		} else {
			//if find free slot
			if slot_free >= 0 {
				for (var i = items_flags.item; i < items_flags.inv_specs_height; ++i) {
					inventory.inv_item[# slot_free, i] = inv_item[# slot, i];
					inv_item[# slot, i] = 0;
				}
				return true;
			} else {
				return false;
			}
		}
	}
	InvRedraw(inventory);
	return false;
}

function InvRecalculateSurfaceSize() {
	///@desc Recalculate inventory surface size
	
	surface_free(inv_surf);
	inv_surf = -1;

	cellSize = inv_slot_spr ? sprite_get_width(inv_slot_spr) : global.InvSlotSize;
	inv_surf_w = inv_width*(cellSize+inv_cell_indent) + inv_left_border + inv_right_border;
	inv_surf_h = inv_height*(cellSize+inv_cell_indent) + inv_head_border + inv_top_border + inv_bottom_border;
}

#endregion

#region //===GETTERS===//

function InvGetState(inventory) {
	///@desc return show/open state of inventory
	return inventory.inv_states;
}

function InvGetName(inventory) {
	///@desc return name of inventory
	return inventory.inv_name;
}

function InvGetSlot(slot, type_of_data) {
	///@desc return slot data
	return inv_item[# slot, type_of_data];
}

function InvGetSlotExt(inventory, slot, type_of_data) {
	///@desc return slot data from the specified inventory
	return inventory.inv_item[# slot, type_of_data];
}

function InvGetHandSlot(type_of_data) {
	///@desc return slot data from hand
	return global.ItemInHand[type_of_data];
}

function InvGetDropData(_drop_obj, type_of_data) {
	///@desc return drop data
	return _drop_obj.drop_data[type_of_data];
}

#endregion

#region //===SETTERS===//

function InvSetMain(inventory) {
	global.InvMainID = inventory.id;
	return global.InvMainID;
}

function InvSetName(inventory, name) {
	inventory.inv_name = name;
}

function InvSetMainSlotSprite(inventory, sprite) {
	///@desc Set sprite to all slots in specified inventory (Sprite should be square!)
	
	with(inventory) {
		inv_slot_spr = sprite;
	
		InvRecalculateSurfaceSize();
	
		//recalculate inv surf size if background sprite was changed before
		if inv_back_spr != noone
		InvSetBackSprite(id,inv_back_spr);
	
		surface_free(inv_surf);
	}
}

function InvSetBackSprite(inventory, sprite) {
	///@desc Set background sprite for specified inventory
	
	with(inventory) {
		inv_back_spr = sprite;

		//recalculate inv surf size if background sprite width or height above previous surf size
		if sprite_get_width(inv_back_spr) > inv_surf_w || sprite_get_height(inv_back_spr) > inv_surf_h {
			inv_surf_w = sprite_get_width(inv_back_spr);
			inv_surf_h = sprite_get_height(inv_back_spr);
		}
	}
}

function InvSetBackSpriteNineSlice(inventory, sprite, stretched) {
	inventory.inv_back_spr_nine_slice = sprite;
	inventory.inv_nine_slice_stretched = stretched;
}

function InvSetCursorSprite(inventory, sprite) {
	///@desc Set cursor sprite for specified inventory
	
	inventory.inv_cursor_sprite = sprite;
}

function InvSetColors(inventory, back_color, top_color, border_color, slot_color) {
	///@desc Set inventory colors
	
	inventory.inv_back_color = back_color;
	inventory.inv_top_color = top_color;
	inventory.inv_border_color = border_color;
	inventory.inv_slot_color = slot_color;

	InvRedraw(inventory);
}

function InvSetPosition(inventory, x, y) {
	///@desc set inventory position on the screen
	
	inventory.invPosX = x;
	inventory.invPosY = y;
}

function InvSetSlotItem() {
	///@args inventory,slot,item,[count,hp,enchant]
	
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

	if InvGetState(_inventory) InvRedraw(_inventory);
}

function InvSetSlotPos(inventory, slot_number, x_position, y_position) {
	///@desc set position for slot
	
	with(inventory) {
		inv_item[# slot_number, items_flags.slot_direct_x] = x_position;
		inv_item[# slot_number, items_flags.slot_direct_y] = y_position;
	}
}

function InvSetSlotBlockToPlace(inventory, slot) {
	inventory.inv_item[# slot, items_flags.blocked_to_place_slot] = true;
}

function InvSetSlotSprite(inventory, slot, sprite) {
	///@desc Set sprite to specified slot in specified inventory (Sprite should be square! And the same size like main slot sprite!)
	
	inventory.inv_item[# slot, items_flags.slot_sprite] = sprite;
}

function InvSetSlotSpecialSprite(inventory, slot, image_number) {
	///@desc Set special sprite (like silhouette of chestplate)
	
	inventory.inv_item[# slot, items_flags.special_sprite] = image_number;
}

function InvSetSlotArmorOnlyType(inventory, slot, armor_type) {
	///@desc Set slot access only for armor
	
	inventory.inv_item[# slot, items_flags.armor_type] = armor_type;
}

function InvSetSlotBar(inventory, slot) {
	///@desc Set selected slot to progressbar
	
	inventory.inv_item[# slot, items_flags.slot_is_bar] = true;
	InvSetSlotBlockToPlace(inventory, slot);
}

function InvSetSlotExt() {
	///@desc Set various slot data
	///@args inventory,slot,[type_of_data,value,...]
	
	var _inv = argument[0];
	var _slot = argument[1];
	var i = 2;
	repeat((argument_count-2)/2) {
		_inv.inv_item[# _slot, argument[i]] = argument[i+1];
		i+=2;
	}
}

function InvSetBordersSize(inventory, left, right, head, top, bottom) {
	///@desc Set borders size of specified inventory
	
	with(inventory) {
		//set inv borders
		inv_left_border = left;
		inv_right_border = right;
		inv_head_border = head;
		inv_top_border = top;
		inv_bottom_border = bottom;

		InvRecalculateSurfaceSize();
	
		//recalculate inv surf size if background sprite was changed before
		if (inv_back_spr != noone) InvSetBackSprite(id,inv_back_spr);
	
		surface_free(inv_surf);
	}
}

function InvShowName(inventory, show) {
	///@desc show name of specified inventory or not
	
	inventory.inv_show_name = show;
}

function InvSetSounds(inventory, open_sound, close_sound) {
	///@desc set open and close sounds of specified inventory
	
	inventory.inv_sound_open = open_sound;
	inventory.inv_sound_close = close_sound;
}

function InvSetIndentOfCell(inventory, indent) {
	///@desc set indent between cells of specified inventory
	
	with(inventory) {
		inv_cell_indent = indent;
		InvRecalculateSurfaceSize();
	}
}

#endregion

