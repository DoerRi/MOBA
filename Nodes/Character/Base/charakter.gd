extends Node3D
class_name Character

var type:String

var health:Stat
var speed:Stat
var armor:Stat




var path:Array[Vector3]
signal changed_path(path:Array[Vector3])

var items:Array



func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
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
