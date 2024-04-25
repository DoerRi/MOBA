extends Node3D
class_name Character

var type:String

var health:Stat
var speed:Stat=Stat.new(10)
var armor:Stat




var path:Array[Vector3]
signal changed_path(path:Array[Vector3])

var items:Array



func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if path.size()>0:
		moveing(delta)
	controll(delta)
	pass
func moveing(delta:float):
	if position.distance_to(path[0])>delta*speed.current:
		position+=(path[0]-position).normalized()*delta*speed.current
	else:
		position=path[0]
		path.pop_front()
	pass

var _ray_cast_result
func _physics_process(delta: float) -> void:
	var RAY_LENGTH = 10000
	var space_state = get_world_3d().direct_space_state
	var cam:Camera3D = $Camera3D
	var mousepos = get_viewport().get_mouse_position()

	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(Vector3(1,1,1), Vector3(-1,-1,-1))
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var _ray_cast_result = space_state.intersect_ray(query)
	#print(space_state.intersect_ray(query))
	#print(_ray_cast_result)


func controll(delta:float):
	if Input.is_action_just_released("Mouse_Left"):
		var cam:Camera3D = $Camera3D
		var mousepos = get_viewport().get_mouse_position()

		var origin = cam.project_ray_origin(mousepos)#-position
		var normal = cam.project_ray_normal(mousepos)

		var k:float=-origin.y/normal.y
		var pos:Vector3=Vector3(k*normal.x+origin.x,0,k*normal.z+origin.z)
		if Input.is_action_pressed("Shift"):
			add_path(pos)
		else:
			set_path(pos)



func set_path(pos:Vector3):#DONE
	reset_path()
	add_path(pos)
func add_path(pos:Vector3):#DONE
	path.push_back(pos)
	print(path)
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
