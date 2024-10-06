extends Button

@export var level_number: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.highest_level_beat < level_number - 1:
		disabled = true
