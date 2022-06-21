extends Spatial


func _process(_delta: float) -> void:
	var target = get_parent().get("target")
	if target:
		$SpotLight.look_at(target.global_transform.origin, Vector3.UP)
