extends Control

@export var gameExists = false
@onready var map1 = preload("res://scenes/map1.tscn")

@onready var map2 = preload("res://scenes/map2.tscn")
@onready var resumeNode = $Resume
@export var mapNum = 1
@onready var save_file = Global.g_data



func _ready():
	if gameExists:
		resumeNode.visible = true
	else:
		resumeNode.visible = false
	#mapNum = save_file.mapNum
	

func loadGame(numPlayer: int):
	if(mapNum == 1):
		get_tree().change_scene_to_packed(map1)
		map1.instantiate()
	elif mapNum == 2:
		get_tree().change_scene_to_packed(map2)

func _on_player_pressed():
	save_file.multiplayermode = false
	Global.save_data()
	loadGame(1)
	
	

func _on_player_2_pressed():
	save_file.multiplayermode = true
	Global.save_data()
	loadGame(2)
	
	


func _on_exit_pressed():
	get_tree().quit()


func _on_resume_pressed():
	#loadGame()
	pass
