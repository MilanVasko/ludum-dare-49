extends Node2D

func _ready():
	unpause()

func _exit_tree():
	unpause()

func _on_download_failed() -> void:
	pause()

func _on_download_finished() -> void:
	pause()

func _on_player_died() -> void:
	pause()

func pause() -> void:
	Engine.time_scale = 0.0

func unpause() -> void:
	Engine.time_scale = 1.0
