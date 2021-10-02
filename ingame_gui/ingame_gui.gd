extends Control

onready var aborting_container := $Aborting
onready var aborting_seconds_remaining := $Aborting/SecondsRemaining
onready var download_progress_bar := $DownloadProgressBar

func _on_download_resumed() -> void:
	set_download_active(true)

func _on_download_stopped() -> void:
	set_download_active(false)

func set_download_active(active: bool) -> void:
	download_progress_bar.visible = true
	download_progress_bar.modulate = Color.white if active else Color.darkgray
	aborting_container.visible = !active

func _on_abort_time_advanced(current_abort_seconds: float, _seconds_to_abort: float) -> void:
	aborting_seconds_remaining.text = str(int(current_abort_seconds))
	#print("_on_abort_time_advanced(" + str(current_abort_seconds) + ", " + str(seconds_to_abort) + ")")

func _on_current_download_time_advanced(current_download_time_seconds: float, total_download_time_seconds: float) -> void:
	download_progress_bar.value = (current_download_time_seconds / total_download_time_seconds) * download_progress_bar.max_value
	#print("_on_current_download_time_advanced(" + str(current_download_time_seconds) + ", " + str(total_download_time_seconds) + ")")

