class_name PlayerControll
extends Node3D

var character:Character

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character=get_parent()
	(character.get_node("Camera3D") as Camera3D).current=true
	(character.get_node("hitbox") as Area3D).input_ray_pickable=false
	(character.get_node("hitbox") as Area3D).collision_layer=(character.get_node("hitbox") as Area3D).collision_layer & 0xFFFE
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	controll(delta)
	pass


func controll(delta:float):
	var cam:Camera3D = get_viewport().get_camera_3d()
	if Input.is_action_just_released("Mouse_Left"):
		var mousepos = get_viewport().get_mouse_position()

		var origin = cam.project_ray_origin(mousepos)#-position
		var normal = cam.project_ray_normal(mousepos)

		var k:float=-origin.y/normal.y
		var pos:Vector3=Vector3(k*normal.x+origin.x,0,k*normal.z+origin.z)
		if raycastonlayers(0x0003).get("collider").name == "Ground":
			if Input.is_action_pressed("Shift"):
				character.add_path(pos)
			else:
				character.set_path(pos)

	raycastonlayers(0xFFFE)

func raycastonlayers(layers:int):
	var cam:Camera3D = get_viewport().get_camera_3d()
	var RAY_LENGTH = 10000
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()

	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.collision_mask=layers

	var _ray_cast_result = space_state.intersect_ray(query)
	return _ray_cast_result
	pass
