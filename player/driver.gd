extends Node2D

var health: int
var immortality_seconds_remaining: float

export(int) var start_health: int
export(int) var damage_on_collision: int
export(int) var damage_on_shot: int
export(float) var seconds_to_be_immortal: float

signal immortality_started
signal immortality_ended

func _ready() -> void:
	set_health(start_health)
	immortality_seconds_remaining = -1.0

func _process(delta: float) -> void:
	if immortality_seconds_remaining > 0.0:
		immortality_seconds_remaining -= delta
		if immortality_seconds_remaining <= 0.0:
			emit_signal("immortality_ended")

func _on_health_picked_up(health_amount: int) -> bool:
	if health >= start_health:
		return false
	set_health(health + health_amount)
	return true

func _on_player_car_collided() -> void:
	if immortality_seconds_remaining > 0.0:
		return
	take_damage(damage_on_collision)

func _on_player_got_shot() -> void:
	if immortality_seconds_remaining > 0.0:
		return
	take_damage(damage_on_shot)

func take_damage(damage: int) -> void:
	set_health(health - damage)
	immortality_seconds_remaining = seconds_to_be_immortal
	emit_signal("immortality_started")
	if health <= 0:
		get_tree().call_group("player_health_subscriber", "_on_player_died")
	else:
		get_tree().call_group("player_health_subscriber", "_on_player_health_changed", health, start_health)

func set_health(new_health: int) -> void:
	health = new_health
	get_tree().call_group("player_health_subscriber", "_on_player_health_changed", health, start_health)
