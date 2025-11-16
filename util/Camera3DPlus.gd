extends Camera3D


## The node followed by this camera.
@export var followed: Node3D

## The offset distance from `followed`.
var offset := Vector3.ZERO

@onready var _desired_size = size

var _zoom_time: float

func _ready():
	if followed != null:
		offset = self.global_position - followed.global_position


func _process(delta):
	if followed != null:
		self.global_position = followed.global_position + offset
	const ZOOM_ADJUST_TIME = 1
	_zoom_time -= delta
	if Input.is_action_just_pressed('zoom_in'):
		_desired_size -= 1
		_zoom_time = ZOOM_ADJUST_TIME
	elif Input.is_action_just_pressed('zoom_out'):
		_desired_size += 1
		_zoom_time = ZOOM_ADJUST_TIME
	_desired_size = clampf(_desired_size, 5, 20)
	size = lerpf(size, _desired_size, 1-_zoom_time)
