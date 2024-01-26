extends CharacterBody2D

class_name Enemy
var speed = 150

var player_chase = true

@onready var save_file = Global.get_global_data()
@export var player: Node2D
@export var player2: Node2D


@onready var audio_stream_player = $AudioStreamPlayer
@onready var health_bar = $HealthBar

var health
var damage
var currentlyAttacking  = false
var enemy_alive = true
signal healthChanged

@onready var nav_agent:= $NavigationAgent2D as NavigationAgent2D
@onready var timer = $PathTimer
@onready var sound_effects = $SoundEffects

func _ready():
	
	damage = save_file.enemy_default_damage
	health = save_file.enemy_default_health
	
	
func _physics_process(_delta: float) -> void:
	
	player_chase = save_file.player_chase
	health_bar.update(health)
	
	#This portion looks for the next path and moves the enemy in that direction
	#Player chase keeps track of the enemy if is chasing or not
	if player_chase:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed

	else:
		velocity = Vector2.ZERO
	

	move_and_slide()
	
	#This code is not being used currently but I will use it in the future as a base for animation changes
	if save_file.level_num == 1:
		$AnimatedSprite2D
		if player_chase and enemy_alive:
			position += (player.position - position)/speed
			if currentlyAttacking == true:
				$AnimatedSprite2D.play("attack0")
			else:
				$AnimatedSprite2D.play("run0")
			
			if(player.position.x - position.x) <0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
		elif enemy_alive == false:
			$AnimatedSprite2D.play("die0")
		else:
			$AnimatedSprite2D.play("idle0")
	elif save_file.level_num == 2:
		if player_chase and enemy_alive:
			position += (player.position - position)/speed
			if currentlyAttacking == true:
				$AnimatedSprite2D.play("attack1")
			else:
				$AnimatedSprite2D.play("run1")
			
			if(player.position.x - position.x) <0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
		elif enemy_alive == false:
			$AnimatedSprite2D.play("die1")
		else:
			$AnimatedSprite2D.play("idle1")
	else:
		if player_chase and enemy_alive:
			position += (player.position - position)/speed
			if currentlyAttacking == true:
				$AnimatedSprite2D.play("attack2")
			else:
				$AnimatedSprite2D.play("run2")
			
			if(player.position.x - position.x) <0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
		elif enemy_alive == false:
			$AnimatedSprite2D.play("die2")
		else:
			$AnimatedSprite2D.play("idle2")

func takeDamage(damage: int):
	if health < 0:
		die()
	else:
		health -= damage
		healthChanged.emit()
	
	
func makepath() -> void:
	nav_agent.target_position = player.global_position
	
func die():
	enemy_alive = false
	sound_effects.play()
	await get_tree().create_timer(2.5).timeout
	queue_free()

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D and body != self and !(body is Door) :
		audio_stream_player.play()
		player_chase = true
		player =  body
		timer.start()
		save_file.player_chase = true
		Global.save_data()

func _on_area_2d_body_exited(body):
	if body is CharacterBody2D and body != self and !(body is Door):
		player_chase = false
		player =  null
		timer.stop()
		save_file.player_chase = false
		Global.save_data()




func _on_timer_timeout():
	if(player_chase):
		makepath()


func _on_attack_area_body_entered(body):
	if body is CharacterBody2D and body != self and !(body is Door) and enemy_alive:
		player2 = body
		#player2.takeDamage(damage)


func _on_attack_area_body_exited(body):
	if body is CharacterBody2D and body != self and !(body is Door):
		player2 = null

func _on_timer_2_timeout():
	if player2 != null and enemy_alive:
		currentlyAttacking = true
		#player2.takeDamage(damage)
