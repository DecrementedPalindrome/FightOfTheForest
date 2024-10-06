extends Node2D

func _ready() -> void:
	var scene_instance = Global.level_parameters.preexisting_objects.instantiate()
	for flower in scene_instance.get_node("Towers").get_children():
		add_child(flower.duplicate())
	scene_instance.queue_free()
