extends Node2D

var room_width = 9
var room_height = 7

var locked_atlas = Vector2i(2, 0)
var open_atlas = Vector2i(2, 1)

#kinds of rooms
var has_key = false
var has_boss = false
var has_shop = false
var has_boss_key = false

signal player_entered(room)

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	
func make_room(_pos):
	position = _pos

func _on_open_door(tilemap, cell):
	var source_id = tilemap.get_cell_source_id(cell)
	
	tilemap.set_cell(
		cell,
		source_id,
		open_atlas
	)
	
func add_door(dir: Vector2, locked): 
	var tilemap = $TileMapLayer
	var door_tile = Vector2i(2, 1)
	if(locked):
		door_tile = Vector2i(2,0)
	var source_id = 0
	
	var half_w = room_width / 2
	var half_h = room_height / 2
	
	var cell_pos: Vector2i
	
	match dir:
		Vector2.RIGHT:
			cell_pos = Vector2i(room_width - 1, half_h)
		Vector2.LEFT:
			cell_pos = Vector2i(0, half_h)
		Vector2.UP:
			cell_pos = Vector2i(half_w, 0)
		Vector2.DOWN:
			cell_pos = Vector2i(half_w, room_height - 1)
		_:
			print("Invalid direction:", dir)
			return
	
	tilemap.set_cell(cell_pos, source_id, door_tile)
	
func _on_body_entered(body):
	if body.name == "Player" and body is CharacterBody2D:
		emit_signal("player_entered", self)
