//Items caption
var top_inv = GetInvOnTop();
with(top_inv) {
	if selected_slot!=-1 && !InvGetHandSlot(items_flags.item) {
		DrawSetText(c_white, global.InvMainFont, fa_left, fa_top, 1);
		var item = InvGetSlot(selected_slot,items_flags.item);
		
		if item {
			var _m_x = other.m_x;
			var _m_y = other.m_y;
			var c_off = 16; //X,Y offset
			var LR_width = 6; //Left and right border offset of text in caption
			var item_name = item < ITEM.item_number ? global.ITEM_TEXT[global.language][item] : "uknown item " + string(item);
			var item_special = "";
			if GetProp(item, ALL_PROPS.type) == TYPE.tool
			item_special = "\n" + global.TEXT[global.language][0] + string(GetProp(item, ALL_PROPS.tool_strength));
			var text = item_name + item_special;
			draw_nine_slice(sInvItemCaption, _m_x+c_off,
											_m_y+c_off,
											string_width(text)+LR_width*2,
											string_height(text)+9,
											true);
			draw_text_outline(_m_x+c_off+LR_width, _m_y+c_off+8, text, 1, c_black,8);
		}
	}
}

//Draw item in hand
if global.ItemInHand[items_flags.item] {

	var _spr_x = m_x + 16;
	var _spr_y = m_y + 16;
	
	//Sprite of item
	draw_sprite(global.InvItemsSprite, global.ItemInHand[items_flags.item], _spr_x, _spr_y);
	
	//Amount
	DrawSetText(c_white, global.InvMainFont, fa_center, fa_middle, 1);
	if global.ItemInHand[items_flags.count]>1
	draw_text_outline(_spr_x + sprite_item_size, _spr_y + sprite_item_size, 
						string(global.ItemInHand[items_flags.count]),
						1, c_black, 8);
}

//DEBUG
if global.InvDrawDebug {
	draw_set_color(c_white);
	draw_set_font(global.InvMainFont);
	draw_text(16, room_height*0.5, string(global.ItemInHand[items_flags.item]));
	draw_text(16, room_height*0.5+16, string(global.ItemInHand[items_flags.count]));
	draw_text(16, room_height*0.5+16*2, string(global.ItemInHand[items_flags.hp]));
	draw_text(16, room_height*0.5+16*3, string(global.ItemInHand[items_flags.enchant]));
}