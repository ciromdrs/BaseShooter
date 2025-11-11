extends Node
## A mouse+keyboard controller for [code]Character[/code]s.
##
## Add this as a child of a [code]Character[/code] node.


## The [code]Character[/code] controlled by this.
@export var controlled: Character

## Indicates if the Character just shot a bullet.
## To be processed during _physics_process.
var just_shot: bool = false

## Target of the last shot.
var target: Vector3


func _process(_delta):
	_control_move()
	_control_jump()
	_control_look_at_mouse()
	_control_equip()


## Commands `controlled` to move.
func _control_move():
	var move_direction := Vector3.ZERO
	move_direction.z = Input.get_action_strength("move_down") - \
		Input.get_action_strength("move_up")
	move_direction.x = Input.get_action_strength("move_right") - \
		Input.get_action_strength("move_left")
	# Camera-relative movement
	var camera = get_viewport().get_camera_3d()
	move_direction = move_direction.rotated(Vector3.UP, camera.rotation.y)
	move_direction = move_direction.normalized()
	self.controlled.move(move_direction, Character.MovementType.RUN)

## Commands `controlled` to look at the mouse.
func _control_look_at_mouse():
	var center = get_viewport().get_visible_rect().size / 2
	var mouse_pos = get_viewport().get_mouse_position()
	var angle = mouse_pos.angle_to_point(center)
	# Correct aim for non-top-down angles.
	# .15 is specific for the camera angle of 60 degrees
	var correction = .16 * sin(angle) * cos(angle) * -sign(mouse_pos.y)
	controlled.rotation.y = -angle - PI/2 + correction

## Commands `controlled` to jump.
func _control_jump():
	if Input.is_action_just_pressed('jump'):
		controlled.jump()

func _control_equip():
	var just_equiped = -1
	if Input.is_action_just_pressed('equip1'):
		just_equiped = 0
	if Input.is_action_just_pressed('equip2'):
		just_equiped = 1
	if Input.is_action_just_pressed('equip3'):
		just_equiped = 2
	if Input.is_action_just_pressed('equip4'):
		just_equiped = 3
	if just_equiped < 0:
		return
	controlled.equip(just_equiped)
