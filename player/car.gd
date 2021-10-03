extends KinematicBody2D

# credit goes to https://kidscancode.org/godot_recipes/2d/car_steering/

onready var driver := $Driver
onready var camera := $Camera2D
onready var audio_player := $AudioStreamPlayer2D

var wheel_base: float = 250
var steering_angle: float = 20
var engine_power: float = 7000
var friction: float = -0.9
var drag: float = -0.001
var braking: float = 4000
var max_speed_reverse: float = 1000
var slip_speed: float = 2000
var traction_fast: float = 0.1
var traction_slow: float = 0.7

var acceleration := Vector2.ZERO
var velocity := Vector2.ZERO
var steer_direction := 0.0
var desired_lookat_position = null

signal car_collided
signal got_shot

func _on_health_picked_up(health_amount: int) -> bool:
	return driver._on_health_picked_up(health_amount)

func _physics_process(delta: float) -> void:
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)
	camera.adjust_zoom_by_velocity(velocity)
	adjust_sound_by_velocity(velocity)

	var collided := false
	for index in get_slide_count():
		var collision := get_slide_collision(index)
		collided = true
		var collider := collision.collider

		if collider != null && collider.has_method("_on_player_collided"):
			collider._on_player_collided(collision)
	if collided:
		emit_signal("car_collided")

func adjust_sound_by_velocity(v: Vector2) -> void:
	var base_volume = -60.0
	var volume = base_volume + (v.length() / (engine_power / 3.5)) * 60
	audio_player.volume_db = volume

# this is needed because Kinematic body apparently can't detect RigidBody2D,
# so RigidBody2D needs to notify us (after the traffic car is blown up)
func collided_with_blown_up_traffic_car(_traffic_car: RigidBody2D) -> void:
	emit_signal("car_collided")

func collided_with_rock(_rock: RigidBody2D) -> void:
	emit_signal("car_collided")

func do_get_shot() -> void:
	emit_signal("got_shot")

func get_input() -> void:
	var turn := Input.get_action_strength("steer_right") - Input.get_action_strength("steer_left")
	steer_direction = turn * deg2rad(steering_angle)
	var forward_direction := Input.get_action_strength("accelerate") - Input.get_action_strength("brake")
	var acceleration_speed := engine_power if forward_direction > 0.0 else braking
	acceleration = transform.x * forward_direction * acceleration_speed

func apply_friction() -> void:
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force := velocity * friction
	var drag_force := velocity * velocity.length() * drag
	acceleration += drag_force + friction_force

func calculate_steering(delta: float) -> void:
	var rear_wheel := position - transform.x * wheel_base / 2.0
	var front_wheel := position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var traction := traction_fast if velocity.length() > slip_speed else traction_slow

	var new_heading := (front_wheel - rear_wheel).normalized()
	var d := new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction * delta)
	elif d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)

	if desired_lookat_position != null:
		look_at(desired_lookat_position)
		desired_lookat_position = null
	else:
		rotation = new_heading.angle()
