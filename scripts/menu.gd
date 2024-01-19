extends Control


@onready var map1 = preload("res://scenes/map1.tscn")

@onready var map2 = preload("res://scenes/map2.tscn")
@onready var resumeNode = $Resume
@onready var save_file = Global.g_data
@onready var gameExists = save_file.gameExists
var mapNum = 1
var two_player = false




func _ready():
	if gameExists:
		resumeNode.visible = true
		mapNum = save_file.mapNum
	else:
		resumeNode.visible = false
	
	

func loadGame(numPlayer: int):
	if(mapNum == 1):
		get_tree().change_scene_to_packed(map1)
		map1.instantiate()
	elif mapNum == 2:
		get_tree().change_scene_to_packed(map2)

func _on_player_pressed():
	save_file.multiplayermode = false
	Global.save_data()
	
	
	

func _on_player_2_pressed():
	save_file.multiplayermode = true
	Global.save_data()
	
	
	


func _on_exit_pressed():
	get_tree().quit()


func _on_resume_pressed():
	if save_file.multiplayermode == true:
		loadGame(2)
	else:
		loadGame(1)
		


func _on_new_game_pressed():
	Global.new_game()
	if save_file.multiplayermode == true:
		loadGame(2)
	else:
		loadGame(1)
