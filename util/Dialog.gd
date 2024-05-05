extends Label3D

## The position offset relative to the parent.
var _position_offset := Vector3.ZERO

func _ready():
	_position_offset = position
	set_as_top_level(true)

func _process(_delta):
	position = get_parent().global_position + _position_offset

## Shows `text` during `duration` (in seconds).
func show_text(text: String, duration: float = 2):
	self.text = text
	$Timer.wait_time = duration
	$Timer.start()

## Shows `text` without a timer.
func show_text_forever(text: String):
	$Timer.stop()
	self.text = text

func _on_timer_timeout():
	self.text = ''
