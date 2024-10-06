extends Node2D

class_name Bee

var hive: BeehiveTower
var target: Node2D
var damage := 2
var speed := 30

var nectar := 0.0
var max_nectar := 10
var nectar_collection_speed := 2.0

var bobOffsetX: float
var bobOffsetY: float
var bobSpeed: float

func _ready() -> void:
	bobOffsetX = randf_range(0, PI * 2)
	bobOffsetY = randf_range(0, PI * 2)
	bobSpeed = randf_range(1, 2.5)

func set_target(new_target: Node2D):
	target = new_target

func set_hive(new_hive: BeehiveTower):
	self.hive = new_hive

func damage_enemies(amount):
	var in_range_areas: Array[Area2D] = $EnemyCollision.get_overlapping_areas()
	var enemies_in_range: Array = in_range_areas.map(func(area: Area2D): return (area.get_parent() as Enemy))
	for enemy: Enemy in enemies_in_range:
		enemy.damage(amount)
		
func collect_nectar(amount):
	var in_range_areas: Array[Area2D] = $FlowerCollision.get_overlapping_areas()
	if in_range_areas.size() >= 1:
		nectar = clamp(nectar + amount, 0, max_nectar)

func move_towards_target(distance: float):
	var current_goal: Node2D
	if nectar >= (max_nectar-0.01) && hive && is_instance_valid(hive):
		current_goal = hive
	elif target && is_instance_valid(target):
		current_goal = target
	if current_goal:
		var center_position = current_goal.global_position
		var target_position = Vector2(
			center_position.x + 4*sin(Time.get_ticks_msec() / 1000.0 * PI + bobOffsetX),
			center_position.y
			)
		global_position = global_position.move_toward(target_position, distance)

func bob():
	$Sprite2D.position.y = 2.5*sin(Time.get_ticks_msec() / 1000.0 * PI / 2 + bobOffsetY)

func _process(delta: float) -> void:
	damage_enemies(delta * damage)
	collect_nectar(delta * nectar_collection_speed)
	move_towards_target(delta*speed)
	bob()
