//should be changed in your game

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