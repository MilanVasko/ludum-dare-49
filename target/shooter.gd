extends Node2D

export(float) var aiming_speed: float
export(float) var min_firing_delay: float
export(float) var max_firing_delay: float

var focused_player: Node2D = null
var current_firing_delay := 0.0
onready var gun = $Gun

func _process(delta: float) -> void:
	if focused_player == null:
		gun.visible = false
		return
	gun.visible = true
	var gun_position = gun.global_position
	var focused_player_position = focused_player.global_position

	var target_rotation = (focused_player_position - gun_position).angle()
	gun.global_rotation = lerp_angle(gun.global_rotation, target_rotation, clamp(delta * aiming_speed, 0, 1))

	current_firing_delay -= delta
	if current_firing_delay <= 0.0:
		current_firing_delay = rand_range(min_firing_delay, max_firing_delay)
		gun.fire()

func _on_body_entered(body: Node2D) -> void:
	if focused_player == null && body.is_in_group("player"):
		focused_player = body
		current_firing_delay = rand_range(min_firing_delay, max_firing_delay)

func _on_body_exited(body: Node2D) -> void:
	if focused_player == body:
		focused_player = null
