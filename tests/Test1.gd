extends Spatial


var enemy_scene = preload("res://scenes/Enemy.tscn")


func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func spawn_enemy() -> void:
	var pos = Vector3(randi() % 100 - 50, 0, randi() % 100 - 50)
	var new = enemy_scene.instance()
	new.transform.origin = pos
	new.navigation = $Navigation
	new.chased = $Player
	new.speed = 5
	add_child(new)


func _on_EnemySpawnTimer_timeout():
	spawn_enemy()
