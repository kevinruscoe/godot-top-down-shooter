extends KinematicBody2D

# most of this is from https://www.youtube.com/watch?v=BeSJgUTLmk0

var MAX_SPEED = 500
var ACCELERATION = 2000

var velocity = Vector2.ZERO

var BULLET_SCENE = preload("res://Scenes/Bullet.tscn")


func get_input_axis():
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
func apply_friction(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO
		
func apply_movement(acceleration):
	velocity += acceleration
	velocity = velocity.clamped(MAX_SPEED)

func handle_weapons():
	if Input.is_action_just_pressed("ui_shoot"):
		var bullet = BULLET_SCENE.instance()
		get_parent().add_child(bullet)
		bullet.set_accuracy(0)
		bullet.fire($Muzzle.global_position)
		
func handle_movement(delta):
	look_at(get_global_mouse_position())

	var axis = get_input_axis()
	
	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)
		
	move_and_slide(velocity)
	
func _physics_process(delta):
	handle_weapons()
	handle_movement(delta)
