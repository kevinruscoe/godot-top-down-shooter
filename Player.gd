extends KinematicBody2D

var MAX_SPEED = 500
var ACCELERATION = 2000

var velocity = Vector2.ZERO

func get_input_axis():
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
func apply_decceleration(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO
		
func apply_acceleration(acceleration):
	velocity += acceleration

func handle_weapons():
	if Input.is_action_just_pressed("ui_shoot"):
		$Gun.shoot();
		
func handle_movement(delta):
	var axis = get_input_axis()
	
	if axis == Vector2.ZERO:
		apply_decceleration(ACCELERATION * delta)
	else:
		apply_acceleration(axis * ACCELERATION * delta)
		
	velocity = velocity.clamped(MAX_SPEED)
		
	move_and_slide(velocity)
	
func _physics_process(delta):
	handle_weapons()
	handle_movement(delta)
