@tool

extends Node3D


## To override the surface material's albedo color.
@export var color: Color = Color(1,1,1):
	set(new):
		color = new
		var material = StandardMaterial3D.new()
		material.albedo_color = self.color
		$Body.set_surface_override_material(0, material)
		$Arrow.set_surface_override_material(0, material)
