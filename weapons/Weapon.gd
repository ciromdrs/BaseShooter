## A weapon.
class_name Weapon
extends Node3D

## In meters.
@export var range: float = 13

## Damage.
@export var damage: int = 30

## Indicates if just shot.
var just_shot: bool = false


func _ready():
	for r in $RayCasts.get_children():
		r.scale = Vector3(1, self.range, 1)


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
		for r in $RayCasts.get_children():
			if r.is_colliding():
				var collider = r.get_collider()
				if collider is Character:
					collider.take_damage(damage)
