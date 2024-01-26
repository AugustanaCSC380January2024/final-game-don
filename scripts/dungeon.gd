extends Node2D

#PROCEDURAL GENERATION VARIABLES--------------
var Room = preload("res://scenes/room.tscn")
var tile_size = 32
var num_rooms = 10
var min_size = 4
var max_size = 10
var hspread = 200
var cull = 0.5
var path #AStar pathfinding object
@onready var Map = $TileMap
var start_roomPos = null
var end_roomPos = null
var end_room = null






#GENERATED MAP VARIABLES-----------------
var mapNum
var player_1
var player_2 
var gameExists = false
var enemy
var built_rooms = []
var used_cells_Array2 
@onready var door = $Door

@onready var player_one = load("res://scenes/player.tscn")
@onready var player_two = load("res://scenes/player2.tscn")
@onready var camera_2d = $Camera2D
@onready var pause_menu = $Camera2D/PauseMenu
@onready var save_file
@onready var spawn_point = $spawn1
@onready var spawn_point_2 = $spawn2
@onready var enemy_spawn = $enemy_spawn
@onready var enemy_res = load("res://scenes/enemy.tscn")
@onready var chest = $Chest
@onready var player_position = null
@onready var player_health = 0


var multiplayermode
const zoommin = .2
const zoommax = 3.0

func _ready():
	
	save_file = Global.get_global_data()
	multiplayermode = save_file.multiplayermode
	gameExists = save_file.gameExists
	
	
	
	if gameExists and save_file.new_game == false:
		load_tile_map()
		load_player(multiplayermode)
		load_progress()
		load_next_level_door()
	else:
		randomize()
		make_rooms()
		await(get_tree().create_timer(0.5).timeout)
		make_map()
		await(get_tree().create_timer(0.5).timeout)
		get_rooms()
		load_player(multiplayermode)
		
		
		
	
	
	
	load_chest()
	await(get_tree().create_timer(1).timeout)
	load_enemy()
	

#PROCEDURAL GENERATION STARTS----------------------------------
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
	
	path = find_mst(room_positions)
	
func get_rooms():
	for room in $Rooms.get_children():
		#built_rooms.append(room.position)
		room.collisionEnable(false)
	find_start_room()
	find_end_room()
	
func find_end_room():
	var max_x = -INF
	for room in $Rooms.get_children():
		if room.position.x > max_x:
			end_room = room
			max_x = room.position.x	
	load_next_level_door()
			
	
func find_start_room():
	var min_x = INF
	for room in $Rooms.get_children():
		if room.position.x < min_x:
			start_roomPos = room.position
			min_x = room.position.x
			spawn_point.global_position = start_roomPos
			spawn_point_2.global_position = Vector2(start_roomPos.x, start_roomPos.y + 20)

func _draw():
	for room in $Rooms.get_children():
		pass
		#draw_rect(Rect2(room.position - room.size, room.size * 2), Color(32, 228,0), false)
	if path:
		pass
		#for current_pos in path.get_point_ids():
			#for c in path.get_point_connections(current_pos):
				#var pp = path.get_point_position(current_pos)
				#var cp = path.get_point_position(c)
				#draw_line(Vector2(pp.x, pp.y), Vector2(cp.x, cp.y), Color(1, 1, 0), 15, true)
		
		
#func _process(delta):
	#queue_redraw()
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
	#MAKING FLOOR/CARVING ROOMS
	var corridors = [] #one corrider per connection

	
	for room in $Rooms.get_children():
		var size = (room.size / tile_size).floor()
		var position = Map.local_to_map(room.position)
		var ul = (room.position / tile_size).floor() - size
		for x in range(2, size.x *2 -1):
			for y in range(2, size.y * 2 -1):
				Map.set_cell(0, Vector2i(ul.x + x, ul.y +y), 1, Vector2i(1,2),0)
		used_cells_Array2 = Map.get_used_cells(0)
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
			
			
	#Making walls
	
	
	var used_cells_Array = Map.get_used_cells(0)
	
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
			if not (used_cells_Array.has(Vector2i(x + 1,y))):
				Map.set_cell(1, Vector2i(x + 1,y), 1, Vector2i(0, 3), 0)
			
			
		for vector in rightWall:
			var x = vector.x
			var y = vector.y
			if not (used_cells_Array.has(Vector2i(x - 1,y))):
				Map.set_cell(1, Vector2i(x - 1,y), 1, Vector2i(5, 3), 0)
			
		for vector in topWall:
			var x = vector.x
			var y = vector.y
			if not (used_cells_Array.has(Vector2i(x ,y + 1))):
				Map.set_cell(1, Vector2i(x ,y + 1), 1, Vector2i(2, 1), 0)
			
		for vector in bottomWall:
			
			var x = vector.x
			var y = vector.y
			if not (used_cells_Array.has(Vector2i(x ,y - 1))):
				Map.set_cell(1, Vector2i(x ,y - 1), 1, Vector2i(2, 4), 0)
			
		#Drawing corners
		Map.set_cell(1,Vector2i(upperLeftCorner.x + 1, upperLeftCorner.y), 1, Vector2i(0,0), 0)
		Map.set_cell(1,Vector2i(bottomLeftCorner.x + 1, bottomLeftCorner.y - 1), 1, Vector2i(0,4), 0)
		Map.set_cell(1,Vector2i(upperRightCorner.x - 1, upperRightCorner.y), 1, Vector2i(5,0), 0)
		Map.set_cell(1,Vector2i(bottomRightCorner.x - 1, bottomRightCorner.y - 1), 1, Vector2i(5,4), 0)
		
		#Adding top wall trim
		for vector in topWall:
			var x = vector.x
			var y = vector.y
			if not (used_cells_Array.has(Vector2i(x ,y))):
				Map.set_cell(1, Vector2i(x ,y), 1, Vector2i(1, 0), 0)
	
	
	
			
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
		#Map.set_cell(0, Vector2i(x, x_y.y - 1), 1,Vector2i(6, 7) , 0)
		
	for y in range(pos1.y, pos2.y, y_diff):
		Map.set_cell(0, Vector2i(y_x.x, y), 1,Vector2i(1,2) , 0)
		Map.set_cell(0, Vector2i(y_x.x + x_diff, y), 1,Vector2i(1,2) , 0)
		#Map.set_cell(0, Vector2i(y_x.x - 1, y), 1,Vector2i(6, 7) , 0)
	
	#MAKING WALLS OF THE CORRIDORS
	var used_cells_Array3 = Map.get_used_cells(0)
	
	#for x in range(pos1.x, pos2.x):
		#if not (used_cells_Array3.has(Vector2i(x, x_y.y - 1))):
		#Map.set_cell(0, Vector2i(x, y_x.y - 1), 1,Vector2i(6, 7) , 0)
		
	#for y in range(pos1.y, pos2.y, y_diff):
		#if not (used_cells_Array3.has(Vector2i(y_x.x, y))):
			#Map.set_cell(0, Vector2i(y_x.x - 1, y), 1,Vector2i(6, 7) , 0)
		
	
	
func save_tile_map():
	
	if save_file.new_game == true:
		var dir = DirAccess.open("res://MAPS")
		dir.remove("res://MAPS/dungeonMap.tscn")
		
	var packed_scene = PackedScene.new()
	packed_scene.pack($TileMap)
		#if save_file.map3_exists == true:
			#ResourceSaver.save(packed_scene, "res://MAPS/dungeonMap3.tscn")
		#elif save_file.map2_exists == true:
			#ResourceSaver.save(packed_scene, "res://MAPS/dungeonMap2.tscn")
		#else:
	ResourceSaver.save(packed_scene, "res://MAPS/dungeonMap.tscn")
		
func load_tile_map():
	var packed_scene 
	#if save_file.map3_exists == true:
		#packed_scene = load("res://MAPS/dungeonMap3.tscn")
		#mapNum = 3
	#elif save_file.map2_exists == true:
		#packed_scene = load("res://MAPS/dungeonMap2.tscn")
		#mapNum = 2
	#else:
	packed_scene = load("res://MAPS/dungeonMap.tscn")
	print(packed_scene)
	var my_scene = packed_scene.instantiate() 
	add_child(my_scene)
	
#MAP FUNCTIONALITY STARTS-----------------------------------

func _physics_process(delta):
	
	if (Input.is_action_just_pressed("pause")):
		save_progress()
		pause_menu.global_position = camera_2d.global_position
		pause_menu.visible =  true
		get_tree().paused = true
		
	if (Input.is_action_just_pressed("giveKey")):
		player_1.collect_key()
	
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
				player_2.die()
	
	else:
		if player_1:
			camera_2d.global_position = player_1.global_position
			camera_2d.zoom.y = zoommax
			camera_2d.zoom.x = zoommax
	if player_1:
		if isThisTileEmpty(player_1.global_position): #and player_1.global_position.x != save_file.player_one_posX:
			print(isThisTileEmpty(player_1.global_position))
			player_1.die()
		
		
	
			

func save_progress():
	save_tile_map()

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
	#save_file["enemy_health"] = enemy.health 
	#save_file["enemy_posX"] = enemy.global_position.x
	#save_file["enemy_posY"] = enemy.global_position.y
	save_file["player_one_hasKey"] = player_1.has_keyy()
	save_file["spawn_pointPosX"] = spawn_point.global_position.x
	save_file["spawn_pointPosY"] = spawn_point.global_position.y
	save_file["spawn_point_2PosX"] = spawn_point_2.global_position.x
	save_file["spawn_point_2PosY"] = spawn_point_2.global_position.y
	save_file["built_rooms_array"] = built_rooms
	save_file["start_roomPos"] = start_roomPos
	save_file["chest_position"] = chest.global_position
	
	if gameExists:
		save_file["end_roomPos"] = end_roomPos
	else:
		save_file["end_roomPos"] = end_room.position
		
	save_file["new_game"] = false
	
	
	print(built_rooms)
		
func load_progress():
	

	load_tile_map()

	player_1.global_position.x = save_file.player_one_posX
	player_1.global_position.y = save_file.player_one_posY
	player_1.health = save_file.player_health
	multiplayermode = save_file.multiplayermode
	#enemy.health = save_file.enemy_health
	#enemy.global_position.x = save_file.enemy_posX
	#enemy.global_position.y = save_file.enemy_posY
	player_1.has_key = save_file.player_one_hasKey
	mapNum = save_file.mapNum
	built_rooms = save_file.built_rooms_array
	start_roomPos = save_file.start_roomPos
	end_roomPos = save_file.end_roomPos
	chest.global_position = save_file.chest_position
	
	
	if multiplayermode:
		player_2.global_position.x = save_file.player_two_posX
		player_2.global_position.y = save_file.player_two_posY
		player_2.health = save_file.player2_health

func load_player(multiplayermode):
	
	player_1 = player_one.instantiate()
	add_child(player_1)
	
	if multiplayermode:
		
		player_2 = player_two.instantiate()
		add_child(player_2)
	
	if gameExists == false:
		player_1.global_position = spawn_point.global_position
		if multiplayermode:
			player_2.global_position =  spawn_point_2.global_position
			if  isThisTileEmpty(player_2.global_position):
				player_2.global_position.x += 200
			
	#IF PLAYER SPAWNED OUTSIDE OF ROOM, MOVE TO THE RIGHT
	if  isThisTileEmpty(player_1.global_position):
		player_1.global_position.x += 200
			
func load_enemy():
	enemy = enemy_res.instantiate()
	add_child(enemy)	
	spawn_enemy()

	

func spawn_enemy():
	if enemy != null:
		var randRoomPos = select_rand_roomPos()
		while randRoomPos != null and  randRoomPos.x == start_roomPos.x:
			randRoomPos = select_rand_roomPos()
		enemy.global_position = randRoomPos
	
	
func select_rand_roomPos():
	if gameExists == false and save_file.new_game == true:
		for room in $Rooms.get_children():
			built_rooms.append(room.position)
			
	if gameExists == true and save_file.new_game == true:
		for room in $Rooms.get_children():
			built_rooms.append(room.position)
			
	var randInt = randi_range(0 , built_rooms.size() - 1)
	return built_rooms[randInt]

func load_chest():
	
	var randChestPosition = select_rand_roomPos()
	while(isThisTileEmpty(randChestPosition) == true or randChestPosition == door.global_position or randChestPosition == player_1.global_position):
		randChestPosition = select_rand_roomPos()
	
	if gameExists == false:
		chest.global_position = randChestPosition
	else:
		chest.global_position = save_file.chest_position

func distance_between_payers():
	var player_pos_differenceX = player_1.global_position.x -  player_2.global_position.x
	var player_pos_differenceY = player_1.global_position.y -  player_2.global_position.y
	var insideRoot = abs((player_pos_differenceX ** 2) - (player_pos_differenceY ** 2))
	var player_pos_difference = sqrt(insideRoot)
	
	return player_pos_difference
	

func load_next_level_door():

	var room = null
	if gameExists:
		door.global_position = save_file.end_roomPos
		if isThisTileEmpty(door.global_position):
			door.global_position.x += 200
			
	else:
		room = end_room
		door.global_position = room.position
		if isThisTileEmpty(door.global_position):
			door.global_position.x += 200

func isThisTileEmpty(position: Vector2):
	var postPosition = Map.local_to_map(position)
	var tileInfo = Map.get_cell_atlas_coords(0, postPosition)
	var tileInfo2 = Map.get_cell_atlas_coords(1, postPosition)
	if tileInfo == Vector2i(-1,-1) and tileInfo2 == Vector2i(-1,-1):
		return true
	else:
		return false
	
	
func _on_enemy_spawn_timer_timeout():
	if save_file.player_chase == false:
		spawn_enemy()
