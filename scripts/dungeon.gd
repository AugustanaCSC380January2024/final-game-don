extends Node2D

var Room = preload("res://scenes/room.tscn")

var tile_size = 32
var num_rooms = 20
var min_size = 4
var max_size = 10
var hspread = 400
var cull = 0.5
var gameExists = true
var path #AStar pathfinding object

@onready var Map = $TileMap
@onready var camera_2d = $Camera2D



func _ready():
	if gameExists:
		load_tile_map()
	else:
		randomize()
		make_rooms()
	
func _physics_process(delta):
	if Input.is_action_just_pressed("zoomIn"):
		camera_2d.zoom.x += 0.5
		camera_2d.zoom.y += 0.5
	if Input.is_action_just_pressed("zoomOut"):
		camera_2d.zoom.x -= 0.5
		camera_2d.zoom.y -= 0.5
func make_rooms():
	for i in range (num_rooms):
		var pos = Vector2(randi_range(-hspread, hspread),0)
		var r = Room.instantiate()
		var w = min_size + randi() % (max_size - min_size)
		var h = min_size + randi() % (max_size - min_size)
		
		r.make_room(pos, Vector2(w, h) * tile_size)
		$Rooms.add_child(r)
		
	await(get_tree().create_timer(0.5).timeout)
	var room_positions = []
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.freeze_mode = RigidBody2D.FREEZE_MODE_STATIC 
			room.freeze_mode = true
			room_positions.append(Vector2(room.position.x, room.position.y))
	#await(get_tree().create_timer(0.5).timeout)
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
		path = null
		make_rooms()
	if event.is_action_pressed("ui_focus_next"):
		make_map()
		save_tile_map()
		
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
		
func make_map():
	Map.clear()
	var full_rect = Rect2()
	
	#Making walls
	for room in $Rooms.get_children():
		var r = Rect2(room.position - room.size,
		room.get_node("CollisionShape2D").shape.extents*2
		)
		full_rect = full_rect.merge(r)
		var topleft = Map.local_to_map(full_rect.position)
		var bottomright = Map.local_to_map(full_rect.end)
		#--------
		var size = (room.size / tile_size).floor()
		var position = Map.local_to_map(room.position)
		var ul = (room.position / tile_size).floor() - size
		
		
		var leftWall = []
		var rightWall = []
		var topWall = []
		var bottomWall = []
		
		
		
		var upperLeftCorner = ul
		var upperRightCorner = Vector2i(ul.x + size.x *2 , ul.y)
		var bottomRightCorner = Vector2i(ul.x + size.x *2 , ul.y + size.y * 2)
		var bottomLeftCorner = Vector2i(ul.x, ul.y + size.y * 2)
		
		for x in range(upperLeftCorner.x,  upperRightCorner.x + 1):
			for y in range(upperRightCorner.y, bottomRightCorner.y + 1):
				if x > upperLeftCorner.x + 1 and x < upperRightCorner.x - 1  and y == upperRightCorner.y:
					topWall.append(Vector2i(x,y))
				if x == upperLeftCorner.x and y < bottomLeftCorner.y - 1 and y > upperLeftCorner.y:
					leftWall.append(Vector2i(x, y))
				if x ==  upperRightCorner.x and y < bottomRightCorner.y - 1 and y > upperRightCorner.y:
					rightWall.append(Vector2i(x,y))
				if x > bottomLeftCorner.x + 1 and y == bottomRightCorner.y and x < bottomRightCorner.x -1:
					bottomWall.append(Vector2i(x,y))
		
		
		
		for vector in leftWall:
			var x = vector.x
			var y = vector.y
			Map.set_cell(0, Vector2i(x + 1,y), 1, Vector2i(0, 3), 0)
			
			
		for vector in rightWall:
			var x = vector.x
			var y = vector.y
			Map.set_cell(0, Vector2i(x - 1,y), 1, Vector2i(5, 3), 0)
			
		for vector in topWall:
			var x = vector.x
			var y = vector.y
			Map.set_cell(0, Vector2i(x ,y + 1), 1, Vector2i(2, 1), 0)
			
		for vector in bottomWall:
			
			var x = vector.x
			var y = vector.y
			Map.set_cell(0, Vector2i(x ,y - 1), 1, Vector2i(2, 4), 0)
			
		#Drawing corners
		Map.set_cell(0,Vector2i(upperLeftCorner.x + 1, upperLeftCorner.y), 1, Vector2i(0,0), 0)
		Map.set_cell(0,Vector2i(bottomLeftCorner.x + 1, bottomLeftCorner.y - 1), 1, Vector2i(0,4), 0)
		Map.set_cell(0,Vector2i(upperRightCorner.x - 1, upperRightCorner.y), 1, Vector2i(5,0), 0)
		Map.set_cell(0,Vector2i(bottomRightCorner.x - 1, bottomRightCorner.y - 1), 1, Vector2i(5,4), 0)
		
		#Adding top wall trim
		for vector in topWall:
			var x = vector.x
			var y = vector.y
			Map.set_cell(0, Vector2i(x ,y), 1, Vector2i(1, 0), 0)
	
	#carving rooms
	var corridors = [] #one corrider per connection
	for room in $Rooms.get_children():
		var size = (room.size / tile_size).floor()
		var position = Map.local_to_map(room.position)
		var ul = (room.position / tile_size).floor() - size
		for x in range(2, size.x *2 -1):
			for y in range(2, size.y * 2 -1):
				Map.set_cell(0, Vector2i(ul.x + x, ul.y +y), 1, Vector2i(1,2),0)
		#carve connection corridor
		var p = path.get_closest_point(Vector2(room.position.x, room.position.y))
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = Map.local_to_map(Vector2(path.get_point_position(p).x, 
				path.get_point_position(p).y))
				var end = Map.local_to_map(Vector2(path.get_point_position(conn).x, 
				path.get_point_position(conn).y))
				carve_path(start, end)
			corridors.append(p)
			
func carve_path(pos1, pos2):
		#carve a path between two points
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	if x_diff ==0: x_diff = pow(-1.0, randi() % 2 )
	if y_diff ==0: y_diff = pow(-1.0, randi() % 2 )
	#choose either x/y or y/x
	var x_y = pos1
	var y_x = pos2
	if (randi()%2)>0:
		x_y = pos2
		y_x = pos1
	for x in range(pos1.x, pos2.x, x_diff):
		Map.set_cell(0, Vector2i(x, x_y.y), 1,Vector2i(1, 2) , 0)
		Map.set_cell(0, Vector2i(x, x_y.y + y_diff), 1,Vector2i(1, 2) , 0)
	for y in range(pos1.y, pos2.y, y_diff):
		Map.set_cell(0, Vector2i(y_x.x, y), 1,Vector2i(1,2) , 0)
		Map.set_cell(0, Vector2i(y_x.x + x_diff, y), 1,Vector2i(1,2) , 0)	

func save_tile_map():
	var packed_scene = PackedScene.new()
	packed_scene.pack($TileMap)
	ResourceSaver.save(packed_scene, "res://MAPS/dungeonMap.tscn")
func load_tile_map():
	var packed_scene = load("res://MAPS/dungeonMap.tscn")
	var my_scene = packed_scene.instantiate()
	add_child(my_scene)
