///@desc Render
if !inv_shown exit;

//Draw on surface
if InvGetState(self) == INV_STATE.open && !surface_exists(inv_surf)
{
	//Create surface
	inv_surf = surface_create(inv_surf_w, inv_surf_h);
	
	draw_set_alpha(1);
		
	surface_set_target(inv_surf);
	draw_clear_alpha(c_black,0);
		
	//Background
	if !inv_back_spr && !inv_back_spr_nine_slice {
		//Back/Main
		draw_set_color(inv_back_color);
		draw_rectangle(0, 0, inv_left_border + inv_width*(cellSize+inv_cell_indent) + inv_right_border,
							inv_head_border + inv_top_border + inv_height*(cellSize+inv_cell_indent) + inv_bottom_border,
							false);
		//Head
		draw_set_color(inv_top_color);
		draw_rectangle(0, 0, inv_left_border + inv_width*(cellSize+inv_cell_indent) + inv_right_border,
							inv_head_border - 1,
							false);
	} else {
		//Draw background (nineslice or default) (if nineslice, do not forgot to setup in sprite nineslice!)
		if inv_back_spr_nine_slice {
			draw_sprite_stretched(inv_back_spr_nine_slice, 0, 0, 0, inv_surf_w, inv_surf_h);
		} else {
			draw_sprite(inv_back_spr,0,0,0);
		}
	}
		
	//Draw borders
	if inv_selected == true && global.InvShowSelected == true {
		//Selected inventory color
		draw_set_color(c_white);
		draw_rectangle(0, 0, inv_surf_w -1, inv_surf_h -1, true);
	} else {
		if !inv_back_spr && !inv_back_spr_nine_slice {
			//Default color of inventory window
			draw_set_color(inv_border_color);
			draw_rectangle(0, 0, inv_surf_w -1, inv_surf_h -1, true);
		}
	}
		
	gpu_set_colorwriteenable(true,true,true,false);
		
	//SLOTS
	var DSinv = inv_item;
	var ii = 0, ix = 0, iy = 0;
	repeat (inv_slots) {
	
		//Getting coordinates
		ix = DSinv[# ii, items_flags.slot_direct_x];
		iy = DSinv[# ii, items_flags.slot_direct_y];
		var slot_pos_x = inv_left_border + ix*(cellSize + inv_cell_indent);
		var slot_pos_y = inv_head_border + inv_top_border + iy*(cellSize+inv_cell_indent);
	
		//Draw slots
		var slot_spr = inv_slot_spr;							//Set default/custom slot sprite for all slots
		if (inv_item[# ii, items_flags.slot_sprite] != noone) 
		slot_spr = inv_item[# ii, items_flags.slot_sprite];		//Set custom sprite for slot if this slot have custom sprite
		//Draw slot if it's not progressbar
		if !DSinv[# ii, items_flags.slot_is_bar] {
			
			//Draw slot
			if slot_spr != noone {
				if DSinv[# ii, items_flags.enchant] {
					//If enchanted
					draw_sprite_ext(slot_spr, 0, slot_pos_x, slot_pos_y, 1, 1, 0, c_yellow, 1);
				} else {
					//Simple slot
					draw_sprite(slot_spr, 0, slot_pos_x, slot_pos_y);
				}
			} else {
				//Draw colored rectangle if slot sprite is not setted
				var _color = DSinv[# ii, items_flags.enchant] ? c_yellow : inv_slot_color; //yellow slot if enchanted
				draw_rectangle_color(slot_pos_x, slot_pos_y, slot_pos_x + cellSize -1, slot_pos_y + cellSize -1, _color, _color, _color, _color, false);
			}
				
			//Draw special sprite (like silhouette of chestplate)
			var _special_sprite = DSinv[# ii, items_flags.special_sprite];
			if _special_sprite >= 0 {
				if !DSinv[# ii, items_flags.item]
				if global.InvSpecialSlotSprite != noone
				draw_sprite_ext(global.InvSpecialSlotSprite, _special_sprite, slot_pos_x + cellSize div 2 + special_offset, slot_pos_y + cellSize div 2 + special_offset, 1,1,0,c_black,0.25);
			}
		}
	
		//Draw items and info
		if DSinv[# ii, items_flags.item] {
			//Sprite of item
			draw_sprite_ext(global.InvItemsSprite, DSinv[# ii, items_flags.item], slot_pos_x + cellSize div 2 + items_offset, slot_pos_y + cellSize div 2 + items_offset,
							global.InvItemScale, global.InvItemScale, 0, c_white, 1);
	
			//Amount
			DrawSetText(c_white, global.InvMainFont, fa_center, fa_middle, 1);
			if DSinv[# ii, items_flags.count]>1
			draw_text_outline(slot_pos_x + cellSize*0.75, slot_pos_y + cellSize*0.75, 
								string(DSinv[# ii, items_flags.count]),
								1, c_black, 8);
			
			//Strength
			if GetProp(DSinv[# ii, items_flags.item], ALL_PROPS.type) == TYPE.tool
			&& DSinv[# ii, items_flags.hp] < GetProp(DSinv[# ii, items_flags.item], ALL_PROPS.hp)
			draw_healthbar(slot_pos_x + 3, slot_pos_y + cellSize-8,
							slot_pos_x + cellSize - 4, slot_pos_y + cellSize-4, 
							(DSinv[# ii, items_flags.hp] / GetProp(DSinv[# ii, items_flags.item], ALL_PROPS.hp))*100,
							c_gray, c_red, c_green, 0, true, true);
		}
	
		//inc
		ii++;
	}
		
	//Inventory name
	if inv_show_name
	if inv_name != "" {
		DrawSetText(c_white, global.InvMainFont, fa_left, fa_top, 1);
		draw_text_outline(inv_left_border, inv_head_border div 3, inv_name, 1, c_black, 8);
	}
	
	gpu_set_colorwriteenable(true,true,true,true);
	surface_reset_target();
}

//Then render on screen
DrawSetText(c_white, global.InvMainFont, fa_left, fa_bottom, image_alpha);

if surface_exists(inv_surf)
draw_surface_ext(inv_surf,  invPosX - inv_left_border + (inv_surf_w*(1-image_xscale))/2,
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

//Draw slot-bars (healthbars)
var DSinv = inv_item;
var ii = 0, ix = 0, iy = 0;
if inv_states == INV_STATE.open
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
	"Inv selected: " + string(inv_selected) + "\n" +
	"Selected slot: " + string(selected_slot) + "\n" +
	"Depth: " + string(depth) + "\n" +
	"Width: " + string(inv_surf_w) + "\n" +
	"Height: " + string(inv_surf_h));
	
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