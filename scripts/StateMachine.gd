# State machine adapted from
# https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
class_name StateMachine
extends Node


# state and related variables
export var initial_state := NodePath()
onready var state: State setget _set_state
var states := []
onready var idle_state: State = $IdleState
onready var move_state: State = $MoveState
onready var attack_state: State = $AttackState
onready var be_attacked_state: State = $BeAttackedState
var _locked := false
var freeze_time: float setget _set_freeze_time, _get_freeze_time


func _ready() -> void:
	yield(owner, "ready")
	# The state machine assigns itself to the State objects' state_machine property
	for child in get_children():
		if child is State:
			child.state_machine = self
			states += [child]
	_set_state(get_node(initial_state))


func _process(delta: float) -> void:
	for s in states:
		s.cooldown_time_left -= delta
	state.process(delta)


func _physics_process(delta: float) -> void:
	state.physics_process(delta)


func valid_transition(to_state: State) -> bool:
	assert(to_state.get_parent() == self, "States have different parents")
	if to_state.cooldown_time_left > 0:
		return false
	if _locked:
		match state:
			attack_state:
				return not (to_state in [idle_state, move_state, attack_state])
			be_attacked_state:
				return not (to_state in [idle_state, move_state, attack_state])
	return true


func transition_to(to_state: State) -> void:
	if not valid_transition(to_state):
		return
	state.exit()
	_set_state(to_state)
	

func _set_freeze_time(new_freeze_time) -> void:
	freeze_time = new_freeze_time
	$FreezeTimer.start(new_freeze_time)


func _get_freeze_time() -> float:
	return $FreezeTimer.time_left


func to_initial_state() -> void:
	_set_state(get_node(initial_state))


func _set_state(new_state: State) -> void:
	state = new_state
	_locked = true
	_set_freeze_time(state.freeze_time)
	state.cooldown_time_left = state.cooldown_time
	owner.get_node("Model").animation = state.animation
	state.enter()


func unlock() -> void:
	_locked = false
