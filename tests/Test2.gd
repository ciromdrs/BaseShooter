extends Spatial


var environment = preload("test_environment.tres")


func _ready():
	get_viewport().world.environment = environment
