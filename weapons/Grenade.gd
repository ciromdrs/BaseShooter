class_name Throwable extends RigidBody3D

## The maximum damage inflicted by the grenade. The closer the body is to the
## grenade, more damage it takes.
@export var damage := 250

## The force applied when throwing the grenade.
## Note: Created for prototyping, might become a constant later.
var force = Vector3(8,5,8)

## The throw range.
@export_range(.1, 1, .1) var range_: float = .7

@export var amount: int = 1

@onready var controller = $MKThrowableController

var bone_name_equiped: String = 'HandL'

var bone_name_unequiped: String = 'PocketL'

## Inflicts the damage of the explosion.
func boom():
	$AnimationPlayer.current_animation = 'boom'
	$AnimationPlayer.play()
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	for body in $DamageArea.get_overlapping_bodies():
		var radius = $DamageArea/CollisionShape3D.shape.radius
		var distance = global_position.distance_to(body.global_position)
		# Sometimes the distance is bigger than the damage radius. Taking the 
		# minimum fixes this problem. TODO: Investigate why that happens.
		distance = min(distance, radius)
		# The final damage depends on the distance
		var inflicted_damage = (1 - (distance / radius)**2) * damage
		body.take_damage(inflicted_damage)

## Performs the throw.
func be_thrown():
	# TODO: Check and update the amount
	# Get mouse influence
	var center = Vector2(get_viewport().size) / 2
	var mouse_pos = get_viewport().get_mouse_position()
	var max_dist = get_viewport().size.y / 2
	var mouse_influence = min(center.distance_to(mouse_pos), max_dist) / max_dist
	# The grenade must be thrown towards the character's forward direction
	var forward: Vector3 = get_parent().transform.basis.z
	# Assign to ancestor to become independant
	var old_pos = global_position
	var ancestor = get_tree().current_scene
	get_parent().remove_child(self)
	ancestor.add_child(self)
	global_position = old_pos
	# Unfreeze to be affected by physics again
	freeze = false
	# Set the grenade's velocity
	# TODO: This formula is the best I got until now. Find a better one later.
	linear_velocity = (forward + Vector3.UP) * force * sqrt(mouse_influence)
	# Start the countdown to explode
	$Timer.start()

## Equips the throwable and activates controller.
func equip():
	controller.process_mode = Node.PROCESS_MODE_INHERIT

## Unequips the throwable and deactivates controller.
func unequip():
	controller.process_mode = Node.PROCESS_MODE_DISABLED
