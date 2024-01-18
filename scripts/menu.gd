extends Control

@export var gameExists = false
@onready var map = $Map
@onready var map1 = preload("res://scenes/map1.tscn")

@onready var resumeNode = $Resume
var maps = []

#func loadMaps():
	#map.loadMap("map1", false)


func _ready():
	if gameExists:
		resumeNode.visible = true
	else:
		resumeNode.visible = false

func loadGame(numPlayer: int):
	#map.loadPlayer(numPlayer, false)
	get_tree().change_scene_to_packed(map1)
	
	


func _on_player_pressed():
	loadGame(1)
	
	

func _on_player_2_pressed():
	loadGame(2)
	
	


func _on_exit_pressed():
	get_tree().quit()


func _on_resume_pressed():
	#loadGame()
	pass
