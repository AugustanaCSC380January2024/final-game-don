extends CharacterBody2D

@onready var tile_map = $"../map1/TileMap"
@onready var animated_sprite = $AnimatedSprite2D

@export var jumpSpeed = 250
@export var normalSpeed = 125

func _physics_process(delta):
	
	var directionX = 0
	var directionY = 0
	var speed = normalSpeed
	var jump = false
	
	directionX = Input.get_axis("left", "right")
	directionY = Input.get_axis("up", "down")
	if Input.is_action_pressed("jump"):
		speed = jumpSpeed
		jump = true
		
	else:
		speed = normalSpeed
		jump = false
		
	
	if directionX != 0:
		animated_sprite.flip_h = (directionX == -1)
		
	velocity.x = directionX * speed
	velocity.y = directionY * speed
	
	update_animations(directionX, directionY, jump)
	move_and_slide()
	

func update_animations(directionX, directionY, jump):
	if(jump == true):
		animated_sprite.play("jump")
	elif(directionX == 0 && directionY == 0):
		animated_sprite.play("idle")
	elif (directionX != 0 || directionY != 0): 
		animated_sprite.play("run")
	
	

		
	
