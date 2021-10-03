extends Control

var win_sounds = [
	preload("res://ingame_gui/sounds/win1.wav")
]

var lose_sounds = [
	preload("res://ingame_gui/sounds/lose1.wav"),
	preload("res://ingame_gui/sounds/lose2.wav"),
	preload("res://ingame_gui/sounds/lose3.wav")
]

onready var aborting_container := $Aborting
onready var aborting_seconds_remaining := $Aborting/SecondsRemaining
onready var download_progress_bar := $DownloadProgressBar
onready var download_failed := $DownloadFailed
onready var download_succeeded := $DownloadSucceeded
onready var player_died := $PlayerDied
onready var health_label := $Health/Label
onready var pause_menu := $PauseMenu
onready var audio_player := $AudioStreamPlayer

func _ready() -> void:
	aborting_container.visible = true
	download_failed.visible = false
	download_succeeded.visible = false
	player_died.visible = false
	pause_menu.visible = false

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
	play_win_sound()
	download_succeeded.visible = true
	download_progress_bar.value = download_progress_bar.max_value

func _on_download_failed() -> void:
	play_lose_sound()
	download_failed.visible = true

func _on_player_died() -> void:
	play_lose_sound()
	player_died.visible = true
	set_download_active(false)

func _on_player_paused() -> void:
	pause_menu.visible = true

func _on_player_unpaused() -> void:
	pause_menu.visible = false

func _on_retry_pressed() -> void:
	var err = get_tree().reload_current_scene()
	assert(err == OK)

func _on_player_health_changed(health: int, _full_health: int) -> void:
	health_label.text = str(health)

func _on_main_menu_pressed() -> void:
	var err = SceneSwitcher.switch("res://main_menu/main_menu.tscn")
	assert(err == OK)

func play_win_sound() -> void:
	audio_player.stream = win_sounds[randi() % win_sounds.size()]
	audio_player.play()

func play_lose_sound() -> void:
	audio_player.stream = lose_sounds[randi() % lose_sounds.size()]
	audio_player.play()
