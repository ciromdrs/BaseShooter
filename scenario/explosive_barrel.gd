extends RigidBody3D


func _on_hurt_box_hit(_damage: int, _collider: Node3D, _collision: CollisionObject3D) -> void:
	$AnimationPlayer.current_animation = 'boom'
	$AnimationPlayer.play()
	#TODO: queue_free()
