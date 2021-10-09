extends Node2D

const EnemyScene = preload("res://Scenes/TestEnemy.tscn")

var _respawn_every: float = 1.0
var _respawn_timer: Timer

func _ready():
	
	self._respawn_timer = Timer.new()
	self._respawn_timer.set_one_shot(true)
	self._respawn_timer.set_wait_time(self._respawn_every)
	self.add_child(self._respawn_timer)
	self._respawn_timer.start()
	
func _process(delta):
	if self._respawn_timer.is_stopped():
		spawn_at(self._get_random_spawn())
		self._respawn_timer.start()
		
func _get_random_spawn():
	return Vector2(
		rand_range(-5, 5),
		rand_range(-5, 5)
	)
	
func spawn_at(location):
	var enemy = EnemyScene.instance()
	enemy.add_to_group("Enemy")
	enemy.set_position(location)
	self.get_node("/root").call_deferred("add_child", enemy)
