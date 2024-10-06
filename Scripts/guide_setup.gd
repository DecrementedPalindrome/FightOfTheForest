extends Control

func _ready() -> void:
	var scene_instance = Global.level_parameters.preexisting_objects.instantiate()
	for node in scene_instance.get_node("Guide").get_children():
		add_child(node.duplicate())
	scene_instance.queue_free()
