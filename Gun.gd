extends Node2D

var BULLET_SCENE = preload("res://Scenes/Bullet.tscn")

var accuracy: float = 0.1
var spread: Vector2 = Vector2(400, 50)

var reload_time: float = 1.0
var reload_timer: float = 0.0
var is_reloading: bool = false

var ammo: int = 10
var clip_size: int = ammo

var shoot_mode: int = shoot_modes.SEMIAUTO
enum shoot_modes {ONE_SHOT, SEMIAUTO}

var draw_debug_cone: bool = true
var debug_cone: PoolVector2Array

func calculated_debug_cone():

	self.debug_cone.append($Muzzle.position)
	
	var _min:Vector2 = $Muzzle.position
	_min.x += spread.x
	_min.y += spread.y
	self.debug_cone.append(_min)
	
	var _max:Vector2 = $Muzzle.position
	_max.x += spread.x
	_max.y -= spread.y
	self.debug_cone.append(_max)

	self.debug_cone.append($Muzzle.position)

	return self.debug_cone

func _process(delta):
	if self.draw_debug_cone:
		$Polygon2D.set_polygon(self.calculated_debug_cone())
		$Polygon2D.set_color(Color(1, 1, 1, .1))

	if shoot_mode == shoot_modes.ONE_SHOT:
		if Input.is_action_just_pressed("ui_shoot"):
			self.shoot()

	if shoot_mode == shoot_modes.SEMIAUTO:
		if Input.is_action_pressed("ui_shoot"):
			self.shoot()

	self.track_reload_lock(delta)

	look_at(get_global_mouse_position())

func track_reload_lock(delta):
	if self.is_reloading:
		if self.reload_timer <= 0:
			self.reload_timer = 0.0
			self.ammo = self.clip_size
			self.is_reloading = false
			$ColorRect.color = Color(1, 1, 1, 1)
		self.reload_timer -= delta

func reload():
	self.is_reloading = true
	$ColorRect.color = Color(0, 0, 0, 1)
	self.reload_timer = self.reload_time

func reduce_ammo(amount):
	self.ammo -= amount
	if self.ammo <= 0:
		self.reload()

func shoot():
	if not self.is_reloading:

		self.reduce_ammo(1)

		var fire_from: Vector2 = $Muzzle.global_position
		var fire_to: Vector2 = get_global_mouse_position()
		
		# spread and accuracy effects where a bullet could hit
		# so we get the clicked positon, and tweak its position
		var angle_to_destination = rad2deg(fire_from.angle_to_point(fire_to)) + 180
		
		fire_to.y = fire_from.y + spread.x * sin(deg2rad(angle_to_destination))
		fire_to.x = fire_from.x + spread.x * cos(deg2rad(angle_to_destination))
		
		var bullet_velocity: Vector2 = -(fire_from - fire_to)

		# get accuracy, if 1.0 it'll hit 100% of the time, if .5, it'll hit 50%.
		# spread is the min and max distance from the target it could hit
		# accuracy dependant
		var spread_negator = self.spread.y - self.spread.y * self.accuracy
		
		bullet_velocity.x = rand_range(bullet_velocity.x - spread_negator, bullet_velocity.x + spread_negator)
		bullet_velocity.y = rand_range(bullet_velocity.y - spread_negator, bullet_velocity.y + spread_negator)
		
		bullet_velocity = bullet_velocity.normalized()
		
		var bullet = BULLET_SCENE.instance()
		self.get_node("/root").add_child(bullet)
		bullet.fire(fire_from, bullet_velocity)
