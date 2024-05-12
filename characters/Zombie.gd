extends Character

func take_damage(damage: int):
	super.take_damage(damage)
	var lines: Array[String] = [
		'Arra meu figo!..',
		'Arra fi de rapariga!..',
		'Arra fresco!..',
		'Arra foi mesmo no pau da minha venta!..',
		'Arra meus dente!..',
	]
	say(lines.pick_random())
