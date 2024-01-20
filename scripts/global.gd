extends Node

const SAVE_FILE4 = "user://save_file5.save"
@onready var g_data = {}

func get_global_data() -> Dictionary:
	return g_data

	
func _ready():
	load_data()
	
func save_data():
	var file = FileAccess.open(SAVE_FILE4, FileAccess.WRITE)
	file.store_var(g_data)
	file.close()


func load_data():
 
	if not FileAccess.file_exists(SAVE_FILE4):
		g_data = {
			
			"player_one_posX": 0.0,
			"player_one_posY": 0.0,
			"player_health": 0,
			"multiplayer": false,
			"mapNum": 1 ,
			"gameExists": true,
			"player_two_posX": 0.0,
			"player_two_posY": 0.0,
			"player2_health": 0,
			"enemy_health":0,
			"enemy_posX":0.0,
			"enemy_posY":0.0

			
		}
		save_data()
	var file = FileAccess.open(SAVE_FILE4, FileAccess.READ)
	g_data = file.get_var()
	file.close()
	
func new_game():
	g_data.player_one_posX = 0.0
	g_data.player_one_posY = 0.0
	g_data.player_health = 0
	g_data.mapNum = 1
	g_data.gameExists = false
	g_data.multiplayer = false
	g_data.player_two_posX = 0.0
	g_data.player_two_posY = 0.0
	g_data.player2_health = 0
	g_data.enemy_health = 0
	g_data.enemy_posX = 0.0
	g_data.enemy_posY = 0.0
	
	
	
	save_data()
	
