//should be changed in your game
	
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
