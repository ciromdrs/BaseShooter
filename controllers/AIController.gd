extends Node


# imports
const util = preload("res://scripts/Util.gd")


export (NodePath) var chased_node
onready var chased: Spatial = get_node(chased_node) setget chase
var path_to_chased: PoolVector3Array
export (NodePath) var navigation_node
onready var navigation: Navigation = get_node(navigation_node)
var path_index = -1
onready var controlled: Character = get_parent()
onready var state_machine: StateMachine = util.assert_get_node(controlled, "StateMachine")
onready var idle_state: IdleState = util.assert_get_node(state_machine, "IdleState")
onready var move_state: MoveState = util.assert_get_node(state_machine, "MoveState")
onready var attack_state: AttackState = util.assert_get_node(state_machine, "AttackState")


func _ready() -> void:
	move_state.move_speed = controlled.move_speed


func _process(_delta):
	if chased != null:
		if $ChaseRefreshTimer.is_stopped() or path_index >= path_to_chased.size()-1:
			update_refresh_interval()
			$ChaseRefreshTimer.start()
			path_to_chased = navigation.get_simple_path(
				controlled.global_transform.origin,
				chased.global_transform.origin)
			path_index = 1

		if path_to_chased.empty():
			state_machine.transition_to(idle_state)
		else:
			var next = path_to_chased[path_index]
			if OS.is_debug_build():
				var name = "DebugPath"
				var path = get_node_or_null(name) as ImmediateGeometry
				if not path:
					path = ImmediateGeometry.new()
					path.name = name
					add_child(path)
				path.clear()
				path.begin(Mesh.PRIMITIVE_LINES)
				for vertex in path_to_chased:
					path.add_vertex(vertex)
				path.end()
			move_state.movement = (next - controlled.global_transform.origin).normalized()
			$Target.global_transform.origin = next
			move_state.target = $Target
			if state_machine.state != move_state:
				state_machine.transition_to(move_state)
			if util.almost_equal(controlled.global_transform.origin.length(), next.length(), 0.1):
				path_index += 1


func _physics_process(_delta):
	if attack_state.is_in_range(chased):
		state_machine.transition_to(attack_state)


func chase(to_chase: Spatial) -> void:
	chased = to_chase
	$ChaseRefreshTimer.stop()


func update_refresh_interval() -> void:
	var distance = controlled.global_transform.origin.distance_to(chased.global_transform.origin)
	$ChaseRefreshTimer.wait_time = .05 if distance <= 10000 else 1.0
