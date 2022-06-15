extends "res://scripts/Character.gd"


var chased:Spatial
var path_to_chased:PoolVector3Array
var navigation:Navigation
var path_index = -1


func _process(delta):
	if chased != null:
		if $ChaseRefreshTimer.is_stopped() or path_index == path_to_chased.size()-1:
			update_refresh_interval()
			$ChaseRefreshTimer.start()
			path_to_chased = navigation.get_simple_path(
				global_transform.origin,
				chased.global_transform.origin)
			path_index = 1
			
		if not path_to_chased.empty():
			var next = path_to_chased[path_index]
			if state in [IDLE, WALKING]:
				move((next-global_transform.origin).normalized()*delta)
				lerp_look_at(next)
			if almost_equal(global_transform.origin, next):
				path_index += 1
				lerp_look_at(path_to_chased[path_index])


func _physics_process(delta):
	if state != ATTACKING:
		if $Attack.is_colliding():
			if $Attack.get_collider() == chased:
				attack()


func chase(to_chase):
	chased = to_chase
	$ChaseRefreshTimer.stop()


func almost_equal(v1, v2, precision=1):
	if (v2-v1).length() < precision:
		return true
	return false


func update_refresh_interval():
	var distance = global_transform.origin.distance_to(chased.global_transform.origin)
	$ChaseRefreshTimer.wait_time = .05 if distance <= 10000 else 1
