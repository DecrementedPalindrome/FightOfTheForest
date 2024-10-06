extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Cost/BiomassIcon/BiomassLabel.text = str(Global.beehive_cost)
	if Global.level_parameters.tech_level < 1:
		$Cost/BiomassIcon/BiomassLabel.text = "Locked"
		modulate.a = 0.5
		disabled = true

func _process(_delta: float) -> void:
	if Global.biomass < Global.beehive_cost:
		disabled = true
	elif Global.level_parameters.tech_level >= 1:
		disabled = false
	if Global.level_parameters.tech_level >= 1:
		$Cost/BiomassIcon/BiomassLabel.text = str(Global.beehive_cost)
