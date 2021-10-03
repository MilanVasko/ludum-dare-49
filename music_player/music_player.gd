extends AudioStreamPlayer

export(AudioStream) var ingame_intro: AudioStream
export(AudioStream) var ingame_variation1: AudioStream
export(AudioStream) var ingame_variation2: AudioStream
export(AudioStream) var ingame_variation3: AudioStream

func _ready():
	randomize()
	handle_scene(get_tree().current_scene.name)

func _on_scene_switched() -> void:
	handle_scene(get_tree().current_scene.name)

func handle_scene(scene_name: String) -> void:
	#print("Switched to " + scene_name)
	if scene_name == "Ingame":
		stream = ingame_intro
		play()

func _on_music_finished() -> void:
	if stream == ingame_intro:
		stream = ingame_variation1
		play()
		return
	var which = randi() % 3
	match which:
		0: stream = ingame_variation1
		1: stream = ingame_variation2
		2: stream = ingame_variation3
	play()
