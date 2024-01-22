extends StaticBody2D 

@export var item_1: Node2D
@export var item_2: Node2D
@export var item_3: Node2D
@export var item_4: Node2D
@export var item_5: Node2D
var player

func _ready():
	pass

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D and body != self and not (body is Enemy):
		player = body
		player.collect_key()
		


func _on_area_2d_body_exited(body):
	if body is CharacterBody2D and body != self and not (body is Enemy):
		player = null
