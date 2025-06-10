extends Node2D

var checkpoint = false
var player = null

func _process(delta: float) -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	else:
		return

	if player.position.x >= 850 and not checkpoint:
		Global.player_original_position = Vector2(850, 340)
		checkpoint = true
