extends Node2D

var BULLET_SCENE = preload("res://Scenes/Bullet.tscn")

var accuracy: float = 1.0 setget set_accuracy, get_accuracy
var spread: Vector2 = Vector2(400, 20) setget set_spread, get_spread

var reload_duration: float = 1.0 setget set_reload_duration, get_reload_duration
var reload_timer: Timer setget set_reload_timer, get_reload_timer

var ammo: int = 50 setget set_ammo, get_ammo
var clip_size: int = 0 setget set_clip_size, get_clip_size

var number_of_projectiles_per_shot: int = 1.0 setget set_number_of_projectiles_per_shot, get_number_of_projectiles_per_shot
var bullet_max_distance: float = 500.0 setget set_bullet_max_distance, get_bullet_max_distance
var bullet_speed: int = 800 setget set_bullet_speed, get_bullet_speed
var bullets_per_second: float = 10.0 setget set_bullets_per_second, get_bullets_per_second
var bullet_timer: Timer setget set_bullet_timer, get_bullet_timer

var debug: bool = true
var debug_cone: Polygon2D

func _ready():
	self.set_reload_timer(Timer.new())
	self.get_reload_timer().set_one_shot(true)
	self.get_reload_timer().set_wait_time(self.get_reload_duration())
	self.add_child(self.get_reload_timer())
	
	self.set_bullet_timer(Timer.new())
	self.get_bullet_timer().set_one_shot(true)
	self.get_bullet_timer().set_wait_time(self.get_bullets_per_second())
	self.add_child(self.get_bullet_timer())

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
		upper_point.x += self.get_spread().x
		upper_point.y += self.get_spread().y
		cone.append(upper_point)
		
		var lower_point:Vector2 = self.get_node("Muzzle").position
		lower_point.x += self.get_spread().x
		lower_point.y -= self.get_spread().y
		cone.append(lower_point)

		cone.append(self.get_node("Muzzle").position)
		
		self.debug_cone.set_polygon(cone)
	
func track_reload_lock():
	if self.get_reload_timer().is_stopped() and self.get_ammo() == 0:
		self.get_ammo() = self.get_clip_size()

func shoot():
	# if were reloading or throttled by bullet count, bail
	if not self.get_reload_timer().is_stopped() or not self.bullet_timer.is_stopped():
		return

	# reload, start reload timer
	self.set_ammo(self.get_ammo() - 1)
	if self.get_ammo() <= 0:
		self.get_reload_timer().start(self.get_reload_duration())

	# throttle bullet count
	self.get_bullet_timer().start(100 / self.get_bullets_per_second() / 100)

	# handle bullet spawn, and target
	var fire_from: Vector2 = self.get_node("Muzzle").global_position

	for projectile in self.get_number_of_projectiles_per_shot():
		var fire_to: Vector2 = get_global_mouse_position()
		
		# spread and accuracy effects where a bullet could hit
		# so we get the clicked positon, and tweak its position
		var angle_to_destination = rad2deg(fire_from.angle_to_point(fire_to)) + 180
		
		fire_to.y = fire_from.y + self.get_spread().x * sin(deg2rad(angle_to_destination))
		fire_to.x = fire_from.x + self.get_spread().x * cos(deg2rad(angle_to_destination))
		
		var bullet_velocity: Vector2 = -(fire_from - fire_to)

		# get accuracy, if 1.0 it'll hit 100% of the time, if .5, it'll hit 50%.
		# spread is the min and max distance from the target it could hit
		# accuracy dependant
		var spread_negator = self.get_spread().y - self.get_spread().y * self.get_accuracy()
		
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
		bullet.set_speed(self.get_bullet_speed())
		bullet.set_velocity(bullet_velocity)
		bullet.set_position(fire_from)
		bullet.set_max_distance(self.get_bullet_max_distance())
		bullet.fire()

func set_accuracy(value):
	accuracy = value

func get_accuracy():
	return accuracy

func set_spread(value):
	spread = value
	
func get_spread():
	return spread

func set_reload_duration(value):
	reload_duration = value
	
func get_reload_duration():
	return reload_duration

func set_ammo(value):
	ammo = value
	
func get_ammo():
	return ammo

func set_clip_size(value):
	clip_size = value
	
func get_clip_size():
	return clip_size

func set_number_of_projectiles_per_shot(value):
	number_of_projectiles_per_shot = value
	
func get_number_of_projectiles_per_shot():
	return number_of_projectiles_per_shot

func set_bullet_max_distance(value):
	bullet_max_distance = value
	
func get_bullet_max_distance():
	return bullet_max_distance

func set_bullet_speed(value):
	bullet_speed = value
	
func get_bullet_speed():
	return bullet_speed

func set_bullets_per_second(value):
	bullets_per_second = value
	
func get_bullets_per_second():
	return bullets_per_second

func set_reload_timer(value):
	reload_timer = value
	
func get_reload_timer():
	return reload_timer

func set_bullet_timer(value):
	bullet_timer = value
	
func get_bullet_timer():
	return bullet_timer