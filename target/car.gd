extends KinematicBody2D

export(NodePath) var path_path
export(float) var speed: float

onready var path: Path2D = get_node(path_path)
var offset: float = 0.0
var lookahead: float = 4.0
var desired_offset = null

func _on_area_wifi_zone_entered(_area_id: int, area: Area2D, _area_shape: int, _local_shape: int) -> void:
	if area != null && area.has_method("_on_wifi_zone_entered"):
		area._on_wifi_zone_entered()

func _on_area_wifi_zone_exited(_area_id: int, area: Area2D, _area_shape: int, _local_shape: int) -> void:
	if area != null && area.has_method("_on_wifi_zone_exited"):
		area._on_wifi_zone_exited()

# Much of this code is taken from Godot's source code for PathFollow2D

func _physics_process(delta: float) -> void:
	if path == null:
		return

	var c := path.curve
	var path_length := c.get_baked_length()
	if path_length == 0:
		return

	if desired_offset != null:
		offset = desired_offset
		desired_offset = null
	else:
		offset = fmod(offset + speed * delta, path_length)

	var pos := c.interpolate_baked(offset, true)
	var ahead := offset + lookahead

	if ahead >= path_length:
		var point_count := c.get_point_count()
		if point_count > 0:
			var start_point := c.get_point_position(0)
			var end_point := c.get_point_position(point_count - 1)
			if start_point == end_point:
				# Since the path is closed we want to 'smooth off'
				# the corner at the start/end.
				# So we wrap the lookahead back round.
				ahead = fmod(ahead, path_length)

	var ahead_pos := c.interpolate_baked(ahead, true)

	var tangent_to_curve: Vector2
	if ahead_pos == pos:
		# This will happen at the end of non-looping or non-closed paths.
		# We'll try a look behind instead, in order to get a meaningful angle.
		tangent_to_curve = (pos - c.interpolate_baked(offset - lookahead, true)).normalized();
	else:
		tangent_to_curve = (ahead_pos - pos).normalized()

	rotation = tangent_to_curve.angle()
	var _velocity := move_and_slide((pos - position) / delta)

	for index in get_slide_count():
		var collision := get_slide_collision(index)
		var collider := collision.collider

		if collider != null && collider.has_method("_on_target_collided"):
			collider._on_target_collided(collision)

