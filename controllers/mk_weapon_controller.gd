extends Control
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


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _process(_delta):
	_control_mouse_actions()
	queue_redraw()


func _draw():
	var camera_radius_meters = get_viewport().get_camera_3d().size / 2
	var mouse_pos = get_viewport().get_mouse_position()
	var center = get_viewport().size / 2
	# Distance from center, normalized in terms of screen's horizontal size
	var distance_px = center.distance_to(mouse_pos)
	var distance_norm = distance_px / center.y
	var distance_meters = distance_norm * camera_radius_meters
	var weapon_range = controlled.current_weapon.range_
	#var angle = Vector2(center).angle_to(mouse_pos)
	#print(angle)
	#print(sin(angle))
	#print(ray_source)
	#print()
	var alpha = 1 if distance_meters <= weapon_range else 0
	# Cursor
	draw_circle(mouse_pos, 3, Color(.5,.5,.5, .4), true, -1., true)
	draw_circle(mouse_pos, 2, Color.WHITE, true, -1., true)
	# Aim
	# TODO: grow radius based on the character's balance.
	var radius = 20
	draw_circle(mouse_pos, radius, Color(.5,.5,.5, .4), false, 3, true)
	draw_circle(mouse_pos, radius, Color(1, 1, 1, alpha), false, 2, true)



## Commands `controlled` to perform mouse actions.
func _control_mouse_actions():
	if Input.is_action_just_pressed("action2"):
		controlled.shove()
	elif Input.is_action_just_pressed("action1"):
		controlled.pull_trigger()
	elif Input.is_action_just_released("action1"):
		controlled.release_trigger()
