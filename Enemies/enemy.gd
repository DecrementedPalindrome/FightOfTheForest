extends PathFollow2D

class_name Enemy

var speed = 15
var max_health = 10
var health = 10
var reward = 1
var dying := false

func with_type(type: EnemyType) -> Enemy:
	self.speed = type.speed
	self.max_health = type.health
	self.health = type.health
	self.reward = type.reward
	var sprite_frames = SpriteFrames.new()
	for frame in type.walking_frames:
		sprite_frames.add_frame("default", frame)
	$Sprite2D.sprite_frames = sprite_frames
	$Sprite2D.play()
	return self

func increase_progress(delta: float) -> void:
	progress += speed * delta
	if progress_ratio >= 1:
		escape()

func damage(amount: float) -> void:
	health -= amount
	$HealthBar.value = health/max_health * 100
	if health <= 0 && !is_queued_for_deletion():
		destroy()

func escape():
	Global.lives -= 1
	var laughs = $LaughPlayers.get_children()
	var laugh_to_play = laughs[randi_range(0, laughs.size()-1)].duplicate()
	get_parent().add_child(laugh_to_play)
	laugh_to_play.play()
	destroy()

func destroy():
	Global.biomass += reward
	dying = true
	$CollisionArea.monitorable = false
	$CollisionArea.monitoring = false
	var death_tween = get_tree().create_tween()
	death_tween.set_parallel(true)
	death_tween.set_ease(Tween.EASE_OUT)
	death_tween.tween_property(self, "rotation_degrees", rotation_degrees-80, 0.3)
	death_tween.tween_property(self, "modulate:a", 0, 0.3)
	death_tween.tween_property(self, "position:x", position.x-3, 0.3)
	death_tween.set_ease(Tween.EASE_IN)
	death_tween.tween_property(self, "position:y", position.y+2, 0.3)
	death_tween.set_parallel(false)
	death_tween.tween_callback(self.queue_free)

func _process(delta: float) -> void:
	if !dying:
		increase_progress(delta)
