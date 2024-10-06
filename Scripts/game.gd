extends Node2D

class_name Game

@export var route: Path2D
@export var enemy: PackedScene

var createdEnemy: Enemy

var current_wave := 0
var current_enemy := 0
var final_wave_finished := false
var started := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().get_current_scene().get_node("FadeToBlack").modulate =  Color(1,1,1,0)
	var audio_tween = get_tree().create_tween()
	audio_tween.tween_property($Music, "volume_db", -4, 5)

func start():
	started = true
	$WaveTimer.start(5)

func _process(delta: float) -> void:
	if final_wave_finished && all_enemies_defeated():
		Global.highest_level_beat = max(Global.highest_level_beat, Global.level_parameters.level_number)
		return_to_level_select()
	if Global.lives <= 0:
		game_over()

func all_enemies_defeated() -> bool:
	return $Route.get_children().filter(func (child: Node2D): return child.get_class() == "PathFollow2D").size() == 0

func spawn_enemy(type: EnemyType) -> void:
	var newEnemy:Enemy = (enemy.instantiate() as Enemy).with_type(type)
	$Route.add_child(newEnemy)

func next_wave():
	if(current_wave == Global.level_parameters.waves.size()):
		final_wave_finished = true
		return
	current_wave += 1
	current_enemy = 0
	$SpawnTimer.start(Global.level_parameters.waves[current_wave-1].time_between_enemies)
	$WaveTimer.start(Global.level_parameters.waves[current_wave-1].duration)

func game_over():
	var game_over_tween = get_tree().create_tween()
	var fade_to_black: ColorRect = get_tree().get_current_scene().get_node("FadeToBlack")
	game_over_tween.tween_property(fade_to_black, "modulate", Color(1,1,1,1), 1)
	game_over_tween.tween_callback(return_to_level_select)

func return_to_level_select():
	get_tree().change_scene_to_file("res://LevelSelect.tscn")

func _on_wave_timer_timeout() -> void:
	next_wave()

func _on_spawn_timer_timeout() -> void:
	if current_enemy < Global.level_parameters.waves[current_wave-1].enemies.size():
		spawn_enemy(Global.level_parameters.waves[current_wave-1].enemies[current_enemy])
		current_enemy += 1
