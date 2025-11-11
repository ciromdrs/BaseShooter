## A Character, either playable or not.

class_name Character extends CharacterBody3D


@warning_ignore("unused_signal")
signal damage_taken


enum MovementType {WALK, RUN}


## In meters per second.
@export var walk_speed: float = .5

## In meters per second.
@export var run_speed: float = 3

## The current intended move speed. Assumes the value of walk_speed or 
## run_speed.
var _move_speed: float:
	get():
		var s = walk_speed
		if _movement_type == MovementType.RUN: s = run_speed
		return s

## The current movement type.
var _movement_type: float

## The direction the Character intents to walk towards, in meters per second.
## It is subject to physics processing.
var _move_direction := Vector3.ZERO

## Indicates that the Character just jumped.
var _just_jumped := false

## In meters per second.
@export var jump_speed: float = 10.5

## The character's weapons.
@export var weapons: Array[Node3D]

## The current (equiped) weapon's index.
var current_weapon_index: int = 0

## The current (equiped) weapon.
var current_weapon:
	get():
		if current_weapon_index < len(weapons):
			return weapons[current_weapon_index]

## The health system.
@onready var health_system = $HealthSystem

## The skin's animation player.
@onready var animation_player = get_node_or_null('Skin/AnimationPlayer')

@export var animation_library_name: String

@onready var skeleton = $Skin/Armature/Skeleton3D

## The freeze time, in seconds.
var freeze_time: float = 0.


func _ready():
	for i in range(len(weapons)):
		if weapons[i] != null:
			equip(i)
		equip(0)


func is_frozen():
	return freeze_time > 0


## Freezes the character for a given time (in seconds).
func freeze(duration: float):
	freeze_time = max(freeze_time, duration)


func _process(delta):
	freeze_time -= delta / 1000
	if not is_frozen():
		var anim = 'idle'
		var variation = ''
		var direction = ''
		if velocity != Vector3():
			anim = 'walk'
			if _movement_type == MovementType.RUN: anim = 'run'
			# TODO: Remove this check when zombies anims have directions too.
			if current_weapon != null:
				direction = _get_anim_direction()
		if current_weapon != null:
			variation = current_weapon.anim_pose
		play_animation(anim, variation, direction)


func _get_anim_direction() -> String:
	# Local velocity, based on rotation
	var local_vel = global_transform.basis.inverse() * _move_direction
	if local_vel == Vector3.ZERO: return ''
	var angle = atan2(local_vel.x, -local_vel.z)
	# Normalize angle to the interval [0, 2*PI)
	if angle < 0: angle += TAU  # TAU is 2 * PI in Godot
	# Each direction covers 45° = PI/4 radians
	var slice = PI / 4.
	# Determine which sector the angle falls in
	if angle < slice / 2. or angle >= TAU - slice / 2.:
		return "S"
	elif angle < slice * 1.5:
		return "SW"
	elif angle < slice * 2.5:
		return "W"
	elif angle < slice * 3.5:
		return "NW"
	elif angle < slice * 4.5:
		return "N"
	elif angle < slice * 5.5:
		return "NE"
	elif angle < slice * 6.5:
		return "E"
	else:
		return "SE"


func _physics_process(delta):
	if is_on_floor():
		if _just_jumped:
			# Handle jumps
			velocity.y = jump_speed
			_just_jumped = false # Must not forget to set this to false
		else:
			# Walk
			velocity = _move_direction * _move_speed
	else:
		_process_fall(delta)
	if not is_frozen():
		move_and_slide()


## Processes fall physics.
func _process_fall(delta):
	# Apply gravity
	var gravity = ProjectSettings.get_setting(
		"physics/3d/default_gravity")
	var gravity_vector = ProjectSettings.get_setting(
		"physics/3d/default_gravity_vector")
	# Increases jump/fall speed to look more realistic
	const JUMP_FALL_MOTION = 5
	velocity += gravity_vector * JUMP_FALL_MOTION * gravity * delta


## Move towards `direction`.
## 
func move(direction: Vector3, movement_type: MovementType):
	if is_on_floor():
		_move_direction = direction.normalized()
		_move_speed = walk_speed
		_movement_type = movement_type


## Look at `at`.
func look(at: Vector3):
	# Avoid error in `look_at` when positions are equal
	if at == global_position:
		return
	# Positions are different, can call `look_at`
	look_at(at)


## Move to destination facing it. Does not change x rotation.
func move_facing(destination: Vector3, movement_type: MovementType):
	# Face destination
	var old_x_rotation = rotation.x
	look(destination)
	rotation.x = old_x_rotation
	# And walk towards it
	move(destination - global_position, movement_type)


## Pulls the weapon's trigger.
func pull_trigger():
	self.current_weapon.pull_trigger()
	var lines: Array[String] = [
		'PEI!!',
		'TEI!!',
		'PÁÁ!!',
		'TÁÁ!!',
		'PEI!! Toma arrombado!',
		'PEI!! Rá po inferno!',
		'PÁ!! Pegue no quengo!',
	]
	say(lines.pick_random())


## Releases the weapon's trigger.
func release_trigger():
	self.current_weapon.release_trigger()


func say(line: String):
	var duration = clamp(len(line)/20.0, .5, 3)
	$Dialog.show_text(line, duration)


func stop():
	velocity = Vector3.ZERO
	_move_direction = Vector3.ZERO
	_move_speed = 0
	_just_jumped = false


func jump():
	_just_jumped = true


func throw():
	self.current_weapon.be_thrown()
	

func equip(weapon_index: int):
	# Unequip current weapon
	if current_weapon != null:
		current_weapon.unequip()
		# Remove from equiped bone (e.g. right hand)
		current_weapon.skin.get_parent().remove_child(current_weapon.skin)
		# Attatch to unequiped bone (e.g. right pocket)
		var bone = skeleton.get_node(current_weapon.bone_name_unequiped + '/Offset')
		bone.add_child(current_weapon.skin)
	# Equip next weapon
	if weapons[weapon_index] != null:
		current_weapon_index = weapon_index
		# Activate weapon controller
		current_weapon.controller.controlled = self
		# Attatch weapon to Skin
		var bone = skeleton.get_node(current_weapon.bone_name_equiped + '/Offset')
		current_weapon.skin.get_parent().remove_child(current_weapon.skin)
		bone.add_child(current_weapon.skin)
		# Set up aim
		#current_weapon.aim.position = $AimPlaceholder.position
		current_weapon.get_node('RayCasts').position = $AimPlaceholder.position
		current_weapon.equip()


func shove():
	play_animation('shove')


func play_animation(action: String, variation = '', direction = ''):
	if animation_player != null:
		var anim = animation_library_name + '/' + action
		if direction != '':
			anim += '_' + direction
		if variation != '':
			anim += '_' + variation
		animation_player.current_animation = anim
		animation_player.play()


func _on_body_hurt_box_hit(damage: int, _collider: Node3D, _collision: CollisionObject3D) -> void:
	damage_taken.emit(damage)
