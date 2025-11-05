## A Character, either playable or not.

class_name Character extends CharacterBody3D


## In meters per second.
@export var walk_speed: float = 3

## The direction the Character intents to walk towards, in meters per second.
## It is subject to physics processing.
var _walk_direction := Vector3.ZERO

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

## The freeze timer.
@onready var freeze_timer = $FreezeTimer


func _ready():
	for i in range(len(weapons)):
		if weapons[i] != null:
			equip(i)
		equip(0)


func is_frozen():
	return freeze_timer.time_left > 0


## Freezes the character for a given time (in seconds).
func freeze(freeze_time: float):
	freeze_timer.wait_time = max(freeze_timer.time_left, freeze_time)
	freeze_timer.start()

func _process(_delta):
	if not is_frozen():
		var anim = 'idle'
		var variation = ''
		if velocity != Vector3():
			anim = 'run'
		if current_weapon != null:
			variation = current_weapon.anim_pose
		play_animation(anim, variation)


func _physics_process(delta):
	if is_on_floor():
		if _just_jumped:
			# Handle jumps
			velocity.y = jump_speed
			_just_jumped = false # Must not forget to set this to false
		else:
			# Walk
			velocity = _walk_direction * walk_speed
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


## Walk towards `direction`.
func walk(direction: Vector3):
	if is_on_floor():
		_walk_direction = direction.normalized()


## Look at `at`.
func look(at: Vector3):
	# Avoid error in `look_at` when positions are equal
	if at == global_position:
		return
	# Positions are different, can call `look_at`
	look_at(at)


## Walk to destination facing it.
## Does not change x rotation.
func walk_facing(destination: Vector3):
	# Face destination
	var old_x_rotation = rotation.x
	look(destination)
	rotation.x = old_x_rotation
	# And walk towards it
	walk(destination - global_position)


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


func take_damage(damage):
	health_system.take_damage(damage)
	if health_system.is_dead():
		self.die()
	else:
		var lines: Array[String] = [
			'Arra meu figo!..',
			'Arra fi de rapariga!..',
			'Arra fresco!..',
			'Arra foi mesmo no pau da minha venta!..',
			'Arra meus dente!..',
		]
		self.freeze(.5)
		play_animation('hit_reaction')
		say(lines.pick_random())
		


func die():
	say('Ai! morri...')
	play_animation('death')
	queue_free()


func say(line: String):
	var duration = clamp(len(line)/20.0, .5, 3)
	$Dialog.show_text(line, duration)


func stop():
	velocity = Vector3.ZERO
	_walk_direction = Vector3.ZERO
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
		current_weapon.get_parent().remove_child(current_weapon)
		#var bone = skeleton.get_node(weapon.bone_name_equiped + '/Offset')
		#bone.remove_child(weapon)
		# Attatch to unequiped bone (e.g. right pocket)
		var bone = skeleton.get_node(current_weapon.bone_name_unequiped + '/Offset')
		bone.add_child(current_weapon)
	# Equip next weapon
	if weapons[weapon_index] != null:
		current_weapon_index = weapon_index
		# Activate weapon controller
		current_weapon.controller.controlled = self
		# Attatch weapon to Skin
		var bone = skeleton.get_node(current_weapon.bone_name_equiped + '/Offset')
		current_weapon.get_parent().remove_child(current_weapon)
		bone.add_child(current_weapon)
		current_weapon.equip()

func shove():
	play_animation('shove')

func play_animation(action: String, variation: String = ''):
	if animation_player != null:
		var anim = animation_library_name + '/' + action
		if variation != '':
			anim += '_' + variation
		animation_player.current_animation = anim
		animation_player.play()
