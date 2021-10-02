extends Node2D

func _ready():
	Engine.time_scale = 1.0

func _on_download_failed() -> void:
	Engine.time_scale = 0.0

func _on_download_finished() -> void:
	Engine.time_scale = 0.0
