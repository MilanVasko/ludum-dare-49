extends Area2D

export(float) var download_time_seconds: float
export(float) var seconds_to_abort: float

var current_download_time_seconds := 0.0
onready var current_abort_seconds = seconds_to_abort
var about_to_abort := true

func _process(delta: float) -> void:
	if about_to_abort:
		current_abort_seconds -= delta
		if current_abort_seconds <= 0.0:
			get_tree().call_group("download_state_subscriber", "_on_download_failed")
			set_process(false)
		else:
			get_tree().call_group("download_state_subscriber", "_on_abort_time_advanced", current_abort_seconds, seconds_to_abort)
	else:
		current_download_time_seconds += delta
		if current_download_time_seconds >= download_time_seconds:
			get_tree().call_group("download_state_subscriber", "_on_download_finished")
			set_process(false)
		else:
			get_tree().call_group("download_state_subscriber", "_on_current_download_time_advanced", current_download_time_seconds, download_time_seconds)

func _on_wifi_zone_entered() -> void:
	if !is_processing():
		return
	about_to_abort = false
	current_abort_seconds = seconds_to_abort
	get_tree().call_group("download_state_subscriber", "_on_download_resumed")

func _on_wifi_zone_exited() -> void:
	if !is_processing():
		return
	about_to_abort = true
	get_tree().call_group("download_state_subscriber", "_on_download_stopped")
