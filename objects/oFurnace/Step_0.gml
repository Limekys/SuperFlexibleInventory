/// @desc Furnace system

//Get info about items
var _material_item = InvGetSlotExt(furnace,material_slot,items_flags.item);
var _fuel_item = InvGetSlotExt(furnace,fuel_slot,items_flags.item);
var _result_item = InvGetSlotExt(furnace,result_slot,items_flags.item);
var _result_count = InvGetSlotExt(furnace,result_slot,items_flags.count);
var _fuel = InvGetSlotExt(furnace,fuel_bar_slot,items_flags.hp);

//Furnace system
if _material_item && _fuel_item && !_fuel && recipe[_material_item] //если есть сырье, если есть предмет топлива и топлива 0 и с этого сырья можно что-то приготовить
&& GetProp(_fuel_item, ALL_PROPS.fuel) && (recipe[_material_item] == _result_item || !_result_item) //если предмет в ячейке топлива имеет свойство топлива и в ячейке результата такойже предмет который можем приготовить, либо просто пусто
&& _result_count < GetProp(_result_item, ALL_PROPS.maxstack) //если стак результата не максимальный
{
	//charge the furnace with fuel and take one item fuel from the slot
	fuel = GetProp(_fuel_item, ALL_PROPS.fuel);
	fuelMAX = fuel;
	
	InvItemSub(furnace,fuel_slot);
	InvRedraw(furnace);
}

//reduce fuel
fuel = Approach(fuel, 0, 0.05);

//main system
//if there is fuel, there is raw material and with this raw material you can cook into the result that is already in the result cell
//either in the result cell is empty and something can be prepared from this raw material
if fuel > 0 && _material_item
&& (recipe[_material_item] == _result_item || !_result_item) && recipe[_material_item]
&& _result_count < GetProp(_result_item, ALL_PROPS.maxstack) //if the stack of the result is not the maximum
readyResult = Approach(readyResult,100,0.1);
else
readyResult = Approach(readyResult,0,0.1); //otherwise cool

//if result is 100%
if readyResult == 100
{
	//getting result
	InvItemAdd(furnace,result_slot,recipe[_material_item]);
	
	readyResult = 0; //zero the result
	
	InvItemSub(furnace,material_slot);
	InvRedraw(furnace);
}

//Update inv bars
InvSetSlotExt(furnace,fuel_bar_slot,items_flags.hp,(fuel/fuelMAX)*100);
InvSetSlotExt(furnace,result_bar_slot,items_flags.hp,readyResult);

//Change sprite when furnace is active
image_index = sign(fuel);

//Caption animation
if collision_point(mouse_x, mouse_y, self, false, false) {
	anim = ReachTween(anim,1,7);
} else {
	anim = ReachTween(anim,0,7);
}