@tool
## A Character, either playable or not.

class_name Character

extends CharacterBody3D


## In meters per second.
@export var walk_speed: float = 3


func _physics_process(_delta):
	if velocity.length() > 0:
		move_and_slide()


func walk(direction):
	velocity = direction.normalized() * self.walk_speed


func look(at):
	look_at(at)
