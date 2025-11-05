class_name StateMachine extends Node

var states: Dictionary = {}

@export var initial_state: State

var current_state: State

func _ready():
	# Register states
	for c in get_children():
		if c is State:
			states[c.name] = c
			c.Transitioned.connect(on_child_transition)
	# Set current state to the initial state
	current_state = initial_state
	initial_state.enter()
			
func _process(delta):
	current_state.update(delta)

func _physics_process(delta):
	current_state.physics_update(delta)

func on_child_transition(old_state, new_state_name, args: Dictionary = {}):
	# TODO: Current state changed before this transition could happen. Discard?
	if old_state != current_state:
		return 
	# Perform the transition
	old_state.exit()
	var new_state = states[new_state_name]
	current_state = new_state
	new_state.enter(args)
