function Approach(_value, _dest, _amount) {
	///@desc Approach(_value, _dest, _amount)
	return (_value + clamp(_dest-_value, -_amount, _amount));
}

function Chance(_value) {
	return _value>random(1);
}

function Wave(_from, _dest, _duration, _offset) {
	//Wave(from, to, duration, offset)

	// Returns a value that will wave back and forth between [from-to] over [duration] seconds
	// Examples
	//      image_angle = Wave(-45,45,1,0)  -> rock back and forth 90 degrees in a second
	//      x = Wave(-10,10,0.25,0)         -> move left and right quickly

	// Or here is a fun one! Make an object be all squishy!! ^u^
	//      image_xscale = Wave(0.5, 2.0, 1.0, 0.0)
	//      image_yscale = Wave(2.0, 0.5, 1.0, 0.0)

	var a4 = (_dest - _from) * 0.5;
	return _from + a4 + sin((((current_time * 0.001) + _duration * _offset) / _duration) * (pi*2)) * a4;
}

function ReachTween(_value, _destination, _smoothness) {
	return(lerp(_value, _destination, 1/_smoothness));
}

function DrawSetText(_color, _font, _haling, _valing, _alpha) {
	/// @desc DrawSetText(colour,font,halign,valign,alpha)
	draw_set_colour(_color);
	draw_set_font(_font);
	draw_set_halign(_haling);
	draw_set_valign(_valing);
	draw_set_alpha(_alpha);
}

function DrawTextShadow(_x, _y, _string) {
	var _colour = draw_get_colour();
	draw_set_colour(c_black);
	draw_text(_x+1, _y+1, _string);
	draw_set_colour(_colour);
	draw_text(_x, _y, _string);
}

function draw_text_outline(_x, _y, _string, _outwidth, _outcolor, _outfidelity) {
	///@desc draw_text_outline(x,y,str,outwidth,outcol,outfidelity)
	//Created by Andrew McCluskey http://nalgames.com/
	//x,y: Coordinates to draw
	//str: String to draw
	//outwidth: Width of outline in pixels
	//outcol: Colour of outline (main text draws with regular set colour)
	//outfidelity: Fidelity of outline (recommended: 4 for small, 8 for medium, 16 for larger. Watch your performance!)

	var dto_dcol=draw_get_color();

	draw_set_color(_outcolor);

	for(var dto_i=45; dto_i<405; dto_i+=360/_outfidelity) {
	    draw_text(_x+lengthdir_x(_outwidth,dto_i),_y+lengthdir_y(_outwidth,dto_i),_string);
	}

	draw_set_color(dto_dcol);
	draw_text(_x,_y,_string);
}

function DeltaTime() {
	return delta_time / 1000000 * 60;
}

///@desc DrawHealthbar(x,y,sprite,hp,maxhp)
function DrawHealthbar(x, y, sprite, hp, maxhp) {
	var _sprite_width = sprite_get_width(sprite);
	var _sprite_height = sprite_get_height(sprite);
	draw_sprite(sprite, 0, x, y);
	draw_sprite_part(sprite, 1, 0, 0, _sprite_width/maxhp*hp, _sprite_height, x, y);
}

