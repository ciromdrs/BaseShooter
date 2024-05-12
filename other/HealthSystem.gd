class_name HealthSystem extends Node


## The maximum health.
@export var max_health: int = 100

## The current health.
var current_health: int = max_health

## Decreases `damage` from `current_health`.
func take_damage(damage: int):
	assert(damage >= 0, "Damage must be >= 0.")
	current_health = max(current_health - damage, 0)

## Returns true if health reached 0 and false otherwise.
func is_dead() -> bool:
	return current_health <= 0
