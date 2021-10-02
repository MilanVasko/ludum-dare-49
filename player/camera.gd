extends Camera2D

export(float) var length_divisor: float
export(float) var zoom_change_speed: float

var base_zoom: Vector2
var current_zoom_level := 0.0
var target_zoom_level: float

func _ready() -> void:
	base_zoom = zoom

func _process(delta: float) -> void:
	current_zoom_level = lerp(current_zoom_level, target_zoom_level, clamp(delta * zoom_change_speed, 0.0, 1.0))
	zoom = base_zoom + Vector2.ONE * current_zoom_level

func adjust_zoom_by_velocity(velocity: Vector2) -> void:
	target_zoom_level = velocity.length() / length_divisor
