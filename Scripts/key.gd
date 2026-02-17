extends Area2D

signal key_collected(amount)

func _on_body_entered(body):
	if body.name == "Player":
		key_collected.emit(1)
		queue_free()
