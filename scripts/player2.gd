extends CharacterBody2D


@onready var animated_sprite = $AnimatedSprite2D
@onready var on_floor = true
@onready var attack_timer = $AttackTimer2
@onready var health_bar = $AnimatedSprite2D/HealthBar

@export var jumpSpeed = 125
@export var normalSpeed = 80
@export var enemy: Node2D
@export var health = 100
@onready var sound_effects = $SoundEffects
@onready var sound_effects_2 = $SoundEffects2


signal healthChanged
var save_file
var my_timer : Timer
var damage
var attack = true
var player_alive = true
@export var has_key = false
var movementEnabled = true

func _ready():
	enemy = null
	save_file = Global.get_global_data()
	damage = save_file.player_default_damage
	health = save_file.player_default_health
	
	
func _physics_process(delta):
	health_bar.update(health)
	var directionX = 0
	var directionY = 0
	var speed = normalSpeed
	var jump = false
	
	
	if player_alive and movementEnabled:
		
		directionX = Input.get_axis("left2", "right2")
		directionY = Input.get_axis("up2", "down2")
		if Input.is_action_pressed("jump2"):
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
	
	if (Input.is_action_just_pressed("attack2") && attack && enemy != null):
		sound_effects.play()
		attack_timer.start()
		enemy.takeDamage(damage)
		attack = false
		
	move_and_slide()


func update_animations(directionX, directionY, jump):
	
	if save_file.level_num == 1:
		if(health <= 0):
			if player_alive:
				player_alive = false
				animated_sprite.play("die0")
				die()
		elif(attack == false):
			animated_sprite.play("attack0")
		elif(jump == true):
			animated_sprite.play("jump0")
			get_tree().create_timer(1.0).timeout
		elif(directionX == 0 && directionY == 0):
			animated_sprite.play("idle0")
		elif (directionX != 0 || directionY != 0): 
			animated_sprite.play("run0")
			
	elif save_file.level_num == 2:
		if(health <= 0):
			if player_alive:
				player_alive = false
				animated_sprite.play("die0")
				die()
		elif(attack == false):
			animated_sprite.play("attack1")
		elif(jump == true):
			animated_sprite.play("jump1")
			get_tree().create_timer(1.0).timeout
		elif(directionX == 0 && directionY == 0):
			animated_sprite.play("idle1")
		elif (directionX != 0 || directionY != 0): 
			animated_sprite.play("run1")
	else:
		if(health <= 0):
			if player_alive:
				player_alive = false
				animated_sprite.play("die0")
				die()
		elif(attack == false):
			animated_sprite.play("attack2")
		elif(jump == true):
			animated_sprite.play("jump2")
			get_tree().create_timer(1.0).timeout
		elif(directionX == 0 && directionY == 0):
			animated_sprite.play("idle2")
		elif (directionX != 0 || directionY != 0): 
			animated_sprite.play("run2")
			
func add_health(amount: int):
	health += amount
	
func takeDamage(amount: int):
	damageIndicator()
	health -= amount
	healthChanged.emit()

func get_global_pos():
	return global_position
	
func get_health():
	return health
	
func collect_key():
	has_key = true
	print("key collected")
	
func has_keyy():
	return has_key


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

func die():
	sound_effects_2.play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/gameOverScreen.tscn")

func damageIndicator():
	$PointLight2D.visible = false
	$PointLight2D2.visible = false
	await get_tree().create_timer(0.2).timeout
	$PointLight2D.visible = true
	$PointLight2D2.visible = true
	
func disableMovement(disable: bool):
	if disable == true:
		movementEnabled = false
	else:
		movementEnabled = true
