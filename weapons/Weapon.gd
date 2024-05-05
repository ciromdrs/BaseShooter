## A weapon.
class_name Weapon
extends Node3D

## In meters.
@export var range: float = 10
## Indicates if just shot.
var just_shot: bool = false


func _ready():
	$RayCast3D.scale = Vector3(1, self.range, 1)


func _physics_process(delta):
	self._shoot_process()

## Prepares to shoot.
func shoot():
	just_shot = true

## Processes a shoot command.
## Should be called in `_physics_process`.
func _shoot_process():
	if just_shot:
		just_shot = false
		if $RayCast3D.is_colliding():
			var collider = $RayCast3D.get_collider()
			if collider is Character:
				collider.take_damage()
