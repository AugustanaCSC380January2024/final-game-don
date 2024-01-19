extends Node2D

@export var mapNum = 1
@onready var map1 = preload("res://scenes/tile_map1.tscn")
@onready var player = $Player
@onready var player_2 = $Player2
@onready var camera_2d = $Camera2D
@onready var save_file

@onready var player_position = null
@onready var player_health = 0

var multiplayermode  = true
const zoommin = 0.4
const zoommax = 3.0

func _ready():
	#multiplayermode = save_file.multiplayermode
	save_file = Global.get_global_data()
	var gameExists = save_file.gameExists
	if(gameExists):
		load_progress()
	
func _physics_process(delta):
	player_position = player_2.get_global_pos()
	player_health = player_2.get_health()
	
	#print(player_position, player_health)
	
	if (Input.is_action_just_pressed("save")):
		save_progress()
		

		
	if (Input.is_action_just_pressed("load")):
		load_progress()
		
	
	if (multiplayermode):
		
		var avg_camera_positionX = (player.global_position.x +  player_2.global_position.x) / 2
		var avg_camera_positionY = (player.global_position.y +  player_2.global_position.y) / 2
		var avg_camera_pos = Vector2(Vector2i(avg_camera_positionX, avg_camera_positionY))
		camera_2d.global_position = avg_camera_pos
		
		var player_pos_differenceX = player.global_position.x -  player_2.global_position.x
		var player_pos_differenceY = player.global_position.y -  player_2.global_position.y
		var insideRoot = abs((player_pos_differenceX ** 2) - (player_pos_differenceY ** 2))
		var player_pos_difference = sqrt(insideRoot)
		
		var cameraZoom = clamp(zoommax - abs(player_pos_difference/200), zoommin, zoommax)
		
		camera_2d.zoom.y = cameraZoom
		camera_2d.zoom.x = cameraZoom
	
	else:
		camera_2d.global_position = player.global_position
		camera_2d.zoom.y = zoommax
		camera_2d.zoom.x = zoommax

func save_progress():
	print("saved_progress")
	save_file["player_one_posX"] = player.global_position.x
	save_file["player_one_posY"] = player.global_position.y
	save_file["player_health"] = player.health
	save_file["mapNum"] = mapNum
	save_file["gameExists"] = true
	save_file["multiplayermode"] = multiplayermode
	Global.save_data()
	print(save_file)

func load_progress():
	print(save_file)
	print("progress_loaded")
	player.global_position.x = save_file.player_one_posX
	player.global_position.y = save_file.player_one_posY
	player.health = save_file.player_health
	multiplayermode = save_file.multiplayermode
	mapNum = save_file.mapNum
