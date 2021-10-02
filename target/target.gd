extends KinematicBody2D

export(NodePath) var path_path

onready var path: Path2D = get_node(path_path)
var offset: float = 0.0 setget set_offset,get_offset
var h_offset: float = 0.0 setget set_h_offset,get_h_offset
var v_offset: float = 0.0 setget set_v_offset,get_v_offset
var lookahead: float = 4.0 setget set_lookahead,get_lookahead
var cubic: bool = true
var loop: bool = true
var rotate: bool = true

func _on_area_wifi_zone_entered(_area_id: int, area: Area2D, _area_shape: int, _local_shape: int) -> void:
	if area != null && area.has_method("_on_wifi_zone_entered"):
		area._on_wifi_zone_entered()

func _on_area_wifi_zone_exited(_area_id: int, area: Area2D, _area_shape: int, _local_shape: int) -> void:
	if area != null && area.has_method("_on_wifi_zone_exited"):
		area._on_wifi_zone_exited()

func _physics_process(delta: float) -> void:
	if path == null:
		return

	var c := path.get_curve()

	var path_length := c.get_baked_length()
	if path_length == 0:
		return

	offset = fmod(offset + 2000 * delta, path_length)

	var pos := c.interpolate_baked(offset, cubic)

	if rotate:
		var ahead := offset + lookahead

		if loop && ahead >= path_length:
			# If our lookahead will loop, we need to check if the path is closed.
			var point_count := c.get_point_count()
			if point_count > 0:
				var start_point := c.get_point_position(0)
				var end_point := c.get_point_position(point_count - 1)
				if start_point == end_point:
					# Since the path is closed we want to 'smooth off'
					# the corner at the start/end.
					# So we wrap the lookahead back round.
					ahead = fmod(ahead, path_length)

		var ahead_pos := c.interpolate_baked(ahead, cubic)

		var tangent_to_curve: Vector2
		if ahead_pos == pos:
			# This will happen at the end of non-looping or non-closed paths.
			# We'll try a look behind instead, in order to get a meaningful angle.
			tangent_to_curve = (pos - c.interpolate_baked(offset - lookahead, cubic)).normalized();
		else:
			tangent_to_curve = (ahead_pos - pos).normalized()

		var normal_of_curve := -tangent_to_curve.tangent()

		pos += tangent_to_curve * h_offset
		pos += normal_of_curve * v_offset

		set_rotation(tangent_to_curve.angle())

	else:
		pos.x += h_offset;
		pos.y += v_offset;

	move_and_slide((pos - position) / delta)

	for index in get_slide_count():
		var collision := get_slide_collision(index)
		var collider := collision.collider

		if collider != null && collider.has_method("_on_player_collided"):
			collider._on_player_collided(collision)

func set_cubic_interpolation(p_enable: bool) -> void:
	cubic = p_enable

func get_cubic_interpolation() -> bool:
	return cubic

func get_configuration_warning() -> String:
	if !is_visible_in_tree() || !is_inside_tree():
		return ""

	var warning := get_configuration_warning()
	if get_parent() == null:
		if warning != "":
			warning += "\n\n"
		warning += "PathFollow2D only works when set as a child of a Path2D node."

	return warning

func set_offset(p_offset: float) -> void:
	offset = p_offset
	if path != null:
		var path_length := path.get_curve().get_baked_length()

		if loop != null:
			offset = fposmod(offset, path_length)
			if !is_zero_approx(p_offset) && is_zero_approx(offset):
				offset = path_length
		else:
			offset = clamp(offset, 0, path_length)

		#_update_transform()

func set_h_offset(p_h_offset: float) -> void:
	h_offset = p_h_offset
	if path != null:
		pass#_update_transform()

func get_h_offset() -> float:
	return h_offset

func set_v_offset(p_v_offset: float) -> void:
	v_offset = p_v_offset
	if path != null:
		pass#_update_transform()

func get_v_offset() -> float:
	return v_offset

func get_offset() -> float:
	return offset

func set_unit_offset(p_unit_offset: float) -> void:
	if path != null && path.get_curve().is_valid() && path.get_curve().get_baked_length():
		set_offset(p_unit_offset * path.get_curve().get_baked_length())

func get_unit_offset() -> float:
	if path != null && path.get_curve().is_valid() && path.get_curve().get_baked_length():
		return get_offset() / path.get_curve().get_baked_length()
	else:
		return 0.0

func set_lookahead(p_lookahead: float) -> void:
	lookahead = p_lookahead;

func get_lookahead() -> float:
	return lookahead;

func set_rotate(p_rotate: bool) -> void:
	rotate = p_rotate
	#_update_transform()

func is_rotating() -> bool:
	return rotate

func set_loop(p_loop: bool) -> void:
	loop = p_loop

func has_loop() -> bool:
	return loop

