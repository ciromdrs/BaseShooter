class_name IdleState
extends State


func init():
	animation = "idle"


func process(_delta: float, params := {}):
	var target = params.get("target")
	if target:
		owner.target = target
