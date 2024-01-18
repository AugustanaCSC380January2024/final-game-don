extends Node


var player_posX = 0.0
var player_posY = 0.0
var player_hp = 0

var player_two_posX = 0.0
var player_two_posY = 0.0
var player_two_hp = 0

const SAVE_FILE = "user://savefile.dat"
var data = {}

func _ready():
	print("ready")
	load_data()



func save_data():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	data = {
		
		"player_posX": player_posX,
		"player_posY": player_posY,
		"player_hp":player_hp,

		"player_two_posX": player_two_posX,
		"player_two_posY": player_two_posY,
		"player_two_hp": player_two_hp,
		
	}
	
	file.store_var(data)
	file = null

func load_data():
	if not FileAccess.file_exists(SAVE_FILE):
		data = {
		
		"player_posX" = player_posX,
		"player_posY" = player_posY,
		"player_hp" = player_hp,

		"player_two_posX" = player_two_posX,
		"player_two_posY" = player_two_posY,
		"player_two_hp" = player_two_hp,
		
	}
	save_data()
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	data = file.get_var()
	player_posX = data.player_posX
	player_posY = data.player_posY
	player_hp = data.player_hp

	player_two_posX = data.player_two_posX
	player_two_posY = data.player_two_posY
	player_two_hp = data.player_two_hp
	file = null

