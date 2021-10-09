extends Node2D

const EnemyScene = preload("res://Scenes/TestEnemy.tscn")

func _ready():
	self.spawn_at(Vector2.ZERO)
	
func spawn_at(location):
	var enemy = EnemyScene.instance()
	enemy.set_position(location)
	self.get_node("/root").call_deferred("add_child", enemy)
