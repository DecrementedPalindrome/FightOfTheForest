extends Button

func _on_pressed() -> void:
	var game = get_tree().root.get_node("Game") as Game
	game.start()
	get_parent().get_parent().queue_free()
