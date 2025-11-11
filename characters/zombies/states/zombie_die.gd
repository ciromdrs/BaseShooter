class_name ZombieDieState extends ZombieState


## Time before queuing this node to free, in seconds.
var before_free: float


func enter(args: Dictionary = {}):
	assert (len(args) == 0, 'Expected 0 arguments, got ' + str(len(args)) + '.')
	# Disable collision except for scenario
	zombie.collision_layer = 0
	zombie.collision_mask = 0
	zombie.set_collision_mask_value(1, true)
	zombie.stop()
	var anims = ['death', 'death_2']
	zombie.play_animation(anims.pick_random())
	before_free = zombie.animation_player.get_animation(zombie.animation_player.current_animation).length
	zombie.freeze(before_free)
	var lines = [
		'',
		'Ai! morri...',
		'Eu nem era zumbi...',
		'Mamae, no ceu tem pao?...',
	]
	zombie.say(lines.pick_random())


func update(delta):
	if before_free <= 0:
		zombie.queue_free()
		return
	before_free -= delta

	
func on_damage_taken(_damage):
	pass

	
