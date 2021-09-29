extends Node2D

var mouse_location: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var speed: float = 400.0
var spread: Vector2 = Vector2(400, 20)
var accuracy: float = 1.0
var lifespan: float = 5.0
var color: Color

func _ready():
	color = Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1), 1)
	set_modulate(color)

func _physics_process(delta):
	#position += velocity * delta * speed
	set_position(get_position() + (velocity * delta * speed))
	
	lifespan -= delta
	
	if lifespan <= 0:
		queue_free()

func set_accuracy(_accuracy: float):
	accuracy = _accuracy

func fire(origin: Vector2):
	mouse_location = get_global_mouse_position()
	
	var angle_to_mouse = rad2deg(origin.angle_to_point(mouse_location)) + 180
	
	var target = origin
	target.y += spread.x * sin(deg2rad(angle_to_mouse))
	target.x += spread.x * cos(deg2rad(angle_to_mouse))
	
	velocity = -(origin - target)

	# get accuracy, if 1.0 it'll hit 100% of the time, if .5, it'll hit 50%.
	# spread is the min and max distance from the target it could hit
	# accuracy dependant
	spread.y -= spread.y * accuracy

	velocity.x = rand_range(velocity.x - spread.y, velocity.x + spread.y)
	velocity.y = rand_range(velocity.y - spread.y, velocity.y + spread.y)
	
	velocity = velocity.normalized()
	
	set_position(origin)
