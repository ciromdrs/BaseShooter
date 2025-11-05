class_name ZombieChaseState extends ZombieState


## The chased node (usually, the player).
var chased: Node3D

## Navigation agent for path finding.
var _navagent: NavigationAgent3D

## Last time the path to `chased` was calculated, in milliseconds.
var _last_refresh: int = 0

## Time interval between path recomputings, in milliseconds.
@export var refresh_interval: int = 1


func enter(args: Dictionary = {}):
	assert (len(args) == 1, 'Expected 1 argument, but got '+str(len(args))+'.')
	assert ('chased' in args, 'Must pass in the "chased" node.')
	chased = args['chased']


func _ready():
	# Make sure to not await during _ready.
	call_deferred("setup_navigation")


## Configures `controlled`'s navigation.
func setup_navigation():
	# Wait for the first physics frame so the NavigationServer can sync.
	_navagent = zombie.get_node("NavigationAgent3D")
	# These values need to be adjusted for the actor's speed and the navigation
	# layout.
	_navagent.path_desired_distance = 1.15
	# navagent.target_desired_distance = 100
	await get_tree().physics_frame


func update(_delta):
	# Refreshes the path at given intervals
	if Util.now() - _last_refresh > refresh_interval:
		_last_refresh = Util.now()
		_navagent.set_target_position(chased.global_position)
	# Checks if `chased` was reached
	if _navagent.is_navigation_finished():
		zombie.stop()
		zombie.say('Teje preso!')
	else:
		var next: Vector3 = _navagent.get_next_path_position()
		zombie.walk_facing(next)
	
