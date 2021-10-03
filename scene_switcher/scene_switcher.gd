extends Node2D

func switch(path: String) -> int:
	var error = get_tree().change_scene(path)
	get_tree().call_group("scene_switch_subscriber", "_on_scene_switched")
	return error

func switch_to(packed_scene: PackedScene) -> int:
	var error = get_tree().change_scene_to(packed_scene)
	get_tree().call_group("scene_switch_subscriber", "_on_scene_switched")
	return error
