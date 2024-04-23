extends Control
## A mouse+keyboard [code]Controller[/code] for [code]Character[/code]s.
##
## Add this as a child of a [code]Character[/code] node.

## The [code]Character[/code] controlled by this.
var character: Character


func _ready():
	self.character = get_parent()
	
func _process(_delta):
	# Walk
	var walk_direction := Vector3.ZERO
	walk_direction.z = Input.get_action_strength("move_down") - \
		Input.get_action_strength("move_up")
	walk_direction.x = Input.get_action_strength("move_right") - \
		Input.get_action_strength("move_left")
	walk_direction = walk_direction.normalized()
	self.character.walk(walk_direction)
	
	# Look at mouse
	var camera3d = get_viewport().get_camera_3d()
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 10  # Must be bigger than the camera's distance?
	var from = camera3d.project_ray_origin(mouse_pos)
	var to = from + camera3d.project_ray_normal(mouse_pos) * ray_length
	to.y = character.global_position.y
	character.look(to)
