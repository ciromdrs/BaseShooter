class_name MoveState
extends State

var move_speed: float


# TODO: make character move to and look at the same target
func process(delta: float, params := {}) -> void:
	state_machine.owner.target = params.target
	state_machine.owner.move_and_collide(params.movement * move_speed * delta)
