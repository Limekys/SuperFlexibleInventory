//should be changed in your game

//Functions for items properties
///@func AddItemProperty()
///@args item,[prop,value,...]
function AddItemProperty() {
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
	
	enum_lenght					
}

enum ITEM_PROPS {
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
	
	enum_lenght
}

enum TYPE {
	others,
	furniture,
	tool,
	food,
	cloth,
	
	enum_lenght
}

enum MATERIAL {
	glass,
	smooth,
	sand,
	grass,
	stone,
	dirt,
	wood,
	metal,
	
	enum_lenght
}

enum TOOL_TYPE {
	sword,
	pickaxe,
	shovel,
	axe,
	
	enum_lenght
}

enum CLOTH_TYPE {
	helmet,
	chestplate,
	leggings,
	boots,
	shield,
	
	enum_lenght
}

//Init global variable of items properties
for (var i = 0, n = sprite_get_number(global.InvItemsSprite); i <= n; ++i) {
	global.item_props[i][ITEM_PROPS.drop_item]		= i; //drop image_index of sprite; 0 - no drop
	global.item_props[i][ITEM_PROPS.hp]				= 1000; //hp of item or block
	global.item_props[i][ITEM_PROPS.maxstack]		= 100; //max stack
	global.item_props[i][ITEM_PROPS.tool_type]		= -1; //tool type (sword, pickaxe, shovel, axe)
	global.item_props[i][ITEM_PROPS.tool_strength]	= 5; //tool strength, equipment protection
	global.item_props[i][ITEM_PROPS.type]			= -1; //item/block type (block, grass, liquid, furniture, tool, food, others, equipment, loose)
	global.item_props[i][ITEM_PROPS.material]		= -1; //(material/sounds for blocks) glass, smooth(cactus, wool, mushroom...), sand, grass/leaves, stone, dirt, wood
	global.item_props[i][ITEM_PROPS.cloth_type]		= -1; //equipment type (helmet, chestplate, leggings, boots)
	global.item_props[i][ITEM_PROPS.satiety]			= 5; //satiety of food
	global.item_props[i][ITEM_PROPS.fuel]			= 0; //amount of fuel (0 = not fuel)
	global.item_props[i][ITEM_PROPS.unbreakable]		= false; //unbreakable
}

//ALL PROPERTIES OF ITEMS
AddItemProperty(ITEM.none, 
ITEM_PROPS.unbreakable, true);
AddItemProperty(ITEM.iron_ingot, 
ITEM_PROPS.type, TYPE.others, 
ITEM_PROPS.material, MATERIAL.metal);
AddItemProperty(ITEM.gold_ingot, 
ITEM_PROPS.type, TYPE.others, 
ITEM_PROPS.material, MATERIAL.metal);
AddItemProperty(ITEM.diamond, 
ITEM_PROPS.type, TYPE.others);
AddItemProperty(ITEM.pork, 
ITEM_PROPS.type, TYPE.food, 
ITEM_PROPS.satiety, 10);
AddItemProperty(ITEM.roast_pork, 
ITEM_PROPS.type, TYPE.food, 
ITEM_PROPS.satiety, 25);
AddItemProperty(ITEM.apple, 
ITEM_PROPS.type, TYPE.food, 
ITEM_PROPS.satiety, 5);
AddItemProperty(ITEM.cookie, 
ITEM_PROPS.type, TYPE.food, 
ITEM_PROPS.satiety, 2);
AddItemProperty(ITEM.wood_sword, 
ITEM_PROPS.type, TYPE.tool, 
ITEM_PROPS.tool_type, TOOL_TYPE.sword, 
ITEM_PROPS.hp, 80, 
ITEM_PROPS.tool_strength, 8, 
ITEM_PROPS.maxstack, 1, 
ITEM_PROPS.material, MATERIAL.wood);
AddItemProperty(ITEM.iron_helmet, 
ITEM_PROPS.type, TYPE.cloth, 
ITEM_PROPS.cloth_type, CLOTH_TYPE.helmet, 
ITEM_PROPS.hp, 60, 
ITEM_PROPS.tool_strength, 6, 
ITEM_PROPS.maxstack, 1, 
ITEM_PROPS.material, MATERIAL.metal);
AddItemProperty(ITEM.iron_chestplate, 
ITEM_PROPS.type, TYPE.cloth, 
ITEM_PROPS.cloth_type, CLOTH_TYPE.chestplate, 
ITEM_PROPS.hp, 60, 
ITEM_PROPS.tool_strength, 6, 
ITEM_PROPS.maxstack, 1, 
ITEM_PROPS.material, MATERIAL.metal);
AddItemProperty(ITEM.iron_leggings, 
ITEM_PROPS.type, TYPE.cloth, 
ITEM_PROPS.cloth_type, CLOTH_TYPE.leggings, 
ITEM_PROPS.hp, 60, 
ITEM_PROPS.tool_strength, 6, 
ITEM_PROPS.maxstack, 1, 
ITEM_PROPS.material, MATERIAL.metal);
AddItemProperty(ITEM.iron_boots, 
ITEM_PROPS.type, TYPE.cloth, 
ITEM_PROPS.cloth_type, CLOTH_TYPE.boots, 
ITEM_PROPS.hp, 60, 
ITEM_PROPS.tool_strength, 6, 
ITEM_PROPS.maxstack, 1, 
ITEM_PROPS.material, MATERIAL.metal);
AddItemProperty(ITEM.shield, 
ITEM_PROPS.type, TYPE.cloth, 
ITEM_PROPS.cloth_type, CLOTH_TYPE.shield, 
ITEM_PROPS.hp, 100, 
ITEM_PROPS.tool_strength, 25, 
ITEM_PROPS.maxstack, 1, 
ITEM_PROPS.material, MATERIAL.wood);
//FUEL
for (var i = 0; i <= sprite_get_number(global.InvItemsSprite); ++i) { //check all items
	if GetProp(i,ITEM_PROPS.material) == MATERIAL.wood //if wood item
	global.item_props[i][ITEM_PROPS.fuel] = 100; //set fuel to default 100
}
AddItemProperty(ITEM.wood_sword, ITEM_PROPS.fuel, 50);
AddItemProperty(ITEM.coal, ITEM_PROPS.fuel, 500);