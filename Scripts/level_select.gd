extends Control

@export var level1_parameters: LevelParameters
@export var level2_parameters: LevelParameters
@export var level3_parameters: LevelParameters
@export var level4_parameters: LevelParameters

func start_level(parameters: LevelParameters):
	randomize()
	Global.reset()
	Global.level_parameters = parameters
	get_tree().change_scene_to_file("res://Game.tscn")

func _on_level_1_button_pressed() -> void:
	start_level(level1_parameters)


func _on_level_2_button_pressed() -> void:
	start_level(level2_parameters)


func _on_level_3_button_pressed() -> void:
	start_level(level3_parameters)


func _on_level_4_button_pressed() -> void:
	start_level(level4_parameters)
