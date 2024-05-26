extends Label3D


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
