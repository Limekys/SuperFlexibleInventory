/// @desc Demo info
DrawSetText(c_white, fMainInventoryFont, fa_left, fa_bottom, 0.75);
draw_text(8, _SINV_GUI_HEIGHT - 2, "WASD - move player");
draw_text(8, _SINV_GUI_HEIGHT - 2 - 16*1, "Space - restart");
draw_text(8, _SINV_GUI_HEIGHT - 2 - 16*2, "E - open/close player inventory and equipment");
draw_text(8, _SINV_GUI_HEIGHT - 2 - 16*3, "Shift + LMB quick sort to last active inventory");
draw_text(8, _SINV_GUI_HEIGHT - 2 - 16*4, "RMB - take half from stack or drop one item to slot");
draw_text(8, _SINV_GUI_HEIGHT - 2 - 16*5, "LMB - take/drop item");
draw_set_alpha(1);