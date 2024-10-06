extends Polygon2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var range: float = get_parent().get_parent().get_node("EnemyRange").get_child(0).shape.radius
	polygon = generate_circle_polygon(range, 30, Vector2(0,0))

func _draw():
	for i in range(polygon.size()-1):
		draw_line(polygon[i], polygon[i+1], Color("#bdac2dd2"))
	draw_line(polygon[polygon.size()-1], polygon[0], Color("#bdac2dd2"))

# https://forum.godotengine.org/t/how-to-shape-polygon2d-into-a-circle/15432/4
func generate_circle_polygon(radius: float, num_sides: int, position: Vector2) -> PackedVector2Array:
	var angle_delta: float = (PI * 2) / num_sides
	var vector: Vector2 = Vector2(radius, 0)
	var polygon: PackedVector2Array
	
	for _i in num_sides:
		polygon.append(vector + position)
		vector = vector.rotated(angle_delta)
	
	return polygon

func _on_mouse_detection_mouse_entered() -> void:
	visible = true

func _on_mouse_detection_mouse_exited() -> void:
	visible = false
