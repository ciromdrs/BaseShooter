extends Node3D


@onready var camera = get_viewport().get_camera_3d()

## The Character holding the Weapon that this Aim belongs to.
@onready var grandparent = get_parent().get_parent()


func _process(_delta):
	if not camera.current:
		camera = get_viewport().get_camera_3d()


## Sets the aim aperture given the accuracy.
func set_aperture(accuracy):
	var angle = (1 - accuracy)**2
	$Left.rotation = Vector3(0, angle/2, 0)
	$Right.rotation = Vector3(0, -angle/2, 0)


## Scales the aim given the range, limited to a maximum.
func set_range(range_):
	const MAX_AIM_LENGTH = 13
	var length = min(range_, MAX_AIM_LENGTH)
	$Left/Mesh.scale.z = length
	$Right/Mesh.scale.z = length
