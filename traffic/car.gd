extends RigidBody2D

export(float) var player_impact_coefficient: float

signal collided_with_player

func _on_player_collided(collision: KinematicCollision2D) -> void:
	mode = RigidBody2D.MODE_RIGID
	apply_central_impulse(-collision.normal * player_impact_coefficient)
	emit_signal("collided_with_player")
