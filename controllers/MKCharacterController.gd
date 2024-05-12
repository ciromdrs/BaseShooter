extends Node
## A mouse+keyboard controller for [code]Character[/code]s.
##
## Add this as a child of a [code]Character[/code] node.


## The [code]Character[/code] controlled by this.
@onready var controlled: Character = get_parent()

## Indicates if the Character just shot a bullet.
## To be processed during _physics_process.
var just_shot: bool = false
## Target of the last shot.
var target: Vector3


func _process(_delta):
	_control_walk()
	_control_jump()
	_control_look_at_mouse()
	_control_mouse_actions()

## Gets the global mouse position in the 3D space.
func _get_mouse_pos3D() -> Vector3:
	var camera3d = get_viewport().get_camera_3d()
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 10  # Must be bigger than the camera's distance?
	var from = camera3d.project_ray_origin(mouse_pos)
	var to = from + camera3d.project_ray_normal(mouse_pos) * ray_length
	to.y = controlled.global_position.y
	return to

## Commands `controlled` to walk.
func _control_walk():
	var walk_direction := Vector3.ZERO
	walk_direction.z = Input.get_action_strength("move_down") - \
		Input.get_action_strength("move_up")
	walk_direction.x = Input.get_action_strength("move_right") - \
		Input.get_action_strength("move_left")
	walk_direction = walk_direction.normalized()
	self.controlled.walk(walk_direction)

## Commands `controlled` to look at the mouse.
func _control_look_at_mouse():
	var to = _get_mouse_pos3D()
	controlled.look(to)

## Commands `controlled` to perform mouse actions.
func _control_mouse_actions():
	if Input.is_action_just_pressed("action1"):
		controlled.shoot()

## Commands `controlled` to jump.
func _control_jump():
	if Input.is_action_just_pressed('jump'):
		controlled.jump()
