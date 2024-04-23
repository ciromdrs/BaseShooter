@tool

extends MeshInstance3D

@export var color:= Color(1,1,1):
	set(new):
		color = new
		var material := StandardMaterial3D.new()
		material.albedo_color = new
		set_surface_override_material(0, material)
