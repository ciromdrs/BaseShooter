class_name MoveState
extends State


var move_speed: float
var movement: Vector3
var target: Spatial

func process(delta: float) -> void:
	state_machine.owner.target = target
	state_machine.owner.move_and_collide(movement * move_speed * delta)
