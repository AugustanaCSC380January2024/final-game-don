extends Node

const SAVE_FILE4 = "user://save_file19.save"
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
			"enemy_posY":0.0,
			"player_one_hasKey":false,
			"map1_exists":false,
			"map2_exists":false,
			"map3_exists":false,
			"spawn_pointPosX" : 0.0,
			"spawn_pointPosY" : 0.0,
			"spawn_point_2PosX" : 0.0,
			"spawn_point_2PosY" : 0.0,
			"player_chase":false,
			"built_rooms_array": [],
			"start_roomPos": null,
			"end_roomPos": null,
			"new_game": true,
			"chest_position":null,
			"num_rooms": 10,
			"enemy_default_health": 100,
			"enemy_default_damage": 20,
			"player_default_damage": 20,
			"player_default_health": 100,
			"level_num": 1,
			"door_pos":null

			
		}
		save_data()
	var file = FileAccess.open(SAVE_FILE4, FileAccess.READ)
	g_data = file.get_var()
	file.close()
	
func new_game():
	
	var dir = DirAccess.open("res://MAPS")
	if g_data.map1_exists:
		dir.remove("res://MAPS/dungeonMap.tscn")
	if g_data.map2_exists == true:
		dir.remove("res://MAPS/dungeonMap.tscn")
	if g_data.map3_exists == true:
		dir.remove("res://MAPS/dungeonMap.tscn")
	
	
	
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
	g_data.player_one_hasKey = false
	g_data.map1_exists = false
	g_data.map2_exists = false
	g_data.map3_exists = false
	g_data.spawn_pointPosX = 0.0
	g_data.spawn_pointPosY = 0.0
	g_data.spawn_point_2PosX = 0.0
	g_data.spawn_point_2PosY = 0.0
	g_data.player_chase = false
	g_data.built_rooms_array = []
	g_data.start_roomPos = null
	g_data.end_roomPos = null
	g_data.new_game = true
	g_data.chest_position = null
	g_data.num_rooms = 10
	g_data.player_default_health = 100
	g_data.enemy_default_health = 100
	g_data.enemy_default_damage = 20
	g_data.player_default_damage = 20
	g_data.level_num = 1
	g_data.door_pos = null
	save_data()
	
