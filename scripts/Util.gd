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


static func almost_equal(n1: float, n2: float, precision := 0.01) -> bool:
	if n2 - n1 < precision:
		return true
	return false


static func assert_get_node(parent: Node, node_path: String) -> Node:
	var node := parent.get_node(node_path)
	assert(node, "Cannot get child node " + node_path + " from " + parent.name)
	return node
