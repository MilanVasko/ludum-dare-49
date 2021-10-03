extends Sprite

var textures = [
	preload("res://trees/tree1.png"),
	preload("res://trees/tree2.png")
]

export(Array) var colors: Array

func _ready():
	texture = textures[randi() % textures.size()]
	rotation = rand_range(0, PI * 2)
	scale = scale * rand_range(0.9, 1.2)
	modulate = colors[randi() % colors.size()]
