extends Node

const SAVE_FILE3 = "user://save_file3.save"
@onready var g_data = {}

func get_global_data() -> Dictionary:
	return g_data

	
func _ready():
	load_data()
	
func save_data():
	var file = FileAccess.open(SAVE_FILE3, FileAccess.WRITE)
	file.store_var(g_data)
	file.close()


func load_data():
 
	if not FileAccess.file_exists(SAVE_FILE3):
		g_data = {
			
			"player_one_posX": 0.0,
			"player_one_posY": 0.0,
			"player_health": 0,
			"multiplayer": false,
			"mapNum": 1 ,
			"gameExists": true
		}
		save_data()
		print("hekki")
	var file = FileAccess.open(SAVE_FILE3, FileAccess.READ)
	g_data = file.get_var()
	file.close()
