class_name HUD3D extends Control


@onready var camera = get_viewport().get_camera_3d()

@onready var parent = get_parent()


func _ready() -> void:
	if not parent is Node3D:
		push_error("The HUD's parent node must inherit from Node3D.")


func _process(_delta):
	# Get the current camera
	if not camera.current:
		camera = get_viewport().get_camera_3d()
	# Position this node on the screen according to the parent's position in 3D
	var parent_translation = parent.global_transform.origin
	var unprojected_position = camera.unproject_position(parent_translation)
	position = unprojected_position


## Show the HUD.
func show_hud():
	$AnimationPlayer.current_animation = 'show'
	$AnimationPlayer.play()


## Hide the HUD.
func hide_hud():
	$AnimationPlayer.current_animation = 'show'
	$AnimationPlayer.play_backwards()
