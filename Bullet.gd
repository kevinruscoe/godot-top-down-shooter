extends Node2D

var velocity: Vector2 = Vector2.ZERO
var speed: float = 400.0
var lifespan: float = 5.0
var color: Color

func _ready():
	self.color = Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1), 1)
	set_modulate(color)

func _physics_process(delta):
	if self.velocity.length() > 0:
		self.set_position(get_position() + (velocity * delta * speed))
		
		self.lifespan -= delta
		
		if self.lifespan <= 0:
			queue_free()

func fire(from: Vector2, direction: Vector2):
	self.set_position(from)
	self.velocity = direction
