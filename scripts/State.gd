class_name State
extends Node


var state_machine = null
export var animation := ""
export var freeze_time := 0.0
export var cooldown_time: float
var cooldown_time_left: float


func _init() -> void:
	init()


func init() -> void:
	pass


func enter():
	pass


func exit():
	state_machine.to_initial_state()


func process(_delta: float) -> void:
	pass


func physics_process(_delta: float) -> void:
	pass
