extends CharacterBody2D

var speed = 80
var player_chase = true


@export var player: Node2D
@export var player2: Node2D
@export var damage = 10

@onready var nav_agent:= $NavigationAgent2D as NavigationAgent2D
@onready var timer = $Timer


func _physics_process(_delta: float) -> void:
	
	
	#This portion looks for the next path and moves the enemy in that direction
	#Player chase keeps track of the enemy if is chasing or not
	if player_chase:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed

	else:
		velocity = Vector2.ZERO
	
	
	move_and_slide()
	
	#This code is not being used currently but I will use it in the future as a base for animation changes
	if false:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("run")
		
		if(player.position.x - position.x) <0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
	else:
		$AnimatedSprite2D.play("idle")
	
	

func makepath() -> void:
	nav_agent.target_position = player.global_position

func _on_area_2d_body_entered(body):
	player_chase = true
	player =  body
	timer.start()
	print("player detected")
	


func _on_area_2d_body_exited(body):
	player_chase = false
	player =  null
	timer.stop()
	print("player exited")



func _on_timer_timeout():
	if(player_chase):
		makepath()


func _on_attack_area_body_entered(body):
	player2 = body
	player2.remove_health(damage)


func _on_attack_area_body_exited(body):
	player2 = null

func _on_timer_2_timeout():
	if player2 != null:
		player2.remove_health(damage)
