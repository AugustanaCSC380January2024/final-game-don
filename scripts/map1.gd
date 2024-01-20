extends Node2D

@export var mapNum = 1
@onready var map1 = preload("res://scenes/tile_map1.tscn")
var player_1
var player_2 
var gameExists = false
var enemy
var chest
@onready var chest_res = load("res://scenes/chest.tscn")
@onready var player_one = load("res://scenes/player.tscn")
@onready var player_two = load("res://scenes/player2.tscn")
@onready var camera_2d = $Camera2D
@onready var pause_menu = $Camera2D/PauseMenu
@onready var save_file
@onready var spawn_point = $spawn1
@onready var spawn_point_2 = $spawn2
@onready var chest_spawn = $chest_spawn
@onready var enemy_spawn = $enemy_spawn
@onready var enemy_res = load("res://scenes/enemy.tscn")

@onready var player_position = null
@onready var player_health = 0

var multiplayermode
const zoommin = 0.4
const zoommax = 3.0

func _ready():
	save_file = Global.get_global_data()
	multiplayermode = save_file.multiplayermode
	gameExists = save_file.gameExists
	load_player(multiplayermode)
	load_enemy()
	load_chest()
	if(gameExists):
		load_progress()
	
func _physics_process(delta):
	
	if (Input.is_action_just_pressed("pause")):
		save_progress()
		pause_menu.visible =  true
		get_tree().paused = true
		
		
	
	if (multiplayermode):
		
		var avg_camera_positionX = (player_1.global_position.x +  player_2.global_position.x) / 2
		var avg_camera_positionY = (player_1.global_position.y +  player_2.global_position.y) / 2
		var avg_camera_pos = Vector2(avg_camera_positionX, avg_camera_positionY)
		camera_2d.global_position = avg_camera_pos
		
		var player_pos_difference = distance_between_payers()
		
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
	save_file["enemy_health"] = enemy.health
	save_file["enemy_posX"] = enemy.global_position.x
	save_file["enemy_posY"] = enemy.global_position.y
	save_file["player_one_hasKey"] = player_1.has_keyy()
	
	
	
	
	

func load_progress():
	
	print("progress_loaded")

	player_1.global_position.x = save_file.player_one_posX
	player_1.global_position.y = save_file.player_one_posY
	player_1.health = save_file.player_health
	multiplayermode = save_file.multiplayermode
	enemy.health = save_file.enemy_health
	enemy.global_position.x = save_file.enemy_posX
	enemy.global_position.y = save_file.enemy_posY
	player_1.has_key = save_file.player_one_hasKey
	mapNum = save_file.mapNum
	
	if multiplayermode:
		print(player_2)
		player_2.global_position.x = save_file.player_two_posX
		player_2.global_position.y = save_file.player_two_posY
		player_2.health = save_file.player2_health
	
	
	
func load_player(multiplayermode):
	
	player_1 = player_one.instantiate()
	add_child(player_1)
	
	if multiplayermode:
		
		player_2 = player_two.instantiate()
		add_child(player_2)
		
		if distance_between_payers() > 20:
			print(distance_between_payers())
			player_2.global_position = spawn_point_2.global_position
			
			
		print(distance_between_payers())
		
	if gameExists == false:
		player_1.global_position = spawn_point.global_position
		if multiplayermode:
			player_2.global_position = spawn_point_2.global_position
			
func load_enemy():
	enemy = enemy_res.instantiate()
	add_child(enemy)
	if gameExists == false:
		print("default spaw")
		enemy.global_position = enemy_spawn.global_position
		
func load_chest():
	chest = chest_res.instantiate()
	add_child(chest)
	if gameExists == false:
		chest.global_position = chest_spawn.global_position
	else:
		chest.global_position = chest_spawn.global_position
		
	
func distance_between_payers():
	var player_pos_differenceX = player_1.global_position.x -  player_2.global_position.x
	var player_pos_differenceY = player_1.global_position.y -  player_2.global_position.y
	var insideRoot = abs((player_pos_differenceX ** 2) - (player_pos_differenceY ** 2))
	var player_pos_difference = sqrt(insideRoot)
	
	return player_pos_difference
		
