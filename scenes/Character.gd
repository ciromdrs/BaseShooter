class_name Character


extends CharacterBody3D


# TODO: Move variables to adequate States
# Overall speed value. Other speeds are calculated from this one.
@export var speed: int = 10: set = set_speed
var move_speed: float
var rotation_speed: float
var target: Node3D


func _ready() -> void:
	set_speed(speed)


func _process(delta):
	if target != null:
		var difference = target.global_transform.origin - global_transform.origin
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


func set_model(model: Node3D) -> void:
	var old = get_node("Model")
	remove_child(old)
	old.queue_free()
	model.name = "Model"
	add_child(model)
