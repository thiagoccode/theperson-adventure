extends Node2D

func _ready():
	var screen_size = get_viewport_rect().size
	var sprite = $Sprite2D
	sprite.position = screen_size / 2
