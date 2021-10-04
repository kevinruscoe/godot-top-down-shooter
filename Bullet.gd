extends Node2D

var velocity: Vector2 = Vector2.ZERO setget set_velocity, get_velocity
var speed: float = 500.0 setget set_speed, get_speed
var max_distance: float = 400.0 setget set_max_distance, get_max_distance
var initial_position: Vector2 = Vector2.ZERO

var color: Color
var fired: bool = false

func _ready():
	self.color = Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1), 1)
	set_modulate(color)

func _physics_process(delta):
	if self.fired:
		self.set_position(get_position() + (get_velocity() * delta * get_speed()))

		if initial_position.distance_to(get_position()) > self.get_max_distance():
			queue_free()

func fire():
	self.initial_position = self.get_position()
	self.fired = true

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
