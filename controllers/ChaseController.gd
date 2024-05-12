extends Node
## A chaser [code]Controller[/code].
##
## Adds a NavigationAgent3D child to `controlled`.
## Use this, for example, to make [code]Zombie[/code]s chase the player.

## The node chased by this.
@export var chased: Node3D

## The [code]Character[/code] controlled by this.
var controlled: Character
var navagent: NavigationAgent3D


func _ready():
	controlled = get_parent()
	# Make sure to not await during _ready.
	call_deferred("setup_navigation")

## Configures `controlled`'s navigation.
func setup_navigation():
	# Wait for the first physics frame so the NavigationServer can sync.
	navagent = NavigationAgent3D.new() # controlled.get_node('NavigationAgent3D')
	controlled.add_child(navagent)
	# These values need to be adjusted for the actor's speed and the navigation
	# layout.
	navagent.path_desired_distance = 1.1
	# navagent.target_desired_distance = 100
	await get_tree().physics_frame


func _process(_delta):
	navagent.set_target_position(chased.global_position)
	if navagent.is_navigation_finished():
		controlled.stop()
		controlled.say('Teje preso!')
	else:
		var next: Vector3 = navagent.get_next_path_position()
		controlled.walk_facing(next)
