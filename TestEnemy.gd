extends KinematicBody2D

var health: int = 100 setget set_health, get_health

func set_health(value):
	health = value

func get_health():
	return health

func _process(delta):

	self.position += self.global_position.direction_to(
		get_node("/root/Level/Player").global_position
	).normalized() * delta * 100

	if self.get_health() < 0:
		queue_free()
