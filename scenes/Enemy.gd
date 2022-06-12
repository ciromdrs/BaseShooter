extends "res://scripts/Character.gd"


enum STATES {
	idle,
	walking,
	attacking
}


var chased:Spatial
var path_to_chased:PoolVector3Array
var navigation:Navigation
var path_index = -1
var state = STATES.idle


func _process(delta):
	if state == STATES.idle:
		$Model/AnimationPlayer.current_animation = "Idle"
	elif state == STATES.walking:
		$Model/AnimationPlayer.current_animation = "Walk"
	elif state == STATES.attacking:
		$Model/AnimationPlayer.current_animation = "Attack"
		if !$Model/AnimationPlayer.is_playing():
			state = STATES.idle
	
	if chased != null:
		if $ChaseRefreshTimer.is_stopped() or path_index == path_to_chased.size()-1:
			$ChaseRefreshTimer.start()
			path_to_chased = navigation.get_simple_path(
				global_transform.origin,
				chased.global_transform.origin)
			path_index = 1
			
		if not path_to_chased.empty():
			var next = path_to_chased[path_index]
			move((next-global_transform.origin).normalized()*delta)
			lerp_look_at(next)
			if state == STATES.idle:
				state = STATES.walking
			if almost_equal(global_transform.origin, next):
				path_index += 1
				lerp_look_at(path_to_chased[path_index])


func _physics_process(delta):
	if $Attack.is_colliding():
		if $Attack.get_collider() == chased:
			state = STATES.attacking
	else:
		if path_to_chased != null:
			state = STATES.walking
		else:
			state = STATES.idle


func chase(to_chase):
	chased = to_chase
	$ChaseRefreshTimer.stop()


func almost_equal(v1, v2, precision=1):
	if (v2-v1).length() < precision:
		return true
	return false
