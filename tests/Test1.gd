extends Spatial


var enemy_scene = preload("res://scenes/Enemy.tscn")
var enemy_controller_scene = preload("res://controllers/AIController.tscn")
var state_machine_scene  = preload("res://scripts/StateMachine.tscn")
var enemy_count := 0


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func spawn_enemy() -> void:
	var pos = Vector3(randi() % 100 - 50, 0, randi() % 100 - 50)
	var new = $Enemy.duplicate() # enemy_scene.instance()
	new.visible = true
	new.transform.origin = pos
	new.speed = 5
	add_child(new)
	enemy_count += 1
	$Label.text = str(enemy_count)


func _on_EnemySpawnTimer_timeout():
	spawn_enemy()
