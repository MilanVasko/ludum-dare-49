extends Node2D

export(float) var min_spawn_seconds: float
export(float) var max_spawn_seconds: float
export(NodePath) var target_node_path: NodePath

onready var target_node: Node2D = get_node(target_node_path)

var pickup_scenes := [
	preload("res://pickups/health/health.tscn"),
	preload("res://pickups/rock/rock.tscn")
]

var current_spawn_seconds: float

func _ready():
	current_spawn_seconds = rand_range(min_spawn_seconds, max_spawn_seconds)

func _process(delta: float) -> void:
	current_spawn_seconds -= delta
	if current_spawn_seconds <= 0.0:
		current_spawn_seconds = rand_range(min_spawn_seconds, max_spawn_seconds)
		var pickup_scene: PackedScene = pickup_scenes[randi() % pickup_scenes.size()]
		var pickup := pickup_scene.instance()
		var pickup_global_position := target_node.global_position
		add_child(pickup)
		pickup.global_position = pickup_global_position
