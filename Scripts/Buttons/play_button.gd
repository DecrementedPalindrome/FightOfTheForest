extends Button

func _ready() -> void:
	get_tree().get_current_scene().get_node("FadeToBlack").modulate =  Color(1,1,1,0)

func _on_pressed() -> void:
	var tween = get_tree().create_tween()
	var fade_to_black: ColorRect = get_tree().get_current_scene().get_node("FadeToBlack")
	tween.tween_property(fade_to_black, "modulate", Color(1,1,1,1), 1)
	tween.tween_callback(start_game)
	
	
func start_game():
	get_tree().change_scene_to_file("res://LevelSelect.tscn")
