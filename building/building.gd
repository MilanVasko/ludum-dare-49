extends Sprite

const MAX_ROTATION_ADJUSTMENT_DEGREES: float = 6.0

var textures = [
	preload("res://building/building.png"),
	preload("res://building/building2.png")
]

export(Array) var colors: Array

func _ready():
	texture = textures[randi() % textures.size()]
	var rotation_limit = deg2rad(MAX_ROTATION_ADJUSTMENT_DEGREES)
	rotate(rand_range(-rotation_limit, rotation_limit))
	if colors != null && !colors.empty():
		modulate = colors[randi() % colors.size()]
