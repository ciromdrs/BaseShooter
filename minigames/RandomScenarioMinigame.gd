extends Node3D


func _on_timer_timeout():
	$SpawnArea.spawn()


func _process(_delta):
	if Input.is_key_pressed(KEY_R):
		var grenade = preload('res://weapons/Grenade.tscn').instantiate()
		grenade.name = 'Grenade'
		grenade.position = Vector3(0.427, 0.908, 0.363)
		$Player.add_child(grenade)
