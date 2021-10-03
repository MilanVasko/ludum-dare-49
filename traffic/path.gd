extends Path2D

class_name TrafficPath2D

export(int) var min_spawn_distance
export(int) var max_spawn_distance

var path_follow_scene := preload("res://traffic/path_follow.tscn")

func _ready() -> void:
	randomize()
	
	var current_offset := rand_range(min_spawn_distance, max_spawn_distance)
	var curve_length := curve.get_baked_length()
	while current_offset < curve_length:
		var path_follow: PathFollow2D = path_follow_scene.instance()
		add_child(path_follow)
		path_follow.offset = current_offset
		current_offset += rand_range(min_spawn_distance, max_spawn_distance)
