extends "res://scripts/Character.gd"


func _process(_delta):
	var animplayer = $Model/AnimationPlayer
	if state == ATTACKING:
		animplayer.current_animation = "Attack"
		if almost_finished_animation():
			state = IDLE
		return
	if state == IDLE:
		animplayer.current_animation = "Idle"
	elif state == WALKING:
		animplayer.current_animation = "Walk"
