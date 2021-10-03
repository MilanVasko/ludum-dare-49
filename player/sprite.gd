extends Node2D

export(Color) var immortality_color: Color
export(Color) var mortality_color: Color
onready var background := $Background

func _on_driver_immortality_started():
	background.modulate = immortality_color

func _on_driver_immortality_ended():
	background.modulate = mortality_color
