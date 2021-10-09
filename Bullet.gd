extends Node2D

var velocity: Vector2 = Vector2.ZERO setget set_velocity, get_velocity
var speed: float = 500.0 setget set_speed, get_speed
var max_distance: float = 400.0 setget set_max_distance, get_max_distance

var _color: Color
var _is_fired: bool = false
var _initial_position: Vector2 = Vector2.ZERO
var _ttl: float = 20.0

func _ready():
	self._color = Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1), 1)
	set_modulate(self._color)

func _physics_process(delta):
	if self._is_fired:
		self.set_position(self.get_position() + (self.get_velocity() * delta * self.get_speed()))

		if self._initial_position.distance_to(self.get_position()) > self.get_max_distance():
			queue_free()

		if self._ttl < 0:
			queue_free()
		else:
			self._ttl -= delta

func fire():
	self._initial_position = self.get_position()
	self._is_fired = true

func get_max_distance():
	return max_distance

func set_max_distance(value):
	max_distance = value

func get_velocity():
	return velocity

func set_velocity(value):
	velocity = value

func get_speed():
	return speed

func set_speed(value):
	speed = value

func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemy"):
		body.take_damage(10)
