extends Spatial


export(Color) var color = Color(1,1,1)

# TODO: update 3D object on the editor's preview
func _ready():
	var material = SpatialMaterial.new()
	material.albedo_color = color
	$MeshInstance.set_surface_material(0, material)
	$Triangle.set_surface_material(0, material)

