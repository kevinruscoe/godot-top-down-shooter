extends KinematicBody2D

var health: int = 100 setget set_health, get_health
var _flash_timer: Timer

func take_damage(value):
	self._flash_timer.start()
	self.set_health(self.get_health() - value)

func set_health(value):
	health = value

func get_health():
	return health
	
func _ready():
	self._flash_timer = Timer.new()
	self._flash_timer.set_one_shot(true)
	self._flash_timer.set_wait_time(0.05)
	self.add_child(self._flash_timer)

func _process(delta):
	
	if self._flash_timer.is_stopped():
		self.get_node("ColorRect").color = Color(1, 1, 1, 1)
	else:
		self.get_node("ColorRect").color = Color(1, 0, 0, 1)

	self.position += self.global_position.direction_to(
		get_node("/root/Level/Player").global_position
	).normalized() * delta * 100

	if self.get_health() < 0:
		queue_free()
