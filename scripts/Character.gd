extends KinematicBody


const IDLE = "IDLE"
const WALKING = "WALKING"
const ATTACKING = "ATTACKING"

var state = IDLE
# Overall speed value. Other speeds are calculated from this one.
export(int) var speed = 10 setget set_speed
var move_speed = speed
var rotation_speed = speed * PI/4
var target:Vector3
var valid_transitions = {
	IDLE: [IDLE, WALKING, ATTACKING],
	WALKING: [IDLE, WALKING, ATTACKING],
	ATTACKING: []
}

func _process(delta):
	var animplayer = $Model/AnimationPlayer
	if state == ATTACKING:
		animplayer.current_animation = "Attack"
		if almost_finished_animation():
			state = IDLE
		return
	if state == IDLE:
		animplayer.current_animation = "Idle"
	elif state == WALKING:
		animplayer.current_animation = "Walk"
	
	if target != null:
		var difference = target-transform.origin
		var rotated = rotation_speed*delta
		# I do not know why PI/2 must be added to the angle, but it works, so keep it :)
		var angle = Vector2(-difference.x, difference.z).angle() + PI/2
		angle = lerp_angle(rotation.y, angle, 1)
		angle = clamp(angle, rotation.y - (rotated), rotation.y + (rotated))
		rotation.y = angle


# TODO: make character move to and look at the same target
func move(movement):
	if valid_transition(WALKING):
		state = WALKING
		move_and_collide(movement*move_speed)


func lerp_look_at(target):
	self.target = target


func set_speed(new_speed):
	speed = new_speed
	move_speed = speed
	rotation_speed = speed * PI/4


func set_model(model):
	var old = get_node("Model")
	remove_child(old)
	old.queue_free()
	model.name = "Model"
	add_child(model)


func attack():
	if valid_transition(ATTACKING):
		state = ATTACKING


func idle():
	if valid_transition(IDLE):
		state = IDLE


func almost_finished_animation():
	var current = $Model/AnimationPlayer.current_animation_position
	var total = $Model/AnimationPlayer.current_animation_length
	return current / total >= .99 # use a constant value almost equal to 1


func valid_transition(to_state):
	return to_state in valid_transitions.get(state, [])
