tool
extends Spatial


export(Color) var color = Color(1,1,1) setget set_color
export var default_animation := "idle"
onready var animation := default_animation setget _set_animation, _get_animation


func set_color(new_color:Color) -> void:
	color = new_color
	var material = SpatialMaterial.new()
	var cylinder = get_node("MeshInstance")
	var triangle = get_node("Triangle")
	material.albedo_color = new_color
	cylinder.set_surface_material(0, material)
	triangle.set_surface_material(0, material)
	property_list_changed_notify()


func _set_animation(new_animation: String):
	animation = new_animation
	$AnimationPlayer.current_animation = new_animation


func _get_animation() -> String:
	return $AnimationPlayer.current_animation
