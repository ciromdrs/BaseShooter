extends Node


var controlled
var input_vector := Vector3()
var camera:Camera


func _ready():
	controlled = get_parent()


func _process(delta):
	if Input.is_action_just_pressed("click"):
		controlled.attack()
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.z = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	if input_vector.length() > 0:
		controlled.move(input_vector*delta)
	else:
		controlled.idle()
