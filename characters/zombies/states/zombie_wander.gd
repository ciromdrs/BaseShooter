class_name ZombieWanderState extends ZombieState

## The direction the zombie is walking towards.
var wander_direction: Vector3

## How long it takes for the zombie to change direction.
var wander_time: float


func enter(_args: Dictionary = {}):
	randomize_wander()


func update(delta):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()
	zombie.move_facing(zombie.global_position + wander_direction, Character.MovementType.WALK)


func randomize_wander():
	wander_direction = Vector3(randf_range(-1,1), 0, randf_range(-1,1)).normalized()
	wander_time = randf_range(2, 5)


## Triggered when a chasable node (usually the player) enters the detection area.
func _on_detection_area_body_entered(body: Node3D) -> void:
	Transitioned.emit(self, 'ZombieChaseState', {'chased': body})
