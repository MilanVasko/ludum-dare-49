extends Control

onready var aborting_container := $Aborting
onready var aborting_seconds_remaining := $Aborting/SecondsRemaining
onready var download_progress_bar := $DownloadProgressBar
onready var download_failed := $DownloadFailed
onready var download_succeeded := $DownloadSucceeded

func _ready():
	download_failed.visible = false
	download_succeeded.visible = false

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

func _on_current_download_time_advanced(current_download_time_seconds: float, total_download_time_seconds: float) -> void:
	download_progress_bar.value = (current_download_time_seconds / total_download_time_seconds) * download_progress_bar.max_value

func _on_download_finished() -> void:
	download_succeeded.visible = true
	download_progress_bar.value = download_progress_bar.max_value

func _on_download_failed() -> void:
	download_failed.visible = true

func _on_retry_pressed():
	var err = get_tree().reload_current_scene()
	assert(err == OK)
