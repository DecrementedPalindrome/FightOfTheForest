extends Tower

class_name BeehiveTower

@export var bee: PackedScene
var bees: Array[Bee]
var max_bees := 10

var nectar := 0.0
var nectar_to_upgrade := 100

func create_bee():
	var newBee = bee.instantiate()
	newBee.position += Vector2(randf_range(-4, 4), randf_range(-4, 4))
	newBee.set_hive(self)
	add_child(newBee)
	bees.append(newBee)
	$Pop.play()

func _ready() -> void:
	super._ready()
	create_bee()

func upgrade_if_necessary():
	if nectar >= nectar_to_upgrade && bees.size() < max_bees:
		nectar -= nectar_to_upgrade
		create_bee()

func collect_honey():
	var in_range_bee_areas: Array[Area2D] = $BeeRange.get_overlapping_areas()
	var bees_in_range: Array = in_range_bee_areas.map(func(area: Area2D): return (area.get_parent() as Bee))
	$NectarProgress.ratio = nectar / nectar_to_upgrade
	for bee: Bee in bees_in_range:
		nectar = clamp(nectar + bee.nectar, 0, nectar_to_upgrade)
		bee.nectar = 0
		upgrade_if_necessary()
	$NectarProgress.ratio = nectar / nectar_to_upgrade

func interact_with_objects(enemies: Array, flowers: Array, delta) -> void:
	if enemies.size() > 0:
		for i in range(bees.size()):
			bees[i].set_target(enemies[i % enemies.size()])
	elif flowers.size() > 0:
		for i in range(min(bees.size(), flowers.size())):
			bees[i].set_target(flowers[i])
	collect_honey()


func _on_mouse_detection_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			var cursor_control = get_tree().root.get_node("Game/CursorControl") as CursorControl
			if cursor_control.selected_tower:
				cursor_control.assign_selected_bees(self)
			elif !cursor_control.placing_type && cursor_control.cooldown <= 0.01:
				cursor_control.selected_tower = self
