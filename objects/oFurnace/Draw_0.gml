/// @desc draw furnace caption
draw_self();

if anim > 0 {
	DrawSetText(c_white,global.InvMainFont,fa_center,fa_middle,anim);
	draw_text(x + 32, y-sprite_yoffset-8*anim, InvGetName(furnace));
}

draw_set_alpha(1);