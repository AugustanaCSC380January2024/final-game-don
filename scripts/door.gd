extends StaticBody2D

@onready var sprite_2d = $Sprite2D
@onready var collision_shape = $Area2D
var player 
@onready var selfDoor = $CollisionShape2D


func _on_area_2d_body_entered(body):
	if body is CharacterBody2D and body != self and not (body is Enemy):
		player = body
		if player.has_keyy() == true:
			if player.global_position.y > selfDoor.global_position.y:
				player.global_position.y = player.global_position.y - 100
			else:
				player.global_position.y = player.global_position.y + 100

func _on_area_2d_body_exited(body):
	if body is CharacterBody2D and body != self and not (body is Enemy):
		player = null
