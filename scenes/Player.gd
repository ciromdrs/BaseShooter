extends "res://scripts/Character.gd"


func _process(_delta):
	var animplayer = $Model/AnimationPlayer
	if state == States.attacking:
		animplayer.current_animation = "Attack"
		if almost_finished_animation():
			state = States.idle
		return
	if state == States.idle:
		animplayer.current_animation = "Idle"
	elif state == States.walking:
		animplayer.current_animation = "Walk"
