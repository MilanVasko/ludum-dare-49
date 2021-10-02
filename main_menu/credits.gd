extends Control

var main_menu_scene := load("res://main_menu/main_menu.tscn")

func _on_back_pressed():
	var err := get_tree().change_scene_to(main_menu_scene)
	assert(err == OK)
