class_name ZombieState extends State


@export var zombie: Character


func _ready():
	zombie.damage_taken.connect(on_damage_taken)


func on_damage_taken(damage):
	zombie.health_system.take_damage(damage)
	if zombie.health_system.is_dead():
		Transitioned.emit(self, 'ZombieDieState')
		return
	var lines: Array[String] = [
		'',
		'Arra meu figo!..',
		'Arra fi de rapariga!..',
		'Arra fresco!..',
		'Arra foi mesmo no pau da minha venta!..',
		'Arra meus dente!..',
	]
	zombie.freeze(.5)
	zombie.play_animation('hit_reaction')
	zombie.say(lines.pick_random())
