extends PathFollow2D

export(float) var min_v_offset: float
export(float) var max_v_offset: float
export(float) var speed: float

func _ready():
	randomize()
	v_offset = rand_range(min_v_offset, max_v_offset)

func _physics_process(delta: float) -> void:
	offset += speed * delta

func _on_car_blown_up():
	set_physics_process(false)
