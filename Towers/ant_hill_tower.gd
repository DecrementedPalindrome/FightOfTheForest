extends Tower

class_name AnthillTower

@export var ant: PackedScene
var bees: Array[Ant]
var max_ants := 10

var plant_matter := 0.0
var nectar_to_upgrade := 100

func create_ant():
	var newAnt = ant.instantiate()
	newAnt.position += Vector2(randf_range(-4, 4), randf_range(-4, 4))
	newAnt.set_home(self)
	add_child(newAnt)
	bees.append(newAnt)
	$Pop.play()

func _ready() -> void:
	super._ready()
	create_ant()

func upgrade_if_necessary():
	if plant_matter >= nectar_to_upgrade && bees.size() < max_ants:
		plant_matter -= nectar_to_upgrade
		create_ant()

func collect_honey():
	var in_range_ant_areas: Array[Area2D] = $AntRange.get_overlapping_areas()
	var ants_in_range: Array = in_range_ant_areas.map(func(area: Area2D): return (area.get_parent() as Ant))
	$NectarProgress.ratio = plant_matter / nectar_to_upgrade
	for ant: Ant in ants_in_range:
		plant_matter = clamp(plant_matter + ant.plant_matter, 0, nectar_to_upgrade)
		ant.plant_matter = 0
		ant.already_eaten = false
		upgrade_if_necessary()
	$NectarProgress.ratio = plant_matter / nectar_to_upgrade

func interact_with_objects(enemies: Array, flowers: Array, delta) -> void:
	if enemies.size() > 0:
		for i in range(bees.size()):
			bees[i].set_target(enemies[i % enemies.size()])
	elif flowers.size() > 0:
		for i in range(min(bees.size(), flowers.size())):
			bees[i].set_target(flowers[i])
	collect_honey()

#func _on_mouse_detection_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
#	if event is InputEventMouseButton:
#		if event.is_pressed():
#			var cursor_control = get_tree().root.get_node("Game/CursorControl") as CursorControl
#			if cursor_control.selected_tower:
#				cursor_control.assign_selected_bees(self)
#			elif !cursor_control.placing_type && cursor_control.cooldown <= 0.01:
#				cursor_control.selected_tower = self
