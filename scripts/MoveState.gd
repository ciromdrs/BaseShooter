class_name MoveState
extends State

var move_speed: float


# TODO: make character move to and look at the same target
func process(delta: float, params := {}) -> void:
	var movement = params['movement']
	self.state_machine.owner.move_and_collide(movement*move_speed*delta)


func init() -> void:
	animation = "walking"
