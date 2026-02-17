extends Node2D

signal player_keys(keys)

var keys
var max_keys = 3
var min_keys = 0

var items = []

func _ready():
	keys = 0
	emit_signal("player_keys", keys)
	
func _process(delta):
	pass
	
func _on_key_collected(amount):
	keys += amount
	print("Keys:", keys)
	clamp(keys, min_keys, max_keys)
	emit_signal("player_keys", keys)
	
func use_key():
	if keys > 0:
		keys -= 1
		print("Used key. Remaining:", keys)
		return true
	return false
