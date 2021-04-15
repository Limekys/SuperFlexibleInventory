///@desc Вraw inventory
if !inv_shown exit;

//Background, slots...
DrawSetText(c_white, global.InvMainFont, fa_left, fa_bottom, image_alpha);
if surface_exists(inv_surf) {
	draw_surface_ext(inv_surf, invPosX - inv_left_border + (inv_surf_w*(1-image_xscale))/2,
								invPosY - inv_top_border - inv_head_border + (inv_surf_h*(1-image_yscale))/2,
								image_xscale, image_yscale, 0, c_white, image_alpha);
	//Draw cursor sprite
	if CheckMouseOnInvSlots() {
		//Calculate slot position
		var DSinv = inv_item;
		var ix = DSinv[# selected_slot, items_flags.slot_direct_x];
		var iy = DSinv[# selected_slot, items_flags.slot_direct_y];
		var slot_pos_x = invPosX + ix*(cellSize + inv_cell_indent);
		var slot_pos_y = invPosY + iy*(cellSize + inv_cell_indent);
		//Draw cursor sprite
		if inv_cursor_sprite != noone {
			//Special sprite
			draw_sprite(inv_cursor_sprite, 0, slot_pos_x, slot_pos_y);
		} else {
			//Or default rectangle
			draw_set_color(c_white);
			draw_set_alpha(0.5);
			draw_rectangle(slot_pos_x, slot_pos_y, slot_pos_x + cellSize-1, slot_pos_y + cellSize-1, false);
			draw_set_alpha(1);
		}
	}
} else {
	InvRedraw();
}

//Draw slot-bars (healthbars)
var DSinv = inv_item;
var ii = 0, ix = 0, iy = 0;
if inv_states
repeat (inv_slots) {
	//Draw slot-bar
	if DSinv[# ii, items_flags.slot_is_bar] {
		
		//Getting coordinates
		ix = DSinv[# ii, items_flags.slot_direct_x];
		iy = DSinv[# ii, items_flags.slot_direct_y];
		var slot_pos_x = invPosX + ix*cellSize;
		var slot_pos_y = invPosY + iy*cellSize;
		
		//Draw bar
		draw_healthbar(slot_pos_x + 3, slot_pos_y + cellSize div 2 -4,
						slot_pos_x + cellSize - 4, slot_pos_y + cellSize div 2 +4, 
						DSinv[# ii, items_flags.hp],
						c_gray, c_red, c_green, 0, true, true);
	}
	
	//inc
	ii++;
}

// --- DEBUG ---
if global.InvDrawDebug {
	DrawSetText(c_white, global.InvDebugFont, fa_right, fa_bottom, 1);
	
	draw_text(invPosX - inv_left_border, invPosY, 
	"Selected slot: " + string(selected_slot) + @"
	Depth: " + string(depth) + @"
	Width: " + string(inv_surf_w) + @"
	Height: " + string(inv_surf_h));
	
	draw_set_color(c_red);
	draw_circle(invPosX, invPosY, 3, false);
}
//-----------------

//default
DrawSetText(c_white, global.InvMainFont, fa_left, fa_top, 1);

#region EFFECT OF ENCHANTED ITEM (UNDER CONSTRUCTION)
/*
	//if !surface_exists(enchant_surf) enchant_surf = surface_create(64,64);
	
	if DSinv[# ii, items_flags.enchant] {
		
		surface_set_target(enchant_surf);
		
		draw_clear_alpha(c_white, 0);
		
		draw_sprite(global.InvItemsSprite, DSinv[# ii, items_flags.item], 16, 16);
		
		gpu_set_colorwriteenable(1,1,1,0);
		gpu_set_blendmode(bm_add);
		draw_sprite_ext(sEnchantedEffect, 0, 32, 32, Wave(0.75,2,10,0), Wave(0.75,2,10,1), Wave(0,359,15,0), c_purple, 0.75);
		gpu_set_blendmode(bm_normal);
		gpu_set_colorwriteenable(1,1,1,1);
		
		surface_reset_target();
		
		draw_surface(enchant_surf,invPosX + ix*sprW, invPosY + iy*sprW);
	} else {
		draw_sprite(global.InvItemsSprite, DSinv[# ii, items_flags.item], invPosX + ix*sprW + 16, invPosY + iy*sprW + 16);
	}
	*/
#endregion