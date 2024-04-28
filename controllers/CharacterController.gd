class_name CharacterController
extends Node
## A [code]Controller[/code] for [code]Character[/code]s.
##
## Add any subclass of this as a child of a [code]Character[/code] node.

## The [code]Character[/code] controlled by this.
@onready var controlled: Character = get_parent()
