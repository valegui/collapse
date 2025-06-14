extends Area2D

func _on_body_entered(body: Node):
	if "Player" in body.name:
		var scene_path = get_tree().current_scene.scene_file_path
		var next_scene_n = scene_path.to_int() + 1
		var next_scene_name: String
		if next_scene_n == 8:
			next_scene_name = "res://scenes/game_over.tscn"
		else:
			next_scene_name = "res://scenes/level_" + str(next_scene_n) + ".tscn"
		Global.player_original_position = Vector2(100, 450)
		var next_scene = load(next_scene_name)
		get_tree().change_scene_to_packed(next_scene)
