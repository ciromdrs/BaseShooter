"""
3D Camera
http://kidscancode.org/godot_recipes/3d/camera_gimbal/
"""

extends Spatial


export (NodePath) var target
export (float, 0.0, 2.0) var rotation_speed = PI/2


# mouse properties
export (float, 0.001, 0.1) var mouse_sensitivity = 0.005
export (bool) var invert_y = true
export (bool) var invert_x = true


# zoom settings
export (float) var max_zoom = 3.0
export (float) var min_zoom = 0.4
export (float, 0.05, 1.0) var zoom_speed = 0.09

var zoom = 1.5

onready var start_pos = transform.origin

func _unhandled_input(event):
	if not Input.get_mouse_mode() in [Input.MOUSE_MODE_CAPTURED, Input.MOUSE_MODE_HIDDEN]:
		return
	if event.is_action_pressed("cam_zoom_in"):
		zoom -= zoom_speed
	if event.is_action_pressed("cam_zoom_out"):
		zoom += zoom_speed
	zoom = clamp(zoom, min_zoom, max_zoom)
#	if event is InputEventMouseMotion:
#		if event.relative.x != 0:
#			var dir = 1 if invert_x else -1
#			rotate_object_local(Vector3.UP, dir * event.relative.x * mouse_sensitivity)
#		if event.relative.y != 0:
#			var dir = 1 if invert_y else -1
#			var y_rotation = clamp(event.relative.y, -30, 30)
#			$InnerGimbal.rotate_object_local(Vector3.RIGHT, dir * y_rotation * mouse_sensitivity)

func _process(delta):
	$InnerGimbal.rotation.x = clamp($InnerGimbal.rotation.x, -1.4, -0.01)
	scale = lerp(scale, Vector3.ONE * zoom, zoom_speed)
	if target:
		global_transform.origin = get_node(target).global_transform.origin + start_pos
