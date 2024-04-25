extends Node3D
class_name Character

var type:String

var health:Stat
var speed:Stat=Stat.new(10)
var armor:Stat




var path:Array[Vector3]
signal changed_path(path:Array[Vector3])

var items:Array

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
	pass







func set_path(pos:Vector3):#DONE
	reset_path()
	add_path(pos)
func add_path(pos:Vector3):#DONE
	path.push_back(pos)
	emit_signal("changed_path",path)
func reset_path():#DONE
	path.clear()
	emit_signal("changed_path",path)






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
		update(0)
	func update(delta:float):
		timer-=delta
		if timer<=0:
			emit_signal("effect_ended")
			on.current_effects.erase(self)
		#TODO: active-effects effects

