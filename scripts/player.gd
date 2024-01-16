extends CharacterBody2D

@onready var tile_map = $"../map1/TileMap"

func _physics_process(delta):
	velocity = Vector2(0,0)
	if Input.is_action_pressed("up"):
		velocity.y = -200
	if Input.is_action_pressed("down"):
		velocity.y = 200
	if Input.is_action_pressed("right"):
		velocity.x = 200
	if Input.is_action_pressed("left"):
		velocity.x = -200
		
	move_and_slide()
	
	#global_position = global_position.clamp(Vector2(0,0), scree)
		

		
	
