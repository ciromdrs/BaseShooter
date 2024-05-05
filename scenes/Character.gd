@tool
## A Character, either playable or not.

class_name Character

extends CharacterBody3D


## In meters per second.
@export var walk_speed: float = 3

@export var weapon: Weapon

func _physics_process(_delta):
	if velocity.length() > 0:
		move_and_slide()

## Walk towards `direction`.
func walk(direction: Vector3):
	velocity = direction.normalized() * self.walk_speed

## Look at `at`.
func look(at: Vector3):
	look_at(at)

## Walk to destination facing it.
func walk_facing(destination: Vector3):
	# Face destination
	look(destination)
	# And walk towards it
	walk(destination - global_position)

## Commands the weapon to shoot.
func shoot():
	self.weapon.shoot()

func take_damage():
	die()

func die():
	queue_free()
