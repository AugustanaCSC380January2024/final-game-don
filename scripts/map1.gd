extends Node2D


@onready var map1 = preload("res://scenes/tile_map1.tscn")
@onready var player = $Player
@onready var player_2 = $Player2
@onready var camera_2d = $Camera2D

const zoommin = 0.4
const zoommax = 3.0

func _ready():
	pass

func _physics_process(delta):
	
	var avg_camera_positionX = (player.global_position.x +  player_2.global_position.x) / 2
	var avg_camera_positionY = (player.global_position.y +  player_2.global_position.y) / 2
	var avg_camera_pos = Vector2(Vector2i(avg_camera_positionX, avg_camera_positionY))
	camera_2d.global_position = avg_camera_pos
	
	var player_pos_differenceX = player.global_position.x -  player_2.global_position.x
	var player_pos_differenceY = player.global_position.y -  player_2.global_position.y
	var insideRoot = abs((player_pos_differenceX ** 2) - (player_pos_differenceY ** 2))
	var player_pos_difference = sqrt(insideRoot)
	
	var cameraZoom = clamp(3 - abs(player_pos_difference/200), zoommin, zoommax)
	
	camera_2d.zoom.y = cameraZoom
	camera_2d.zoom.x = cameraZoom
