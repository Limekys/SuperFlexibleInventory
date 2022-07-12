var m_x = device_mouse_x_to_gui(0);
var m_y = device_mouse_y_to_gui(0);

//Items caption
var top_inv = GetInvOnTop();
with(top_inv) {
	if selected_slot!=-1 && !InvGetHandSlot(items_flags.item) {
		DrawSetText(c_white, global.InvMainFont, fa_left, fa_top, 1);
		var item = InvGetSlot(selected_slot,items_flags.item);
		
		if item {
			//Setup
			var mouse_offset_x = 16;	//X mouse offset
			var mouse_offset_y = 16;	//Y mouse offset
			var h_padding = 6;			//Horizontal padding of caption size
			var v_padding = 4;			//Vertical padding of caption size
			
			//Text
			var item_name = item < ITEM.enum_lenght ? global.ITEM_TEXT[global.language][item] : "uknown item " + string(item);
			var item_special = "";
			if GetProp(item, ITEM_PROPS.type) == TYPE.tool {
				item_special = "\n" + global.TEXT[global.language][0] + string(GetProp(item, ITEM_PROPS.tool_strength));
			}
			var text = item_name + item_special;
			
			//Draw
			draw_sprite_stretched(sInvItemCaption, 0,	m_x + mouse_offset_x - h_padding,
														m_y + mouse_offset_y - v_padding,
														string_width(text) + h_padding * 2,
														string_height(text) + v_padding * 2);
			draw_text_outline(	m_x + mouse_offset_x, 
								m_y + mouse_offset_y, 
								text, 1, c_black, 8);
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
	draw_text_outline(_spr_x + sprite_item_size - sprite_item_offset_x, _spr_y + sprite_item_size - sprite_item_offset_y, 
						string(global.ItemInHand[items_flags.count]),
						1, c_black, 8);
}

//DEBUG
if global.InvDrawDebug {
	
	DrawSetText(c_white, global.InvDebugFont, fa_left, fa_middle, 1);
	
	draw_text(m_x + 16, m_y - 64, 
	"Taken item: " + string(global.ItemInHand[items_flags.item]) + "\n" +
	"Count: " + string(global.ItemInHand[items_flags.count]) + "\n" +
	"Hp: " + string(global.ItemInHand[items_flags.hp]) + "\n" +
	"Enchanted: " + string(global.ItemInHand[items_flags.enchant]));
}