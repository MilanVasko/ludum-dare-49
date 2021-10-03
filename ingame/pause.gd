extends Node2D

enum PauseReason {
	DOWNLOAD_FAILED,
	DOWNLOAD_FINISHED,
	PLAYER_DIED,
	PAUSE_REQUESTED,
	FORCE_UNPAUSE
}

var pause_reason = null

func _ready():
	unpause(PauseReason.FORCE_UNPAUSE)

func _exit_tree():
	unpause(PauseReason.FORCE_UNPAUSE)

func _on_download_failed() -> void:
	pause(PauseReason.DOWNLOAD_FAILED)

func _on_download_finished() -> void:
	pause(PauseReason.DOWNLOAD_FINISHED)

func _on_player_died() -> void:
	pause(PauseReason.PLAYER_DIED)

func pause(reason: int) -> void:
	var tree := get_tree()
	if tree == null:
		return
	tree.paused = true
	pause_reason = reason
	if reason == PauseReason.PAUSE_REQUESTED:
		get_tree().call_group("pause_subscriber", "_on_player_paused")
		return

func unpause(reason: int) -> void:
	var tree := get_tree()
	if tree == null:
		return
	if reason == PauseReason.FORCE_UNPAUSE:
		tree.paused = false
		pause_reason = null
		return
	if reason == PauseReason.PAUSE_REQUESTED && reason == pause_reason:
		tree.paused = false
		pause_reason = null
		get_tree().call_group("pause_subscriber", "_on_player_unpaused")
		return

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("pause"):
			toggle(PauseReason.PAUSE_REQUESTED)

func toggle(reason: int) -> void:
	if get_tree().paused:
		unpause(reason)
	else:
		pause(reason)
