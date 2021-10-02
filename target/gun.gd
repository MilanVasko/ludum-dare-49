extends RayCast2D

export(float) var bullet_path_visible_seconds: float
var current_bullet_path_visible_seconds := 0.0
onready var bullet_path = $BulletPath
onready var light = $Light2D

func _ready() -> void:
	bullet_path.visible = false
	light.visible = false

func _process(delta: float) -> void:
	if current_bullet_path_visible_seconds > 0.0:
		current_bullet_path_visible_seconds -= delta
		if current_bullet_path_visible_seconds <= 0.0:
			bullet_path.visible = false
			light.visible = false

func fire() -> void:
	print("Puff!")
	current_bullet_path_visible_seconds = bullet_path_visible_seconds
	bullet_path.visible = true
	light.visible = true

	var collider = get_collider()
	if collider != null && collider.has_method("do_get_shot"):
		collider.do_get_shot()
