extends AudioStreamPlayer

class_name MusicPlayer

export(AudioStream) var intro: AudioStream
export(AudioStream) var variation1: AudioStream
export(AudioStream) var variation2: AudioStream
export(AudioStream) var variation3: AudioStream

func _ready():
	randomize()
	stream = intro
	play()

func _on_music_finished():
	if stream == intro:
		stream = variation1
		play()
		return
	var which = randi() % 3
	match which:
		0: stream = variation1
		1: stream = variation2
		2: stream = variation3
	play()
