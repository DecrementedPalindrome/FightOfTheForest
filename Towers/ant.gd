extends Node2D

class_name Ant

@export var sunflower: PackedScene

var home: AnthillTower
var target: Node2D
var damage := 3
var speed := 15

var plant_matter := 0.0
var max_nectar := 50
var nectar_collection_speed := 2.0
var seeds := 0
var time_between_seed_drops := 2.0
var time_to_next_seed_drop := 2.0
var already_eaten := false

func set_target(new_target: Node2D):
	target = new_target

func set_home(new_home: AnthillTower):
	self.home = new_home

func damage_enemies(amount):
	var in_range_areas: Array[Area2D] = $EnemyCollision.get_overlapping_areas()
	var enemies_in_range: Array = in_range_areas.map(func(area: Area2D): return (area.get_parent() as Enemy))
	for enemy: Enemy in enemies_in_range:
		enemy.damage(amount)
		
func collect_nectar(amount):
	var in_range_areas: Array[Area2D] = $FlowerCollision.get_overlapping_areas()
	if in_range_areas.size() >= 1:
		plant_matter = clamp(plant_matter + amount, 0, max_nectar)
		if plant_matter >= max_nectar && !already_eaten:
			in_range_areas[0].get_parent().queue_free()
			print("nom")
			seeds = 2
			time_to_next_seed_drop = time_between_seed_drops
			already_eaten = true

func move_towards_target(distance: float):
	var current_goal: Node2D
	if plant_matter >= max_nectar && home && is_instance_valid(home):
		current_goal = home
	elif target && is_instance_valid(target):
		current_goal = target
	if current_goal:
		var center_position = current_goal.global_position
		var target_position = Vector2(
			center_position.x,
			center_position.y,
			)
		global_position = global_position.move_toward(target_position, distance)

func drop_seeds(delta):
	time_to_next_seed_drop -= delta
	if time_to_next_seed_drop <= 0 && seeds > 0:
		print("new seed just dropped")
		seeds -= 1
		var new_flower: Node2D = sunflower.instantiate()
		var flower_position_tween = get_tree().create_tween()
		flower_position_tween.set_ease(Tween.EASE_OUT)
		new_flower.global_position = self.global_position 
		flower_position_tween.tween_property(
			new_flower,
			"global_position", 
			self.global_position + Vector2(randf_range(-12, 12), randf_range(-12, 12)),
			1
		)
		get_tree().root.get_node("Game/Flowers").add_child(new_flower)
		time_to_next_seed_drop = time_between_seed_drops

func _process(delta: float) -> void:
	damage_enemies(delta * damage)
	collect_nectar(delta * nectar_collection_speed)
	move_towards_target(delta*speed)
	drop_seeds(delta)
