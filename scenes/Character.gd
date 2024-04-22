@tool

extends CharacterBody3D

@export var color: Color:
	set(new):
		color = new
		var material = StandardMaterial3D.new()
		material.albedo_color = self.color
		$Mesh/Body.set_surface_override_material(0, material)
		$Mesh/Arrow.set_surface_override_material(0, material)

var move_intention = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
