extends Path2D

@export var images: Array[CompressedTexture2D]
var density = 1
var rock_size = 6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curve = Global.level_parameters.route_curve
	for d in range(0, curve.get_baked_length() / rock_size + 1):
		if randf() < (density):
			var grassTuft = Sprite2D.new()
			grassTuft.texture = images[randi_range(0, images.size()-1)]
			var path_position = curve.sample_baked(d * rock_size)
			grassTuft.position = path_position + Vector2(randi_range(-1, 2),randi_range(-1, 2))
			#grassTuft.modulate = Color(randf_range(-1, 1), randf_range(1, 1.2), randf_range(-1, 1))
			add_child(grassTuft)
