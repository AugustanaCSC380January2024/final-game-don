extends Node2D

var Room = preload("res://scenes/room.tscn")

var tile_size = 32
var num_rooms = 50
var min_size = 4
var max_size = 10
var hspread = 400
var cull = 0.5

var path #AStar pathfinding object


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
	var room_positions = []
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.freeze_mode = RigidBody2D.FREEZE_MODE_STATIC 
			room.freeze_mode = true
			room_positions.append(Vector2(room.position.x, room.position.y))
	await(get_tree().create_timer(0.5).timeout)
	path = find_mst(room_positions)
	
func _draw():
	for room in $Rooms.get_children():
		draw_rect(Rect2(room.position - room.size, room.size * 2), Color(32, 228,0), false)
	if path:
		for current_pos in path.get_point_ids():
			for c in path.get_point_connections(current_pos):
				var pp = path.get_point_position(current_pos)
				var cp = path.get_point_position(c)
				draw_line(Vector2(pp.x, pp.y), Vector2(cp.x, cp.y), Color(1, 1, 0), 15, true)
func _process(delta):
	queue_redraw()
	
func _input(event):
	if event.is_action_pressed("ui_select"):
		for n in $Rooms.get_children():
			n.queue_free()
		make_rooms()
	
func find_mst(nodes):  #Prims algorithm
	var path = AStar2D.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
	
	while nodes:
		var min_dist = INF #minimum distance so far
		var min_p = null
		var current_pos = null
		
		for p1 in path.get_point_ids():
			var pos = path.get_point_position(p1)
			for p2 in nodes:
				if pos.distance_to(p2) < min_dist:
					min_dist = pos.distance_to(p2)
					min_p = p2
					current_pos = pos
		var n = path.get_available_point_id()
		path.add_point(n, min_p)
		path.connect_points(path.get_closest_point(current_pos), n)
		nodes.erase(min_p)
	
	return path
		
