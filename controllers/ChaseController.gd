extends Node
## A chaser [code]Controller[/code].
##
## Use this, for example, to make [code]Zombie[/code]s chase the player.

## The node chased by this.
@export var chased: Node3D

## The [code]Character[/code] controlled by this.
@onready var controlled: Character = get_parent()


func _process(_delta):
	# Naive chase strategy
	controlled.walk_facing(chased.global_position)
