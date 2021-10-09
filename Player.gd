extends KinematicBody2D

var max_speed: int = 500 setget set_max_speed, get_max_speed
var acceleration_rate: int = 2000 setget set_acceleration_rate, get_acceleration_rate
var velocity: Vector2 = Vector2.ZERO setget set_velocity, get_velocity

func _ready():
	$Gun.set_gun_type($Gun.GunTypes.SEMI_AUTO)

func _physics_process(delta):
	self._handle_movement(delta)

func _get_input_axis():
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
func _apply_deceleration(value):
	if self.get_velocity().length() > value:
		self.set_velocity(self.get_velocity() - self.get_velocity().normalized() * value)
	else:
		self.set_velocity(Vector2.ZERO)
		
func _apply_acceleration(value):
	self.set_velocity(self.get_velocity() + value)
		
func _handle_movement(delta):
	var axis: Vector2 = self._get_input_axis()
	
	if axis == Vector2.ZERO:
		self._apply_deceleration(self.get_acceleration_rate() * delta)
	else:
		self._apply_acceleration(axis * self.get_acceleration_rate() * delta)
		
	self.set_velocity(self.get_velocity().clamped(self.get_max_speed()))
		
	self.move_and_slide(self.get_velocity())

func set_max_speed(value):
	max_speed = value
	
func get_max_speed():
	return max_speed

func set_acceleration_rate(value):
	acceleration_rate = value
	
func get_acceleration_rate():
	return acceleration_rate

func set_velocity(value):
	velocity = value
	
func get_velocity():
	return velocity
