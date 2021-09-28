extends Node2D

var speed: float = 10.0
var velocity: Vector2 = Vector2.ZERO
var target: Vector2 = Vector2.ZERO
var accuracy: float = 1.0
var max_spread: float = 100.0
var living_for: float = 2.0

func _physics_process(delta):
	if target.length() > 0:
		velocity = velocity.move_toward(target, delta).normalized() * speed
		position = position + velocity
		living_for -= delta
		
		if living_for <= 0:
			queue_free()

func set_accuracy(_accuracy: float):
	accuracy = _accuracy

func fire(from: Vector2):
	set_position(from)
	target = get_global_mouse_position()
	
	# get accuracy, if 1.0 it'll hit 100% of the time, if .5, it'll hit 50%.
	# spread is the min and max distance from the target it could hit
	# accuracy dependant
	var spread = max_spread - max_spread * accuracy
	
	target.x = rand_range(target.x - spread, target.x + spread)
	target.y = rand_range(target.y - spread, target.y + spread)
