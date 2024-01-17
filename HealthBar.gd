extends CanvasLayer

@onready var bar_sprite = $BarSprite
@export var character: CharacterBody2D

func _ready():
	character.healthChanged.connect(update)
	update()

func update():
	var value = character.health
	print(value)
	if value == 100:
		bar_sprite.set_frame_coords(Vector2i(0, 4))
	if value < 75:
		bar_sprite.set_frame_coords(Vector2i(1, 4))
	if value < 50:
		bar_sprite.set_frame_coords(Vector2i(2, 4))
	if value < 25:
		bar_sprite.set_frame_coords(Vector2i(3, 4))
	if value < 10:
		bar_sprite.set_frame_coords(Vector2i(5, 4))
