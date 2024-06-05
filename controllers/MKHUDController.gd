extends Node


@onready var controlled: HUD3D = get_parent()

func _process(delta):
	control_hud()

## Commands `controlled` to show the HUD.
func control_hud():
	if Input.is_action_just_pressed('status'):
		controlled.show_hud()
	elif Input.is_action_just_released('status'):
		controlled.hide_hud()
