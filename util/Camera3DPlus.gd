extends Camera3D


## The node followed by this camera.
@export var followed: Node3D

func _process(delta):
	self.global_position.x = followed.global_position.x
	self.global_position.z = followed.global_position.z
