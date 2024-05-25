## Spawns nodes inside its area.
##
## Note: To make the spawn area bigger, scale this node, DO NOT change $Area.

extends Node3D

## TODO: Temporary variable. Delete it.
var count = 0

## The amount of zombies spawned at every interval.
@export var spawn_amount: int = 10

## The node to add spawned zombies as children.
@export var spawn_parent: Node3D


func _ready():
	if not Engine.is_editor_hint():
		self.visible = false

## Spawns zombies.
## Raises a warning if a zombie could not be spawned in the navigation map.
func spawn():
	var zombie_scene = preload('res://characters/Zombie.tscn')
	for i in spawn_amount:
		var point = _get_random_spawn_point()
		# Check if the point is in the spawn area
		var min_ = _get_spawn_area_bounds()['min']
		var max_ = _get_spawn_area_bounds()['max']
		if point < min_ or point > max_:
			push_warning('Position ', point, ' not in spawn area.')
			continue
		count += 1
		var zombie = zombie_scene.instantiate()
		spawn_parent.add_child(zombie)
		zombie.global_position = point
		var health_system = preload('res://other/HealthSystem.tscn').instantiate()
		zombie.health_system = health_system
		#var controller = \
			#preload('res://controllers/ChaseController.tscn').instantiate()
		#zombie.add_child(controller)

## Returns a random position on the navigation region, making a best effort for
## it to be inside the spawn area.
func _get_random_spawn_point() -> Vector3:
	var min_ = _get_spawn_area_bounds()['min']
	var max_ = _get_spawn_area_bounds()['max']
	var x = min_.x + randf() * (max_.x - min_.x)
	var y = min_.y + randf() * (max_.y - min_.y)
	var z = min_.z + randf() * (max_.z - min_.z)
	var point = Vector3(x,y,z)
	# Get the closest point in the navigation map
	point = NavigationServer3D.map_get_closest_point(
		 get_world_3d().get_navigation_map(),
		 point)
	return point


## Returns the min and max points in the spawn area.
## The size is determined by the scale of this Spawner node. The $Area child
## MUST NOT be changed in other scenes.
func _get_spawn_area_bounds() -> Dictionary:
	# The position of the same as the spawn area.
	var _pos = $Area.global_position
	var _size = self.scale
	var min_ = Vector3(_pos + -.5 * _size)
	var max_ = Vector3(_pos +  .5 * _size)
	return {'min': min_, 'max': max_}
