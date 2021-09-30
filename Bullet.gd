extends Node2D

var velocity: Vector2 = Vector2.ZERO
var speed: float = 400.0
var lifespan: float = 5.0
var color: Color

func _ready():
	color = Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1), 1)
	set_modulate(color)

func _physics_process(delta):
	if velocity.length() > 0:
		set_position(get_position() + (velocity * delta * speed))
		
		lifespan -= delta
		
		if lifespan <= 0:
			queue_free()

func fire(origin: Vector2, direction: Vector2):
	set_position(origin)
	velocity = direction
