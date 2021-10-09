extends Node2D

func _process(delta):
	self.set_position(get_global_mouse_position())
