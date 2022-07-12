//Should be changed in your game
	
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

//Init default names
for (var i = 0; i < ITEM.enum_lenght; ++i) {
    global.ITEM_TEXT[GAME_LANGUAGE.en][i] = "item_" + string(i);
    global.ITEM_TEXT[GAME_LANGUAGE.ru][i] = "предмет_" + string(i);
}

//ENGLISH
global.TEXT[GAME_LANGUAGE.en][0] = "damage: ";
global.TEXT[GAME_LANGUAGE.en][1] = "player inventory";
global.TEXT[GAME_LANGUAGE.en][2] = "equipment";
global.TEXT[GAME_LANGUAGE.en][3] = "chest";
global.TEXT[GAME_LANGUAGE.en][4] = "furnace";

global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.none] = "-uknown-";
global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.iron_ingot] = "iron ingot";
global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.gold_ingot] = "gold ingot";
global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.diamond] = "diamond";
global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.pork] = "pork";
global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.roast_pork] = "roast pork";
global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.wood_sword] = "wood sword";
global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.apple] = "apple";
global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.cookie] = "cookie";
global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.coal] = "coal";
global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.iron_helmet] = "iron helmet";
global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.iron_chestplate] = "iron chestplate";
global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.iron_leggings] = "iron leggings";
global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.iron_boots] = "iron boots";
global.ITEM_TEXT[GAME_LANGUAGE.en][ITEM.shield] = "shield";

//РУССКИЙ
global.TEXT[GAME_LANGUAGE.ru][0] = "урон: ";
global.TEXT[GAME_LANGUAGE.ru][1] = "инвентарь игрока";
global.TEXT[GAME_LANGUAGE.ru][2] = "экипировка";
global.TEXT[GAME_LANGUAGE.ru][3] = "сундук";
global.TEXT[GAME_LANGUAGE.ru][4] = "печка";

global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.none] = "-неизвестно-";
global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.iron_ingot] = "железный слиток";
global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.gold_ingot] = "золотой слиток";
global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.diamond] = "алмаз";
global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.pork] = "свинина";
global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.roast_pork] = "жареная свинина";
global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.apple] = "яблоко";
global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.cookie] = "печенька";
global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.coal] = "уголь";
global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.wood_sword] = "деревянный меч";
global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.iron_helmet] = "железный шлем";
global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.iron_chestplate] = "железная нагрудник";
global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.iron_leggings] = "железные леггинсы";
global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.iron_boots] = "железные сапоги";
global.ITEM_TEXT[GAME_LANGUAGE.ru][ITEM.shield] = "щит";