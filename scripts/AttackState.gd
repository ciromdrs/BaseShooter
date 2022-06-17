class_name AttackState
extends State


func init() -> void:
	animation = "attacking"
	freeze_time = 1


func process(_delta: float, _params := {}) -> void:
	if state_machine.freeze_time == 0:
		exit()
