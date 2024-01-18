extends Node2D


@onready var map1 = preload("res://scenes/tile_map1.tscn")
@onready var player = $Player
@onready var player_2 = $Player2
@onready var camera_2d = $Camera2D

var zoommin = 0.8
var zoommax = 2

func _ready():
	#map1 = preload("res://scenes/tile_map1.tscn")
	#var map2 = preload("res://scenes/map2.tscn")
	pass

func _physics_process(delta):
	var avg_camera_positionX = (player.global_position.x +  player_2.global_position.x) / 2
	var avg_camera_positionY = (player.global_position.y +  player_2.global_position.y) / 2
	var avg_camera_pos = Vector2(Vector2i(avg_camera_positionX, avg_camera_positionY))
	camera_2d.global_position = avg_camera_pos
	
	var player_pos_differenceX = player.global_position.x -  player_2.global_position.x
	var player_pos_differenceY = player.global_position.y -  player_2.global_position.y
	var player_pos_difference = sqrt((player_pos_differenceX ** 2) - (player_pos_differenceY ** 2))

	player_pos_differenceX = abs((player_pos_differenceX)/30)
	player_pos_differenceY = abs((player_pos_differenceY)/30)
	#camera_2d.zoom.x = player_pos_differenceX
	#camera_2d.zoom.y = player_pos_differenceY

	if camera_2d.zoom.x > zoommax:
		camera_2d.zoom.y = zoommax
		camera_2d.zoom.x = zoommax
	print(camera_2d.zoom.x)
