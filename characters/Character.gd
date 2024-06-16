## A Character, either playable or not.

class_name Character

extends CharacterBody3D


## In meters per second.
@export var walk_speed: float = 3

## The direction the Character intents to walk towards, in meters per second.
## It is subject to physics processing.
var _walk_direction := Vector3.ZERO

## Indicates that the Character just jumped.
var _just_jumped := false

## In meters per second.
@export var jump_speed: float = 10.5

## The character's weapon.
@export var weapon: Weapon

## The health system.
@onready var health_system = $HealthSystem


func _ready():
	pass

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
	var could_shoot = self.weapon.pull_trigger()
	if could_shoot:
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
	self.weapon.release_trigger()


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
		say(lines.pick_random())

func die():
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
