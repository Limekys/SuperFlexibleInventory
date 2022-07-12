selected_slot = -1;
invItemMaxStack = 1;

#region Show and hide system

//Inventory states
switch(inv_states) {
	case INV_STATE.close: //Close
		if image_alpha > 0 {
			image_alpha = ReachTween(image_alpha, 0, 3);
			image_xscale = ReachTween(image_xscale, 0.9, 3);
			image_yscale = ReachTween(image_yscale, 0.9, 3);
		}
		if (image_alpha == 0 && inv_shown) InvToggle(id,false);
	break;
	case INV_STATE.open: //Open
		if (!inv_shown) InvToggle(id,true);
		if image_alpha < 1 {
			image_alpha = ReachTween(image_alpha, 1, 3);
			image_xscale = ReachTween(image_xscale, 1, 3);
			image_yscale = ReachTween(image_yscale, 1, 3);
		}
	break;
}

#endregion

if inv_states == INV_STATE.close exit;

//Get mouse_x_to_gui and mouse_y_to_dui position
var m_x = device_mouse_x_to_gui(0);
var m_y = device_mouse_y_to_gui(0);

#region Selecting slot

//Select slot if mouse on
var ii = 0;
if GetInvOnTop() == self
repeat(inv_slots) {
	if inv_item[# ii, items_flags.slot_is_bar] break;
	
	var slot_direct_x = inv_item[# ii, items_flags.slot_direct_x];
	var slot_direct_y = inv_item[# ii, items_flags.slot_direct_y];
	
	if	m_x >= invPosX + slot_direct_x*(cellSize+inv_cell_indent) &&
		m_x < invPosX + slot_direct_x*(cellSize+inv_cell_indent) + cellSize &&
		m_y >= invPosY + slot_direct_y*(cellSize+inv_cell_indent) &&
		m_y < invPosY + slot_direct_y*(cellSize+inv_cell_indent) + cellSize 
	{
		selected_slot = ii;
		
		invItemMaxStack = GetProp(inv_item[# selected_slot, items_flags.item], ITEM_PROPS.maxstack);
		
		break;
	}
	
	//inc
	ii++;
}

#endregion

#region Move items
//Click to slots
if selected_slot!=-1
if mouse_check_button_pressed(mb_left) && GetInvOnTop() == self
{
	if InvGetSlot(selected_slot, items_flags.item) //If there is an item in the slot
	{
		//Play take sound
		if global.InvClickSounds
		audio_play_sound(global.InvSndClick,1,false);
		
		//Move item to another inventory with Shift button
		if keyboard_check(vk_shift)
		{
			if self != global.InvMainID {
				InvMoveItemToInv(global.InvMainID,selected_slot);
			} else {
				if global.InvLastSelectedID!=-1 && global.InvLastSelectedID.inv_states == INV_STATE.open
				InvMoveItemToInv(global.InvLastSelectedID,selected_slot);
			}
		} 
		else 
		{
			//Take item to hand from slot
			if !InvGetHandSlot(items_flags.item) //If nothing in hand
			{
				InvSlotToHand(selected_slot);
				InvSlotClear(selected_slot);
			}
			else
			{ //If have an item in hand
				//If slot is not blocked to place items in here
				if !InvGetSlot(selected_slot, items_flags.blocked_to_place_slot) &&
				(InvGetSlot(selected_slot, items_flags.armor_type) == GetProp(InvGetHandSlot(items_flags.item), ITEM_PROPS.cloth_type)
				or InvGetSlot(selected_slot, items_flags.armor_type) == -1)
				{
					//If in slot the same item what in hand
					if InvGetSlot(selected_slot, items_flags.item) == InvGetHandSlot(items_flags.item) &&
					InvGetSlot(selected_slot, items_flags.count)<invItemMaxStack
					{
					    /* add items until it is full or until we add all the dragged items */
						while (InvGetSlot(selected_slot, items_flags.count)<invItemMaxStack && InvGetHandSlot(items_flags.count)>0)
					    {
							inv_item[# selected_slot, items_flags.count]++;
						    global.ItemInHand[items_flags.count]--;
					
							//If was moved all items, delete item from hand
							if InvGetHandSlot(items_flags.count) == 0 InvHandClear();
					    }
					}
					else
					{
						//swap items in slot with items in hand
						InvSwapSlotWithHand(selected_slot);
					}
				}
			}
		}
	}
	else
	{
		//if the cell is empty and there is an item in the hand and the slot is not locked to place the item in it
		if InvGetHandSlot(items_flags.item) && !InvGetSlot(selected_slot, items_flags.blocked_to_place_slot)
		&& (InvGetSlot(selected_slot, items_flags.armor_type) == GetProp(InvGetHandSlot(items_flags.item), ITEM_PROPS.cloth_type)
		or InvGetSlot(selected_slot, items_flags.armor_type) == -1)
		{
			//Move item from hand to slot
			InvHandToSlot(selected_slot);
			InvHandClear();
			
			//Play drop sound
			if global.InvClickSounds
			audio_play_sound(global.InvSndUnClick,1,false);
		}
	}
	
	InvRedraw();
}
else
{
	if mouse_check_button_pressed(mb_right) && GetInvOnTop() == self
	{
		//If nothing in hand
		if !InvGetHandSlot(items_flags.item)
		{
			//If there is something in the slot
			if InvGetSlot(selected_slot, items_flags.item)
			{
				//Play take sound
				if global.InvClickSounds
				audio_play_sound(global.InvSndClick,1,false);
				
				//Take half from stack if items in here > 1
				if InvGetSlot(selected_slot, items_flags.count)>1
				{
					InvSlotHalfToHand(selected_slot);
				}
				else
				{
					InvSlotToHand(selected_slot);
					InvSlotClear(selected_slot);
				}
			}
		} 
		else
		{
			//if the slot is not locked to place an item in it
			if !InvGetSlot(selected_slot, items_flags.blocked_to_place_slot)
			&& (InvGetSlot(selected_slot, items_flags.armor_type) == GetProp(InvGetHandSlot(items_flags.item), ITEM_PROPS.cloth_type)
			or InvGetSlot(selected_slot, items_flags.armor_type) == -1)
			{
				//Play drop sound
				if global.InvClickSounds
				audio_play_sound(global.InvSndUnClick,1,false);
				
				//Place last item if it is one
				if InvGetHandSlot(items_flags.count) == 1 && !InvGetSlot(selected_slot, items_flags.item)
				{
					InvHandToSlot(selected_slot);
					InvHandClear();
				}
				else
				{
					//else we’re trying to put one item on hand, or change their places if they are different
					if !InvOneFromHandToSlot(selected_slot)
					{
						InvSwapSlotWithHand(selected_slot);
					}
				}
			}
		}
		
		InvRedraw();
	}
}
#endregion

#region Drag and select inventories

var l_side = invPosX - inv_left_border;
var r_side = invPosX + inv_surf_w - inv_left_border;
var t_side = invPosY - inv_head_border - inv_top_border;
var b_side = invPosY - inv_top_border;
if (m_x>l_side && m_x<r_side) && (m_y>t_side && m_y<b_side)
{
	//Change depth and select
	if (mouse_check_button_pressed(mb_left)) 
	if GetInvOnTop() == self
	{
		if !inv_selected {
			//Change depth for all inventories and unselect
			with(oInventory) {
				depth = clamp(depth+1,-99,0);
				//Deselect and redraw if was selected
				if inv_selected == true {
					inv_selected = false;
					InvRedraw();
				}
			}
			//Bring up on top selected inventory
			depth = -99;
			inv_selected = true;
			if (self != global.InvMainID) global.InvLastSelectedID = self;
			InvRedraw();
		}
		
		drag_x = m_x;
		drag_y = m_y;
		offsetx = m_x - invPosX;
		offsety = m_y - invPosY;
		isdrag = true;
	}
}

if !global.InvDragAndDrop exit;

if (mouse_check_button(mb_left)) && isdrag && inv_selected {
	//Drag and drop and clamp
	invPosX = clamp(m_x-offsetx, inv_left_border, _FINV_GUI_WIDTH - (inv_surf_w - inv_left_border));
	invPosY = clamp(m_y-offsety, inv_head_border + inv_top_border, _FINV_GUI_HEIGHT - (inv_surf_h - inv_head_border - inv_top_border));
}

if (mouse_check_button_released(mb_left)) {
	isdrag = false;
}

#endregion