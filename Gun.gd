extends Node2D

var BULLET_SCENE = preload("res://Scenes/Bullet.tscn")

var accuracy: float = 1.0 #todo getset
var spread: Vector2 = Vector2(400, 20) #todo getset

var reload_duration: float = 1.0 #todo getset
var reload_timer: Timer

var ammo: int = 50 #todo getset
var clip_size: int = ammo #todo getset

var number_of_projectiles_per_shot: int = 1 #todo getset
var bullet_max_distance: float = 500.0 #todo getset
var bullet_speed: int = 800 #todo getset
var bullets_per_second: float = 10.0 #todo getset
var bullet_timer: Timer

var debug: bool = true
var debug_cone: Polygon2D

func _ready():
	self.reload_timer = Timer.new()
	self.reload_timer.set_one_shot(true)
	self.reload_timer.set_wait_time(reload_duration)
	self.add_child(self.reload_timer)
	
	self.bullet_timer = Timer.new()
	self.bullet_timer.set_one_shot(true)
	self.bullet_timer.set_wait_time(bullets_per_second)
	self.add_child(self.bullet_timer)

func _process(delta):
	self.draw_debugs()
	self.track_reload_lock()

	if Input.is_action_pressed("ui_shoot"):
		self.shoot()

	look_at(get_global_mouse_position())

func draw_debugs():
	if not self.debug_cone:
		self.debug_cone = Polygon2D.new()
		self.debug_cone.set_color(Color(1, 1, 1, .1))
		self.add_child(self.debug_cone)

	if self.debug_cone:
		var cone: PoolVector2Array = PoolVector2Array();
		cone.append(self.get_node("Muzzle").position)
	
		var upper_point:Vector2 = self.get_node("Muzzle").position
		upper_point.x += spread.x
		upper_point.y += spread.y
		cone.append(upper_point)
		
		var lower_point:Vector2 = self.get_node("Muzzle").position
		lower_point.x += spread.x
		lower_point.y -= spread.y
		cone.append(lower_point)

		cone.append(self.get_node("Muzzle").position)
		
		self.debug_cone.set_polygon(cone)
	
func track_reload_lock():
	if self.reload_timer.is_stopped() and self.ammo == 0:
		self.ammo = self.clip_size

func shoot():
	# if were reloading or throttled by bullet count, bail
	if not self.reload_timer.is_stopped() or not self.bullet_timer.is_stopped():
		return

	# reload, start reload timer
	self.ammo -= 1
	if self.ammo <= 0:
		self.reload_timer.start(reload_duration)

	# throttle bullet count
	self.bullet_timer.start(100 / bullets_per_second / 100)

	# handle bullet spawn, and target
	var fire_from: Vector2 = self.get_node("Muzzle").global_position

	for projectile in number_of_projectiles_per_shot:
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
		
		bullet_velocity.x = rand_range(
			bullet_velocity.x - spread_negator, 
			bullet_velocity.x + spread_negator
		)
		bullet_velocity.y = rand_range(
			bullet_velocity.y - spread_negator,
			bullet_velocity.y + spread_negator
		)
		
		bullet_velocity = bullet_velocity.normalized()
		
		var bullet = BULLET_SCENE.instance()
		self.get_node("/root").add_child(bullet)
		bullet.set_speed(self.bullet_speed)
		bullet.set_velocity(bullet_velocity)
		bullet.set_position(fire_from)
		bullet.set_max_distance(self.bullet_max_distance)
		bullet.fire()
