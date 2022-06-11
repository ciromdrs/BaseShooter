extends Spatial


var enemy_scene = preload("res://scenes/Enemy.tscn")
var zombie_model = preload("res://assets/zombie.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	target_to_mouse()
	$Player.lerp_look_at($Target.translation)
	$Player.rotation_speed = 20*PI


func _process(delta):
	# project ray from screen
	target_to_mouse()
	$Player.lerp_look_at($Target.translation)
	
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func spawn_enemy():
	var pos = Vector3(randi() % 100 - 50, 0, randi() % 100 - 50)
	var new = enemy_scene.instance()
	new.transform.origin = pos
	var model = zombie_model.instance()
	model.scale = Vector3(3,3,3)
	#new.set_model(model)
	new.navigation = $Navigation
	new.chased = $Player
	new.speed = 5
	add_child(new)


func target_to_mouse():
	var camera = $Camera/InnerGimbal/Camera
	var space_state = get_world().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_position) * 2000
	var intersection = space_state.intersect_ray(ray_origin, ray_end, [$Player])
	if not intersection.empty():
		var pos = intersection.position
		pos.y = $Player.global_transform.origin.y # using Player's y avoids rotation bugs
		$Target.translation = pos
	$TextureRect/Dot.position = mouse_position


func _on_EnemySpawnTimer_timeout():
	spawn_enemy()
