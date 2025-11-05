## A weapon.
class_name Weapon extends Node3D

## Fire mode.
enum FireMode {
	MANUAL,  ## Pull the trigger to shoot one bullet.
	AUTO,  ## Hold the trigger to shoot automaticaly.
	THROW  ## Hold the click and release to throw.
}

## Animation pose.
enum _AnimationPose {
	PISTOL,
	RIFLE,
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
@export_range(.01, 1) var accuracy: float = .7

## Freeze time between shots, in milliseconds.
@export var freeze_time: float = 400

@export var _anim_pose: _AnimationPose
var anim_pose: String:
	get:
		return {
			_AnimationPose.PISTOL: 'pistol',
			_AnimationPose.RIFLE: 'rifle',
			_AnimationPose.SHOTGUN: 'shotgun',
			_AnimationPose.THROWABLE: 'throwable'
		}[_anim_pose]



@export var bone_name_equiped: String

@export var bone_name_unequiped: String

@onready var controller: = $MKWeaponController


## Indicates if the trigger is pulled.
var trigger_pulled: bool = false

## Indicates if the trigger was just pulled.
var trigger_just_pulled: bool = false

## Time of last shot.
var _last_shot: float = 0


func _ready():
	_update_aim()
	_rotate_raycasts()
	_scale_raycasts()


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
	# just_shot = true
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
				var skin = collider.owner
				if skin != null:
					# The Skin node MUST be a direct child of a Character
					var character: Character = skin.get_parent()
					character.take_damage(ray_damage)
	# Play animations
	$GunshotFire.texture = gunshot_textures.pick_random()
	$GunshotFire.flip_h = randf() > .5
	$AnimationPlayer.current_animation = 'shoot'
	


## Rotates the raycasts to simulate accuracy.
func _rotate_raycasts():
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


## Scales raycasts to the weapon's range.
func _scale_raycasts():
	for r in $RayCasts.get_children():
		r.scale.y = self.range_


## Update the aim.
func _update_aim():
	$Aim.set_range(self.range_)
	$Aim.set_aperture(self.accuracy)


## Equips the weapon and activates controls.
func equip():
	controller.process_mode = Node.PROCESS_MODE_INHERIT
	$RayCasts.process_mode = Node.PROCESS_MODE_INHERIT
	$Aim.process_mode = Node.PROCESS_MODE_INHERIT
	$Aim.visible = true


## Unequips the weapon and deactivates controls.
func unequip():
	controller.process_mode = Node.PROCESS_MODE_DISABLED
	$RayCasts.process_mode = Node.PROCESS_MODE_DISABLED
	$Aim.process_mode = Node.PROCESS_MODE_DISABLED
	$Aim.visible = false
