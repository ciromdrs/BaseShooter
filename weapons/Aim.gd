extends Node3D


@onready var camera = get_viewport().get_camera_3d()

## The Character holding the Weapon that this Aim belongs to.
@onready var grandparent = get_parent().get_parent()


func _process(delta):
	if not camera.current:
		camera = get_viewport().get_camera_3d()
	$Left.position = camera.unproject_position(global_position)
	$Right.position = camera.unproject_position(global_position)
	$Left.rotation = -grandparent.rotation.y
	$Right.rotation = -grandparent.rotation.y


## Sets the aim aperture given the accuracy.
func set_aperture(accuracy):
	var angle = (1 - accuracy)**2
	$Left/Sprite.rotation = -angle/2
	$Right/Sprite.rotation = angle/2


## Scales the aim given the range, limited to a maximum.
func set_range(range_):
	const MAX_AIM_LENGTH = 13
	var sprite_scale = Vector2(1, min(range_, MAX_AIM_LENGTH))
	#print(sprite_scale)
	$Left/Sprite.scale = sprite_scale
	$Right/Sprite.scale = sprite_scale
