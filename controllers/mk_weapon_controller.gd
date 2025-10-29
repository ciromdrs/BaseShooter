extends Node
## A mouse+keyboard controller for [code]Character[/code]s equiped with a 
## [code]Weapon[/code].
##
## Add this as a child of a [code]Weapon[/code] node.


## The character controlled by this.
@onready var controlled: Character = null

## Indicates if the Character just shot a bullet.
## To be processed during _physics_process.
var just_shot: bool = false

## Target of the last shot.
var target: Vector3


func _process(_delta):
	_control_mouse_actions()

## Gets the global mouse position in the 3D space.
func _get_mouse_pos3D() -> Vector3:
	var mouse_pos = get_viewport().get_mouse_position()
	var center = get_viewport().get_visible_rect().size / 2
	var angle = mouse_pos.angle_to_point(center)
	
	var pos = Vector3()
	pos.y = controlled.global_position.y - .1
	controlled.rotation.y = -angle - PI*.5
	return pos

## Commands `controlled` to perform mouse actions.
func _control_mouse_actions():
	if Input.is_action_just_pressed("action1"):
		controlled.pull_trigger()
	elif Input.is_action_just_released("action1"):
		controlled.release_trigger()
