extends StaticBody2D

var player = null


func _physics_process(delta):
	if player != null and visible == true:
		if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("interact2"):
			$SoundEffect.play()
			player.add_heal(50)
			await get_tree().create_timer(1).timeout
			queue_free()

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D and body != self and not (body is Enemy):
		player = body
	

func _on_area_2d_body_exited(body):
	if body is CharacterBody2D and body != self and not (body is Enemy):
		player = null

