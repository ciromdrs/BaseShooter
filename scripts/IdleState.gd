class_name IdleState
extends State


var target: Node3D


func init():
	animation = "idle"


func process(_delta: float):
	if target:
		owner.target = target
