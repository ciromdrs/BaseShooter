class_name Character


extends KinematicBody

# imports
var states = preload("res://scripts/States.gd").new()


# state and related variables
var state = states.IDLE
# Overall speed value. Other speeds are calculated from this one.
export(int) var speed = 10 setget set_speed
var move_speed = speed
var rotation_speed = speed * PI/4
var target:Vector3
var invalid_transitions = {
	states.ATTACKING: [states.IDLE, states.WALKING, states.ATTACKING],
	states.BEING_ATTACKED: [states.IDLE, states.WALKING, states.ATTACKING]
}


func _ready():
	_set_animation("idle")


func _process(delta):
	var animplayer = $Model/AnimationPlayer
	var animpos = animplayer.current_animation_position / animplayer.current_animation_length
	if state == states.ATTACKING:
		animplayer.current_animation = "attacking"
		if 0.2 < animpos and animpos < 0.3:
			if $Attack.is_colliding():
				$Attack.get_collider().be_attacked()
		if almost_finished_animation():
			state = states.IDLE
		return
	if state == states.BEING_ATTACKED:
		animplayer.current_animation = "being_attacked"
		if almost_finished_animation():
			state = states.IDLE
		return
	if state == states.IDLE:
		animplayer.current_animation = "idle"
	elif state == states.WALKING:
		animplayer.current_animation = "walking"
	
	if target != null:
		var difference = target-transform.origin
		var rotated = rotation_speed*delta
		# I do not know why PI/2 must be added to the angle, but it works, so keep it :)
		var angle = Vector2(-difference.x, difference.z).angle() + PI/2
		angle = lerp_angle(rotation.y, angle, 1)
		angle = clamp(angle, rotation.y - (rotated), rotation.y + (rotated))
		rotation.y = angle


# TODO: make character move to and look at the same target
func move(movement: Vector3) -> void:
	if valid_transition(states.WALKING):
		state = states.WALKING
		move_and_collide(movement*move_speed)


func lerp_look_at(target: Vector3) -> void:
	self.target = target


func set_speed(new_speed: float) -> void:
	speed = new_speed
	move_speed = speed
	rotation_speed = speed * PI/4


func set_model(model: Spatial) -> void:
	var old = get_node("Model")
	remove_child(old)
	old.queue_free()
	model.name = "Model"
	add_child(model)


func attack() -> void:
	if valid_transition(states.ATTACKING):
		state = states.ATTACKING


func idle() -> void:
	if valid_transition(states.IDLE):
		state = states.IDLE


func almost_finished_animation() -> bool:
	var current = $Model/AnimationPlayer.current_animation_position
	var total = $Model/AnimationPlayer.current_animation_length
	return current / total >= .99 # use a constant value almost equal to 1


func valid_transition(to_state) -> bool:
	return not(to_state in invalid_transitions.get(state, []))


func be_attacked() -> void:
	if valid_transition(states.BEING_ATTACKED):
		state = states.BEING_ATTACKED

