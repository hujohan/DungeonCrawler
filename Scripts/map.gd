extends Node2D
var rooms = []
		
var room = preload("res://Scenes/room.tscn")
var key = preload("res://Scenes/key.tscn")

var keys_in_dungeon = 0

var tile_size = 32
var num_rooms = 10
var num_locked_rooms = 0
var max_locked_rooms = 2

var locked_odds = 0.5

var locked = false
@onready var camera = $Camera2D

var item_manager
var player

var room_size = Vector2(288, 224)

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	item_manager = get_tree().get_first_node_in_group("item_manager")
	randomize()
	make_dungeon()
	


#keys
func check_if_enough_keys_for_locked_door():
	for room in rooms:
		if room.has_key:
			return true
	return false
		
func add_key(room):
	if randf() < 0.5: # 50% chans
		var key_inst = key.instantiate()
		key_inst.key_collected.connect(item_manager._on_key_collected)
		room.add_child(key_inst)
		var grid_x = randi_range(1, room.room_width - 2)
		var grid_y = randi_range(1, room.room_height - 2)
		
		key_inst.position = Vector2(grid_x, grid_y) * tile_size
		keys_in_dungeon += 1
		print(keys_in_dungeon)
		room.has_key = true
#generate rooms
func make_dungeon(): #main create map thing
	var keys_in_dungeon = 0
	var first_room = spawn_room(Vector2.ZERO)
	rooms.append(first_room)
	
	for i in range(num_rooms - 1):
		add_room()
		
func spawn_room(pos: Vector2):
	var r = room.instantiate()
	r.position = pos
	add_key(r) #sometimes adds a key
	$Rooms.add_child(r)
	
	r.player_entered.connect(_on_player_entered_room)
	
	return r
	
func add_room():
	var base_room = rooms[randi() % rooms.size()]
	var directions = [
		Vector2.UP,
		Vector2.DOWN,
		Vector2.LEFT,
		Vector2.RIGHT
	]
	directions.shuffle()

	for dir in directions:
		var locked_chance = randf()
		var new_pos = base_room.position + dir * room_size
		if not room_exists_at(new_pos):
			locked = false
			if check_if_enough_keys_for_locked_door():
				if(locked_chance <= locked_odds):
					locked = true
			var new_room = spawn_room(new_pos)
			rooms.append(new_room)
			create_door_between(base_room, new_room, dir, locked)
			return
			
func room_exists_at(pos: Vector2):
	for r in rooms:
		if r.position == pos:
			return true
	return false
	
func create_door_between(room_a, room_b, direction, locked):
	room_a.add_door(direction, locked)
	room_b.add_door(-direction, false)
	
#camera stuff
func _on_player_entered_room(room):
	move_camera_to_room(room)
	player.open_door.connect(room._on_open_door)
	
func move_camera_to_room(room):
	var camera_offset = Vector2(352, 288)
	camera.global_position = room.global_position + camera_offset / 2
	
func _process(delta):
	pass
