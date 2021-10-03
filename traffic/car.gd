extends RigidBody2D

var explosions = [
	preload("res://traffic/sounds/explosion0.wav"),
	preload("res://traffic/sounds/explosion1.wav"),
	preload("res://traffic/sounds/explosion2.wav"),
	preload("res://traffic/sounds/explosion3.wav"),
	preload("res://traffic/sounds/explosion4.wav")
]

export(float) var player_impact_coefficient: float
onready var explosion_player: AudioStreamPlayer2D = $ExplosionPlayer2D

signal blown_up

func _ready():
	randomize()

func _on_target_collided(collision: KinematicCollision2D) -> void:
	blow_up(collision)

func _on_player_collided(collision: KinematicCollision2D) -> void:
	blow_up(collision)

func blow_up(collision: KinematicCollision2D) -> void:
	mode = RigidBody2D.MODE_RIGID
	apply_central_impulse(-collision.normal * player_impact_coefficient)
	emit_signal("blown_up")
	$Sprite.texture = preload("res://traffic/car_damaged.png")
	explosion_player.stream = explosions[randi() % explosions.size()]
	explosion_player.play()

func _on_body_entered(body: Node) -> void:
	if body.has_method("collided_with_blown_up_traffic_car"):
		body.collided_with_blown_up_traffic_car(self)
