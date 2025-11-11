class_name StateMachine extends Node

var states: Dictionary = {}

@export var initial_state: State

var current_state: State

func _ready():
	# Register states
	for c in get_children():
		if c is State:
			states[c.name] = c
			c.Transitioned.connect(on_state_transition)
	# Set current state to the initial state
	on_state_transition(null, initial_state.name)

		
func _process(delta):
	current_state.update(delta)

func _physics_process(delta):
	current_state.physics_update(delta)

func on_state_transition(old_state, new_state_name: String, args: Dictionary = {}):
	# TODO: Discard loop transitions?
	if current_state != null:
		if current_state.name == new_state_name:
			return
	# Perform the transition
	if old_state != null:
		old_state.exit()
	var new_state = states[new_state_name]
	current_state = new_state
	current_state.enter(args)
