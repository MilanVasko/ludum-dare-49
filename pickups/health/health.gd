extends Area2D

export(int) var health_amount: int

func _on_body_entered(body: Node) -> void:
	if body != null && body.has_method("_on_health_picked_up"):
		if body._on_health_picked_up(health_amount):
			queue_free()
