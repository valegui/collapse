extends StaticBody2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_detected_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		body.hit()



func _on_player_detected_body_exited(body: Node2D) -> void:
	pass
