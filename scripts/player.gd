extends CharacterBody2D

@onready var tile_map = $"../map1/TileMap"
@onready var animated_sprite = $AnimatedSprite2D
@onready var on_floor = true
@onready var attack_timer = $AttackTimer2

@export var jumpSpeed = 125
@export var normalSpeed = 80
@export var enemy: Node2D
@export var damage = 25
@export var maxHealth = 100

signal healthChanged

var my_timer : Timer
var health = 100
var attack = true

func _ready():
	enemy = null
	
	
func _physics_process(delta):
	
	var directionX = 0
	var directionY = 0
	var speed = normalSpeed
	var jump = false
	
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
	
	if (Input.is_action_just_pressed("attack") && attack && enemy != null):
		attack_timer.start()
		enemy.takeDamage(damage)
		attack = false
		
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
	if health < 0:
		get_tree().change_scene_to_file("res://scenes/gameOverScreen.tscn")
	else:
		health -= amount
		healthChanged.emit()
	
#notes, timer works but it seems like there is not enough time for the animation to play
func _on_timer_timeout():
	on_floor = true

func _on_attack_area_body_entered(body):
	if body is CharacterBody2D and body != self:
		enemy = body
		
		
func _on_attack_area_body_exited(body):
	if body is CharacterBody2D and body != self:
		enemy = null


func _on_attack_timer_2_timeout():
	attack = true
	
