extends Node2D
@onready var pause_menu = $Camera2D/PauseMenu
@onready var camera_2d = $Camera2D
@onready var player_1 = $Player
@onready var player_2 = $Player2
@onready var Map = $TileMap

var mapNum
var gameExists = false
@onready var save_file
@onready var player_position = null
@onready var player_health = 0


var multiplayermode
const zoommin = 1
const zoommax = 3.0

func _ready():
	save_file = Global.get_global_data()
	multiplayermode = save_file.multiplayermode
	#multiplayermode = false
	gameExists = save_file.gameExists
	
	if multiplayermode == false:
		player_2.queue_free()
		
	$AudioStreamPlayer2D.play()
		

func _physics_process(delta):
	if (Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("pause2")):
		pause_menu.global_position = camera_2d.global_position
		pause_menu.visible =  true
		get_tree().paused = true
		
		
	if (multiplayermode and player_2 != null):
		var avg_camera_positionX = (player_1.global_position.x +  player_2.global_position.x) / 2
		var avg_camera_positionY = (player_1.global_position.y +  player_2.global_position.y) / 2
		var avg_camera_pos = Vector2(avg_camera_positionX, avg_camera_positionY)
		camera_2d.global_position = avg_camera_pos
		
		var player_pos_difference = distance_between_payers()
		
		var cameraZoom = clamp(zoommax - abs(player_pos_difference/200), zoommin, zoommax)
		
		camera_2d.zoom.y = cameraZoom
		camera_2d.zoom.x = cameraZoom
		if isThisTileEmpty(player_2.global_position):
			pass
			
			player_2.takeDamage(1000)
	
	else:
		if player_1:
			camera_2d.global_position = player_1.global_position
			camera_2d.zoom.y = zoommax
			camera_2d.zoom.x = zoommax
	if player_1:
		if isThisTileEmpty(player_1.global_position):
			pass
			player_1.takeDamage(1000)


func distance_between_payers():
	var player_pos_differenceX = player_1.global_position.x -  player_2.global_position.x
	var player_pos_differenceY = player_1.global_position.y -  player_2.global_position.y
	var insideRoot = abs((player_pos_differenceX ** 2) - (player_pos_differenceY ** 2))
	var player_pos_difference = sqrt(insideRoot)
	
	return player_pos_difference

func isThisTileEmpty(position: Vector2):
	var postPosition = Map.local_to_map(position)
	var tileInfo = Map.get_cell_atlas_coords(0, postPosition)
	var tileInfo2 = Map.get_cell_atlas_coords(1, postPosition)
	if tileInfo == Vector2i(-1,-1) and tileInfo2 == Vector2i(-1,-1):
		return true
	else:
		return false
	
