extends Node


# imports
const util = preload("res://scripts/Util.gd")


@onready var controlled: Character = get_parent()
@onready var state_machine: StateMachine = util.assert_get_node(controlled, "StateMachine")
@onready var idle_state: IdleState = util.assert_get_node(state_machine, "IdleState")
@onready var move_state: MoveState = util.assert_get_node(state_machine, "MoveState")
@onready var attack_state: AttackState = util.assert_get_node(state_machine, "AttackState")
@onready var be_attacked_state: BeAttackedState = util.assert_get_node(state_machine, "BeAttackedState")
var input_vector := Vector3()
@export var camera_node: NodePath
var camera: Node3D # Declare it a Node3D to make it possible to use a PlayerCamera
var move_actions = ["move_up", "move_down", "move_left", "move_right"]
@export var custom_mouse_image: Texture2D
@onready var target := $Target
var _mouse_raycast_mask := util.collision_mask(["characters","scenario"])


func _ready():
	camera = get_node(camera_node)
	move_state.move_speed = controlled.move_speed
	if custom_mouse_image:
		Input.set_custom_mouse_cursor(
			custom_mouse_image,
			Input.CURSOR_ARROW,
			custom_mouse_image.get_size()/2)


func _process(_delta):
	var space_state = controlled.get_world_3d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_position) * 2000
	var query = PhysicsRayQueryParameters3D.create(mouse_position, mouse_position + Vector3(0, -10, 0))
	var intersection = space_state.intersect_ray(query) #ray_origin, ray_end, [], _mouse_raycast_mask)
	if not intersection.is_empty():
		target.global_transform.origin = intersection.position
	
	if Input.is_action_just_pressed("click"):
		state_machine.transition_to(attack_state)
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.z = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
			
	if input_vector.length() > 0:
		move_state.movement = input_vector
		move_state.target = target
		if state_machine.state != move_state:
			state_machine.transition_to(move_state)
	elif _just_released_any_move_action():
		idle_state.target = target
		state_machine.transition_to(idle_state)
	
	if Input.is_action_just_pressed("toggle_fullscreen"):
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (not ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED
	
	if OS.is_debug_build() and Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()



func _just_released_any_move_action() -> bool:
	for action in move_actions:
		if Input.is_action_just_released(action):
			return true
	return false

