extends Label3D

## The position offset relative to the parent.
var _position_offset := Vector3.ZERO

func _ready():
	_position_offset = position
	set_as_top_level(true)

func _process(_delta):
	position = get_parent().global_position + _position_offset

## Shows `text_` during `duration` (in seconds).
func show_text(text_: String, duration: float = 2):
	self.text = text_
	$Timer.wait_time = duration
	$Timer.start()

## Shows `text_` without a timer.
func show_text_forever(text_: String):
	$Timer.stop()
	self.text = text_

func _on_timer_timeout():
	self.text = ''
