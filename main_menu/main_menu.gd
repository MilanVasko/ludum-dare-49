extends Control

var story_scene := load("res://main_menu/story.tscn")
var credits_scene := load("res://main_menu/credits.tscn")

func _on_play_pressed():
	var err := SceneSwitcher.switch("res://ingame/ingame.tscn")
	assert(err == OK)

func _on_story_pressed():
	var err := SceneSwitcher.switch_to(story_scene)
	assert(err == OK)

func _on_credits_pressed():
	var err := SceneSwitcher.switch_to(credits_scene)
	assert(err == OK)

func _on_quit_pressed():
	get_tree().quit()
