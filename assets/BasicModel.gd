tool
extends Spatial


export(Color) var color = Color(1,1,1) setget set_color


func set_color(new_color:Color) -> void:
	color = new_color
	var material = SpatialMaterial.new()
	var cylinder = get_node("MeshInstance")
	var triangle = get_node("Triangle")
	material.albedo_color = new_color
	cylinder.set_surface_material(0, material)
	triangle.set_surface_material(0, material)
	property_list_changed_notify()
	
	
