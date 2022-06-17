# State machine adapted from
# https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
class_name StateMachine
extends Node


# state and related variables
export var initial_state := NodePath()
onready var state: State setget _set_state
onready var idle_state: State = $IdleState
onready var move_state: State = $MoveState
onready var attack_state: State = $AttackState
var _params := {}
var freeze_time: float setget _set_freeze_time, _get_freeze_time


func _ready() -> void:
	yield(owner, "ready")
	# The state machine assigns itself to the State objects' state_machine property
	for child in get_children():
		if child is State:
			child.state_machine = self
	_set_state(get_node(initial_state))


func _process(delta: float) -> void:
	state.process(delta, _params)


func _physics_process(delta: float) -> void:
	state.physics_process(delta, _params)


func valid_transition(to_state: State) -> bool:
	assert(to_state.get_parent() == self, "States have different parents")
	match state:
		attack_state:
			return not (to_state in [idle_state, move_state, attack_state])
	return true


func transition_to(to_state: State, params := {}) -> void:
	if not valid_transition(to_state):
		return
	_params = params
	_set_state(to_state)
	

func _set_freeze_time(new_freeze_time) -> void:
	freeze_time = new_freeze_time
	$FreezeTimer.start(new_freeze_time)


func _get_freeze_time() -> float:
	return $FreezeTimer.time_left


func to_initial_state():
	_set_state(get_node(initial_state))


func _set_state(new_state) -> void:
	state = new_state
	_set_freeze_time(state.freeze_time)
	owner.get_node("Model").animation = state.animation
	state.enter()
