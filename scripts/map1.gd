extends Node2D

@export var mapNum = 1
@onready var map1 = preload("res://scenes/tile_map1.tscn")
var player_1
var player_2 
@onready var player_one = load("res://scenes/player.tscn")
@onready var player_two = load("res://scenes/player2.tscn")
@onready var camera_2d = $Camera2D
@onready var save_file

@onready var player_position = null
@onready var player_health = 0

var multiplayermode  = true
const zoommin = 0.4
const zoommax = 3.0

func _ready():
	save_file = Global.get_global_data()
	var gameExists = save_file.gameExists
	load_player(multiplayermode)
	if(gameExists):
		load_progress()
	
func _physics_process(delta):
	
	if (Input.is_action_just_pressed("save")):
		save_progress()
	
	if (multiplayermode):
		
		var avg_camera_positionX = (player_1.global_position.x +  player_2.global_position.x) / 2
		var avg_camera_positionY = (player_1.global_position.y +  player_2.global_position.y) / 2
		var avg_camera_pos = Vector2(Vector2i(avg_camera_positionX, avg_camera_positionY))
		camera_2d.global_position = avg_camera_pos
		
		var player_pos_differenceX = player_1.global_position.x -  player_2.global_position.x
		var player_pos_differenceY = player_1.global_position.y -  player_2.global_position.y
		var insideRoot = abs((player_pos_differenceX ** 2) - (player_pos_differenceY ** 2))
		var player_pos_difference = sqrt(insideRoot)
		
		var cameraZoom = clamp(zoommax - abs(player_pos_difference/200), zoommin, zoommax)
		
		camera_2d.zoom.y = cameraZoom
		camera_2d.zoom.x = cameraZoom
	
	else:
		camera_2d.global_position = player_1.global_position
		camera_2d.zoom.y = zoommax
		camera_2d.zoom.x = zoommax

func save_progress():
	print("saved_progress")
	if multiplayermode:
		save_file["player_two_posX"] = player_2.get_global_pos().x
		save_file["player_two_posY"] = player_2.get_global_pos().y
		save_file["player2_health"] = player_2.get_health()
	
	
	save_file["player_one_posX"] = player_1.get_global_pos().x
	save_file["player_one_posY"] = player_1.get_global_pos().y
	save_file["player_health"] = player_1.get_health()
	save_file["mapNum"] = mapNum
	save_file["gameExists"] = true
	save_file["multiplayermode"] = multiplayermode
	Global.save_data()
	print(save_file)

func load_progress():
	print(save_file)
	print("progress_loaded")
	player_1.global_position.x = save_file.player_one_posX
	player_1.global_position.y = save_file.player_one_posY
	player_1.health = save_file.player_health
	multiplayermode = save_file.multiplayermode
	mapNum = save_file.mapNum
	
	if multiplayermode:
		print(player_2)
		player_2.global_position.x = save_file.player_two_posX
		player_2.global_position.y = save_file.player_two_posY
		player_2.health = save_file.player2_health
	
func load_player(multiplayermode):
	
	if multiplayermode:
		player_2 = player_two.instantiate()
		add_child(player_2)
		
	player_1 = player_one.instantiate()
	add_child(player_1)
		
		
		
