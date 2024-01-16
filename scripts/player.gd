extends CharacterBody2D

@onready var tile_map = $"../map1/TileMap"
@onready var animated_sprite = $AnimatedSprite2D
@export var speed = 125

func _physics_process(delta):
	
	var directionX = 0
	var directionY = 0
	
	directionX = Input.get_axis("left", "right")
	directionY = Input.get_axis("up", "down")
	
	if directionX != 0:
		animated_sprite.flip_h = (directionX == -1)
		
	velocity.x = directionX * speed
	velocity.y = directionY * speed
	update_animations(directionX, directionY)
	move_and_slide()
	

func update_animations(directionX, directionY):
	if(directionX == 0 && directionY == 0 ):
		animated_sprite.play("idle")
	else: 
		animated_sprite.play("run")
		
		
	
