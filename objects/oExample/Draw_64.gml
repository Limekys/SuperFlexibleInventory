/// @desc Demo info
DrawSetText(c_white, fMainInventoryFont, fa_left, fa_bottom, 0.75);

if global.language == GAME_LANGUAGE.en {
	draw_text(8, display_get_gui_height() - 2, 
	@"WASD - move player
	Space - restart
	E - open/close player inventory and equipment
	Shift + LMB quick sort to last active inventory
	RMB - take half from stack or drop one item to slot
	LMB - take/drop item"
	);
} else {
	draw_text(8, display_get_gui_height() - 2, 
	@"WASD - движение игрока
	Пробел - рестарт
	E - открыть/закрыть инвентарь и инветарь экипировки игрока
	Shift + ЛКМ - сортировка предмета в последний активный либо главный инвентарь
	ПКМ - взять половину предметов в ячейке либо положить один из руки
	ЛКМ - взять/положить предмет"
	);
}

draw_set_alpha(1);