m_x = device_mouse_x_to_gui(0);
m_y = device_mouse_y_to_gui(0);

if InvGetHandSlot(items_flags.item) && !CheckMouseOnEveryInvs() {
	//if LMB drop all in hand
	if mouse_check_button_pressed(mb_left) {
		InvDropHand(mouse_x, mouse_y, global.ItemInHand);
	} else {
		//if RMB drop 1
		if mouse_check_button_pressed(mb_right) {
			InvDropHand(mouse_x, mouse_y, global.ItemInHand,1);
		}
	}
}


// --- DEBUG ---
if keyboard_check_pressed(ord("Z")) {
	//Draw debug
	global.InvDrawDebug = !global.InvDrawDebug;
	with(oInventory) InvRedraw();
}