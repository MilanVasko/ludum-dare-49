extends Area2D

var current_download_time_seconds := 0.0
var total_download_time_seconds = 30.0
var current_abort_seconds = 0.0
var seconds_to_abort = 10.0
var about_to_abort := false

func _process(delta: float) -> void:
	if about_to_abort:
		current_abort_seconds -= delta
		get_tree().call_group("download_state_subscriber", "_on_abort_time_advanced", current_abort_seconds, seconds_to_abort)
	else:
		current_download_time_seconds += delta
		get_tree().call_group("download_state_subscriber", "_on_current_download_time_advanced", current_download_time_seconds, total_download_time_seconds)

func _on_wifi_zone_entered() -> void:
	about_to_abort = false
	current_abort_seconds = seconds_to_abort
	get_tree().call_group("download_state_subscriber", "_on_download_resumed")

func _on_wifi_zone_exited() -> void:
	about_to_abort = true
	get_tree().call_group("download_state_subscriber", "_on_download_stopped")
