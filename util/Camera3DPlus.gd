extends Camera3D


## The node followed by this camera.
@export var followed: Node3D

## The offset distance from `followed`.
var offset := Vector3.ZERO

func _ready():
	if followed != null:
		offset = self.global_position - followed.global_position

func _process(_delta):
	if followed != null:
		self.global_position = followed.global_position + offset
