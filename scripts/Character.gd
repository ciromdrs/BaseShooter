extends KinematicBody

# Overall speed value. Other speeds are calculated from this one.
export(int) var speed = 10 setget set_speed
var move_speed = speed
var rotation_speed = speed * PI/4
var target:Vector3


func _process(delta):
	if target != null:
		var difference = target-transform.origin
		var rotated = rotation_speed*delta
		# I do not know why PI/2 must be added to the angle, but it works, so keep it :)
		var angle = Vector2(-difference.x, difference.z).angle() + PI/2
		angle = lerp_angle(rotation.y, angle, 1)
		angle = clamp(angle, rotation.y - (rotated), rotation.y + (rotated))
		rotation.y = angle


# make character move to and look at the same target
func move(movement):
	move_and_collide(movement*move_speed)


func lerp_look_at(target):
	self.target = target


func set_speed(new_speed):
	speed = new_speed
	move_speed = speed
	rotation_speed = speed * PI/4
