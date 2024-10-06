extends Node2D

class_name Tower

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_tree().root.get_node("Game") && get_tree().root.get_node("Game").started:
		var in_range_enemy_areas: Array[Area2D] = $EnemyRange.get_overlapping_areas()
		var in_range_flower_areas: Array[Area2D] = $FlowerRange.get_overlapping_areas()
		var enemies_in_range: Array = in_range_enemy_areas.map(func(area: Area2D): return (area.get_parent() as Enemy))
		var flowers_in_range: Array = in_range_flower_areas.map(func(area: Area2D): return (area.get_parent() as Node2D))
		interact_with_objects(enemies_in_range, flowers_in_range, delta)

func interact_with_objects(_enemies: Array, _flowers: Array, _delta) -> void:
	pass
