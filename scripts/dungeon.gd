extends Node2D

var Room = preload("res://scenes/room.tscn")

var tile_size = 32
var num_rooms = 50
var min_size = 4
var max_size = 10
var hspread = 400
var cull = 0.5


func _ready():
	randomize()
	make_rooms()
	
func make_rooms():
	for i in range (num_rooms):
		var pos = Vector2(randi_range(-hspread, hspread),0)
		var r = Room.instantiate()
		var w = min_size + randi() % (max_size - min_size)
		var h = min_size + randi() % (max_size - min_size)
		
		r.make_room(pos, Vector2(w, h) * tile_size)
		$Rooms.add_child(r)
		
		await(get_tree().create_timer(1.1).timeout)
		for room in $Rooms.get_children():
			if randi() < cull:
				room.queue_free()
			else:
				room.freeze_mode = RigidBody2D.FREEZE_MODE_STATIC 
				room.freeze = true 
func _draw():
	for room in $Rooms.get_children():
		draw_rect(Rect2(room.position - room.size, room.size * 2), Color(32, 228,0), false)

func _process(delta):
	queue_redraw()
	
func _input(event):
	if event.is_action_pressed("ui_select"):
		for n in $Rooms.get_children():
			n.queue_free()
		make_rooms()
	
