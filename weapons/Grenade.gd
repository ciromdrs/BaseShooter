extends RigidBody3D


## The maximum damage inflicted by the grenade. The closer the body is to the
## grenade, more damage it takes.
@export var damage := 250

## The initial parent of the grenade, used to respawn grenades. Usually a
## character.
@onready var initial_parent = get_parent()

## The initial transform of the grenade. Used to respawn grenades in their
## original position, rotation and scale relative to the parent.
@onready var initial_transform = transform

## The force applied when throwing the grenade.
## Note: Created for prototyping, might become a constant later.
var force = Vector3(8,5,8)

## The throw range.
@export_range(.1, 1, .1) var range_: float = .7


func _process(_delta):
	# TODO: Move to MKCharacterController
	if Input.is_action_just_released('action2'):
		$AnimationPlayer.current_animation = 'throw'
		$AnimationPlayer.speed_scale = 1
		$AnimationPlayer.play()


## Inflicts the damage of the explosion.
func boom():
	for body in $DamageArea.get_overlapping_bodies():
		var radius = $DamageArea/CollisionShape3D.shape.radius
		var distance = self.global_position.distance_to(body.global_position)
		# Sometimes the distance is bigger than the damage radius. Taking the 
		# minimum fixes this problem. TODO: Investigate why that happens.
		distance = min(distance, radius)
		# The final damage depends on the distance
		var inflicted_damage = (1 - (distance / radius)**2) * damage
		body.take_damage(inflicted_damage)


## Performs the throw.
func apply_throw():
	# Unfreeze to be affected by physics again
	self.freeze = false
	# Reparent to become independant
	var old_pos = global_position
	var grandparent = get_parent().get_parent()
	get_parent().remove_child(self)
	grandparent.add_child(self)
	global_position = old_pos
	# Get mouse influence
	var center = Vector2(get_viewport().size) / 2
	var mouse_pos = get_viewport().get_mouse_position()
	var max_dist = get_viewport().size.y / 2
	var mouse_influence = min(center.distance_to(mouse_pos), max_dist) / max_dist
	# The grenade must be thrown towards the parent's forward direction
	var forward: Vector3 = -initial_parent.transform.basis.z
	# Set the grenade's velocity
	# TODO: This formula is the best I got until now. Find a better one later.
	linear_velocity = (forward + Vector3.UP) * force * sqrt(mouse_influence)
