class_name AttackState
extends State


export var hit_start := 0.0
export var hit_end := 1.0
var _elapsed := 0.0
var already_hit := false

func enter() -> void:
	_elapsed = 0.0
	already_hit = false


func process(_delta: float) -> void:
	if state_machine.freeze_time == 0:
		exit()


func physics_process(delta: float) -> void:
	_elapsed += delta
	if not already_hit:
		if hit_start <= _elapsed and _elapsed <= hit_end:
			for body in $Area.get_overlapping_bodies():
				if body != owner:
					var msg = "body (" + body.get_class() + ") is not a Character"
					assert(body is Character, msg)
					already_hit = true
					var sm = body.get_node("StateMachine")
					sm.transition_to(sm.get_node("BeAttackedState"))


func is_in_range(body: PhysicsBody) -> bool:
	for another in $Area.get_overlapping_bodies():
		if body == another:
			return true
	return false
