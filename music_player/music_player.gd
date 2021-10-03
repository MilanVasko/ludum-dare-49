extends AudioStreamPlayer

var current_scene: String = ""
export(AudioStream) var ingame_intro: AudioStream
export(AudioStream) var ingame_variation1: AudioStream
export(AudioStream) var ingame_variation2: AudioStream
export(AudioStream) var ingame_variation3: AudioStream

func _ready():
	handle_scene(get_tree().current_scene.name)

func _on_scene_switched() -> void:
	handle_scene(get_tree().current_scene.name)

func handle_scene(scene_name: String) -> void:
	#print("Switched to " + scene_name)
	current_scene = scene_name
	match current_scene:
		"Ingame":
			stream = ingame_intro
			play()
		_:
			stop()

func _on_music_finished() -> void:
	match current_scene:
		"Ingame":
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
