extends Node2D

@export var images: Array[CompressedTexture2D]
var density = 0.05

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(360 / 10):
		for y in range(202 / 10):
			if randf() < (density * 4):
				var grassTuft = Sprite2D.new()
				grassTuft.texture = images[randi_range(0, images.size()-1)]
				grassTuft.position = Vector2(x * 10 + randi_range(-2, 2), y * 10 + randi_range(-2, 2))
				#grassTuft.modulate = Color(randf_range(-1, 1), randf_range(1, 1.2), randf_range(-1, 1))
				add_child(grassTuft)
