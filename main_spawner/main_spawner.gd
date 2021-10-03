extends Node2D

export(NodePath) var target_node_path: NodePath
export(NodePath) var target_path_path: NodePath
export(NodePath) var player_node_path: NodePath

onready var target_node: Node2D = get_node(target_node_path)
onready var target_path: Path2D = get_node(target_path_path)
onready var player_node: Node2D = get_node(player_node_path)

func _ready():
	var curve := target_path.curve
	var path_length := curve.get_baked_length()
	var random_offset = randf() * path_length
	var random_offset_behind = fmod(random_offset + (path_length - 500), path_length)
	var point := curve.interpolate_baked(random_offset, true)
	var point_behind := curve.interpolate_baked(random_offset_behind, true)
	target_node.desired_offset = random_offset
	player_node.global_position = point_behind
	player_node.desired_lookat_position = point
	
