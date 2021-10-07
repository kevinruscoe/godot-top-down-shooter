extends Node2D

func _process(delta):
	self.set_position(get_viewport().get_mouse_position())
