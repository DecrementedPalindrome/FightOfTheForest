extends Sprite2D

class_name CursorControl

@export var beehive: CompressedTexture2D
@export var beehive_tower: PackedScene
@export var anthill: CompressedTexture2D
@export var anthill_tower: PackedScene

var placing_type: String = ""
var selected_tower: BeehiveTower
var cooldown := 0.0

func update_held_item(item: String):
	placing_type = item
	match placing_type:
		"":
			texture = null
		"beehive":
			texture = beehive
		"anthill":
			texture = anthill

func _input(event):
	if event.is_action("Cancel"):
		update_held_item("")
		selected_tower = null
	if event is InputEventMouseButton:
		if event.is_pressed() && placing_type != "":
			place_tower()
	elif event is InputEventMouseMotion:
		position = get_viewport().get_mouse_position()

func place_tower():
	var newTower: Tower
	match placing_type:
		"beehive":
			newTower = beehive_tower.instantiate()
			Global.biomass -= Global.beehive_cost
			Global.beehive_cost = int(Global.beehive_cost * 1.5)
	match placing_type:
		"anthill":
			newTower = anthill_tower.instantiate()
			Global.biomass -= Global.anthill_cost
			Global.anthill_cost = int(Global.anthill_cost * 1.5)
	if newTower != null:
		newTower.global_position = global_position
		get_tree().get_current_scene().get_node("Towers").add_child(newTower)
	update_held_item("")
	cooldown = 0.2

func assign_selected_bees(new_beehive: BeehiveTower):
	var number_of_bees = clamp((selected_tower.bees.size()-1) / 2 + 1, 0, selected_tower.bees.size())
	for i in range(number_of_bees):
		var bee = selected_tower.bees[0]
		var new_bee = bee.duplicate()
		new_beehive.add_child(new_bee)
		new_beehive.bees.append(new_bee)
		new_bee.position = new_bee.position - new_beehive.global_position + selected_tower.global_position
		selected_tower.bees.remove_at(0)
		bee.queue_free()
	selected_tower = null
	cooldown = 0.2

func _process(delta: float) -> void:
	cooldown = clamp(cooldown - delta, 0, 1)
	queue_redraw()

func _draw():
	if selected_tower:
		for i in clamp((selected_tower.bees.size()-1) / 2 + 1, 0, selected_tower.bees.size()):
			draw_line(Vector2.ZERO, selected_tower.bees[i].global_position - self.global_position, Color("#266ccdd2"))

func _on_bee_hive_button_pressed() -> void:
	if Global.biomass < Global.beehive_cost:
		return
	update_held_item("beehive")

func _on_ant_hill_button_pressed() -> void:
	if Global.biomass < Global.anthill_cost:
		return
	update_held_item("anthill")
