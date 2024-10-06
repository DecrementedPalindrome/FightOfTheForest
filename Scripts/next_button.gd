extends Button

func _on_pressed() -> void:
	var game = get_tree().root.get_node("Game") as Game
	game.get_node("Guide/Panel2").visible = true
	game.get_node("Guide/Panel").queue_free()
