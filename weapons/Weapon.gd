## A weapon.
class_name Weapon extends Node3D


## Fire mode.
enum FireMode {
	MANUAL,  ## Pull the trigger to shoot one bullet.
	AUTO,  ## Hold the trigger to shoot automaticaly.
	THROW  ## Hold the click and release to throw.
}

## Weapon type.
enum WeaponType {
	RIFLE,
	PISTOL,
	SHOTGUN,
	THROWABLE
}

## In meters.
@export var range_: float = 10

## Damage.
@export var damage: int = 30

## Fire mode.
@export var fire_mode: FireMode = FireMode.MANUAL

## Accuracy.
@export_range(.01, 1) var accuracy: float = .9

## Freeze time between shots, in milliseconds.
@export var freeze_time: float = 400

## Type.
@export var weapon_type: WeaponType

## Animation pose.
var anim_pose: String:
	get:
		return {
			WeaponType.PISTOL: 'pistol',
			WeaponType.RIFLE: 'rifle',
			WeaponType.SHOTGUN: 'shotgun',
			WeaponType.THROWABLE: 'throwable'
		}[weapon_type]

@export var bone_name_equiped: String

@export var bone_name_unequiped: String

@onready var animation_player: = $Skin/AnimationPlayer

@onready var controller: = $MKWeaponController

@onready var skin: = $Skin


## Indicates if the trigger is pulled.
var trigger_pulled: bool = false

## Indicates if the trigger was just pulled.
var trigger_just_pulled: bool = false

## Time of last shot.
var _last_shot: float = 0


func _ready():
	_rotate_raycasts()
	_grow_raycasts()


func _physics_process(_delta):
	self._shoot_process()


## Pulls the trigger to shoot.
func pull_trigger():
	trigger_pulled = true
	trigger_just_pulled = true


## Releases the trigger.
func release_trigger():
	trigger_pulled = false


## Processes a shoot command.
## Should be called in `_physics_process`.
func _shoot_process():
	# Check if must shoot
	var autofire = fire_mode == FireMode.AUTO
	var frozen = (Util.now() - _last_shot) <= freeze_time
	var triggered = trigger_just_pulled or (autofire and trigger_pulled)
	if not triggered or frozen:
		return
	# Will not shoot again if not in auto fire mode
	trigger_just_pulled = false
	self._shoot()
	# Prepare for next shot
	self._rotate_raycasts()


## Performs a shot by applying damage to raycast colliders and updates last shot
## time.
func _shoot():
	var gunshot_textures = [
		preload('res://assets/models3D/gunshot-fire1.png'),
		preload('res://assets/models3D/gunshot-fire2.png'),
		preload('res://assets/models3D/gunshot-fire3.png'),
	]
	_last_shot = Util.now()
	var ray_damage = damage / float(len($RayCasts.get_children()))
	for r in $RayCasts.get_children():
		if r.is_colliding():
			var collider = r.get_collider()
			if collider is HurtBox:
				# Get Character ancestor
				# The collider is a HurtBox attatched to a bone in the skin's
				# skeleton
				collider.hit.emit(ray_damage, self, null)
	# Play animations
	var fire = skin.get_node('GunshotFire')
	fire.texture = gunshot_textures.pick_random()
	fire.flip_h = randf() > .5
	animation_player.current_animation = 'weapon/shoot'
	


## Rotates the raycasts to simulate accuracy.
func _rotate_raycasts():
	const MAX_APERTURE = PI / 3
	# Number of rays
	var nrays = len($RayCasts.get_children())
	# Aperture of each ray
	var ray_aperture = MAX_APERTURE * (1-accuracy) / nrays
	var ray_rotation = TAU * (1-accuracy) / nrays
	for i in nrays:
		var ray = $RayCasts.get_child(i)
		var y_rotation = ray_aperture * (randf()-.5)
		var z_rotation = ray_rotation * (randf()-.5)
		# Apply rotation
		ray.rotation.y = y_rotation
		ray.rotation.z = z_rotation


## Grows raycasts to the weapon's range.
func _grow_raycasts():
	for r in $RayCasts.get_children():
		r.target_position.z = self.range_


## Equips the weapon and activates controls.
func equip():
	controller.process_mode = Node.PROCESS_MODE_INHERIT
	$RayCasts.process_mode = Node.PROCESS_MODE_INHERIT


## Unequips the weapon and deactivates controls.
func unequip():
	controller.process_mode = Node.PROCESS_MODE_DISABLED
	$RayCasts.process_mode = Node.PROCESS_MODE_DISABLED
