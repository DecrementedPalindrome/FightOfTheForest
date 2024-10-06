extends Node2D

func _process(delta: float) -> void:
		queue_redraw()

func _draw():
	if get_parent().get_node("RangeDisplay").visible:
		for bee in get_parent().get_parent().bees:
			draw_line(Vector2.ZERO, bee.position, Color("#cd6c26d2"))
