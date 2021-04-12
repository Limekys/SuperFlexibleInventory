function SuperFlexibleInventoryInit() {
	
	#region --- SETTINGS --- (You can change it like you want!)
	
	//Resolution
	//global.disp_w = display_get_width();
	//global.disp_h = display_get_height();
	global.gui_w = display_get_gui_width();
	global.gui_h = display_get_gui_height();
	
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
	
	//Main font
	global.InvMainFont = fMainInventoryFont;
	
	//Draw debug
	global.InvDrawDebug = false;
	
	//Move the inventory window with the mouse
	global.InvDragAndDrop = true;
	
	//Sounds
	global.InvClickSounds = true; //Play sounds or not
	global.InvSndClick = sndInvClick; //Sound when you pick up item from slot
	global.InvSndUnClick = sndInvUnClick; //Sound when you drop item to slot
	global.InvSndOpen = noone; //Main sound for all inventories when opening inventory
	global.InvSndClose = noone; //Main sound for all inventories when closing inventory
	
	#endregion// -------------------
	
	#region --- DON'T TOUCH ---
	
	//Main inventory id
	global.InvMainID = -1;
	//Last active inventory id
	global.InvLastSelectedID = -1;
	//Hand data (item in hand, when you picked up it with mouse)
	global.ItemInHand = array_create(items_flags.inv_specs_height, 0);
	
	#endregion // -------------------
	
	#region init macros
	
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
	
		inv_specs_height
	}

	//All game items
	enum ITEM {
		none						,
		dirt						,
		sand						,
		coal_ore					,
		iron_ore					,
		gold_ore					,
		diamond_ore					,
		emerald_ore					,
		iron_ingot					,
		gold_ingot					,
		diamond						,
		emerald						,
		pork						,
		roast_pork					,
		iron_sword					,
		iron_pickaxe				,
		iron_shovel					,
		iron_axe					,
		wood_sword					,
		wood_pickaxe				,
		wood_shovel					,
		wood_axe					,
		iron_helmet					,
		iron_chestplate				,
		iron_leggings				,
		iron_boots					,
		pumpkin_cutted				,
		apple						,
		cookie						,
		cake						,
		cake_chocolate				,
		coal						,
		glass_block					,
		item_number					
	}
	
	#endregion
	
	#region init language
	
	global.language = 0;
	global.TEXT[0][0] = 0;
	global.ITEM_TEXT[0][0] = 0;

	enum GAME_LANGUAGE {
		en,
		ru
	}

	switch (os_get_language()) {
		case "en": global.language = GAME_LANGUAGE.en; break;
		case "ru": global.language = GAME_LANGUAGE.ru; break;
	}

	//ENGLISH
	global.TEXT[GAME_LANGUAGE.en][0] = "damage: ";

	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.none] = "-uknown-";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.dirt] = "dirt";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.sand] = "sand";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.coal_ore] = "coal ore";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.iron_ore] = "iron ore";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.gold_ore] = "gold ore";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.diamond_ore] = "diamond ore";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.emerald_ore] = "emerald ore";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.iron_ingot] = "iron ingot";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.gold_ingot] = "gold ingot";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.diamond] = "diamond";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.emerald] = "emerald";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.pork] = "pork";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.roast_pork] = "roast pork";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.iron_sword] = "iron sword";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.iron_pickaxe] = "iron pickaxe";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.iron_shovel] = "iron shovel";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.iron_axe] = "iron axe";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.wood_sword] = "wood sword";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.wood_pickaxe] = "wood pickaxe";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.wood_shovel] = "wood shovel";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.wood_axe] = "wood axe";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.iron_helmet] = "iron helmet";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.iron_chestplate] = "iron chestplate";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.iron_leggings] = "iron leggings";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.iron_boots] = "iron boots";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.pumpkin_cutted] = "cutted pumpkin";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.apple] = "apple";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.cookie] = "cookie";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.cake] = "cake :3";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.cake_chocolate] = "cake chocolate :3";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.coal] = "coal";
	global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.glass_block] = "glass block";

	//РУССКИЙ
	global.TEXT[GAME_LANGUAGE.ru][0] = "урон: ";

	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.none] = "-неизвестно-";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.dirt] = "земля";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.sand] = "песок";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.coal_ore] = "угольная руда";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.iron_ore] = "железная руда";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.gold_ore] = "золотая руда";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.diamond_ore] = "алмазная руда";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.emerald_ore] = "изумрудная руда";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.iron_ingot] = "железный слиток";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.gold_ingot] = "золотой слиток";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.diamond] = "алмаз";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.emerald] = "изумруд";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.pork] = "свинина";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.roast_pork] = "жареная свинина";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.iron_sword] = "железный меч";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.iron_pickaxe] = "железная кирка";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.iron_shovel] = "железная лопата";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.iron_axe] = "железный топор";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.wood_sword] = "деревянный меч";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.wood_pickaxe] = "деревянная кирка";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.wood_shovel] = "деревянная лопата";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.wood_axe] = "деревянный топор";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.iron_helmet] = "железный шлем";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.iron_chestplate] = "железная нагрудник";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.iron_leggings] = "железные леггинсы";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.iron_boots] = "железные сапоги";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.pumpkin_cutted] = "вырезанная тыква";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.apple] = "яблоко";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.cookie] = "печенька";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.cake] = "тортик :3";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.cake_chocolate] = "шоколадный тортик :3";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.coal] = "уголь";
	global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.glass_block] = "стеклянный блок";
	
	#endregion
	
	#region items properties
	
	#region ENUMS

	enum ALL_PROPS {
		drop_item,
		hp,
		maxstack,
		tool_type,
		tool_strength,
		type,
		material,
		cloth_type,
		satiety,
		fuel,
		unbreakable,
		props_length
	}

	enum TYPE {
		block,
		grass,
		liquid,
		furniture,
		tool,
		food,
		others,
		cloth,
		loose
	}

	enum MATERIAL {
		block,
		glass,
		smooth,
		sand,
		grass = 6,
		stone = 7,
		dirt = 8,
		wood = 9
	}

	enum TOOL_TYPE {
		sword = 6,
		pickaxe = 7,
		shovel = 8,
		axe = 9
	}

	enum CLOTH_TYPE {
		helmet,
		chestplate,
		leggings,
		boots,
		shield
	}

	#endregion

	for (var i = 0; i <= sprite_get_number(global.InvItemsSprite); ++i) {
		global.item_props[i][ALL_PROPS.drop_item]		= i; //drop image_index of sprite; 0 - no drop
		global.item_props[i][ALL_PROPS.hp]				= 1000*1.75; //hp of item or block
		global.item_props[i][ALL_PROPS.maxstack]		= 100; //max stack
		global.item_props[i][ALL_PROPS.tool_type]		= TOOL_TYPE.pickaxe; //tool type (sword, pickaxe, shovel, axe)
		global.item_props[i][ALL_PROPS.tool_strength]	= 5; //tool strength, equipment protection
		global.item_props[i][ALL_PROPS.type]			= TYPE.block; //item/block type (block, grass, liquid, furniture, tool, food, others, equipment, loose)
		global.item_props[i][ALL_PROPS.material]		= MATERIAL.stone; //(material/sounds for blocks) glass, smooth(cactus, wool, mushroom...), sand, grass/leaves, stone, dirt, wood
		global.item_props[i][ALL_PROPS.cloth_type]		= -1; //equipment type (helmet, chestplate, leggings, boots)
		global.item_props[i][ALL_PROPS.satiety]			= 5; //satiety of food
		global.item_props[i][ALL_PROPS.fuel]			= 0; //amount of fuel (if 0 then not fuel)
		global.item_props[i][ALL_PROPS.unbreakable]		= false; //unbreakable
	}

	// \/ \/ \/ HERE YOU CAN SET ALL PROPERTIES OF ITEMS \/ \/ \/

	//ITEMS
	AddItemProperty(ITEM.none,ALL_PROPS.unbreakable,true);
	AddItemProperty(ITEM.dirt,ALL_PROPS.hp,500,ALL_PROPS.material,MATERIAL.dirt);
	AddItemProperty(ITEM.sand,ALL_PROPS.hp,350,ALL_PROPS.type,TYPE.loose,ALL_PROPS.material,MATERIAL.dirt);
	AddItemProperty(ITEM.coal_ore,ALL_PROPS.hp,1200);
	AddItemProperty(ITEM.iron_ore,ALL_PROPS.hp,1700);
	AddItemProperty(ITEM.gold_ore,ALL_PROPS.hp,2500);
	AddItemProperty(ITEM.diamond_ore,ALL_PROPS.drop_item,ITEM.diamond,ALL_PROPS.hp,3000);
	AddItemProperty(ITEM.emerald_ore,ALL_PROPS.drop_item,ITEM.emerald,ALL_PROPS.hp,2500);
	AddItemProperty(ITEM.iron_ingot,ALL_PROPS.type,TYPE.others);
	AddItemProperty(ITEM.gold_ingot,ALL_PROPS.type,TYPE.others);
	AddItemProperty(ITEM.diamond,ALL_PROPS.type,TYPE.others);
	AddItemProperty(ITEM.emerald,ALL_PROPS.type,TYPE.others);
	AddItemProperty(ITEM.glass_block, ALL_PROPS.material, MATERIAL.glass, ALL_PROPS.hp, 50, ALL_PROPS.drop_item, ITEM.none);
	AddItemProperty(ITEM.pumpkin_cutted,ALL_PROPS.hp,200,ALL_PROPS.material,MATERIAL.smooth);

	//TOOLS
	AddItemProperty(ITEM.wood_sword,ALL_PROPS.type,TYPE.tool,ALL_PROPS.tool_type,TOOL_TYPE.sword,ALL_PROPS.hp,80,ALL_PROPS.tool_strength,8,ALL_PROPS.maxstack,1);
	AddItemProperty(ITEM.wood_pickaxe,ALL_PROPS.type,TYPE.tool,ALL_PROPS.tool_type,TOOL_TYPE.pickaxe,ALL_PROPS.hp,80,ALL_PROPS.tool_strength,8,ALL_PROPS.maxstack,1);
	AddItemProperty(ITEM.wood_shovel,ALL_PROPS.type,TYPE.tool,ALL_PROPS.tool_type,TOOL_TYPE.shovel,ALL_PROPS.hp,80,ALL_PROPS.tool_strength,8,ALL_PROPS.maxstack,1);
	AddItemProperty(ITEM.wood_axe,ALL_PROPS.type,TYPE.tool,ALL_PROPS.tool_type,TOOL_TYPE.axe,ALL_PROPS.hp,80,ALL_PROPS.tool_strength,8,ALL_PROPS.maxstack,1);
	AddItemProperty(ITEM.iron_sword,ALL_PROPS.type,TYPE.tool,ALL_PROPS.tool_type,TOOL_TYPE.sword,ALL_PROPS.hp,340,ALL_PROPS.tool_strength,32,ALL_PROPS.maxstack,1);
	AddItemProperty(ITEM.iron_pickaxe,ALL_PROPS.type,TYPE.tool,ALL_PROPS.tool_type,TOOL_TYPE.pickaxe,ALL_PROPS.hp,340,ALL_PROPS.tool_strength,32,ALL_PROPS.maxstack,1);
	AddItemProperty(ITEM.iron_shovel,ALL_PROPS.type,TYPE.tool,ALL_PROPS.tool_type,TOOL_TYPE.shovel,ALL_PROPS.hp,340,ALL_PROPS.tool_strength,32,ALL_PROPS.maxstack,1);
	AddItemProperty(ITEM.iron_axe,ALL_PROPS.type,TYPE.tool,ALL_PROPS.tool_type,TOOL_TYPE.axe,ALL_PROPS.hp,340,ALL_PROPS.tool_strength,32,ALL_PROPS.maxstack,1);

	//ARMOR
	AddItemProperty(ITEM.iron_helmet,ALL_PROPS.type,TYPE.cloth,ALL_PROPS.cloth_type,CLOTH_TYPE.helmet,ALL_PROPS.hp,60,ALL_PROPS.tool_strength,6,ALL_PROPS.maxstack,1);
	AddItemProperty(ITEM.iron_chestplate,ALL_PROPS.type,TYPE.cloth,ALL_PROPS.cloth_type,CLOTH_TYPE.chestplate,ALL_PROPS.hp,60,ALL_PROPS.tool_strength,6,ALL_PROPS.maxstack,1);
	AddItemProperty(ITEM.iron_leggings,ALL_PROPS.type,TYPE.cloth,ALL_PROPS.cloth_type,CLOTH_TYPE.leggings,ALL_PROPS.hp,60,ALL_PROPS.tool_strength,6,ALL_PROPS.maxstack,1);
	AddItemProperty(ITEM.iron_boots,ALL_PROPS.type,TYPE.cloth,ALL_PROPS.cloth_type,CLOTH_TYPE.boots,ALL_PROPS.hp,60,ALL_PROPS.tool_strength,6,ALL_PROPS.maxstack,1);

	//FOOD
	AddItemProperty(ITEM.pork,ALL_PROPS.type,TYPE.food,ALL_PROPS.satiety,10);
	AddItemProperty(ITEM.roast_pork,ALL_PROPS.type,TYPE.food,ALL_PROPS.satiety,25);
	AddItemProperty(ITEM.apple,ALL_PROPS.type,TYPE.food,ALL_PROPS.satiety,5);
	AddItemProperty(ITEM.cookie,ALL_PROPS.type,TYPE.food,ALL_PROPS.satiety,2);
	AddItemProperty(ITEM.cake,ALL_PROPS.type,TYPE.food,ALL_PROPS.satiety,30,ALL_PROPS.maxstack,1);

	//FUEL
	for (var i = 0; i <= sprite_get_number(global.InvItemsSprite); ++i) { //check all items
		if GetProp(i,ALL_PROPS.material) == MATERIAL.wood //if wood item
		global.item_props[i][ALL_PROPS.fuel] = 100; //set fuel to default 100
	}
	AddItemProperty(ITEM.wood_sword,ALL_PROPS.fuel,50);
	AddItemProperty(ITEM.wood_pickaxe,ALL_PROPS.fuel,50);
	AddItemProperty(ITEM.wood_shovel,ALL_PROPS.fuel,50);
	AddItemProperty(ITEM.wood_axe,ALL_PROPS.fuel,50);
	AddItemProperty(ITEM.coal,ALL_PROPS.fuel,500);

	#endregion
}

#region //===MAIN===//

function InvCreate() {
	///@desc Create a new inventory
	///@args width,height,[inv_slots]
	
	if !layer_exists("Inventories") layer_create(-100, "Inventories");
	if !layer_exists("items") layer_create(0, "items");
	if !instance_exists(oInvControl) instance_create_layer(0,0,"Inventories",oInvControl);

	with(instance_create_layer(0,0,"Inventories",oInventory)) {
		//Main parameters
		inv_item = -1; //main data structure with items (ds_grid)
		inv_show = false;
		inv_states = false;
		inv_selected = false;
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
		invPosX = global.gui_w div 2 - inv_surf_w div 2; //X position of inventory
		invPosY = global.gui_h div 2 - inv_surf_h div 2; //Y position of inventory
	
		InvRedraw();
	
		//Set main inv if it first
		if global.InvMainID == -1 global.InvMainID = id;
	
		return id;
	}
}

function InvDestroy(inventory) {
	///@desc Destroy previously created inventory
	
	if instance_exists(inventory) {
	
		if ds_exists(inventory.inv_item, ds_type_grid)
		ds_grid_destroy(inventory.inv_item);
	
		if surface_exists(inventory.inv_surf)
		surface_free(inventory.inv_surf);
	
		instance_destroy(inventory);
	}
}

function InvToggle() {
	///@desc Open or close inventory
	///@args inventory,[show/hide]
	
	with(argument[0]) {
		
		inv_show = argument_count > 1 ? argument[1] : !inv_show;
		
		if !inv_show {
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
			else
			if global.InvSndOpen != noone audio_play_sound(global.InvSndOpen, 1, false);
		} else {
			//Close sound
			if inv_sound_close != noone audio_play_sound(inv_sound_close, 1, false);
			else
			if global.InvSndClose != noone audio_play_sound(global.InvSndClose, 1, false);
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

function CheckMouseOnEveryInvs() {
	///@desc Check mouse position on all opened inventories
	
	with(oInventory) {
		if InvGetState(id)
		if CheckMouseOnInv()
		return true;
	}
	
	return false;
}

function CheckMouseOnEverySlots() {
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
			
				//Show cursor sprite or simple selected slot
				if selected_slot == ii {
					if inv_cursor_sprite != noone {
						draw_sprite(inv_cursor_sprite, 0, slot_pos_x, slot_pos_y);
					} else {
						draw_set_color(c_white);
						draw_set_alpha(0.5);
						draw_rectangle(slot_pos_x, slot_pos_y, slot_pos_x + cellSize-1, slot_pos_y + cellSize-1, false);
						draw_set_alpha(1);
					}
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

