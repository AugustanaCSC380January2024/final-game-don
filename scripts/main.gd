extends Node2D

var num_player 


func _ready():
	var menu = get_node("Menu")
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	startGame(1)
	
func startGame(player_num: int):
	num_player = player_num
	#var one_player_mode = menu.one_player_mode
	#var two_player_mode = menu.two_player_mode
	#var resume = menu.resume
	
	get_tree().change_scene_to_file("res://scenes/map1.tscn")

func _mode_selected():
	startGame(1)
func _on_menu_player_mode_selected():
	startGame(1)
	print("worked")
