extends Node2D

export var speed = 10

var velocity = Vector2.ZERO
var mouse_position = Vector2.ZERO
var fired = false
var accuracy = 1

func _physics_process(delta):
	if fired:
		var target = mouse_position
		target.x = rand_range(target.x - accuracy, target.x + accuracy)
		target.y = rand_range(target.y - accuracy, target.y + accuracy)
		velocity = velocity.move_toward(target, delta).normalized() * speed
		position = position + velocity

func set_accuracy(new_accuracy):
	accuracy = new_accuracy

func fire():
	mouse_position = get_local_mouse_position()
	fired = true
