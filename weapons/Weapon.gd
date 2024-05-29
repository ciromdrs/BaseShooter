## A weapon.
class_name Weapon extends Node3D


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

func _physics_process(delta):
	self._rotate_raycasts(delta)
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

## Rotates the RayCast3D nodes to simulate accuracy.
func _rotate_raycasts(delta):
	# Number of rays
	var nrays = len($RayCasts.get_children())
	# Aperture of each ray
	var ray_aperture = ($Aim/Right.rotation.y - $Aim/Left.rotation.y) / nrays
	for i in nrays:
		var ray = $RayCasts.get_child(i)
		var target = $Aim/Left.rotation.y + \
			i * ray_aperture + \
			ray_aperture * (1 - randf())
		var current = ray.rotation.z
		var radians = current - target
		# Apply rotation
		ray.rotate(Vector3.FORWARD, radians)

## Update the aim's aperture.
func _update_aim():
	var angle = (1 - accuracy)**2
	$Aim/Left.rotate(Vector3.UP, angle)
	$Aim/Right.rotate(Vector3.UP, -angle)
