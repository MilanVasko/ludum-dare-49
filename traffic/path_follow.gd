extends PathFollow2D

var speed := 1000.0

func _physics_process(delta: float) -> void:
	offset += speed * delta
