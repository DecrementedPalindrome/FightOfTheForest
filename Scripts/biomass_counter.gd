extends TextureRect

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$BiomassLabel.text = str(Global.biomass)
