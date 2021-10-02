extends Path2D

var speed := 2000.0
onready var path_follow := $PathFollow2D

func _physics_process(delta: float) -> void:
	path_follow.offset += speed * delta
