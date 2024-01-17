extends CharacterBody2D

@onready var tile_map = $"../map1/TileMap"
@onready var animated_sprite = $AnimatedSprite2D
@onready var on_floor = true
@export var jumpSpeed = 125
@export var normalSpeed = 80
var my_timer : Timer
var health = 0


func _ready():
	add_health(100)
	
	
func _physics_process(delta):
	
	var directionX = 0
	var directionY = 0
	var speed = normalSpeed
	var jump = false
	print(health)
	directionX = Input.get_axis("left", "right")
	directionY = Input.get_axis("up", "down")
	if Input.is_action_pressed("jump"):
		$Timer.start()
		speed = jumpSpeed
		jump = true
		on_floor = false
		
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
		get_tree().create_timer(1.0).timeout
	elif(directionX == 0 && directionY == 0):
		animated_sprite.play("idle")
	elif (directionX != 0 || directionY != 0): 
		animated_sprite.play("run")
	
func add_health(amount: int):
	health += amount
	
func remove_health(amount: int):
	health -= amount

#notes, timer works but it seems like there is not enough time for the animation to play
func _on_timer_timeout():
	on_floor = true
	

