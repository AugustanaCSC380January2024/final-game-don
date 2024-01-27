extends CharacterBody2D
class_name Door

@onready var sprite_2d = $Sprite2D
@onready var collision_shape = $Area2D
var player 
@onready var selfDoor = $CollisionShape2D
var save_file
var mapNum
@onready var sound_effects = $SoundEffects
var locked = true

func _ready():
	save_file = Global.get_global_data()
	mapNum = save_file.mapNum
	


func _on_area_2d_body_entered(body):
	if body is CharacterBody2D and body != self and not (body is Enemy):
		player = body
		if player.has_keyy() == true:
			unlockPortal()
			
		if locked == false:
			player.disableMovement(true)
			#save_file.mapNum = mapNum + 1
			save_file.new_game = true
			add_stats()
			Global.save_data()
			sound_effects.play()
			await get_tree().create_timer(2.5).timeout
			player.disableMovement(false)
			get_tree().change_scene_to_file("res://scenes/dungeon.tscn")

func _on_area_2d_body_exited(body):
	if body is CharacterBody2D and body != self and not (body is Enemy):
		player = null
func unlockPortal():
	locked = false
func add_stats():
	save_file.level_num += 1
	save_file.num_rooms += 3
	save_file.enemy_default_health += 10
	save_file.enemy_default_damage += 10
	save_file.player_default_damage += 10
	
