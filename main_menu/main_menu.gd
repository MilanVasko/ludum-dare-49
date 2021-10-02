extends Control

var about_scene := load("res://main_menu/about.tscn")

func _on_play_pressed():
	var err := get_tree().change_scene("res://ingame/ingame.tscn")
	assert(err == OK)

func _on_about_pressed():
	var err := get_tree().change_scene_to(about_scene)
	assert(err == OK)

func _on_quit_pressed():
	get_tree().quit()
