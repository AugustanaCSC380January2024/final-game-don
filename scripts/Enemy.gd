extends CharacterBody2D

class_name Enemy
var speed = 150

var player_chase = true

@onready var save_file = Global.get_global_data()
@export var player: Node2D
@export var player2: Node2D
@export var damage = 10
@export var maxHealth = 100
@onready var audio_stream_player = $AudioStreamPlayer

var health = 100

signal healthChanged

@onready var nav_agent:= $NavigationAgent2D as NavigationAgent2D
@onready var timer = $PathTimer
@onready var sound_effects = $SoundEffects

func _ready():
	pass
	
func _physics_process(_delta: float) -> void:
	
	player_chase = save_file.player_chase

	
	#This portion looks for the next path and moves the enemy in that direction
	#Player chase keeps track of the enemy if is chasing or not
	if player_chase:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed

	else:
		velocity = Vector2.ZERO
	

	move_and_slide()
	
	#This code is not being used currently but I will use it in the future as a base for animation changes
	if player_chase:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("run")
		
		if(player.position.x - position.x) <0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
	else:
		$AnimatedSprite2D.play("idle")
		

func takeDamage(damage: int):
	if health < 0:
		die()
	else:
		health -= damage
		healthChanged.emit()
	
	
func makepath() -> void:
	nav_agent.target_position = player.global_position
	
func die():
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
	if body is CharacterBody2D and body != self and !(body is Door):
		player2 = body
		player2.takeDamage(damage)


func _on_attack_area_body_exited(body):
	if body is CharacterBody2D and body != self and !(body is Door):
		player2 = null

func _on_timer_2_timeout():
	if player2 != null:
		player2.takeDamage(damage)
