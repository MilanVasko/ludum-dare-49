extends KinematicBody2D

func _on_area_wifi_zone_entered(_area_id: int, area: Area2D, _area_shape: int, _local_shape: int) -> void:
	if area.has_method("_on_wifi_zone_entered"):
		area._on_wifi_zone_entered()

func _on_area_wifi_zone_exited(_area_id: int, area: Area2D, _area_shape: int, _local_shape: int) -> void:
	if area.has_method("_on_wifi_zone_exited"):
		area._on_wifi_zone_exited()
