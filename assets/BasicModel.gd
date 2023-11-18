@tool
extends Node3D


@export var color: Color = Color(1,1,1): set = set_color
@export var default_animation := "idle"
@onready var animation := default_animation: get = _get_animation, set = _set_animation


func set_color(new_color:Color) -> void:
	color = new_color
	var material = StandardMaterial3D.new()
	var cylinder = get_node("MeshInstance3D")
	var triangle = get_node("Triangle")
	material.albedo_color = new_color
	cylinder.set_surface_override_material(0, material)
	triangle.set_surface_override_material(0, material)
	notify_property_list_changed()


func _set_animation(new_animation: String):
	animation = new_animation
	$AnimationPlayer.current_animation = new_animation


func _get_animation() -> String:
	return $AnimationPlayer.current_animation
