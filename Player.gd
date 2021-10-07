extends KinematicBody2D

var speed: int = 500
var acceleration: int = 2000
var velocity: Vector2 = Vector2.ZERO

func _ready():
	# semi
	$Gun.set_spread(Vector2(400, 30))
	$Gun.set_bullet_max_distance($Gun.get_spread().x)
	$Gun.set_accuracy(0.6)
	$Gun.set_bullets_per_second(10)
	$Gun.set_clip_size(60)
	$Gun.set_ammo($Gun.get_clip_size())
	$Gun.set_reload_duration(4.0)

	# pistol
	# $Gun.set_spread(Vector2(600, 20))
	# $Gun.set_accuracy(0.9)
	# $Gun.set_bullets_per_second(1)
	# $Gun.set_clip_size(8)
	# $Gun.set_ammo($Gun.get_clip_size())
	# $Gun.set_reload_duration(2.0)

	# shotgun
	# $Gun.set_spread(Vector2(100, 30))
	# $Gun.set_accuracy(0)
	# $Gun.set_bullets_per_second(1)
	# $Gun.set_number_of_projectiles_per_shot(6)
	# $Gun.set_clip_size(2)
	# $Gun.set_ammo($Gun.get_clip_size())
	# $Gun.set_reload_duration(5.0)

func _physics_process(delta):
	self.handle_movement(delta)

func get_input_axis():
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
func apply_deceleration(value):
	if self.velocity.length() > value:
		self.velocity -= self.velocity.normalized() * value
	else:
		self.velocity = Vector2.ZERO
		
func apply_acceleration(value):
	self.velocity += value
		
func handle_movement(delta):
	var axis = self.get_input_axis()
	
	if axis == Vector2.ZERO:
		apply_deceleration(acceleration * delta)
	else:
		apply_acceleration(axis * acceleration * delta)
		
	velocity = velocity.clamped(speed)
		
	move_and_slide(self.velocity)
