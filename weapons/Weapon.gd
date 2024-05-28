## A weapon.
class_name Weapon
extends Node3D


const MAX_APERTURE = PI

## In meters.
@export var range_: float = 13

## Damage.
@export var damage: int = 30

## Accuracy.
@export_range(.01, 1) var accuracy: float = .7

## Indicates if just shot.
var just_shot: bool = false


func _ready():
	_update_aim()
	for r in $RayCasts.get_children():
		r.scale = Vector3(1, self.range_, 1)


func _physics_process(_delta):
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

func _update_aim():
	var angle = (1 - accuracy)**2 * MAX_APERTURE / 2
	$LeftBound.rotate(Vector3.UP, -angle)
	$RightBound.rotate(Vector3.UP, angle)
