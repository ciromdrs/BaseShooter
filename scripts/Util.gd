extends Node

const MAX_NUMBER_OF_LAYERS = 32

static func collision_mask(layers: Array) -> int:
	var mask := 0
	for layer in layers:
		for i in range(1, MAX_NUMBER_OF_LAYERS+1):
			if layer == ProjectSettings.get_setting("layer_names/3d_physics/layer_" + str(i)):
				mask += pow(2, i-1)
				break
	return mask
