/// @desc (for example)
draw_self();

//Draw count (for example)
DrawSetText(c_white, global.InvMainFont, fa_center, fa_middle, 1);
draw_text_outline(x+sprite_item_size, y+sprite_item_size, drop_data[items_flags.count], 1, c_black, 8);