//should be changed in your game

//Functions for items properties
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

//Macros
enum ITEM {
	none						,
	iron_ingot					,
	gold_ingot					,
	diamond						,
	pork						,
	roast_pork					,
	apple						,
	cookie						,
	coal						,
	wood_sword					,
	iron_helmet					,
	iron_chestplate				,
	iron_leggings				,
	iron_boots					,
	shield						,
	
	item_number					
}

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
	others,
	furniture,
	tool,
	food,
	cloth
}

enum MATERIAL {
	glass,
	smooth,
	sand,
	grass,
	stone,
	dirt,
	wood,
	metal
}

enum TOOL_TYPE {
	sword,
	pickaxe,
	shovel,
	axe
}

enum CLOTH_TYPE {
	helmet,
	chestplate,
	leggings,
	boots,
	shield
}

//Init global variable of items properties
for (var i = 0, n = sprite_get_number(global.InvItemsSprite); i <= n; ++i) {
	global.item_props[i][ALL_PROPS.drop_item]		= i; //drop image_index of sprite; 0 - no drop
	global.item_props[i][ALL_PROPS.hp]				= 1000; //hp of item or block
	global.item_props[i][ALL_PROPS.maxstack]		= 100; //max stack
	global.item_props[i][ALL_PROPS.tool_type]		= -1; //tool type (sword, pickaxe, shovel, axe)
	global.item_props[i][ALL_PROPS.tool_strength]	= 5; //tool strength, equipment protection
	global.item_props[i][ALL_PROPS.type]			= -1; //item/block type (block, grass, liquid, furniture, tool, food, others, equipment, loose)
	global.item_props[i][ALL_PROPS.material]		= -1; //(material/sounds for blocks) glass, smooth(cactus, wool, mushroom...), sand, grass/leaves, stone, dirt, wood
	global.item_props[i][ALL_PROPS.cloth_type]		= -1; //equipment type (helmet, chestplate, leggings, boots)
	global.item_props[i][ALL_PROPS.satiety]			= 5; //satiety of food
	global.item_props[i][ALL_PROPS.fuel]			= 0; //amount of fuel (0 = not fuel)
	global.item_props[i][ALL_PROPS.unbreakable]		= false; //unbreakable
}

//ALL PROPERTIES OF ITEMS
AddItemProperty(ITEM.none, ALL_PROPS.unbreakable, true);
AddItemProperty(ITEM.iron_ingot, ALL_PROPS.type, TYPE.others, ALL_PROPS.material, MATERIAL.metal);
AddItemProperty(ITEM.gold_ingot, ALL_PROPS.type, TYPE.others, ALL_PROPS.material, MATERIAL.metal);
AddItemProperty(ITEM.diamond, ALL_PROPS.type, TYPE.others);
AddItemProperty(ITEM.pork, ALL_PROPS.type, TYPE.food, ALL_PROPS.satiety, 10);
AddItemProperty(ITEM.roast_pork, ALL_PROPS.type, TYPE.food, ALL_PROPS.satiety, 25);
AddItemProperty(ITEM.apple, ALL_PROPS.type, TYPE.food, ALL_PROPS.satiety, 5);
AddItemProperty(ITEM.cookie, ALL_PROPS.type, TYPE.food, ALL_PROPS.satiety, 2);
AddItemProperty(ITEM.wood_sword, ALL_PROPS.type, TYPE.tool, ALL_PROPS.tool_type, TOOL_TYPE.sword, ALL_PROPS.hp, 80, ALL_PROPS.tool_strength, 8, ALL_PROPS.maxstack, 1, ALL_PROPS.material, MATERIAL.wood);
AddItemProperty(ITEM.iron_helmet, ALL_PROPS.type, TYPE.cloth, ALL_PROPS.cloth_type, CLOTH_TYPE.helmet, ALL_PROPS.hp, 60, ALL_PROPS.tool_strength, 6, ALL_PROPS.maxstack, 1, ALL_PROPS.material, MATERIAL.metal);
AddItemProperty(ITEM.iron_chestplate, ALL_PROPS.type, TYPE.cloth, ALL_PROPS.cloth_type, CLOTH_TYPE.chestplate, ALL_PROPS.hp, 60, ALL_PROPS.tool_strength, 6, ALL_PROPS.maxstack, 1, ALL_PROPS.material, MATERIAL.metal);
AddItemProperty(ITEM.iron_leggings, ALL_PROPS.type, TYPE.cloth, ALL_PROPS.cloth_type, CLOTH_TYPE.leggings, ALL_PROPS.hp, 60, ALL_PROPS.tool_strength, 6, ALL_PROPS.maxstack, 1, ALL_PROPS.material, MATERIAL.metal);
AddItemProperty(ITEM.iron_boots, ALL_PROPS.type, TYPE.cloth, ALL_PROPS.cloth_type, CLOTH_TYPE.boots, ALL_PROPS.hp, 60, ALL_PROPS.tool_strength, 6, ALL_PROPS.maxstack, 1, ALL_PROPS.material, MATERIAL.metal);
AddItemProperty(ITEM.shield, ALL_PROPS.type, TYPE.cloth, ALL_PROPS.cloth_type, CLOTH_TYPE.shield, ALL_PROPS.hp, 100, ALL_PROPS.tool_strength, 25, ALL_PROPS.maxstack, 1, ALL_PROPS.material, MATERIAL.wood);
//FUEL
for (var i = 0; i <= sprite_get_number(global.InvItemsSprite); ++i) { //check all items
	if GetProp(i,ALL_PROPS.material) == MATERIAL.wood //if wood item
	global.item_props[i][ALL_PROPS.fuel] = 100; //set fuel to default 100
}
AddItemProperty(ITEM.wood_sword, ALL_PROPS.fuel, 50);
AddItemProperty(ITEM.coal, ALL_PROPS.fuel, 500);