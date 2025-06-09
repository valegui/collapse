extends Area2D

func _on_body_entered(body: Node):
	if body.name == "Player":
		var scene_path = get_tree().current_scene.scene_file_path
		var next_scene_n = scene_path.to_int() + 1
		var next_scene_name: String
		if next_scene_n == 3:
			next_scene_name = "res://scenes/game_over.tscn"
		else:
			next_scene_name = "res://scenes/level_" + str(next_scene_n) + ".tscn"
		var next_scene = load(next_scene_name)
		get_tree().change_scene_to_packed(next_scene)
