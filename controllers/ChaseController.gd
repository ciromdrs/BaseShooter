extends CharacterController
## A chaser [code]CharacterController[/code].
##
## Use this, for example, to make [code]Zombie[/code]s chase the player.

## The node chased by this.
@export var chased: Node3D


func _process(_delta):
	# Naive chase strategy
	controlled.walk_facing(chased.global_position)
