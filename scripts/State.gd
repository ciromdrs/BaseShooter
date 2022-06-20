class_name State
extends Node


var state_machine = null
export var animation := ""
export var freeze_time := 0.0
var _cooldown_timer:= Timer.new()
export var cooldown_time: float setget _set_cooldown_time, _get_cooldown_time


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


func _set_cooldown_time(new) -> void:
	cooldown_time = new
	_cooldown_timer.start(new)


func _get_cooldown_time() -> float:
	return _cooldown_timer.time_left
