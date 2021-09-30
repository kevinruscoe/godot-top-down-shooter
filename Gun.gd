extends Node2D

var BULLET_SCENE = preload("res://Scenes/Bullet.tscn")

var accuracy: float = 1.0
var speed: float = 10.0
var spread: Vector2 = Vector2(400, 20)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	look_at(get_global_mouse_position())

func shoot():
	
	var fire_from: Vector2 = $Muzzle.global_position
	var fire_to: Vector2 = get_global_mouse_position()
	
	# find position to actually fire to
	var angle_to_destination = rad2deg(fire_from.angle_to_point(fire_to)) + 180
	
	fire_to.y += spread.x * sin(deg2rad(angle_to_destination))
	fire_to.x += spread.x * cos(deg2rad(angle_to_destination))
	
	var bullet_velocity: Vector2 = -(fire_from - fire_to)

	# get accuracy, if 1.0 it'll hit 100% of the time, if .5, it'll hit 50%.
	# spread is the min and max distance from the target it could hit
	# accuracy dependant
	spread.y -= spread.y * accuracy

	bullet_velocity.x = rand_range(bullet_velocity.x - spread.y, bullet_velocity.x + spread.y)
	bullet_velocity.y = rand_range(bullet_velocity.y - spread.y, bullet_velocity.y + spread.y)
	
	bullet_velocity = bullet_velocity.normalized()
	
	var bullet = BULLET_SCENE.instance()
	get_node("/root").add_child(bullet)
	bullet.fire(fire_from, bullet_velocity)
	
