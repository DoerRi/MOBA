extends Node3D
class_name Character

var type:String

var health:Stat
var speed:Stat=Stat.new(10)
var armor:Stat




var path:Array[Vector3]
signal changed_path(path:Array[Vector3])


signal gained_item(item:Item)
signal removed_item(item:Item)
const MAX_ITEMCOUNT:int=6
const ABILITYCOUNT:int=4
var items:Array[Item]#max size= 10 4 abilitys and 6 normal items
#NOTE: Abbilitys are represented as items

signal new_effect_started
signal effect_ended
var current_effects:Array[Effect]



func _ready() -> void:


	pass # Replace with function body.

signal updated(float)
func _process(delta: float) -> void:
	emit_signal("updated",delta)
	if path.size()>0:
		moveing(delta)
	pass
func moveing(delta:float):
	if position.distance_to(path[0])>delta*speed.current:
		position+=(path[0]-position).normalized()*delta*speed.current
	else:
		position=path[0]
		path.pop_front()







func set_path(pos:Vector3):#DONE
	reset_path()
	add_path(pos)
func add_path(pos:Vector3):#DONE
	path.push_back(pos)
	emit_signal("changed_path",path)
func reset_path():#DONE
	path.clear()
	emit_signal("changed_path",path)

func new_effect():
	emit_signal("new_effect_started")
func effect_end():
	emit_signal("effect_ended")


func add_item(item:Item):
	#TODO: add stat changes
	if items.size()>=MAX_ITEMCOUNT+MAX_ITEMCOUNT:
		return
	items.push_back(item)
	emit_signal("gained_item",item)
func remove_item(itemtype:ItemTypen):
	#TODO:  remove stat changes
	for x in items.size():
		if items[x].type==itemtype:
			items.remove_at(x)
			return
	pass


class Stat:
	var start:float
	var normal:float
	var current:float
	func _init(start:float)->void:
		self.start=start
		self.normal=start
		self.current=start


enum EffectTypen{
	Slowed,
	Healing
}
class Effect:
	var on:Character
	var type:EffectTypen
	var timer:float
	var value:float
	signal effect_started
	signal effect_ended
	func _init(on:Character,type:EffectTypen,timer:float,value:float) -> void:
		if on == null||timer<0:
			return
		self.on=on
		self.type=type
		self.timer=timer
		self.value=value
		on.connect("updated",Callable(self,"update"))
		on.current_effects.append(self)
		emit_signal("effect_started")
		on.new_effect()
		update(0)
	func update(delta:float):
		timer-=delta
		if timer<=0:
			emit_signal("effect_ended")
			on.current_effects.erase(self)
			on.effect_end()
			on=null
		#TODO: active-effects effects

enum ItemTypen{
	item1,
	item2
}

class Item:
	var type:ItemTypen
	var extra_health:Stat
	var extra_speed:Stat
	var extra_armor:Stat
	var cooldown:Stat=Stat.new(0)
	var effect:EffectPlan

	func _init(on:Character, type:ItemTypen) -> void:
		if on==null:
			return
		self.type=type
		#TODO: load values (stats & effects & cooldown & usw.)
		on.connect("updated",Callable(self,"update"))
		on.add_item(self)
	func update(delta:float):
		cooldown.current-=delta
		pass

## This class holds the data for generating a effect
class EffectPlan:
	pass


