extends Node2D

@onready var bar_sprite = $BarSprite


func update(health_val:int):
	var value = health_val
	if value == 100:
		bar_sprite.set_frame_coords(Vector2i(0, 3))
	if value < 75:
		bar_sprite.set_frame_coords(Vector2i(1, 3))
	if value < 50:
		bar_sprite.set_frame_coords(Vector2i(2, 3))
	if value < 25:
		bar_sprite.set_frame_coords(Vector2i(3, 3))
	if value < 10:
		bar_sprite.set_frame_coords(Vector2i(5, 3))
