extends KinematicBody


enum States {
	idle,
	walking,
	attacking
}
var state = States.idle
# Overall speed value. Other speeds are calculated from this one.
export(int) var speed = 10 setget set_speed
var move_speed = speed
var rotation_speed = speed * PI/4
var target:Vector3
export(Dictionary) var valid_transitions:Dictionary

func _process(delta):
	var animplayer = $Model/AnimationPlayer
	if state == States.attacking:
		animplayer.current_animation = "Attack"
		if almost_finished_animation():
			state = States.idle
		return
	if state == States.idle:
		animplayer.current_animation = "Idle"
	elif state == States.walking:
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
	if state != States.attacking:
		state = States.walking
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
	state = States.attacking
	print("qui")


func idle():
	if state != States.attacking:
		state = States.idle


func almost_finished_animation():
	var current = $Model/AnimationPlayer.current_animation_position
	var total = $Model/AnimationPlayer.current_animation_length
	return current / total >= .99 # use a constant value almost equal to 1
