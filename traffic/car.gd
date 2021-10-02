extends RigidBody2D

export(float) var player_impact_coefficient: float

signal blown_up

func _on_target_collided(collision: KinematicCollision2D) -> void:
	blow_up(collision)

func _on_player_collided(collision: KinematicCollision2D) -> void:
	blow_up(collision)

func blow_up(collision: KinematicCollision2D) -> void:
	mode = RigidBody2D.MODE_RIGID
	apply_central_impulse(-collision.normal * player_impact_coefficient)
	emit_signal("blown_up")
	$Sprite.texture = preload("res://traffic/car_damaged.png")

func _on_body_entered(body: Node) -> void:
	if body.has_method("collided_with_blown_up_traffic_car"):
		body.collided_with_blown_up_traffic_car(self)
