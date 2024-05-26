extends Node3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$FPS.text = 'FPS: ' + str(Engine.get_frames_per_second()) + \
				'\nZombies: ' + str($SpawnArea.count)


func _on_timer_timeout():
	$SpawnArea.spawn()
