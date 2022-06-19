class_name Character


extends KinematicBody


# Overall speed value. Other speeds are calculated from this one.
export(int) var speed: float = 10# setget set_speed
var move_speed: float = speed
var rotation_speed: float = speed * PI/4
var target: Spatial


func _process(delta):
	if target != null:
		var difference = target.transform.origin - global_transform.origin
		var rotated = rotation_speed*delta
		# I do not know why PI/2 must be added to the angle, but it works, so keep it :)
		var angle = Vector2(-difference.x, difference.z).angle() + PI/2
		angle = lerp_angle(rotation.y, angle, 1)
		angle = clamp(angle, rotation.y - (rotated), rotation.y + (rotated))
		rotation.y = angle


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


#func almost_finished_animation() -> bool:
#	var current = $Model/AnimationPlayer.current_animation_position
#	var total = $Model/AnimationPlayer.current_animation_length
#	return current / total >= .99 # use a constant value almost equal to 1
