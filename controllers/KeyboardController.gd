extends Node


# imports
const util = preload("res://scripts/Util.gd")


var controlled
var state_machine: StateMachine
var idle_state: IdleState
var move_state: MoveState
var attack_state: AttackState
var be_attacked_state: BeAttackedState
var input_vector := Vector3()
export var camera_node: NodePath
var camera: Camera
var move_actions = ["move_up", "move_down", "move_left", "move_right"]
export var custom_mouse_image: Texture
onready var target := $Target
var _mouse_raycast_mask := util.collision_mask(["aimable"])

func _ready():
	camera = get_node(camera_node)
	controlled = get_parent()
	state_machine = util.assert_get_node(controlled, "StateMachine")
	idle_state = util.assert_get_node(state_machine, "IdleState")
	move_state = util.assert_get_node(state_machine, "MoveState")
	move_state.move_speed = controlled.move_speed
	attack_state = util.assert_get_node(state_machine, "AttackState")
	be_attacked_state = util.assert_get_node(state_machine, "BeAttackedState")
	if custom_mouse_image:
		Input.set_custom_mouse_cursor(
			custom_mouse_image,
			Input.CURSOR_ARROW,
			custom_mouse_image.get_size()/2)


func _process(_delta):
	var params := {}
	var space_state = controlled.get_world().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_position) * 2000
	var intersection = space_state.intersect_ray(ray_origin, ray_end, [], _mouse_raycast_mask)
	if not intersection.empty():
		target.global_transform.origin = intersection.position
	
	
	if Input.is_action_just_pressed("click"):
		state_machine.transition_to(attack_state)
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.z = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector.length() > 0:
		if state_machine.state != move_state:
			move_state.movement = input_vector
			move_state.target = target
			state_machine.transition_to(move_state)
	elif _just_released_any_move_action():
		idle_state.target = target
		state_machine.transition_to(idle_state)
	
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen



func _just_released_any_move_action() -> bool:
	for action in move_actions:
		if Input.is_action_just_released(action):
			return true
	return false

