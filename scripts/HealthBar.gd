extends Node2D

@onready var bar_sprite = $BarSprite
@export var character: CharacterBody2D

func _ready():
	character.healthChanged.connect(update)
	update()

func update():
	var value = character.health
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
