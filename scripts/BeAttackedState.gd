class_name BeAttackedState
extends State


func init() -> void:
	animation = "being_attacked"
	freeze_time = 1


func process(_delta: float) -> void:
	if state_machine.freeze_time == 0:
		exit()
