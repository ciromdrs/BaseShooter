extends Spatial


export(Color) var color = Color(1,1,1)

# Called when the node enters the scene tree for the first time.
func _ready():
	var material = SpatialMaterial.new()
	material.albedo_color = color
	$MeshInstance.set_surface_material(0, material)
	$Triangle.set_surface_material(0, material)

