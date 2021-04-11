/// @desc caption animation
if collision_point(mouse_x, mouse_y, self, false, false) {
	anim = ReachTween(anim,1,7);
} else {
	anim = ReachTween(anim,0,7);
}