extends Sprite

export(Color) var immortality_color: Color
export(Color) var mortality_color: Color

func _on_driver_immortality_started():
	modulate = immortality_color

func _on_driver_immortality_ended():
	modulate = mortality_color
