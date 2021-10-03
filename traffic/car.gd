extends RigidBody2D

var explosions = [
	preload("res://traffic/sounds/explosion0.wav"),
	preload("res://traffic/sounds/explosion1.wav"),
	preload("res://traffic/sounds/explosion2.wav"),
	preload("res://traffic/sounds/explosion3.wav"),
	preload("res://traffic/sounds/explosion4.wav")
]

var bumps = [
	preload("res://traffic/sounds/bump1.wav"),
	preload("res://traffic/sounds/bump2.wav"),
	preload("res://traffic/sounds/bump3.wav"),
	preload("res://traffic/sounds/bump4.wav")
]

export(float) var player_impact_coefficient: float
onready var explosion_player: AudioStreamPlayer2D = $ExplosionPlayer2D
onready var bump_player: AudioStreamPlayer2D = $BumpPlayer2D
onready var honk_player: AudioStreamPlayer2D = $HonkPlayer2D

var current_honk_cooldown := 0.0
var min_honk_cooldown := 5.0
var max_honk_cooldown := 50.0

signal blown_up

func _ready():
	randomize()
	current_honk_cooldown = rand_range(0.0, max_honk_cooldown)

func _process(delta: float) -> void:
	current_honk_cooldown -= delta
	if current_honk_cooldown <= 0.0:
		current_honk_cooldown = rand_range(min_honk_cooldown, max_honk_cooldown)
		honk_player.play()

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
	set_process(false)
	if randf() > 0.5:
		honk_player.play()

func _on_body_entered(body: Node) -> void:
	bump_player.stream = bumps[randi() % bumps.size()]
	bump_player.play()

	if body.has_method("collided_with_blown_up_traffic_car"):
		body.collided_with_blown_up_traffic_car(self)
