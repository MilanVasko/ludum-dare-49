extends RigidBody2D

var textures = [
	preload("res://pickups/rock/rock1.png"),
	preload("res://pickups/rock/rock2.png")
]

func _ready():
	randomize()
	$Sprite.texture = textures[randi() % textures.size()]

func _on_body_entered(body: Node) -> void:
	if body.has_method("collided_with_rock"):
		body.collided_with_rock(self)
