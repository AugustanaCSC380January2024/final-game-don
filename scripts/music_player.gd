extends Node2D
const SIMPLE_LOFI_PIANO_LOOP = preload("res://SOUND/BGMusic/Simple_Lofi_Piano_Loop.ogg")
const MYSTERIOUS_THEME = preload("res://SOUND/BGMusic/Mysterious_Theme.ogg")
const MELLOW_AMBIENT_TRACK = preload("res://SOUND/BGMusic/Mellow_Ambient_Track.ogg")
@onready var song_1 = $Song1
@onready var song_2 = $Song2
@onready var song_3 = $Song3
var currentSong = null


func _ready():
	playRandSong()
	
func randNum():
	return randi_range(1,3)

func _physics_process(delta):
	if !(currentSong.is_playing()):
		playRandSong()
		
func playRandSong():
	var randNum = randNum()
	if randNum == 1:
		song_1.play()
		currentSong = song_1
	elif randNum == 2:
		song_2.play()
		currentSong = song_2
	else:
		song_3.play()
		currentSong = song_3


func _on_timer_timeout():
	pass 
