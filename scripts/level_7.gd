extends Node2D

@onready var player = $Player
var checkpoint = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.position.x >= 850:
		if checkpoint == false:
			Global.player_original_position = Vector2(850, 340)
			checkpoint = true
	
	
