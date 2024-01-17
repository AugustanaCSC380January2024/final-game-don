extends CharacterBody2D

var speed = 80
var player_chase = false

@export var player: Node2D
@onready var nav_agent:= $NavigationAgent2D as NavigationAgent2D


func _physics_process(_delta: float) -> void:
	
	
	#This portion looks for the next path and moves the enemy in that direction
	#Player chase keeps track of the enemy if is chasing or not
	if player_chase:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed
		print(nav_agent.get_next_path_position())
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
	
	

func makepath():
	nav_agent.target_position = player.global_position

func _on_area_2d_body_entered(body):
	player_chase = true
	player =  body
	print("player detected")
	


func _on_area_2d_body_exited(body):
	player =  null
	player_chase = false
	print("player exited")



func _on_timer_timeout():
	if(player_chase):
		makepath()
