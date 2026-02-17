extends Node2D

var currentPosition = [0, 0] #32 pixels per movement

signal open_door(tilemap, coords)

@onready var item_manager = $ItemManager
var locked_atlas = Vector2i(2, 0)
var room

func _ready():
	currentPosition[0] = position.x
	currentPosition[1] = position.y
	
func _process(delta):
	move()
	
#movement
func move():
	if(Input.is_action_just_pressed("RIGHT") and checkCollision("RIGHT")):
		$Sprite2D.flip_h = false
		currentPosition[0] += 32
		boing()
	if(Input.is_action_just_pressed("LEFT") and checkCollision("LEFT")):
		$Sprite2D.flip_h = true
		currentPosition[0] -= 32
		boing()
	if(Input.is_action_just_pressed("DOWN") and checkCollision("DOWN")):
		currentPosition[1] += 32 
		boing()
	if(Input.is_action_just_pressed("UP") and checkCollision("UP")):
		currentPosition[1] -= 32
		boing()
	#check current room
	
	self.position = Vector2(currentPosition[0], currentPosition[1])
	
func checkCollision(dir):
	match dir:
		"RIGHT":
			$RayCast2D.target_position = Vector2(32,0)
		"LEFT":
			$RayCast2D.target_position = Vector2(-32,0)
		"DOWN":
			$RayCast2D.target_position = Vector2(0, 32)
		"UP":
			$RayCast2D.target_position = Vector2(0, -32)
			
	$RayCast2D.force_raycast_update()
	
	if($RayCast2D.is_colliding()):
		var collider = $RayCast2D.get_collider()
		if collider is TileMapLayer:
			var ray_end = $RayCast2D.global_position + $RayCast2D.target_position
			var local_pos = collider.to_local(ray_end)
			var cell = collider.local_to_map(local_pos)

			var tile_data = collider.get_cell_source_id(cell)
			var tile_atlas = collider.get_cell_atlas_coords(cell)
			
			
			print("Hit tile at: ", cell)
			print("Tile source id: ", tile_data)
			print("Tile atlas: ", tile_atlas)
			
			if tile_atlas == locked_atlas:
				print("yeah")
				if item_manager.use_key():
					open_door.emit(collider, cell)
					return true  # allow movement
				else:
					print("Door is locked. No key.")
					return false

		return false
	else:
		return true
		
#visuals
func boing():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.8, 1.2), 0.05)
	tween.tween_property(self, "scale", Vector2(1.2, 0.8), 0.05)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.05)
	
#items


	
	#if enemy should do attack thing
	#if door should check if can go to next area
	
